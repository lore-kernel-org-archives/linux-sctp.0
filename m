From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 14 May 2018 17:34:37 +0000
Subject: [PATCH net-next v3 2/8] sctp: factor out sctp_outq_select_transport
Message-Id: <85c608b7d56ccd73e218268a499e636ca16dbd35.1526318522.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1526318522.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1526318522.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>

We had two spots doing such complex operation and they were very close to
each other, a bit more tailored to here or there.

This patch unifies these under the same function,
sctp_outq_select_transport, which knows how to handle control chunks and
original transmissions (but not retransmissions).

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/outqueue.c | 187 +++++++++++++++++++++++++---------------------------
 1 file changed, 90 insertions(+), 97 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 300bd0dfc7c14c9df579dbe2f9e78dd8356ae1a3..bda50596d4bfebeac03966c5a161473df1c1986a 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -791,6 +791,90 @@ static int sctp_packet_singleton(struct sctp_transport *transport,
 	return sctp_packet_transmit(&singleton, gfp);
 }
 
+static bool sctp_outq_select_transport(struct sctp_chunk *chunk,
+				       struct sctp_association *asoc,
+				       struct sctp_transport **transport,
+				       struct list_head *transport_list)
+{
+	struct sctp_transport *new_transport = chunk->transport;
+	struct sctp_transport *curr = *transport;
+	bool changed = false;
+
+	if (!new_transport) {
+		if (!sctp_chunk_is_data(chunk)) {
+			/*
+			 * If we have a prior transport pointer, see if
+			 * the destination address of the chunk
+			 * matches the destination address of the
+			 * current transport.  If not a match, then
+			 * try to look up the transport with a given
+			 * destination address.  We do this because
+			 * after processing ASCONFs, we may have new
+			 * transports created.
+			 */
+			if (curr && sctp_cmp_addr_exact(&chunk->dest,
+							&curr->ipaddr))
+				new_transport = curr;
+			else
+				new_transport = sctp_assoc_lookup_paddr(asoc,
+								  &chunk->dest);
+		}
+
+		/* if we still don't have a new transport, then
+		 * use the current active path.
+		 */
+		if (!new_transport)
+			new_transport = asoc->peer.active_path;
+	} else {
+		__u8 type;
+
+		switch (new_transport->state) {
+		case SCTP_INACTIVE:
+		case SCTP_UNCONFIRMED:
+		case SCTP_PF:
+			/* If the chunk is Heartbeat or Heartbeat Ack,
+			 * send it to chunk->transport, even if it's
+			 * inactive.
+			 *
+			 * 3.3.6 Heartbeat Acknowledgement:
+			 * ...
+			 * A HEARTBEAT ACK is always sent to the source IP
+			 * address of the IP datagram containing the
+			 * HEARTBEAT chunk to which this ack is responding.
+			 * ...
+			 *
+			 * ASCONF_ACKs also must be sent to the source.
+			 */
+			type = chunk->chunk_hdr->type;
+			if (type != SCTP_CID_HEARTBEAT &&
+			    type != SCTP_CID_HEARTBEAT_ACK &&
+			    type != SCTP_CID_ASCONF_ACK)
+				new_transport = asoc->peer.active_path;
+			break;
+		default:
+			break;
+		}
+	}
+
+	/* Are we switching transports? Take care of transport locks. */
+	if (new_transport != curr) {
+		changed = true;
+		curr = new_transport;
+		*transport = curr;
+		if (list_empty(&curr->send_ready))
+			list_add_tail(&curr->send_ready, transport_list);
+
+		sctp_packet_config(&curr->packet, asoc->peer.i.init_tag,
+				   asoc->peer.ecn_capable);
+		/* We've switched transports, so apply the
+		 * Burst limit to the new transport.
+		 */
+		sctp_transport_burst_limited(curr);
+	}
+
+	return changed;
+}
+
 /*
  * Try to flush an outqueue.
  *
@@ -806,7 +890,6 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 	struct sctp_association *asoc = q->asoc;
 	__u32 vtag = asoc->peer.i.init_tag;
 	struct sctp_transport *transport = NULL;
-	struct sctp_transport *new_transport;
 	struct sctp_chunk *chunk, *tmp;
 	enum sctp_xmit status;
 	int error = 0;
@@ -843,68 +926,12 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 
 		list_del_init(&chunk->list);
 
-		/* Pick the right transport to use. */
-		new_transport = chunk->transport;
-
-		if (!new_transport) {
-			/*
-			 * If we have a prior transport pointer, see if
-			 * the destination address of the chunk
-			 * matches the destination address of the
-			 * current transport.  If not a match, then
-			 * try to look up the transport with a given
-			 * destination address.  We do this because
-			 * after processing ASCONFs, we may have new
-			 * transports created.
-			 */
-			if (transport &&
-			    sctp_cmp_addr_exact(&chunk->dest,
-						&transport->ipaddr))
-					new_transport = transport;
-			else
-				new_transport = sctp_assoc_lookup_paddr(asoc,
-								&chunk->dest);
-
-			/* if we still don't have a new transport, then
-			 * use the current active path.
-			 */
-			if (!new_transport)
-				new_transport = asoc->peer.active_path;
-		} else if ((new_transport->state = SCTP_INACTIVE) ||
-			   (new_transport->state = SCTP_UNCONFIRMED) ||
-			   (new_transport->state = SCTP_PF)) {
-			/* If the chunk is Heartbeat or Heartbeat Ack,
-			 * send it to chunk->transport, even if it's
-			 * inactive.
-			 *
-			 * 3.3.6 Heartbeat Acknowledgement:
-			 * ...
-			 * A HEARTBEAT ACK is always sent to the source IP
-			 * address of the IP datagram containing the
-			 * HEARTBEAT chunk to which this ack is responding.
-			 * ...
-			 *
-			 * ASCONF_ACKs also must be sent to the source.
-			 */
-			if (chunk->chunk_hdr->type != SCTP_CID_HEARTBEAT &&
-			    chunk->chunk_hdr->type != SCTP_CID_HEARTBEAT_ACK &&
-			    chunk->chunk_hdr->type != SCTP_CID_ASCONF_ACK)
-				new_transport = asoc->peer.active_path;
-		}
-
-		/* Are we switching transports?
-		 * Take care of transport locks.
+		/* Pick the right transport to use. Should always be true for
+		 * the first chunk as we don't have a transport by then.
 		 */
-		if (new_transport != transport) {
-			transport = new_transport;
-			if (list_empty(&transport->send_ready)) {
-				list_add_tail(&transport->send_ready,
-					      &transport_list);
-			}
+		if (sctp_outq_select_transport(chunk, asoc, &transport,
+					       &transport_list))
 			packet = &transport->packet;
-			sctp_packet_config(packet, vtag,
-					   asoc->peer.ecn_capable);
-		}
 
 		switch (chunk->chunk_hdr->type) {
 		/*
@@ -1072,43 +1099,9 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 				goto sctp_flush_out;
 			}
 
-			/* If there is a specified transport, use it.
-			 * Otherwise, we want to use the active path.
-			 */
-			new_transport = chunk->transport;
-			if (!new_transport ||
-			    ((new_transport->state = SCTP_INACTIVE) ||
-			     (new_transport->state = SCTP_UNCONFIRMED) ||
-			     (new_transport->state = SCTP_PF)))
-				new_transport = asoc->peer.active_path;
-			if (new_transport->state = SCTP_UNCONFIRMED) {
-				WARN_ONCE(1, "Attempt to send packet on unconfirmed path.");
-				sctp_sched_dequeue_done(q, chunk);
-				sctp_chunk_fail(chunk, 0);
-				sctp_chunk_free(chunk);
-				continue;
-			}
-
-			/* Change packets if necessary.  */
-			if (new_transport != transport) {
-				transport = new_transport;
-
-				/* Schedule to have this transport's
-				 * packet flushed.
-				 */
-				if (list_empty(&transport->send_ready)) {
-					list_add_tail(&transport->send_ready,
-						      &transport_list);
-				}
-
+			if (sctp_outq_select_transport(chunk, asoc, &transport,
+						       &transport_list))
 				packet = &transport->packet;
-				sctp_packet_config(packet, vtag,
-						   asoc->peer.ecn_capable);
-				/* We've switched transports, so apply the
-				 * Burst limit to the new transport.
-				 */
-				sctp_transport_burst_limited(transport);
-			}
 
 			pr_debug("%s: outq:%p, chunk:%p[%s], tx-tsn:0x%x skb->head:%p "
 				 "skb->users:%d\n",
-- 
2.14.3

