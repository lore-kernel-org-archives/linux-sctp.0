From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 03 May 2018 11:23:41 +0000
Subject: Re: [PATCH] sctp: fix a potential missing-check bug
Message-Id: <20180503112341.GA4220@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1525299165-27098-1-git-send-email-wang6495@umn.edu>
 <20180502232352.GJ5105@localhost.localdomain>
 <CAAa=b7d_dHFUudPdJr3YuDaYRzNvAgHd0Lcubw3Ks94O-2kb3w@mail.gmail.com>
In-Reply-To: <CAAa=b7d_dHFUudPdJr3YuDaYRzNvAgHd0Lcubw3Ks94O-2kb3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wenwen Wang <wang6495@umn.edu>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Kangjie Lu <kjlu@umn.edu>, Vlad Yasevich <vyasevich@gmail.com>, "David S. Miller" <davem@davemloft.net>, "open list:SCTP PROTOCOL" <linux-sctp@vger.kernel.org>, "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

On Wed, May 02, 2018 at 08:07:17PM -0500, Wenwen Wang wrote:
> Hi Marcelo,
> 
> I guess I worked on an old version of the kernel. I will re-submit the
> patch. Sorry :(
> 
You don't have to resubmit the patch, this isn't broken.  As marcelo points out,
a value of zero in this socket option is special, meaning set the fragmentation
to whatever the pmtu is, which will always rest between the min and max segment
lengths.

Neil

> Wenwen
> 
> On Wed, May 2, 2018 at 6:23 PM, Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> > Hi Wenwen,
> >
> > On Wed, May 02, 2018 at 05:12:45PM -0500, Wenwen Wang wrote:
> >> In sctp_setsockopt_maxseg(), the integer 'val' is compared against min_len
> >> and max_len to check whether it is in the appropriate range. If it is not,
> >> an error code -EINVAL will be returned. This is enforced by a security
> >> check. But, this check is only executed when 'val' is not 0. In fact, if
> >
> > Which makes sense, no? Especially if considering that 0 should be an
> > allowed value as it turns off the user limit.
> >
> >> 'val' is 0, it will be assigned with a new value (if the return value of
> >> the function sctp_id2assoc() is not 0) in the following execution. However,
> >> this new value of 'val' is not checked before it is used to assigned to
> >
> > Which 'new value'? val is not set to something new during the
> > function. It always contains the user supplied value.
> >
> >> asoc->user_frag. That means it is possible that the new value of 'val'
> >> could be out of the expected range. This can cause security issues
> >> such as buffer overflows, e.g., the new value of 'val' is used as an index
> >> to access a buffer.
> >>
> >> This patch inserts a check for the new value of 'val' to see if it is in
> >> the expected range. If it is not, an error code -EINVAL will be returned.
> >>
> >> Signed-off-by: Wenwen Wang <wang6495@umn.edu>
> >> ---
> >>  net/sctp/socket.c | 21 ++++++++++-----------
> >>  1 file changed, 10 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> >> index 80835ac..2beb601 100644
> >> --- a/net/sctp/socket.c
> >> +++ b/net/sctp/socket.c
> >> @@ -3212,6 +3212,7 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
> >>       struct sctp_af *af = sp->pf->af;
> >>       struct sctp_assoc_value params;
> >>       struct sctp_association *asoc;
> >> +     int min_len, max_len;
> >>       int val;
> >>
> >>       if (optlen = sizeof(int)) {
> >> @@ -3231,19 +3232,15 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
> >>               return -EINVAL;
> >>       }
> >>
> >> -     if (val) {
> >> -             int min_len, max_len;
> >> +     min_len = SCTP_DEFAULT_MINSEGMENT - af->net_header_len;
> >> +     min_len -= af->ip_options_len(sk);
> >> +     min_len -= sizeof(struct sctphdr) +
> >> +                sizeof(struct sctp_data_chunk);
> >
> > On which tree did you base your patch on? Your patch lacks a tag so it
> > defaults to net-next, and I reworked this section on current net-next
> > and these MTU calculcations are now handled by sctp_mtu_payload().
> >
> > But even for net tree, I don't understand which issue you're fixing
> > here. Actually it seems to me that both codes seems to do the same
> > thing.
> >
> >>
> >> -             min_len = SCTP_DEFAULT_MINSEGMENT - af->net_header_len;
> >> -             min_len -= af->ip_options_len(sk);
> >> -             min_len -= sizeof(struct sctphdr) +
> >> -                        sizeof(struct sctp_data_chunk);
> >> +     max_len = SCTP_MAX_CHUNK_LEN - sizeof(struct sctp_data_chunk);
> >>
> >> -             max_len = SCTP_MAX_CHUNK_LEN - sizeof(struct sctp_data_chunk);
> >> -
> >> -             if (val < min_len || val > max_len)
> >> -                     return -EINVAL;
> >> -     }
> >> +     if (val && (val < min_len || val > max_len))
> >> +             return -EINVAL;
> >>
> >>       asoc = sctp_id2assoc(sk, params.assoc_id);
> >>       if (asoc) {
> >> @@ -3253,6 +3250,8 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
> >>                       val -= sizeof(struct sctphdr) +
> >>                              sctp_datachk_len(&asoc->stream);
> >>               }
> >> +             if (val < min_len || val > max_len)
> >> +                     return -EINVAL;
> >>               asoc->user_frag = val;
> >>               asoc->frag_point = sctp_frag_point(asoc, asoc->pathmtu);
> >>       } else {
> >> --
> >> 2.7.4
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> 
