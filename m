From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 14 May 2018 17:34:43 +0000
Subject: [PATCH net-next v3 8/8] sctp: rework switch cases in sctp_outq_flush_data
Message-Id: <abe052538de49792423914e113541cd08ff5f61d.1526318522.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1526318522.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1526318522.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>

Remove an inner one, which tended to be error prone due to the cascading
and it can be replaced by a simple if ().

Rework the outer one so that the actual flush code is not inside it. Now
we first validate if we can or cannot send data, return if not, and then
the flush code.

Suggested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/outqueue.c | 191 +++++++++++++++++++++++++---------------------------
 1 file changed, 93 insertions(+), 98 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index e1632b8e2900f88070aebc82bbe4eca61f424e87..e9c22b3db11cd702afc52f8233fb7f39d917698a 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1058,122 +1058,117 @@ static void sctp_outq_flush_data(struct sctp_outq *q,
 		 * chunk.
 		 */
 		if (!packet || !packet->has_cookie_echo)
-			break;
+			return;
 
 		/* fallthru */
 	case SCTP_STATE_ESTABLISHED:
 	case SCTP_STATE_SHUTDOWN_PENDING:
 	case SCTP_STATE_SHUTDOWN_RECEIVED:
-		/*
-		 * RFC 2960 6.1  Transmission of DATA Chunks
-		 *
-		 * C) When the time comes for the sender to transmit,
-		 * before sending new DATA chunks, the sender MUST
-		 * first transmit any outstanding DATA chunks which
-		 * are marked for retransmission (limited by the
-		 * current cwnd).
-		 */
-		if (!list_empty(&q->retransmit)) {
-			if (!sctp_outq_flush_rtx(q, _transport, transport_list,
-						 rtx_timeout, gfp))
-				break;
-			/* We may have switched current transport */
-			transport = *_transport;
-			packet = &transport->packet;
-		}
+		break;
 
-		/* Apply Max.Burst limitation to the current transport in
-		 * case it will be used for new data.  We are going to
-		 * rest it before we return, but we want to apply the limit
-		 * to the currently queued data.
-		 */
-		if (transport)
-			sctp_transport_burst_limited(transport);
-
-		/* Finally, transmit new packets.  */
-		while ((chunk = sctp_outq_dequeue_data(q)) != NULL) {
-			__u32 sid = ntohs(chunk->subh.data_hdr->stream);
-
-			/* Has this chunk expired? */
-			if (sctp_chunk_abandoned(chunk)) {
-				sctp_sched_dequeue_done(q, chunk);
-				sctp_chunk_fail(chunk, 0);
-				sctp_chunk_free(chunk);
-				continue;
-			}
+	default:
+		/* Do nothing. */
+		return;
+	}
 
-			if (asoc->stream.out[sid].state = SCTP_STREAM_CLOSED) {
-				sctp_outq_head_data(q, chunk);
-				break;
-			}
+	/*
+	 * RFC 2960 6.1  Transmission of DATA Chunks
+	 *
+	 * C) When the time comes for the sender to transmit,
+	 * before sending new DATA chunks, the sender MUST
+	 * first transmit any outstanding DATA chunks which
+	 * are marked for retransmission (limited by the
+	 * current cwnd).
+	 */
+	if (!list_empty(&q->retransmit)) {
+		if (!sctp_outq_flush_rtx(q, _transport, transport_list,
+					 rtx_timeout, gfp))
+			return;
+		/* We may have switched current transport */
+		transport = *_transport;
+		packet = &transport->packet;
+	}
 
-			if (sctp_outq_select_transport(chunk, asoc, _transport,
-						       transport_list)) {
-				transport = *_transport;
-				packet = &transport->packet;
-			}
+	/* Apply Max.Burst limitation to the current transport in
+	 * case it will be used for new data.  We are going to
+	 * rest it before we return, but we want to apply the limit
+	 * to the currently queued data.
+	 */
+	if (transport)
+		sctp_transport_burst_limited(transport);
 
-			pr_debug("%s: outq:%p, chunk:%p[%s], tx-tsn:0x%x skb->head:%p "
-				 "skb->users:%d\n",
-				 __func__, q, chunk, chunk && chunk->chunk_hdr ?
-				 sctp_cname(SCTP_ST_CHUNK(chunk->chunk_hdr->type)) :
-				 "illegal chunk", ntohl(chunk->subh.data_hdr->tsn),
-				 chunk->skb ? chunk->skb->head : NULL, chunk->skb ?
-				 refcount_read(&chunk->skb->users) : -1);
-
-			/* Add the chunk to the packet.  */
-			status = sctp_packet_transmit_chunk(packet, chunk, 0, gfp);
-			switch (status) {
-			case SCTP_XMIT_OK:
-				break;
+	/* Finally, transmit new packets.  */
+	while ((chunk = sctp_outq_dequeue_data(q)) != NULL) {
+		__u32 sid = ntohs(chunk->subh.data_hdr->stream);
 
-			case SCTP_XMIT_PMTU_FULL:
-			case SCTP_XMIT_RWND_FULL:
-			case SCTP_XMIT_DELAY:
-				/* We could not append this chunk, so put
-				 * the chunk back on the output queue.
-				 */
-				pr_debug("%s: could not transmit tsn:0x%x, status:%d\n",
-					 __func__, ntohl(chunk->subh.data_hdr->tsn),
-					 status);
+		/* Has this chunk expired? */
+		if (sctp_chunk_abandoned(chunk)) {
+			sctp_sched_dequeue_done(q, chunk);
+			sctp_chunk_fail(chunk, 0);
+			sctp_chunk_free(chunk);
+			continue;
+		}
 
-				sctp_outq_head_data(q, chunk);
-				return;
-			}
+		if (asoc->stream.out[sid].state = SCTP_STREAM_CLOSED) {
+			sctp_outq_head_data(q, chunk);
+			break;
+		}
 
-			/* The sender is in the SHUTDOWN-PENDING state,
-			 * The sender MAY set the I-bit in the DATA
-			 * chunk header.
-			 */
-			if (asoc->state = SCTP_STATE_SHUTDOWN_PENDING)
-				chunk->chunk_hdr->flags |= SCTP_DATA_SACK_IMM;
-			if (chunk->chunk_hdr->flags & SCTP_DATA_UNORDERED)
-				asoc->stats.ouodchunks++;
-			else
-				asoc->stats.oodchunks++;
+		if (sctp_outq_select_transport(chunk, asoc, _transport,
+					       transport_list)) {
+			transport = *_transport;
+			packet = &transport->packet;
+		}
 
-			/* Only now it's safe to consider this
-			 * chunk as sent, sched-wise.
+		pr_debug("%s: outq:%p, chunk:%p[%s], tx-tsn:0x%x skb->head:%p "
+			 "skb->users:%d\n",
+			 __func__, q, chunk, chunk && chunk->chunk_hdr ?
+			 sctp_cname(SCTP_ST_CHUNK(chunk->chunk_hdr->type)) :
+			 "illegal chunk", ntohl(chunk->subh.data_hdr->tsn),
+			 chunk->skb ? chunk->skb->head : NULL, chunk->skb ?
+			 refcount_read(&chunk->skb->users) : -1);
+
+		/* Add the chunk to the packet.  */
+		status = sctp_packet_transmit_chunk(packet, chunk, 0, gfp);
+		if (status != SCTP_XMIT_OK) {
+			/* We could not append this chunk, so put
+			 * the chunk back on the output queue.
 			 */
-			sctp_sched_dequeue_done(q, chunk);
+			pr_debug("%s: could not transmit tsn:0x%x, status:%d\n",
+				 __func__, ntohl(chunk->subh.data_hdr->tsn),
+				 status);
 
-			list_add_tail(&chunk->transmitted_list,
-				      &transport->transmitted);
+			sctp_outq_head_data(q, chunk);
+			break;
+		}
 
-			sctp_transport_reset_t3_rtx(transport);
-			transport->last_time_sent = jiffies;
+		/* The sender is in the SHUTDOWN-PENDING state,
+		 * The sender MAY set the I-bit in the DATA
+		 * chunk header.
+		 */
+		if (asoc->state = SCTP_STATE_SHUTDOWN_PENDING)
+			chunk->chunk_hdr->flags |= SCTP_DATA_SACK_IMM;
+		if (chunk->chunk_hdr->flags & SCTP_DATA_UNORDERED)
+			asoc->stats.ouodchunks++;
+		else
+			asoc->stats.oodchunks++;
 
-			/* Only let one DATA chunk get bundled with a
-			 * COOKIE-ECHO chunk.
-			 */
-			if (packet->has_cookie_echo)
-				break;
-		}
-		break;
+		/* Only now it's safe to consider this
+		 * chunk as sent, sched-wise.
+		 */
+		sctp_sched_dequeue_done(q, chunk);
 
-	default:
-		/* Do nothing.  */
-		break;
+		list_add_tail(&chunk->transmitted_list,
+			      &transport->transmitted);
+
+		sctp_transport_reset_t3_rtx(transport);
+		transport->last_time_sent = jiffies;
+
+		/* Only let one DATA chunk get bundled with a
+		 * COOKIE-ECHO chunk.
+		 */
+		if (packet->has_cookie_echo)
+			break;
 	}
 }
 
-- 
2.14.3

