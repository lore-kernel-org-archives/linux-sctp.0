From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 02 Mar 2009 19:46:13 +0000
Subject: [PATCH net-next 4/5] sctp: use time_before or time_after for comparing jiffies
Message-Id: <1236023174-18314-5-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <>
 <1236023174-18314-1-git-send-email-vladislav.yasevich@hp.com>
 <1236023174-18314-2-git-send-email-vladislav.yasevich@hp.com>
 <1236023174-18314-3-git-send-email-vladislav.yasevich@hp.com>
 <1236023174-18314-4-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1236023174-18314-4-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, Wei Yongjun <yjwei@cn.fujitsu.com>, Vlad Yasevich <vladislav.yasevich@hp.com>

From: Wei Yongjun <yjwei@cn.fujitsu.com>

The functions time_before or time_after are more robust
for comparing jiffies against other values.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
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
index 5c29b14..e5dde45 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -543,8 +543,8 @@ void sctp_transport_lower_cwnd(struct sctp_transport *transport,
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
@@ -561,7 +561,8 @@ void sctp_transport_lower_cwnd(struct sctp_transport *transport,
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
1.5.4.3

