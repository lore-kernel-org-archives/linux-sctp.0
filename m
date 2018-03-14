From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 14 Mar 2018 19:41:29 +0000
Subject: Re: [PATCH net-next 1/5] sctp: add refcnt support for sh_key
Message-Id: <20180314194129.GA9345@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1521025473.git.lucien.xin@gmail.com>
 <6b9a82f18f69682fea668026d33b937c1702a09a.1521025473.git.lucien.xin@gmail.com>
 <20180314135927.GA28936@hmswarspite.think-freely.org>
 <CADvbK_ew__wdmX9KeE38S7=3YWJ7nFJB7YXyMKxPr8y+Bo9+qw@mail.gmail.com>
In-Reply-To: <CADvbK_ew__wdmX9KeE38S7=3YWJ7nFJB7YXyMKxPr8y+Bo9+qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>

On Thu, Mar 15, 2018 at 12:12:32AM +0800, Xin Long wrote:
> On Wed, Mar 14, 2018 at 9:59 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > On Wed, Mar 14, 2018 at 07:05:30PM +0800, Xin Long wrote:
> >> With refcnt support for sh_key, chunks auth sh_keys can be decided
> >> before enqueuing it. Changing the active key later will not affect
> >> the chunks already enqueued.
> >>
> >> Furthermore, this is necessary when adding the support for authinfo
> >> for sendmsg in next patch.
> >>
> >> Note that struct sctp_chunk can't be grown due to that performance
> >> drop issue on slow cpu, so it just reuses head_skb memory for shkey
> >> in sctp_chunk.
> >>
> >> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> >> ---
> >>  include/net/sctp/auth.h    |  9 +++--
> >>  include/net/sctp/sm.h      |  3 +-
> >>  include/net/sctp/structs.h |  9 +++--
> >>  net/sctp/auth.c            | 86 +++++++++++++++++++++++-----------------------
> >>  net/sctp/chunk.c           |  5 +++
> >>  net/sctp/output.c          | 18 ++++++++--
> >>  net/sctp/sm_make_chunk.c   | 15 ++++++--
> >>  net/sctp/sm_statefuns.c    | 11 +++---
> >>  net/sctp/socket.c          |  6 ++++
> >>  9 files changed, 104 insertions(+), 58 deletions(-)
> >>
> >> diff --git a/include/net/sctp/auth.h b/include/net/sctp/auth.h
> >> index e5c57d0..017c1aa 100644
> >> --- a/include/net/sctp/auth.h
> >> +++ b/include/net/sctp/auth.h
> >> @@ -62,8 +62,9 @@ struct sctp_auth_bytes {
> >>  /* Definition for a shared key, weather endpoint or association */
> >>  struct sctp_shared_key {
> >>       struct list_head key_list;
> >> -     __u16 key_id;
> >>       struct sctp_auth_bytes *key;
> >> +     refcount_t refcnt;
> >> +     __u16 key_id;
> >>  };
> >>
> >>  #define key_for_each(__key, __list_head) \
> >> @@ -103,8 +104,10 @@ int sctp_auth_send_cid(enum sctp_cid chunk,
> >>  int sctp_auth_recv_cid(enum sctp_cid chunk,
> >>                      const struct sctp_association *asoc);
> >>  void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
> >> -                         struct sk_buff *skb,
> >> -                         struct sctp_auth_chunk *auth, gfp_t gfp);
> >> +                           struct sk_buff *skb, struct sctp_auth_chunk *auth,
> >> +                           struct sctp_shared_key *ep_key, gfp_t gfp);
> >> +void sctp_auth_shkey_release(struct sctp_shared_key *sh_key);
> >> +void sctp_auth_shkey_hold(struct sctp_shared_key *sh_key);
> >>
> >>  /* API Helpers */
> >>  int sctp_auth_ep_add_chunkid(struct sctp_endpoint *ep, __u8 chunk_id);
> >> diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
> >> index 2883c43..2d0e782 100644
> >> --- a/include/net/sctp/sm.h
> >> +++ b/include/net/sctp/sm.h
> >> @@ -263,7 +263,8 @@ int sctp_process_asconf_ack(struct sctp_association *asoc,
> >>  struct sctp_chunk *sctp_make_fwdtsn(const struct sctp_association *asoc,
> >>                                   __u32 new_cum_tsn, size_t nstreams,
> >>                                   struct sctp_fwdtsn_skip *skiplist);
> >> -struct sctp_chunk *sctp_make_auth(const struct sctp_association *asoc);
> >> +struct sctp_chunk *sctp_make_auth(const struct sctp_association *asoc,
> >> +                               __u16 key_id);
> >>  struct sctp_chunk *sctp_make_strreset_req(const struct sctp_association *asoc,
> >>                                         __u16 stream_num, __be16 *stream_list,
> >>                                         bool out, bool in);
> >> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> >> index ec6e46b..49ad67b 100644
> >> --- a/include/net/sctp/structs.h
> >> +++ b/include/net/sctp/structs.h
> >> @@ -577,8 +577,12 @@ struct sctp_chunk {
> >>       /* This points to the sk_buff containing the actual data.  */
> >>       struct sk_buff *skb;
> >>
> >> -     /* In case of GSO packets, this will store the head one */
> >> -     struct sk_buff *head_skb;
> >> +     union {
> >> +             /* In case of GSO packets, this will store the head one */
> >> +             struct sk_buff *head_skb;
> >> +             /* In case of auth enabled, this will point to the shkey */
> >> +             struct sctp_shared_key *shkey;
> >> +     };
> > Why do you need to add this at all?  You add the shared key pointer to the
> > association in this patch, and sctp_chunk already has a pointer to the
> > association, so you should already be able to find the shared key via
> > chunk->asoc->shkey, no?
> We need this, because one asoc can have a list of shared keys.
> When sending a msg, we can even choose one of these keys with
> cmsg info (cmsgs->authinfo) for this msg, which is that
> 5.3.8.  SCTP AUTH Information Structure (SCTP_AUTHINFO)
> is supposed to do. (Patch 2/5)
> 
> After this patchset, asoc->shkey (or we can say active shkey) is
> more like default shkey. It will be used only when SCTP_AUTHINFO
> is not set in cmsg info.

And even then, now once the chunk is enqueued, asoc->shkey is allowed
to change without affecting it.

This is probably one of the main improvements on this patchset.

  M.
