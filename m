From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 20 Feb 2009 02:32:04 +0000
Subject: [PATCH] sctp: used time_before or time_after for comparing jiffies
Message-Id: <499E1624.9010001@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

The functions time_before or time_after are more robust
for comparing jiffies against other values.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/outqueue.c  |    3 ++-
 net/sctp/transport.c |    7 ++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index bc411c8..a367d15 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -428,7 +428,8 @@ void sctp_retransmit_mark(struct sctp_outq *q,
 			 * retransmitting due to T3 timeout.
 			 */
 			if (reason = SCTP_RTXR_T3_RTX &&
-			    (jiffies - chunk->sent_at) < transport->last_rto)
+			    time_before(jiffies, chunk->sent_at +
+						 transport->last_rto))
 				continue;
 
 			/* RFC 2960 6.2.1 Processing a Received SACK
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index e745c11..e197b76 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -542,8 +542,8 @@ void sctp_transport_lower_cwnd(struct sctp_transport *transport,
 		 * congestion indications more than once every window of
 		 * data (or more loosely more than once every round-trip time).
 		 */
-		if ((jiffies - transport->last_time_ecne_reduced) >
-		    transport->rtt) {
+		if (time_after(jiffies, transport->last_time_ecne_reduced +
+					transport->rtt)) {
 			transport->ssthresh = max(transport->cwnd/2,
 						  4*transport->asoc->pathmtu);
 			transport->cwnd = transport->ssthresh;
@@ -560,7 +560,8 @@ void sctp_transport_lower_cwnd(struct sctp_transport *transport,
 		 * to be done every RTO interval, we do it every hearbeat
 		 * interval.
 		 */
-		if ((jiffies - transport->last_time_used) > transport->rto)
+		if (time_after(jiffies, transport->last_time_used +
+					transport->rto))
 			transport->cwnd = max(transport->cwnd/2,
 						 4*transport->asoc->pathmtu);
 		break;
-- 
1.5.3.8




