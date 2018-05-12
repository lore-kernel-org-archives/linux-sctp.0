From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Sat, 12 May 2018 22:21:48 +0000
Subject: [PATCH net-next v2 1/3] sctp: add sctp_flush_ctx, a context struct on outq_flush routines
Message-Id: <fb735793dfc87838a87c2cdd08852e7b46465404.1526142994.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1526142994.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1526142994.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>

With this struct we avoid passing lots of variables around and taking care
of updating the current transport/packet.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/outqueue.c | 182 +++++++++++++++++++++++++---------------------------
 1 file changed, 88 insertions(+), 94 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index a9400cb0cc249affcf2bedfc7a070d9e48843d27..db94a2513dd874149aa77c4936f68537e97f8855 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -791,13 +791,22 @@ static int sctp_packet_singleton(struct sctp_transport *transport,
 	return sctp_packet_transmit(&singleton, gfp);
 }
 
-static bool sctp_outq_select_transport(struct sctp_chunk *chunk,
-				       struct sctp_association *asoc,
-				       struct sctp_transport **transport,
-				       struct list_head *transport_list)
+/* Struct to hold the context during sctp outq flush */
+struct sctp_flush_ctx {
+	struct sctp_outq *q;
+	/* Current transport being used. It's NOT the same as curr active one */
+	struct sctp_transport *transport;
+	/* These transports have chunks to send. */
+	struct list_head transport_list;
+	gfp_t gfp;
+};
+
+/* transport: current transport */
+static bool sctp_outq_select_transport(struct sctp_flush_ctx *ctx,
+				       struct sctp_chunk *chunk)
 {
 	struct sctp_transport *new_transport = chunk->transport;
-	struct sctp_transport *curr = *transport;
+	struct sctp_association *asoc = ctx->q->asoc;
 	bool changed = false;
 
 	if (!new_transport) {
@@ -812,9 +821,9 @@ static bool sctp_outq_select_transport(struct sctp_chunk *chunk,
 			 * after processing ASCONFs, we may have new
 			 * transports created.
 			 */
-			if (curr && sctp_cmp_addr_exact(&chunk->dest,
-							&curr->ipaddr))
-				new_transport = curr;
+			if (ctx->transport && sctp_cmp_addr_exact(&chunk->dest,
+							&ctx->transport->ipaddr))
+				new_transport = ctx->transport;
 			else
 				new_transport = sctp_assoc_lookup_paddr(asoc,
 								  &chunk->dest);
@@ -857,37 +866,33 @@ static bool sctp_outq_select_transport(struct sctp_chunk *chunk,
 	}
 
 	/* Are we switching transports? Take care of transport locks. */
-	if (new_transport != curr) {
+	if (new_transport != ctx->transport) {
 		changed = true;
-		curr = new_transport;
-		*transport = curr;
-		if (list_empty(&curr->send_ready))
-			list_add_tail(&curr->send_ready, transport_list);
+		ctx->transport = new_transport;
+		if (list_empty(&ctx->transport->send_ready))
+			list_add_tail(&ctx->transport->send_ready,
+				      &ctx->transport_list);
 
-		sctp_packet_config(&curr->packet, asoc->peer.i.init_tag,
+		sctp_packet_config(&ctx->transport->packet, asoc->peer.i.init_tag,
 				   asoc->peer.ecn_capable);
 		/* We've switched transports, so apply the
 		 * Burst limit to the new transport.
 		 */
-		sctp_transport_burst_limited(curr);
+		sctp_transport_burst_limited(ctx->transport);
 	}
 
 	return changed;
 }
 
-static void sctp_outq_flush_ctrl(struct sctp_outq *q,
-				 struct sctp_transport **_transport,
-				 struct list_head *transport_list,
-				 gfp_t gfp)
+static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 {
-	struct sctp_transport *transport = *_transport;
-	struct sctp_association *asoc = q->asoc;
+	struct sctp_association *asoc = ctx->q->asoc;
 	struct sctp_packet *packet = NULL;
 	struct sctp_chunk *chunk, *tmp;
 	enum sctp_xmit status;
 	int one_packet, error;
 
-	list_for_each_entry_safe(chunk, tmp, &q->control_chunk_list, list) {
+	list_for_each_entry_safe(chunk, tmp, &ctx->q->control_chunk_list, list) {
 		one_packet = 0;
 
 		/* RFC 5061, 5.3
@@ -905,11 +910,8 @@ static void sctp_outq_flush_ctrl(struct sctp_outq *q,
 		/* Pick the right transport to use. Should always be true for
 		 * the first chunk as we don't have a transport by then.
 		 */
-		if (sctp_outq_select_transport(chunk, asoc, &transport,
-					       transport_list)) {
-			transport = *_transport;
-			packet = &transport->packet;
-		}
+		if (sctp_outq_select_transport(ctx, chunk))
+			packet = &ctx->transport->packet;
 
 		switch (chunk->chunk_hdr->type) {
 		/*
@@ -921,7 +923,8 @@ static void sctp_outq_flush_ctrl(struct sctp_outq *q,
 		case SCTP_CID_INIT:
 		case SCTP_CID_INIT_ACK:
 		case SCTP_CID_SHUTDOWN_COMPLETE:
-			error = sctp_packet_singleton(transport, chunk, gfp);
+			error = sctp_packet_singleton(ctx->transport, chunk,
+						      ctx->gfp);
 			if (error < 0) {
 				asoc->base.sk->sk_err = -error;
 				return;
@@ -957,10 +960,10 @@ static void sctp_outq_flush_ctrl(struct sctp_outq *q,
 		case SCTP_CID_I_FWD_TSN:
 		case SCTP_CID_RECONF:
 			status = sctp_packet_transmit_chunk(packet, chunk,
-							    one_packet, gfp);
+							    one_packet, ctx->gfp);
 			if (status != SCTP_XMIT_OK) {
 				/* put the chunk back */
-				list_add(&chunk->list, &q->control_chunk_list);
+				list_add(&chunk->list, &ctx->q->control_chunk_list);
 				break;
 			}
 
@@ -971,12 +974,12 @@ static void sctp_outq_flush_ctrl(struct sctp_outq *q,
 			 */
 			if (chunk->chunk_hdr->type = SCTP_CID_FWD_TSN ||
 			    chunk->chunk_hdr->type = SCTP_CID_I_FWD_TSN) {
-				sctp_transport_reset_t3_rtx(transport);
-				transport->last_time_sent = jiffies;
+				sctp_transport_reset_t3_rtx(ctx->transport);
+				ctx->transport->last_time_sent = jiffies;
 			}
 
 			if (chunk = asoc->strreset_chunk)
-				sctp_transport_reset_reconf_timer(transport);
+				sctp_transport_reset_reconf_timer(ctx->transport);
 
 			break;
 
@@ -988,41 +991,38 @@ static void sctp_outq_flush_ctrl(struct sctp_outq *q,
 }
 
 /* Returns false if new data shouldn't be sent */
-static bool sctp_outq_flush_rtx(struct sctp_outq *q,
-				struct sctp_transport **_transport,
-				struct list_head *transport_list,
-				int rtx_timeout, gfp_t gfp)
+static bool sctp_outq_flush_rtx(struct sctp_flush_ctx *ctx,
+				int rtx_timeout)
 {
-	struct sctp_transport *transport = *_transport;
-	struct sctp_packet *packet = transport ? &transport->packet : NULL;
-	struct sctp_association *asoc = q->asoc;
+	struct sctp_packet *packet = ctx->transport ? &ctx->transport->packet :
+				     NULL;
+	struct sctp_association *asoc = ctx->q->asoc;
 	int error, start_timer = 0;
 
 	if (asoc->peer.retran_path->state = SCTP_UNCONFIRMED)
 		return false;
 
-	if (transport != asoc->peer.retran_path) {
+	if (ctx->transport != asoc->peer.retran_path) {
 		/* Switch transports & prepare the packet.  */
-		transport = asoc->peer.retran_path;
-		*_transport = transport;
+		ctx->transport = asoc->peer.retran_path;
 
-		if (list_empty(&transport->send_ready))
-			list_add_tail(&transport->send_ready,
-				      transport_list);
+		if (list_empty(&ctx->transport->send_ready))
+			list_add_tail(&ctx->transport->send_ready,
+				      &ctx->transport_list);
 
-		packet = &transport->packet;
+		packet = &ctx->transport->packet;
 		sctp_packet_config(packet, asoc->peer.i.init_tag,
 				   asoc->peer.ecn_capable);
 	}
 
-	error = __sctp_outq_flush_rtx(q, packet, rtx_timeout, &start_timer,
-				      gfp);
+	error = __sctp_outq_flush_rtx(ctx->q, packet, rtx_timeout, &start_timer,
+				      ctx->gfp);
 	if (error < 0)
 		asoc->base.sk->sk_err = -error;
 
 	if (start_timer) {
-		sctp_transport_reset_t3_rtx(transport);
-		transport->last_time_sent = jiffies;
+		sctp_transport_reset_t3_rtx(ctx->transport);
+		ctx->transport->last_time_sent = jiffies;
 	}
 
 	/* This can happen on COOKIE-ECHO resend.  Only
@@ -1034,20 +1034,18 @@ static bool sctp_outq_flush_rtx(struct sctp_outq *q,
 	/* Don't send new data if there is still data
 	 * waiting to retransmit.
 	 */
-	if (!list_empty(&q->retransmit))
+	if (!list_empty(&ctx->q->retransmit))
 		return false;
 
 	return true;
 }
 
-static void sctp_outq_flush_data(struct sctp_outq *q,
-				 struct sctp_transport **_transport,
-				 struct list_head *transport_list,
-				 int rtx_timeout, gfp_t gfp)
+static void sctp_outq_flush_data(struct sctp_flush_ctx *ctx,
+				 int rtx_timeout)
 {
-	struct sctp_transport *transport = *_transport;
-	struct sctp_packet *packet = transport ? &transport->packet : NULL;
-	struct sctp_association *asoc = q->asoc;
+	struct sctp_packet *packet = ctx->transport ? &ctx->transport->packet :
+				     NULL;
+	struct sctp_association *asoc = ctx->q->asoc;
 	struct sctp_chunk *chunk;
 	enum sctp_xmit status;
 
@@ -1080,13 +1078,11 @@ static void sctp_outq_flush_data(struct sctp_outq *q,
 	 * are marked for retransmission (limited by the
 	 * current cwnd).
 	 */
-	if (!list_empty(&q->retransmit)) {
-		if (!sctp_outq_flush_rtx(q, _transport, transport_list,
-					 rtx_timeout, gfp))
+	if (!list_empty(&ctx->q->retransmit)) {
+		if (!sctp_outq_flush_rtx(ctx, rtx_timeout))
 			return;
 		/* We may have switched current transport */
-		transport = *_transport;
-		packet = &transport->packet;
+		packet = &ctx->transport->packet;
 	}
 
 	/* Apply Max.Burst limitation to the current transport in
@@ -1094,42 +1090,39 @@ static void sctp_outq_flush_data(struct sctp_outq *q,
 	 * rest it before we return, but we want to apply the limit
 	 * to the currently queued data.
 	 */
-	if (transport)
-		sctp_transport_burst_limited(transport);
+	if (ctx->transport)
+		sctp_transport_burst_limited(ctx->transport);
 
 	/* Finally, transmit new packets.  */
-	while ((chunk = sctp_outq_dequeue_data(q)) != NULL) {
+	while ((chunk = sctp_outq_dequeue_data(ctx->q)) != NULL) {
 		__u32 sid = ntohs(chunk->subh.data_hdr->stream);
 
 		/* Has this chunk expired? */
 		if (sctp_chunk_abandoned(chunk)) {
-			sctp_sched_dequeue_done(q, chunk);
+			sctp_sched_dequeue_done(ctx->q, chunk);
 			sctp_chunk_fail(chunk, 0);
 			sctp_chunk_free(chunk);
 			continue;
 		}
 
 		if (asoc->stream.out[sid].state = SCTP_STREAM_CLOSED) {
-			sctp_outq_head_data(q, chunk);
+			sctp_outq_head_data(ctx->q, chunk);
 			break;
 		}
 
-		if (sctp_outq_select_transport(chunk, asoc, _transport,
-					       transport_list)) {
-			transport = *_transport;
-			packet = &transport->packet;
-		}
+		if (sctp_outq_select_transport(ctx, chunk))
+			packet = &ctx->transport->packet;
 
 		pr_debug("%s: outq:%p, chunk:%p[%s], tx-tsn:0x%x skb->head:%p "
 			 "skb->users:%d\n",
-			 __func__, q, chunk, chunk && chunk->chunk_hdr ?
+			 __func__, ctx->q, chunk, chunk && chunk->chunk_hdr ?
 			 sctp_cname(SCTP_ST_CHUNK(chunk->chunk_hdr->type)) :
 			 "illegal chunk", ntohl(chunk->subh.data_hdr->tsn),
 			 chunk->skb ? chunk->skb->head : NULL, chunk->skb ?
 			 refcount_read(&chunk->skb->users) : -1);
 
 		/* Add the chunk to the packet.  */
-		status = sctp_packet_transmit_chunk(packet, chunk, 0, gfp);
+		status = sctp_packet_transmit_chunk(packet, chunk, 0, ctx->gfp);
 		if (status != SCTP_XMIT_OK) {
 			/* We could not append this chunk, so put
 			 * the chunk back on the output queue.
@@ -1138,7 +1131,7 @@ static void sctp_outq_flush_data(struct sctp_outq *q,
 				 __func__, ntohl(chunk->subh.data_hdr->tsn),
 				 status);
 
-			sctp_outq_head_data(q, chunk);
+			sctp_outq_head_data(ctx->q, chunk);
 			break;
 		}
 
@@ -1156,13 +1149,13 @@ static void sctp_outq_flush_data(struct sctp_outq *q,
 		/* Only now it's safe to consider this
 		 * chunk as sent, sched-wise.
 		 */
-		sctp_sched_dequeue_done(q, chunk);
+		sctp_sched_dequeue_done(ctx->q, chunk);
 
 		list_add_tail(&chunk->transmitted_list,
-			      &transport->transmitted);
+			      &ctx->transport->transmitted);
 
-		sctp_transport_reset_t3_rtx(transport);
-		transport->last_time_sent = jiffies;
+		sctp_transport_reset_t3_rtx(ctx->transport);
+		ctx->transport->last_time_sent = jiffies;
 
 		/* Only let one DATA chunk get bundled with a
 		 * COOKIE-ECHO chunk.
@@ -1172,22 +1165,20 @@ static void sctp_outq_flush_data(struct sctp_outq *q,
 	}
 }
 
-static void sctp_outq_flush_transports(struct sctp_outq *q,
-				       struct list_head *transport_list,
-				       gfp_t gfp)
+static void sctp_outq_flush_transports(struct sctp_flush_ctx *ctx)
 {
 	struct list_head *ltransport;
 	struct sctp_packet *packet;
 	struct sctp_transport *t;
 	int error = 0;
 
-	while ((ltransport = sctp_list_dequeue(transport_list)) != NULL) {
+	while ((ltransport = sctp_list_dequeue(&ctx->transport_list)) != NULL) {
 		t = list_entry(ltransport, struct sctp_transport, send_ready);
 		packet = &t->packet;
 		if (!sctp_packet_empty(packet)) {
-			error = sctp_packet_transmit(packet, gfp);
+			error = sctp_packet_transmit(packet, ctx->gfp);
 			if (error < 0)
-				q->asoc->base.sk->sk_err = -error;
+				ctx->q->asoc->base.sk->sk_err = -error;
 		}
 
 		/* Clear the burst limited state, if any */
@@ -1204,12 +1195,15 @@ static void sctp_outq_flush_transports(struct sctp_outq *q,
  * locking concerns must be made.  Today we use the sock lock to protect
  * this function.
  */
+
 static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 {
-	/* Current transport being used. It's NOT the same as curr active one */
-	struct sctp_transport *transport = NULL;
-	/* These transports have chunks to send. */
-	LIST_HEAD(transport_list);
+	struct sctp_flush_ctx ctx = {
+		.q = q,
+		.transport = NULL,
+		.transport_list = LIST_HEAD_INIT(ctx.transport_list),
+		.gfp = gfp,
+	};
 
 	/*
 	 * 6.10 Bundling
@@ -1221,16 +1215,16 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 	 *   ...
 	 */
 
-	sctp_outq_flush_ctrl(q, &transport, &transport_list, gfp);
+	sctp_outq_flush_ctrl(&ctx);
 
 	if (q->asoc->src_out_of_asoc_ok)
 		goto sctp_flush_out;
 
-	sctp_outq_flush_data(q, &transport, &transport_list, rtx_timeout, gfp);
+	sctp_outq_flush_data(&ctx, rtx_timeout);
 
 sctp_flush_out:
 
-	sctp_outq_flush_transports(q, &transport_list, gfp);
+	sctp_outq_flush_transports(&ctx);
 }
 
 /* Update unack_data based on the incoming SACK chunk */
-- 
2.14.3

