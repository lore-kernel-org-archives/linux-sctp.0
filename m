From: Andrei Pelinescu-Onciul <andrei@iptel.org>
Date: Mon, 23 Nov 2009 13:39:18 +0000
Subject: [PATCH] sctp: on T3_RTX retransmit all the in-flight chunks
Message-Id: <20091123133916.GL10897@shell.iptel.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

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
(unless more new packets are sent on the primary path which depends
on cwnd allowing it, and even in this case the 9 packets will be
retransmitted only after a new packet timeouts which even in the
best case would be more then RTO).

This commit reverts d0ce92910bc04e107b2f3f2048f07e94f570035d.

Signed-off-by: Andrei Pelinescu-Onciul <andrei@iptel.org>
---
 net/sctp/outqueue.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index d765fc5..746f06c 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -422,16 +422,6 @@ void sctp_retransmit_mark(struct sctp_outq *q,
 		if ((reason = SCTP_RTXR_FAST_RTX  &&
 			    (chunk->fast_retransmit = SCTP_NEED_FRTX)) ||
 		    (reason != SCTP_RTXR_FAST_RTX  && !chunk->tsn_gap_acked)) {
-			/* If this chunk was sent less then 1 rto ago, do not
-			 * retransmit this chunk, but give the peer time
-			 * to acknowlege it.  Do this only when
-			 * retransmitting due to T3 timeout.
-			 */
-			if (reason = SCTP_RTXR_T3_RTX &&
-			    time_before(jiffies, chunk->sent_at +
-						 transport->last_rto))
-				continue;
-
 			/* RFC 2960 6.2.1 Processing a Received SACK
 			 *
 			 * C) Any time a DATA chunk is marked for
-- 
1.6.5.2

