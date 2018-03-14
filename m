From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 14 Mar 2018 16:12:32 +0000
Subject: Re: [PATCH net-next 1/5] sctp: add refcnt support for sh_key
Message-Id: <CADvbK_ew__wdmX9KeE38S7=3YWJ7nFJB7YXyMKxPr8y+Bo9+qw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1521025473.git.lucien.xin@gmail.com> <6b9a82f18f69682fea668026d33b937c1702a09a.1521025473.git.lucien.xin@gmail.com>
 <20180314135927.GA28936@hmswarspite.think-freely.org>
In-Reply-To: <20180314135927.GA28936@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, davem <davem@davemloft.net>

On Wed, Mar 14, 2018 at 9:59 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Wed, Mar 14, 2018 at 07:05:30PM +0800, Xin Long wrote:
>> With refcnt support for sh_key, chunks auth sh_keys can be decided
>> before enqueuing it. Changing the active key later will not affect
>> the chunks already enqueued.
>>
>> Furthermore, this is necessary when adding the support for authinfo
>> for sendmsg in next patch.
>>
>> Note that struct sctp_chunk can't be grown due to that performance
>> drop issue on slow cpu, so it just reuses head_skb memory for shkey
>> in sctp_chunk.
>>
>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>> ---
>>  include/net/sctp/auth.h    |  9 +++--
>>  include/net/sctp/sm.h      |  3 +-
>>  include/net/sctp/structs.h |  9 +++--
>>  net/sctp/auth.c            | 86 +++++++++++++++++++++++-----------------------
>>  net/sctp/chunk.c           |  5 +++
>>  net/sctp/output.c          | 18 ++++++++--
>>  net/sctp/sm_make_chunk.c   | 15 ++++++--
>>  net/sctp/sm_statefuns.c    | 11 +++---
>>  net/sctp/socket.c          |  6 ++++
>>  9 files changed, 104 insertions(+), 58 deletions(-)
>>
>> diff --git a/include/net/sctp/auth.h b/include/net/sctp/auth.h
>> index e5c57d0..017c1aa 100644
>> --- a/include/net/sctp/auth.h
>> +++ b/include/net/sctp/auth.h
>> @@ -62,8 +62,9 @@ struct sctp_auth_bytes {
>>  /* Definition for a shared key, weather endpoint or association */
>>  struct sctp_shared_key {
>>       struct list_head key_list;
>> -     __u16 key_id;
>>       struct sctp_auth_bytes *key;
>> +     refcount_t refcnt;
>> +     __u16 key_id;
>>  };
>>
>>  #define key_for_each(__key, __list_head) \
>> @@ -103,8 +104,10 @@ int sctp_auth_send_cid(enum sctp_cid chunk,
>>  int sctp_auth_recv_cid(enum sctp_cid chunk,
>>                      const struct sctp_association *asoc);
>>  void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
>> -                         struct sk_buff *skb,
>> -                         struct sctp_auth_chunk *auth, gfp_t gfp);
>> +                           struct sk_buff *skb, struct sctp_auth_chunk *auth,
>> +                           struct sctp_shared_key *ep_key, gfp_t gfp);
>> +void sctp_auth_shkey_release(struct sctp_shared_key *sh_key);
>> +void sctp_auth_shkey_hold(struct sctp_shared_key *sh_key);
>>
>>  /* API Helpers */
>>  int sctp_auth_ep_add_chunkid(struct sctp_endpoint *ep, __u8 chunk_id);
>> diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
>> index 2883c43..2d0e782 100644
>> --- a/include/net/sctp/sm.h
>> +++ b/include/net/sctp/sm.h
>> @@ -263,7 +263,8 @@ int sctp_process_asconf_ack(struct sctp_association *asoc,
>>  struct sctp_chunk *sctp_make_fwdtsn(const struct sctp_association *asoc,
>>                                   __u32 new_cum_tsn, size_t nstreams,
>>                                   struct sctp_fwdtsn_skip *skiplist);
>> -struct sctp_chunk *sctp_make_auth(const struct sctp_association *asoc);
>> +struct sctp_chunk *sctp_make_auth(const struct sctp_association *asoc,
>> +                               __u16 key_id);
>>  struct sctp_chunk *sctp_make_strreset_req(const struct sctp_association *asoc,
>>                                         __u16 stream_num, __be16 *stream_list,
>>                                         bool out, bool in);
>> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
>> index ec6e46b..49ad67b 100644
>> --- a/include/net/sctp/structs.h
>> +++ b/include/net/sctp/structs.h
>> @@ -577,8 +577,12 @@ struct sctp_chunk {
>>       /* This points to the sk_buff containing the actual data.  */
>>       struct sk_buff *skb;
>>
>> -     /* In case of GSO packets, this will store the head one */
>> -     struct sk_buff *head_skb;
>> +     union {
>> +             /* In case of GSO packets, this will store the head one */
>> +             struct sk_buff *head_skb;
>> +             /* In case of auth enabled, this will point to the shkey */
>> +             struct sctp_shared_key *shkey;
>> +     };
> Why do you need to add this at all?  You add the shared key pointer to the
> association in this patch, and sctp_chunk already has a pointer to the
> association, so you should already be able to find the shared key via
> chunk->asoc->shkey, no?
We need this, because one asoc can have a list of shared keys.
When sending a msg, we can even choose one of these keys with
cmsg info (cmsgs->authinfo) for this msg, which is that
5.3.8.  SCTP AUTH Information Structure (SCTP_AUTHINFO)
is supposed to do. (Patch 2/5)

After this patchset, asoc->shkey (or we can say active shkey) is
more like default shkey. It will be used only when SCTP_AUTHINFO
is not set in cmsg info.


>
>
>>
>>       /* These are the SCTP headers by reverse order in a packet.
>>        * Note that some of these may happen more than once.  In that
>> @@ -1995,6 +1999,7 @@ struct sctp_association {
>>        * The current generated assocaition shared key (secret)
>>        */
>>       struct sctp_auth_bytes *asoc_shared_key;
>> +     struct sctp_shared_key *shkey;
>>
>>       /* SCTP AUTH: hmac id of the first peer requested algorithm
>>        * that we support.
>> diff --git a/net/sctp/auth.c b/net/sctp/auth.c
>> index 00667c5..e5214fd 100644
>> --- a/net/sctp/auth.c
>> +++ b/net/sctp/auth.c
>> @@ -101,13 +101,14 @@ struct sctp_shared_key *sctp_auth_shkey_create(__u16 key_id, gfp_t gfp)
>>               return NULL;
>>
>>       INIT_LIST_HEAD(&new->key_list);
>> +     refcount_set(&new->refcnt, 1);
>>       new->key_id = key_id;
>>
>>       return new;
>>  }
>>
>>  /* Free the shared key structure */
>> -static void sctp_auth_shkey_free(struct sctp_shared_key *sh_key)
>> +static void sctp_auth_shkey_destroy(struct sctp_shared_key *sh_key)
>>  {
>>       BUG_ON(!list_empty(&sh_key->key_list));
>>       sctp_auth_key_put(sh_key->key);
>> @@ -115,6 +116,17 @@ static void sctp_auth_shkey_free(struct sctp_shared_key *sh_key)
>>       kfree(sh_key);
>>  }
>>
>> +void sctp_auth_shkey_release(struct sctp_shared_key *sh_key)
>> +{
>> +     if (refcount_dec_and_test(&sh_key->refcnt))
>> +             sctp_auth_shkey_destroy(sh_key);
>> +}
>> +
>> +void sctp_auth_shkey_hold(struct sctp_shared_key *sh_key)
>> +{
>> +     refcount_inc(&sh_key->refcnt);
>> +}
>> +
>>  /* Destroy the entire key list.  This is done during the
>>   * associon and endpoint free process.
>>   */
>> @@ -128,7 +140,7 @@ void sctp_auth_destroy_keys(struct list_head *keys)
>>
>>       key_for_each_safe(ep_key, tmp, keys) {
>>               list_del_init(&ep_key->key_list);
>> -             sctp_auth_shkey_free(ep_key);
>> +             sctp_auth_shkey_release(ep_key);
>>       }
>>  }
>>
>> @@ -409,13 +421,19 @@ int sctp_auth_asoc_init_active_key(struct sctp_association *asoc, gfp_t gfp)
>>
>>       sctp_auth_key_put(asoc->asoc_shared_key);
>>       asoc->asoc_shared_key = secret;
>> +     asoc->shkey = ep_key;
>>
>>       /* Update send queue in case any chunk already in there now
>>        * needs authenticating
>>        */
>>       list_for_each_entry(chunk, &asoc->outqueue.out_chunk_list, list) {
>> -             if (sctp_auth_send_cid(chunk->chunk_hdr->type, asoc))
>> +             if (sctp_auth_send_cid(chunk->chunk_hdr->type, asoc)) {
>>                       chunk->auth = 1;
>> +                     if (!chunk->shkey) {
>> +                             chunk->shkey = asoc->shkey;
>> +                             sctp_auth_shkey_hold(chunk->shkey);
>> +                     }
>> +             }
> Do we really need to take a reference for every chunk we send?  Wouldn't it be
> sufficient to just hold the shared key until the association is released?
As we can use other shkey(not only asoc->shkey) for one chunk, and even
different shkeys for different chunks, we have to hold it in case that this
shkey may be removed/freed when this chunk is still queuing up in
outqueue, until this chunk has been transmitted and freed.

make sense?
