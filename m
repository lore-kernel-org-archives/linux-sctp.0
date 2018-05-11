From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 11 May 2018 23:28:50 +0000
Subject: [PATCH net-next 4/8] sctp: move outq data rtx code out of sctp_outq_flush
Message-Id: <eb20da48124e573154f4512e70402a28c40faa8d.1526077476.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1526077476.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1526077476.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>

This patch renames current sctp_outq_flush_rtx to __sctp_outq_flush_rtx
and create a new sctp_outq_flush_rtx, with the code that was on
sctp_outq_flush. Again, the idea is to have functions with small and
defined objectives.

Yes, there is an open-coded path selection in the now sctp_outq_flush_rtx.
That is kept as is for now because it may be very different when we
implement retransmission path selection algorithms for CMT-SCTP.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/outqueue.c | 101 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 58 insertions(+), 43 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 1081e1eea703be5d65d9828c3e4265fbb7a155f9..74c3961eec4fca8b4ce9bb380f8465fae4625763 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -601,14 +601,14 @@ void sctp_retransmit(struct sctp_outq *q, struct sctp_transport *transport,
 
 /*
  * Transmit DATA chunks on the retransmit queue.  Upon return from
- * sctp_outq_flush_rtx() the packet 'pkt' may contain chunks which
+ * __sctp_outq_flush_rtx() the packet 'pkt' may contain chunks which
  * need to be transmitted by the caller.
  * We assume that pkt->transport has already been set.
  *
  * The return value is a normal kernel error return value.
  */
-static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
-			       int rtx_timeout, int *start_timer)
+static int __sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
+				 int rtx_timeout, int *start_timer)
 {
 	struct sctp_transport *transport = pkt->transport;
 	struct sctp_chunk *chunk, *chunk1;
@@ -987,6 +987,57 @@ static void sctp_outq_flush_ctrl(struct sctp_outq *q,
 	}
 }
 
+/* Returns false if new data shouldn't be sent */
+static bool sctp_outq_flush_rtx(struct sctp_outq *q,
+				struct sctp_transport **_transport,
+				struct list_head *transport_list,
+				int rtx_timeout)
+{
+	struct sctp_transport *transport = *_transport;
+	struct sctp_packet *packet = transport ? &transport->packet : NULL;
+	struct sctp_association *asoc = q->asoc;
+	int error, start_timer = 0;
+
+	if (asoc->peer.retran_path->state = SCTP_UNCONFIRMED)
+		return false;
+
+	if (transport != asoc->peer.retran_path) {
+		/* Switch transports & prepare the packet.  */
+		transport = asoc->peer.retran_path;
+		*_transport = transport;
+
+		if (list_empty(&transport->send_ready))
+			list_add_tail(&transport->send_ready,
+				      transport_list);
+
+		packet = &transport->packet;
+		sctp_packet_config(packet, asoc->peer.i.init_tag,
+				   asoc->peer.ecn_capable);
+	}
+
+	error = __sctp_outq_flush_rtx(q, packet, rtx_timeout, &start_timer);
+	if (error < 0)
+		asoc->base.sk->sk_err = -error;
+
+	if (start_timer) {
+		sctp_transport_reset_t3_rtx(transport);
+		transport->last_time_sent = jiffies;
+	}
+
+	/* This can happen on COOKIE-ECHO resend.  Only
+	 * one chunk can get bundled with a COOKIE-ECHO.
+	 */
+	if (packet->has_cookie_echo)
+		return false;
+
+	/* Don't send new data if there is still data
+	 * waiting to retransmit.
+	 */
+	if (!list_empty(&q->retransmit))
+		return false;
+
+	return true;
+}
 /*
  * Try to flush an outqueue.
  *
@@ -1000,12 +1051,10 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 {
 	struct sctp_packet *packet;
 	struct sctp_association *asoc = q->asoc;
-	__u32 vtag = asoc->peer.i.init_tag;
 	struct sctp_transport *transport = NULL;
 	struct sctp_chunk *chunk;
 	enum sctp_xmit status;
 	int error = 0;
-	int start_timer = 0;
 
 	/* These transports have chunks to send. */
 	struct list_head transport_list;
@@ -1052,45 +1101,11 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 		 * current cwnd).
 		 */
 		if (!list_empty(&q->retransmit)) {
-			if (asoc->peer.retran_path->state = SCTP_UNCONFIRMED)
-				goto sctp_flush_out;
-			if (transport = asoc->peer.retran_path)
-				goto retran;
-
-			/* Switch transports & prepare the packet.  */
-
-			transport = asoc->peer.retran_path;
-
-			if (list_empty(&transport->send_ready)) {
-				list_add_tail(&transport->send_ready,
-					      &transport_list);
-			}
-
+			if (!sctp_outq_flush_rtx(q, _transport, transport_list,
+						 rtx_timeout))
+				break;
+			/* We may have switched current transport */
 			packet = &transport->packet;
-			sctp_packet_config(packet, vtag,
-					   asoc->peer.ecn_capable);
-		retran:
-			error = sctp_outq_flush_rtx(q, packet,
-						    rtx_timeout, &start_timer);
-			if (error < 0)
-				asoc->base.sk->sk_err = -error;
-
-			if (start_timer) {
-				sctp_transport_reset_t3_rtx(transport);
-				transport->last_time_sent = jiffies;
-			}
-
-			/* This can happen on COOKIE-ECHO resend.  Only
-			 * one chunk can get bundled with a COOKIE-ECHO.
-			 */
-			if (packet->has_cookie_echo)
-				goto sctp_flush_out;
-
-			/* Don't send new data if there is still data
-			 * waiting to retransmit.
-			 */
-			if (!list_empty(&q->retransmit))
-				goto sctp_flush_out;
 		}
 
 		/* Apply Max.Burst limitation to the current transport in
-- 
2.14.3

