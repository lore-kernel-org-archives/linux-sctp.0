From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 12 May 2018 22:21:12 +0000
Subject: [PATCH net-next v2 7/8] sctp: make use of gfp on retransmissions
Message-Id: <7f569955f4d33ad9c3fe797d8f650c35a602eae6.1526142784.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1526142784.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1526142784.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>

Retransmissions may be triggered when in user context, so lets make use
of gfp.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/outqueue.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 3b738fdb08b9c596e6d4d4b18bef645187e0da4a..8173dd26f5878cbf67dd7e162ac5e6b18d9a3332 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -608,7 +608,7 @@ void sctp_retransmit(struct sctp_outq *q, struct sctp_transport *transport,
  * The return value is a normal kernel error return value.
  */
 static int __sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
-				 int rtx_timeout, int *start_timer)
+				 int rtx_timeout, int *start_timer, gfp_t gfp)
 {
 	struct sctp_transport *transport = pkt->transport;
 	struct sctp_chunk *chunk, *chunk1;
@@ -684,12 +684,12 @@ static int __sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 				 * control chunks are already freed so there
 				 * is nothing we can do.
 				 */
-				sctp_packet_transmit(pkt, GFP_ATOMIC);
+				sctp_packet_transmit(pkt, gfp);
 				goto redo;
 			}
 
 			/* Send this packet.  */
-			error = sctp_packet_transmit(pkt, GFP_ATOMIC);
+			error = sctp_packet_transmit(pkt, gfp);
 
 			/* If we are retransmitting, we should only
 			 * send a single packet.
@@ -705,7 +705,7 @@ static int __sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 
 		case SCTP_XMIT_RWND_FULL:
 			/* Send this packet. */
-			error = sctp_packet_transmit(pkt, GFP_ATOMIC);
+			error = sctp_packet_transmit(pkt, gfp);
 
 			/* Stop sending DATA as there is no more room
 			 * at the receiver.
@@ -715,7 +715,7 @@ static int __sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 
 		case SCTP_XMIT_DELAY:
 			/* Send this packet. */
-			error = sctp_packet_transmit(pkt, GFP_ATOMIC);
+			error = sctp_packet_transmit(pkt, gfp);
 
 			/* Stop sending DATA because of nagle delay. */
 			done = 1;
@@ -991,7 +991,7 @@ static void sctp_outq_flush_ctrl(struct sctp_outq *q,
 static bool sctp_outq_flush_rtx(struct sctp_outq *q,
 				struct sctp_transport **_transport,
 				struct list_head *transport_list,
-				int rtx_timeout)
+				int rtx_timeout, gfp_t gfp)
 {
 	struct sctp_transport *transport = *_transport;
 	struct sctp_packet *packet = transport ? &transport->packet : NULL;
@@ -1015,7 +1015,8 @@ static bool sctp_outq_flush_rtx(struct sctp_outq *q,
 				   asoc->peer.ecn_capable);
 	}
 
-	error = __sctp_outq_flush_rtx(q, packet, rtx_timeout, &start_timer);
+	error = __sctp_outq_flush_rtx(q, packet, rtx_timeout, &start_timer,
+				      gfp);
 	if (error < 0)
 		asoc->base.sk->sk_err = -error;
 
@@ -1074,7 +1075,7 @@ static void sctp_outq_flush_data(struct sctp_outq *q,
 		 */
 		if (!list_empty(&q->retransmit)) {
 			if (!sctp_outq_flush_rtx(q, _transport, transport_list,
-						 rtx_timeout))
+						 rtx_timeout, gfp))
 				break;
 			/* We may have switched current transport */
 			transport = *_transport;
-- 
2.14.3

