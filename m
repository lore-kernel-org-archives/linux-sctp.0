From: Andrei Pelinescu-Onciul <andrei@iptel.org>
Date: Mon, 23 Nov 2009 17:26:04 +0000
Subject: Re: [PATCH] sctp: on T3_RTX retransmit all the in-flight chunks
Message-Id: <20091123172602.GM10897@shell.iptel.org>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="w7PDEPdKQumQfZlR"
List-Id: <linux-sctp.vger.kernel.org>
References: <20091123133916.GL10897@shell.iptel.org>
In-Reply-To: <20091123133916.GL10897@shell.iptel.org>
To: linux-sctp@vger.kernel.org


--w7PDEPdKQumQfZlR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Nov 23, 2009 at 11:50, Vlad Yasevich <vladislav.yasevich@hp.com> wrote:
> 
> 
> > Example: 10 packets in flight, sent at 0.1 s intervals on the
> > primary path. The primary path is down and the first packet
> > timeouts. The first packet is retransmitted on another path, the
> > T3 timer for the primary path is stopped and cwnd is set to MTU.
> > All the other 9 in-flight packets will not be retransmitted
> > (unless more new packets are sent on the primary path which depends
> > on cwnd allowing it, and even in this case the 9 packets will be
> > retransmitted only after a new packet timeouts which even in the
> > best case would be more then RTO).
> > 
> 
> Thanks.  This code was done after talking with Randy Stewart.
> He said that linux was retransmitting chunks too early in some
> situations.  This would happen when small chunks are bundled,
> and it might be possible to retransmit a chunk that was just
> sent.
> 
> I agree, though, that the original code meets the letter of the
> spec better and works better too.  Can you get rid of the last_rto
> definition and code too, since that was there to work around
> a problem that was related to the original commit.

Updated patch (git format), that removes last_rto attached.


Andrei

--w7PDEPdKQumQfZlR
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-sctp-on-T3_RTX-retransmit-all-the-in-flight-chunks.patch"

From 29abf879cc488ad73d2429b6d380fa0e3a20f1a6 Mon Sep 17 00:00:00 2001
From: Andrei Pelinescu-Onciul <andrei@iptel.org>
Date: Mon, 23 Nov 2009 14:02:02 +0100
Subject: [PATCH] sctp: on T3_RTX retransmit all the in-flight chunks

When retransmitting due to T3 timeout, retransmit all the
in-flight chunks for the corresponding  transport/path, including
chunks sent less then 1 rto ago.
This is the correct behaviour according to rfc4960 section 6.3.3
E3 and
"Note: Any DATA chunks that were sent to the address for which the
 T3-rtx timer expired but did not fit in one MTU (rule E3 above)
 should be marked for retransmission and sent as soon as cwnd
 allows (normally, when a SACK arrives). ".

This fixes problems when more then one path is present and the T3
retransmission of the first chunk that timeouts stops the T3 timer
for the initial active path, leaving all the other in-flight
chunks waiting forever or until a new chunk is transmitted on the
same path and timeouts (and this will happen only if the cwnd
allows sending new chunks, but since cwnd was dropped to MTU by
the timeout => it will wait until the first heartbeat).

Example: 10 packets in flight, sent at 0.1 s intervals on the
primary path. The primary path is down and the first packet
timeouts. The first packet is retransmitted on another path, the
T3 timer for the primary path is stopped and cwnd is set to MTU.
All the other 9 in-flight packets will not be retransmitted
(unless more new packets are sent on the primary path which depend
on cwnd allowing it, and even in this case the 9 packets will be
retransmitted only after a new packet timeouts which even in the
best case would be more then RTO).

This commit reverts d0ce92910bc04e107b2f3f2048f07e94f570035d and
also removes the now unused transport->last_rto, introduced in
 b6157d8e03e1e780660a328f7183bcbfa4a93a19.

Signed-off-by: Andrei Pelinescu-Onciul <andrei@iptel.org>
---
 include/net/sctp/structs.h |    1 -
 net/sctp/outqueue.c        |   10 ----------
 net/sctp/sm_sideeffect.c   |    1 -
 net/sctp/transport.c       |    5 ++---
 4 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index edfcacf..a106695 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -892,7 +892,6 @@ struct sctp_transport {
 	 */
 	/* RTO	       : The current retransmission timeout value.  */
 	unsigned long rto;
-	unsigned long last_rto;
 
 	__u32 rtt;		/* This is the most recent RTT.	 */
 
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index d765fc5..746f06c 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -422,16 +422,6 @@ void sctp_retransmit_mark(struct sctp_outq *q,
 		if ((reason == SCTP_RTXR_FAST_RTX  &&
 			    (chunk->fast_retransmit == SCTP_NEED_FRTX)) ||
 		    (reason != SCTP_RTXR_FAST_RTX  && !chunk->tsn_gap_acked)) {
-			/* If this chunk was sent less then 1 rto ago, do not
-			 * retransmit this chunk, but give the peer time
-			 * to acknowlege it.  Do this only when
-			 * retransmitting due to T3 timeout.
-			 */
-			if (reason == SCTP_RTXR_T3_RTX &&
-			    time_before(jiffies, chunk->sent_at +
-						 transport->last_rto))
-				continue;
-
 			/* RFC 2960 6.2.1 Processing a Received SACK
 			 *
 			 * C) Any time a DATA chunk is marked for
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 86426aa..1606bda 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -468,7 +468,6 @@ static void sctp_do_8_2_transport_strike(struct sctp_association *asoc,
 	 * that indicates that we have an outstanding HB.
 	 */
 	if (!is_hb || transport->hb_sent) {
-		transport->last_rto = transport->rto;
 		transport->rto = min((transport->rto * 2), transport->asoc->rto_max);
 	}
 }
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index e5dde45..44c7289 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -74,7 +74,7 @@ static struct sctp_transport *sctp_transport_init(struct sctp_transport *peer,
 	 * given destination transport address, set RTO to the protocol
 	 * parameter 'RTO.Initial'.
 	 */
-	peer->last_rto = peer->rto = msecs_to_jiffies(sctp_rto_initial);
+	peer->rto = msecs_to_jiffies(sctp_rto_initial);
 	peer->rtt = 0;
 	peer->rttvar = 0;
 	peer->srtt = 0;
@@ -385,7 +385,6 @@ void sctp_transport_update_rto(struct sctp_transport *tp, __u32 rtt)
 		tp->rto = tp->asoc->rto_max;
 
 	tp->rtt = rtt;
-	tp->last_rto = tp->rto;
 
 	/* Reset rto_pending so that a new RTT measurement is started when a
 	 * new data chunk is sent.
@@ -598,7 +597,7 @@ void sctp_transport_reset(struct sctp_transport *t)
 	 */
 	t->cwnd = min(4*asoc->pathmtu, max_t(__u32, 2*asoc->pathmtu, 4380));
 	t->ssthresh = asoc->peer.i.a_rwnd;
-	t->last_rto = t->rto = asoc->rto_initial;
+	t->rto = asoc->rto_initial;
 	t->rtt = 0;
 	t->srtt = 0;
 	t->rttvar = 0;
-- 
1.6.5.2


--w7PDEPdKQumQfZlR--
