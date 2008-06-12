From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 12 Jun 2008 15:57:14 +0000
Subject: [RFC PATCH] sctp: Follow security requirement of responding with 1 packet
Message-Id: <1213286234-13359-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi All

Please review this patch since it impacts quite a lot of code paths.
I am doing addition testing, but the more eyes the better.

Thanks
-vlad

RFC 4960, Section 11.4. Protection of Non-SCTP-Capable Hosts

When an SCTP stack receives a packet containing multiple control or
DATA chunks and the processing of the packet requires the sending of
multiple chunks in response, the sender of the response chunk(s) MUST
NOT send more than one packet.  If bundling is supported, multiple
response chunks that fit into a single packet MAY be bundled together
into one single response packet.  If bundling is not supported, then
the sender MUST NOT send more than one response chunk and MUST
discard all other responses.  Note that this rule does NOT apply to a
SACK chunk, since a SACK chunk is, in itself, a response to DATA and
a SACK does not require a response of more DATA.

We implement this by not servicing our outqueue until we reach the end
of the packet.  This enables maximum bundling.  We also identify
'response' chunks and make sure that we only send 1 packet when sending
such chunks.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 include/net/sctp/structs.h |    2 +-
 net/sctp/associola.c       |    1 +
 net/sctp/output.c          |    7 +++++--
 net/sctp/outqueue.c        |   34 ++++++++++++++++++++++++----------
 net/sctp/sm_sideeffect.c   |   27 ++++++++++++++++++---------
 net/sctp/sm_statefuns.c    |   16 +++++-----------
 6 files changed, 54 insertions(+), 33 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index fbc27ac..82116e8 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -827,7 +827,7 @@ struct sctp_packet *sctp_packet_init(struct sctp_packet *,
 				     __u16 sport, __u16 dport);
 struct sctp_packet *sctp_packet_config(struct sctp_packet *, __u32 vtag, int);
 sctp_xmit_t sctp_packet_transmit_chunk(struct sctp_packet *,
-                                       struct sctp_chunk *);
+                                       struct sctp_chunk *, int);
 sctp_xmit_t sctp_packet_append_chunk(struct sctp_packet *,
                                      struct sctp_chunk *);
 int sctp_packet_transmit(struct sctp_packet *);
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index d5cc731..bb85d8f 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1016,6 +1016,7 @@ static void sctp_assoc_bh_rcv(struct work_struct *work)
 	struct sctp_chunk *chunk;
 	struct sock *sk;
 	struct sctp_inq *inqueue;
+	struct sctp_outq *outq;
 	int state;
 	sctp_subtype_t subtype;
 	int error = 0;
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 6d45bae..abcd00d 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -157,7 +157,8 @@ void sctp_packet_free(struct sctp_packet *packet)
  * packet can be sent only after receiving the COOKIE_ACK.
  */
 sctp_xmit_t sctp_packet_transmit_chunk(struct sctp_packet *packet,
-				       struct sctp_chunk *chunk)
+				       struct sctp_chunk *chunk,
+				       int one_packet)
 {
 	sctp_xmit_t retval;
 	int error = 0;
@@ -175,7 +176,9 @@ sctp_xmit_t sctp_packet_transmit_chunk(struct sctp_packet *packet,
 			/* If we have an empty packet, then we can NOT ever
 			 * return PMTU_FULL.
 			 */
-			retval = sctp_packet_append_chunk(packet, chunk);
+			if (!one_packet)
+				retval = sctp_packet_append_chunk(packet,
+								  chunk);
 		}
 		break;
 
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index ace6770..70ead8d 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -702,6 +702,7 @@ int sctp_outq_uncork(struct sctp_outq *q)
 	return error;
 }
 
+
 /*
  * Try to flush an outqueue.
  *
@@ -725,6 +726,7 @@ int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 	sctp_xmit_t status;
 	int error = 0;
 	int start_timer = 0;
+	int one_packet = 0;
 
 	/* These transports have chunks to send. */
 	struct list_head transport_list;
@@ -830,20 +832,33 @@ int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 			if (sctp_test_T_bit(chunk)) {
 				packet->vtag = asoc->c.my_vtag;
 			}
-		case SCTP_CID_SACK:
-		case SCTP_CID_HEARTBEAT:
+		/* The following chunks are "response" chunks, i.e.
+		 * they are generated in response to something we
+		 * received.  If we are sending these, then we can
+		 * send only 1 packet containing these chunks.
+		 */
 		case SCTP_CID_HEARTBEAT_ACK:
-		case SCTP_CID_SHUTDOWN:
 		case SCTP_CID_SHUTDOWN_ACK:
-		case SCTP_CID_ERROR:
-		case SCTP_CID_COOKIE_ECHO:
 		case SCTP_CID_COOKIE_ACK:
-		case SCTP_CID_ECN_ECNE:
+		case SCTP_CID_COOKIE_ECHO:
+		case SCTP_CID_ERROR:
 		case SCTP_CID_ECN_CWR:
-		case SCTP_CID_ASCONF:
 		case SCTP_CID_ASCONF_ACK:
+			one_packet = 1;
+			/* Fall throught */
+
+		case SCTP_CID_SACK:
+		case SCTP_CID_HEARTBEAT:
+		case SCTP_CID_SHUTDOWN:
+		case SCTP_CID_ECN_ECNE:
+		case SCTP_CID_ASCONF:
 		case SCTP_CID_FWD_TSN:
-			sctp_packet_transmit_chunk(packet, chunk);
+			status = sctp_packet_transmit_chunk(packet, chunk,
+							    one_packet);
+			if (status  != SCTP_XMIT_OK) {
+				/* put the chunk back */
+				list_add(&chunk->list, &q->control_chunk_list);
+			}
 			break;
 
 		default:
@@ -974,7 +989,7 @@ int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 					atomic_read(&chunk->skb->users) : -1);
 
 			/* Add the chunk to the packet.  */
-			status = sctp_packet_transmit_chunk(packet, chunk);
+			status = sctp_packet_transmit_chunk(packet, chunk, 0);
 
 			switch (status) {
 			case SCTP_XMIT_PMTU_FULL:
@@ -1239,7 +1254,6 @@ int sctp_outq_sack(struct sctp_outq *q, struct sctp_sackhdr *sack)
 	 * Make sure the empty queue handler will get run later.
 	 */
 	q->empty = (list_empty(&q->out_chunk_list) &&
-		    list_empty(&q->control_chunk_list) &&
 		    list_empty(&q->retransmit));
 	if (!q->empty)
 		goto finish;
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index b083312..9732c79 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -664,7 +664,7 @@ static int sctp_cmd_process_sack(sctp_cmd_seq_t *cmds,
 				 struct sctp_association *asoc,
 				 struct sctp_sackhdr *sackh)
 {
-	int err;
+	int err = 0;
 
 	if (sctp_outq_sack(&asoc->outqueue, sackh)) {
 		/* There are no more TSNs awaiting SACK.  */
@@ -672,11 +672,6 @@ static int sctp_cmd_process_sack(sctp_cmd_seq_t *cmds,
 				 SCTP_ST_OTHER(SCTP_EVENT_NO_PENDING_TSN),
 				 asoc->state, asoc->ep, asoc, NULL,
 				 GFP_ATOMIC);
-	} else {
-		/* Windows may have opened, so we need
-		 * to check if we have DATA to transmit
-		 */
-		err = sctp_outq_flush(&asoc->outqueue, 0);
 	}
 
 	return err;
@@ -1481,8 +1476,15 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
 			break;
 
 		case SCTP_CMD_DISCARD_PACKET:
-			/* We need to discard the whole packet.  */
+			/* We need to discard the whole packet.
+			 * Uncork the queue since there might be
+			 * responses pending
+			 */
 			chunk->pdiscard = 1;
+			if (asoc) {
+				sctp_outq_uncork(&asoc->outqueue);
+				local_cork = 0;
+			}
 			break;
 
 		case SCTP_CMD_RTO_PENDING:
@@ -1553,8 +1555,15 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
 	}
 
 out:
-	if (local_cork)
-		sctp_outq_uncork(&asoc->outqueue);
+	/* If this is in response to a received chunk, wait until
+	 * we are done with the packet to open the queue so that we don't
+	 * send multiple packets in response to a single request.
+	 */
+	if (asoc && SCTP_EVENT_T_CHUNK = event_type && chunk) {
+		if (chunk->end_of_packet || chunk->singleton)
+			sctp_outq_uncork(&asoc->outqueue);
+	} else if (local_cork)
+			sctp_outq_uncork(&asoc->outqueue);
 	return error;
 nomem:
 	error = -ENOMEM;
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 0c9d5a6..b66a41d 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -795,8 +795,6 @@ sctp_disposition_t sctp_sf_do_5_1D_ce(const struct sctp_endpoint *ep,
 		sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_START,
 				SCTP_TO(SCTP_EVENT_TIMEOUT_AUTOCLOSE));
 
-	sctp_add_cmd_sf(commands, SCTP_CMD_TRANSMIT, SCTP_NULL());
-
 	/* This will send the COOKIE ACK */
 	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(repl));
 
@@ -883,7 +881,6 @@ sctp_disposition_t sctp_sf_do_5_1E_ca(const struct sctp_endpoint *ep,
 	if (asoc->autoclose)
 		sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_START,
 				SCTP_TO(SCTP_EVENT_TIMEOUT_AUTOCLOSE));
-	sctp_add_cmd_sf(commands, SCTP_CMD_TRANSMIT, SCTP_NULL());
 
 	/* It may also notify its ULP about the successful
 	 * establishment of the association with a Communication Up
@@ -1781,7 +1778,6 @@ static sctp_disposition_t sctp_sf_do_dupcook_b(const struct sctp_endpoint *ep,
 		goto nomem;
 
 	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(repl));
-	sctp_add_cmd_sf(commands, SCTP_CMD_TRANSMIT, SCTP_NULL());
 
 	/* RFC 2960 5.1 Normal Establishment of an Association
 	 *
@@ -1898,12 +1894,13 @@ static sctp_disposition_t sctp_sf_do_dupcook_d(const struct sctp_endpoint *ep,
 
 		}
 	}
-	sctp_add_cmd_sf(commands, SCTP_CMD_TRANSMIT, SCTP_NULL());
 
 	repl = sctp_make_cookie_ack(new_asoc, chunk);
 	if (!repl)
 		goto nomem;
 
+	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(repl));
+
 	if (ev)
 		sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP,
 				SCTP_ULPEVENT(ev));
@@ -1911,9 +1908,6 @@ static sctp_disposition_t sctp_sf_do_dupcook_d(const struct sctp_endpoint *ep,
 		sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP,
 					SCTP_ULPEVENT(ai_ev));
 
-	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(repl));
-	sctp_add_cmd_sf(commands, SCTP_CMD_TRANSMIT, SCTP_NULL());
-
 	return SCTP_DISPOSITION_CONSUME;
 
 nomem:
@@ -3970,9 +3964,6 @@ sctp_disposition_t sctp_sf_unk_chunk(const struct sctp_endpoint *ep,
 		return sctp_sf_pdiscard(ep, asoc, type, arg, commands);
 		break;
 	case SCTP_CID_ACTION_DISCARD_ERR:
-		/* Discard the packet.  */
-		sctp_sf_pdiscard(ep, asoc, type, arg, commands);
-
 		/* Generate an ERROR chunk as response. */
 		hdr = unk_chunk->chunk_hdr;
 		err_chunk = sctp_make_op_error(asoc, unk_chunk,
@@ -3982,6 +3973,9 @@ sctp_disposition_t sctp_sf_unk_chunk(const struct sctp_endpoint *ep,
 			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
 					SCTP_CHUNK(err_chunk));
 		}
+
+		/* Discard the packet.  */
+		sctp_sf_pdiscard(ep, asoc, type, arg, commands);
 		return SCTP_DISPOSITION_CONSUME;
 		break;
 	case SCTP_CID_ACTION_SKIP:
-- 
1.5.3.5

