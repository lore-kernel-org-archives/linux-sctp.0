From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 12 May 2018 22:21:01 +0000
Subject: [PATCH net-next v2 3/8] sctp: move the flush of ctrl chunks into its own function
Message-Id: <629f02a784ff90761adee451a870c7548069287d.1526142784.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1526142784.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1526142784.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>

Named sctp_outq_flush_ctrl and, with that, keep the contexts contained.

One small fix embedded is the reset of one_packet at every iteration.
This allows bundling of some control chunks in case they were preceded by
another control chunk that cannot be bundled.

Other than this, it has the same behavior.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/outqueue.c | 89 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 35 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index bda50596d4bfebeac03966c5a161473df1c1986a..800202c68cb89f1086ee7d3a4493dc752c8bf6ac 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -875,45 +875,21 @@ static bool sctp_outq_select_transport(struct sctp_chunk *chunk,
 	return changed;
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
+static void sctp_outq_flush_ctrl(struct sctp_outq *q,
+				 struct sctp_transport **_transport,
+				 struct list_head *transport_list,
+				 gfp_t gfp)
 {
-	struct sctp_packet *packet;
+	struct sctp_transport *transport = *_transport;
 	struct sctp_association *asoc = q->asoc;
-	__u32 vtag = asoc->peer.i.init_tag;
-	struct sctp_transport *transport = NULL;
+	struct sctp_packet *packet = NULL;
 	struct sctp_chunk *chunk, *tmp;
 	enum sctp_xmit status;
-	int error = 0;
-	int start_timer = 0;
-	int one_packet = 0;
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
+	int one_packet, error;

 	list_for_each_entry_safe(chunk, tmp, &q->control_chunk_list, list) {
+		one_packet = 0;
+
 		/* RFC 5061, 5.3
 		 * F1) This means that until such time as the ASCONF
 		 * containing the add is acknowledged, the sender MUST
@@ -930,8 +906,10 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 		 * the first chunk as we don't have a transport by then.
 		 */
 		if (sctp_outq_select_transport(chunk, asoc, &transport,
-					       &transport_list))
+					       transport_list)) {
+			transport = *_transport;
 			packet = &transport->packet;
+		}

 		switch (chunk->chunk_hdr->type) {
 		/*
@@ -954,6 +932,7 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 			if (sctp_test_T_bit(chunk))
 				packet->vtag = asoc->c.my_vtag;
 			/* fallthru */
+
 		/* The following chunks are "response" chunks, i.e.
 		 * they are generated in response to something we
 		 * received.  If we are sending these, then we can
@@ -979,7 +958,7 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 		case SCTP_CID_RECONF:
 			status = sctp_packet_transmit_chunk(packet, chunk,
 							    one_packet, gfp);
-			if (status  != SCTP_XMIT_OK) {
+			if (status != SCTP_XMIT_OK) {
 				/* put the chunk back */
 				list_add(&chunk->list, &q->control_chunk_list);
 				break;
@@ -1006,6 +985,46 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 			BUG();
 		}
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
+	__u32 vtag = asoc->peer.i.init_tag;
+	struct sctp_transport *transport = NULL;
+	struct sctp_chunk *chunk;
+	enum sctp_xmit status;
+	int error = 0;
+	int start_timer = 0;
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

 	if (q->asoc->src_out_of_asoc_ok)
 		goto sctp_flush_out;
--
2.14.3

