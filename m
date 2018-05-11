From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 11 May 2018 23:30:03 +0000
Subject: [PATCH net-next 2/3] sctp: add asoc and packet to sctp_flush_ctx
Message-Id: <5635a6d7212362120272e36edf35aa011483c9e2.1526078163.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1526078163.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1526078163.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>

Pre-compute these so the compiler won't reload them (due to
no-strict-aliasing).

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/outqueue.c | 99 ++++++++++++++++++++++++-----------------------------
 1 file changed, 45 insertions(+), 54 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index db94a2513dd874149aa77c4936f68537e97f8855..a594d181fa1178c34cf477e13d700f7b37e72e21 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -798,16 +798,17 @@ struct sctp_flush_ctx {
 	struct sctp_transport *transport;
 	/* These transports have chunks to send. */
 	struct list_head transport_list;
+	struct sctp_association *asoc;
+	/* Packet on the current transport above */
+	struct sctp_packet *packet;
 	gfp_t gfp;
 };
 
 /* transport: current transport */
-static bool sctp_outq_select_transport(struct sctp_flush_ctx *ctx,
+static void sctp_outq_select_transport(struct sctp_flush_ctx *ctx,
 				       struct sctp_chunk *chunk)
 {
 	struct sctp_transport *new_transport = chunk->transport;
-	struct sctp_association *asoc = ctx->q->asoc;
-	bool changed = false;
 
 	if (!new_transport) {
 		if (!sctp_chunk_is_data(chunk)) {
@@ -825,7 +826,7 @@ static bool sctp_outq_select_transport(struct sctp_flush_ctx *ctx,
 							&ctx->transport->ipaddr))
 				new_transport = ctx->transport;
 			else
-				new_transport = sctp_assoc_lookup_paddr(asoc,
+				new_transport = sctp_assoc_lookup_paddr(ctx->asoc,
 								  &chunk->dest);
 		}
 
@@ -833,7 +834,7 @@ static bool sctp_outq_select_transport(struct sctp_flush_ctx *ctx,
 		 * use the current active path.
 		 */
 		if (!new_transport)
-			new_transport = asoc->peer.active_path;
+			new_transport = ctx->asoc->peer.active_path;
 	} else {
 		__u8 type;
 
@@ -858,7 +859,7 @@ static bool sctp_outq_select_transport(struct sctp_flush_ctx *ctx,
 			if (type != SCTP_CID_HEARTBEAT &&
 			    type != SCTP_CID_HEARTBEAT_ACK &&
 			    type != SCTP_CID_ASCONF_ACK)
-				new_transport = asoc->peer.active_path;
+				new_transport = ctx->asoc->peer.active_path;
 			break;
 		default:
 			break;
@@ -867,27 +868,25 @@ static bool sctp_outq_select_transport(struct sctp_flush_ctx *ctx,
 
 	/* Are we switching transports? Take care of transport locks. */
 	if (new_transport != ctx->transport) {
-		changed = true;
 		ctx->transport = new_transport;
+		ctx->packet = &ctx->transport->packet;
+
 		if (list_empty(&ctx->transport->send_ready))
 			list_add_tail(&ctx->transport->send_ready,
 				      &ctx->transport_list);
 
-		sctp_packet_config(&ctx->transport->packet, asoc->peer.i.init_tag,
-				   asoc->peer.ecn_capable);
+		sctp_packet_config(ctx->packet,
+				   ctx->asoc->peer.i.init_tag,
+				   ctx->asoc->peer.ecn_capable);
 		/* We've switched transports, so apply the
 		 * Burst limit to the new transport.
 		 */
 		sctp_transport_burst_limited(ctx->transport);
 	}
-
-	return changed;
 }
 
 static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 {
-	struct sctp_association *asoc = ctx->q->asoc;
-	struct sctp_packet *packet = NULL;
 	struct sctp_chunk *chunk, *tmp;
 	enum sctp_xmit status;
 	int one_packet, error;
@@ -901,7 +900,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 		 * NOT use the new IP address as a source for ANY SCTP
 		 * packet except on carrying an ASCONF Chunk.
 		 */
-		if (asoc->src_out_of_asoc_ok &&
+		if (ctx->asoc->src_out_of_asoc_ok &&
 		    chunk->chunk_hdr->type != SCTP_CID_ASCONF)
 			continue;
 
@@ -910,8 +909,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 		/* Pick the right transport to use. Should always be true for
 		 * the first chunk as we don't have a transport by then.
 		 */
-		if (sctp_outq_select_transport(ctx, chunk))
-			packet = &ctx->transport->packet;
+		sctp_outq_select_transport(ctx, chunk);
 
 		switch (chunk->chunk_hdr->type) {
 		/*
@@ -926,14 +924,14 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 			error = sctp_packet_singleton(ctx->transport, chunk,
 						      ctx->gfp);
 			if (error < 0) {
-				asoc->base.sk->sk_err = -error;
+				ctx->asoc->base.sk->sk_err = -error;
 				return;
 			}
 			break;
 
 		case SCTP_CID_ABORT:
 			if (sctp_test_T_bit(chunk))
-				packet->vtag = asoc->c.my_vtag;
+				ctx->packet->vtag = ctx->asoc->c.my_vtag;
 			/* fallthru */
 
 		/* The following chunks are "response" chunks, i.e.
@@ -959,7 +957,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 		case SCTP_CID_FWD_TSN:
 		case SCTP_CID_I_FWD_TSN:
 		case SCTP_CID_RECONF:
-			status = sctp_packet_transmit_chunk(packet, chunk,
+			status = sctp_packet_transmit_chunk(ctx->packet, chunk,
 							    one_packet, ctx->gfp);
 			if (status != SCTP_XMIT_OK) {
 				/* put the chunk back */
@@ -967,7 +965,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 				break;
 			}
 
-			asoc->stats.octrlchunks++;
+			ctx->asoc->stats.octrlchunks++;
 			/* PR-SCTP C5) If a FORWARD TSN is sent, the
 			 * sender MUST assure that at least one T3-rtx
 			 * timer is running.
@@ -978,7 +976,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 				ctx->transport->last_time_sent = jiffies;
 			}
 
-			if (chunk = asoc->strreset_chunk)
+			if (chunk = ctx->asoc->strreset_chunk)
 				sctp_transport_reset_reconf_timer(ctx->transport);
 
 			break;
@@ -994,31 +992,28 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 static bool sctp_outq_flush_rtx(struct sctp_flush_ctx *ctx,
 				int rtx_timeout)
 {
-	struct sctp_packet *packet = ctx->transport ? &ctx->transport->packet :
-				     NULL;
-	struct sctp_association *asoc = ctx->q->asoc;
 	int error, start_timer = 0;
 
-	if (asoc->peer.retran_path->state = SCTP_UNCONFIRMED)
+	if (ctx->asoc->peer.retran_path->state = SCTP_UNCONFIRMED)
 		return false;
 
-	if (ctx->transport != asoc->peer.retran_path) {
+	if (ctx->transport != ctx->asoc->peer.retran_path) {
 		/* Switch transports & prepare the packet.  */
-		ctx->transport = asoc->peer.retran_path;
+		ctx->transport = ctx->asoc->peer.retran_path;
+		ctx->packet = &ctx->transport->packet;
 
 		if (list_empty(&ctx->transport->send_ready))
 			list_add_tail(&ctx->transport->send_ready,
 				      &ctx->transport_list);
 
-		packet = &ctx->transport->packet;
-		sctp_packet_config(packet, asoc->peer.i.init_tag,
-				   asoc->peer.ecn_capable);
+		sctp_packet_config(ctx->packet, ctx->asoc->peer.i.init_tag,
+				   ctx->asoc->peer.ecn_capable);
 	}
 
-	error = __sctp_outq_flush_rtx(ctx->q, packet, rtx_timeout, &start_timer,
-				      ctx->gfp);
+	error = __sctp_outq_flush_rtx(ctx->q, ctx->packet, rtx_timeout,
+				      &start_timer, ctx->gfp);
 	if (error < 0)
-		asoc->base.sk->sk_err = -error;
+		ctx->asoc->base.sk->sk_err = -error;
 
 	if (start_timer) {
 		sctp_transport_reset_t3_rtx(ctx->transport);
@@ -1028,7 +1023,7 @@ static bool sctp_outq_flush_rtx(struct sctp_flush_ctx *ctx,
 	/* This can happen on COOKIE-ECHO resend.  Only
 	 * one chunk can get bundled with a COOKIE-ECHO.
 	 */
-	if (packet->has_cookie_echo)
+	if (ctx->packet->has_cookie_echo)
 		return false;
 
 	/* Don't send new data if there is still data
@@ -1043,20 +1038,17 @@ static bool sctp_outq_flush_rtx(struct sctp_flush_ctx *ctx,
 static void sctp_outq_flush_data(struct sctp_flush_ctx *ctx,
 				 int rtx_timeout)
 {
-	struct sctp_packet *packet = ctx->transport ? &ctx->transport->packet :
-				     NULL;
-	struct sctp_association *asoc = ctx->q->asoc;
 	struct sctp_chunk *chunk;
 	enum sctp_xmit status;
 
 	/* Is it OK to send data chunks?  */
-	switch (asoc->state) {
+	switch (ctx->asoc->state) {
 	case SCTP_STATE_COOKIE_ECHOED:
 		/* Only allow bundling when this packet has a COOKIE-ECHO
 		 * chunk.
 		 */
-		if (!packet || !packet->has_cookie_echo)
-			return;
+		if (!ctx->packet || !ctx->packet->has_cookie_echo)
+			break;
 
 		/* fallthru */
 	case SCTP_STATE_ESTABLISHED:
@@ -1078,12 +1070,9 @@ static void sctp_outq_flush_data(struct sctp_flush_ctx *ctx,
 	 * are marked for retransmission (limited by the
 	 * current cwnd).
 	 */
-	if (!list_empty(&ctx->q->retransmit)) {
-		if (!sctp_outq_flush_rtx(ctx, rtx_timeout))
-			return;
-		/* We may have switched current transport */
-		packet = &ctx->transport->packet;
-	}
+	if (!list_empty(&ctx->q->retransmit) &&
+	    !sctp_outq_flush_rtx(ctx, rtx_timeout))
+		return;
 
 	/* Apply Max.Burst limitation to the current transport in
 	 * case it will be used for new data.  We are going to
@@ -1105,13 +1094,12 @@ static void sctp_outq_flush_data(struct sctp_flush_ctx *ctx,
 			continue;
 		}
 
-		if (asoc->stream.out[sid].state = SCTP_STREAM_CLOSED) {
+		if (ctx->asoc->stream.out[sid].state = SCTP_STREAM_CLOSED) {
 			sctp_outq_head_data(ctx->q, chunk);
 			break;
 		}
 
-		if (sctp_outq_select_transport(ctx, chunk))
-			packet = &ctx->transport->packet;
+		sctp_outq_select_transport(ctx, chunk);
 
 		pr_debug("%s: outq:%p, chunk:%p[%s], tx-tsn:0x%x skb->head:%p "
 			 "skb->users:%d\n",
@@ -1122,7 +1110,8 @@ static void sctp_outq_flush_data(struct sctp_flush_ctx *ctx,
 			 refcount_read(&chunk->skb->users) : -1);
 
 		/* Add the chunk to the packet.  */
-		status = sctp_packet_transmit_chunk(packet, chunk, 0, ctx->gfp);
+		status = sctp_packet_transmit_chunk(ctx->packet, chunk, 0,
+						    ctx->gfp);
 		if (status != SCTP_XMIT_OK) {
 			/* We could not append this chunk, so put
 			 * the chunk back on the output queue.
@@ -1139,12 +1128,12 @@ static void sctp_outq_flush_data(struct sctp_flush_ctx *ctx,
 		 * The sender MAY set the I-bit in the DATA
 		 * chunk header.
 		 */
-		if (asoc->state = SCTP_STATE_SHUTDOWN_PENDING)
+		if (ctx->asoc->state = SCTP_STATE_SHUTDOWN_PENDING)
 			chunk->chunk_hdr->flags |= SCTP_DATA_SACK_IMM;
 		if (chunk->chunk_hdr->flags & SCTP_DATA_UNORDERED)
-			asoc->stats.ouodchunks++;
+			ctx->asoc->stats.ouodchunks++;
 		else
-			asoc->stats.oodchunks++;
+			ctx->asoc->stats.oodchunks++;
 
 		/* Only now it's safe to consider this
 		 * chunk as sent, sched-wise.
@@ -1160,7 +1149,7 @@ static void sctp_outq_flush_data(struct sctp_flush_ctx *ctx,
 		/* Only let one DATA chunk get bundled with a
 		 * COOKIE-ECHO chunk.
 		 */
-		if (packet->has_cookie_echo)
+		if (ctx->packet->has_cookie_echo)
 			break;
 	}
 }
@@ -1202,6 +1191,8 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 		.q = q,
 		.transport = NULL,
 		.transport_list = LIST_HEAD_INIT(ctx.transport_list),
+		.asoc = q->asoc,
+		.packet = NULL,
 		.gfp = gfp,
 	};
 
-- 
2.14.3

