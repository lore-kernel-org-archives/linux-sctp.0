From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 31 Jan 2013 02:58:48 +0000
Subject: Re: Suspected renege problem in sctp
Message-Id: <5109DDE8.9050700@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 01/30/2013 07:51 PM, Bob Montgomery wrote:
> Vlad,
>
> If you're not the right guy to ask can you let me know who might be?

Hi Bob.  I am still the right person, but it would be even better to
address these types of questions and writeups to linux-sctp@vger.kernel.org.

>
> We've been investigating sctpspray hangs for quite some time.
>
> I think we're seeing a case where a renege operation is removing
> fragments from the ulp reasm queue that are at or below the value
> of cumulative_tsn_ack_point.  We put a BUG statement in
> sctp_tsnmap_renege so we'd crash instead of ignoring this case:
>
>          if (TSN_lt(tsn, map->base_tsn))
>                  return;


Hmm..  Looking at the reneging functions there is no TSN checking at 
all.  You are completely right.  We MUST not renege DATA that has moved
the cumulative_tsn_ack_point.

Adding something like this in sctp_ulpq_renege_list should fix this:

diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index ada1746..9bd94e6 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -970,10 +970,14 @@ static __u16 sctp_ulpq_renege_list(struct 
sctp_ulpq *ulpq,
         tsnmap = &ulpq->asoc->peer.tsn_map;

         while ((skb = __skb_dequeue_tail(list)) != NULL) {
-               freed += skb_headlen(skb);
                 event = sctp_skb2event(skb);
                 tsn = event->tsn;
-
+
+               /* Make sure we do not renege below CTSN */
+               if (TSN_lte(tsn, sctp_tsnmap_get_ctsn(tsnmap)))
+                       break;
+
+               freed += skb_headlen(skb);
                 sctp_ulpevent_free(event);
                 sctp_tsnmap_renege(tsnmap, tsn);
                 if (freed >= needed)

I think there also might be a bug here when reneging from the ordered 
queue and the message has been reassembled.  I need to look at that a 
bit more.

-vlad

>
> And after two days of sctpspray pounding, hit the bug.
>
> Here's a partial write-up using examples from the core file:
>
> ====================================> Fact 1:  a renege operation will only be launched if there's a gap in
> the tsn.
>
> So a reassembly queue like this one would not be set upon:
>
> PID 1784
> sctp_association 0xffff88041b6a2000
>
>        tsn_map = 0xffff88041dd8d560,
>        base_tsn = 0x55751715,
>        cumulative_tsn_ack_point = 0x55751714,
>        max_tsn_seen = 0x55751714,
>
> reasm queue summary:
>    ssn = 0x345,   tsn = 0x5575170c,   msg_flags = 0x2,   rmem_len = 0x69c
>    ssn = 0x345,   tsn = 0x5575170d,   msg_flags = 0x0,   rmem_len = 0x69c
>    ssn = 0x345,   tsn = 0x5575170e,   msg_flags = 0x0,   rmem_len = 0x69c
>    ssn = 0x345,   tsn = 0x5575170f,   msg_flags = 0x0,   rmem_len = 0x69c
>    ssn = 0x345,   tsn = 0x55751710,   msg_flags = 0x0,   rmem_len = 0x69c
>    ssn = 0x345,   tsn = 0x55751711,   msg_flags = 0x0,   rmem_len = 0x69c
>    ssn = 0x345,   tsn = 0x55751712,   msg_flags = 0x0,   rmem_len = 0x69c
>    ssn = 0x345,   tsn = 0x55751713,   msg_flags = 0x0,   rmem_len = 0x69c
>    ssn = 0x345,   tsn = 0x55751714,   msg_flags = 0x0,   rmem_len = 0x69c
>
> No gap: the last tsn in the reasm queue matches cumulative_tsn_ack_point = 0x55751714,
>
>
> In our case, I believe the reasm queue looked like this when the renege launched:
>
> In sctp_association 0xffff88041b845000
>
>        base_tsn = 0x936a6d76,
>        cumulative_tsn_ack_point = 0x936a6d75,
>        max_tsn_seen = 0x936a6d79,
>
>    ssn = 0x0,   tsn = 0x936a6d6f,   msg_flags = 0x2,   rmem_len = 0x69c
>    ssn = 0x0,   tsn = 0x936a6d70,   msg_flags = 0x0,   rmem_len = 0x69c
>    ssn = 0x0,   tsn = 0x936a6d71,   msg_flags = 0x0,   rmem_len = 0x69c
>    ssn = 0x0,   tsn = 0x936a6d72,   msg_flags = 0x0,   rmem_len = 0x69c
>    ssn = 0x0,   tsn = 0x936a6d73,   msg_flags = 0x0,   rmem_len = 0x69c
>    ssn = 0x0,   tsn = 0x936a6d74,   msg_flags = 0x0,   rmem_len = 0x69c
>    ssn = 0x0,   tsn = 0x936a6d75,   msg_flags = 0x0,   rmem_len = 0x69c
>
>    ssn = 0x0,   tsn = 0x936a6d78,   msg_flags = 0x0,   rmem_len = 0x628
>
> The gap between 75 and 78 meant that a renege could be launched.
>
> It was launched for tsn = 0x936a6d76 (just arriving and apparently out
> of memory), and the "needed" amount was 0x05ac (1452 bytes).
>
> tsn = 0x936a6d78 was removed, and the amount recovered was 0x538 (1336 bytes).
> The value of "rmem_len" in the event is not what is used to calculated needed
> and freed.
>
> Since 0x538 didn't satisfy 0x5ac, it went for the next one down on the queue
> (tsn = 0x936a6d75)
> and recovered 0x5ac from it for a total recovery of 0xae4 (2788 bytes).
> So because the first post-gap fragment happened to be a LAST_FRAG and shorter than
> the rest of them, it wasn't enough to satisfy the request and we moved on
> to the one that caused the BUG.
>
> If there had been two gapped frags, or if the gapped frag had been another
> middle one that was big enough to satisfy the request, it would not have
> been caught freeing a fragment that was at the cumulative tsn ack point.
> ====================================
>
> Since the base_tsn and cumulative_tsn_ack_point are advanced in
> sctp_ulpevent_make_rcvmsg() before putting the fragments on the
> reasm queue, the renege code should not be allowed to dip below
> that point in sctp_ulpq_renege_list().   Otherwise, you're
> discarding undelivered data that you've already reported as
> "delivered" to the sender, right?
>
> Thanks,
> Bob Montgomery
>
>
>
>

