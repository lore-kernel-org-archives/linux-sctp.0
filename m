From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 12 May 2018 22:21:06 +0000
Subject: [PATCH net-next v2 5/8] sctp: move flushing of data chunks out of sctp_outq_flush
Message-Id: <5ebf53c4ad96f127de242de572cc635f3fc969f4.1526142784.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1526142784.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1526142784.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>

To the new sctp_outq_flush_data. Again, smaller functions and with well
defined objectives.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/outqueue.c | 148 ++++++++++++++++++++++++++--------------------------
 1 file changed, 75 insertions(+), 73 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 6d7ee372a9d6b8e68a759277830d5334ec992d47..7522188107792643f3bb5f00e5c254b00e91ef12 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1038,45 +1038,17 @@ static bool sctp_outq_flush_rtx(struct sctp_outq *q,
 
 	return true;
 }
-/*
- * Try to flush an outqueue.
- *
- * Description: Send everything in q which we legally can, subject to
- * congestion limitations.
- * * Note: This function can be called from multiple contexts so appropriate
- * locking concerns must be made.  Today we use the sock lock to protect
- * this function.
- */
-static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
+
+static void sctp_outq_flush_data(struct sctp_outq *q,
+				 struct sctp_transport **_transport,
+				 struct list_head *transport_list,
+				 int rtx_timeout, gfp_t gfp)
 {
-	struct sctp_packet *packet;
+	struct sctp_transport *transport = *_transport;
+	struct sctp_packet *packet = transport ? &transport->packet : NULL;
 	struct sctp_association *asoc = q->asoc;
-	struct sctp_transport *transport = NULL;
 	struct sctp_chunk *chunk;
 	enum sctp_xmit status;
-	int error = 0;
-
-	/* These transports have chunks to send. */
-	struct list_head transport_list;
-	struct list_head *ltransport;
-
-	INIT_LIST_HEAD(&transport_list);
-	packet = NULL;
-
-	/*
-	 * 6.10 Bundling
-	 *   ...
-	 *   When bundling control chunks with DATA chunks, an
-	 *   endpoint MUST place control chunks first in the outbound
-	 *   SCTP packet.  The transmitter MUST transmit DATA chunks
-	 *   within a SCTP packet in increasing order of TSN.
-	 *   ...
-	 */
-
-	sctp_outq_flush_ctrl(q, &transport, &transport_list, gfp);
-
-	if (q->asoc->src_out_of_asoc_ok)
-		goto sctp_flush_out;
 
 	/* Is it OK to send data chunks?  */
 	switch (asoc->state) {
@@ -1101,10 +1073,11 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 		 * current cwnd).
 		 */
 		if (!list_empty(&q->retransmit)) {
-			if (!sctp_outq_flush_rtx(q, &transport, &transport_list,
+			if (!sctp_outq_flush_rtx(q, _transport, transport_list,
 						 rtx_timeout))
 				break;
 			/* We may have switched current transport */
+			transport = *_transport;
 			packet = &transport->packet;
 		}
 
@@ -1130,12 +1103,14 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 
 			if (asoc->stream.out[sid].state = SCTP_STREAM_CLOSED) {
 				sctp_outq_head_data(q, chunk);
-				goto sctp_flush_out;
+				break;
 			}
 
-			if (sctp_outq_select_transport(chunk, asoc, &transport,
-						       &transport_list))
+			if (sctp_outq_select_transport(chunk, asoc, _transport,
+						       transport_list)) {
+				transport = *_transport;
 				packet = &transport->packet;
+			}
 
 			pr_debug("%s: outq:%p, chunk:%p[%s], tx-tsn:0x%x skb->head:%p "
 				 "skb->users:%d\n",
@@ -1147,8 +1122,10 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 
 			/* Add the chunk to the packet.  */
 			status = sctp_packet_transmit_chunk(packet, chunk, 0, gfp);
-
 			switch (status) {
+			case SCTP_XMIT_OK:
+				break;
+
 			case SCTP_XMIT_PMTU_FULL:
 			case SCTP_XMIT_RWND_FULL:
 			case SCTP_XMIT_DELAY:
@@ -1160,41 +1137,25 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 					 status);
 
 				sctp_outq_head_data(q, chunk);
-				goto sctp_flush_out;
-
-			case SCTP_XMIT_OK:
-				/* The sender is in the SHUTDOWN-PENDING state,
-				 * The sender MAY set the I-bit in the DATA
-				 * chunk header.
-				 */
-				if (asoc->state = SCTP_STATE_SHUTDOWN_PENDING)
-					chunk->chunk_hdr->flags |= SCTP_DATA_SACK_IMM;
-				if (chunk->chunk_hdr->flags & SCTP_DATA_UNORDERED)
-					asoc->stats.ouodchunks++;
-				else
-					asoc->stats.oodchunks++;
-
-				/* Only now it's safe to consider this
-				 * chunk as sent, sched-wise.
-				 */
-				sctp_sched_dequeue_done(q, chunk);
-
-				break;
-
-			default:
-				BUG();
+				return;
 			}
 
-			/* BUG: We assume that the sctp_packet_transmit()
-			 * call below will succeed all the time and add the
-			 * chunk to the transmitted list and restart the
-			 * timers.
-			 * It is possible that the call can fail under OOM
-			 * conditions.
-			 *
-			 * Is this really a problem?  Won't this behave
-			 * like a lost TSN?
+			/* The sender is in the SHUTDOWN-PENDING state,
+			 * The sender MAY set the I-bit in the DATA
+			 * chunk header.
 			 */
+			if (asoc->state = SCTP_STATE_SHUTDOWN_PENDING)
+				chunk->chunk_hdr->flags |= SCTP_DATA_SACK_IMM;
+			if (chunk->chunk_hdr->flags & SCTP_DATA_UNORDERED)
+				asoc->stats.ouodchunks++;
+			else
+				asoc->stats.oodchunks++;
+
+			/* Only now it's safe to consider this
+			 * chunk as sent, sched-wise.
+			 */
+			sctp_sched_dequeue_done(q, chunk);
+
 			list_add_tail(&chunk->transmitted_list,
 				      &transport->transmitted);
 
@@ -1205,7 +1166,7 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 			 * COOKIE-ECHO chunk.
 			 */
 			if (packet->has_cookie_echo)
-				goto sctp_flush_out;
+				break;
 		}
 		break;
 
@@ -1213,6 +1174,47 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 		/* Do nothing.  */
 		break;
 	}
+}
+
+/*
+ * Try to flush an outqueue.
+ *
+ * Description: Send everything in q which we legally can, subject to
+ * congestion limitations.
+ * * Note: This function can be called from multiple contexts so appropriate
+ * locking concerns must be made.  Today we use the sock lock to protect
+ * this function.
+ */
+static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
+{
+	struct sctp_packet *packet;
+	struct sctp_association *asoc = q->asoc;
+	struct sctp_transport *transport = NULL;
+	int error = 0;
+
+	/* These transports have chunks to send. */
+	struct list_head transport_list;
+	struct list_head *ltransport;
+
+	INIT_LIST_HEAD(&transport_list);
+	packet = NULL;
+
+	/*
+	 * 6.10 Bundling
+	 *   ...
+	 *   When bundling control chunks with DATA chunks, an
+	 *   endpoint MUST place control chunks first in the outbound
+	 *   SCTP packet.  The transmitter MUST transmit DATA chunks
+	 *   within a SCTP packet in increasing order of TSN.
+	 *   ...
+	 */
+
+	sctp_outq_flush_ctrl(q, &transport, &transport_list, gfp);
+
+	if (q->asoc->src_out_of_asoc_ok)
+		goto sctp_flush_out;
+
+	sctp_outq_flush_data(q, &transport, &transport_list, rtx_timeout, gfp);
 
 sctp_flush_out:
 
-- 
2.14.3

