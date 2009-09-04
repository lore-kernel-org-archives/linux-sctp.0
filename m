From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 04 Sep 2009 06:38:39 +0000
Subject: [PATCH 3/3] sctp: implement the sender side for SACK-IMMEDIATELY
Message-Id: <4AA0B5EF.1000207@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patch implement the sender side for SACK-IMMEDIATELY
extension.

  Section 4.1.  Sender Side Considerations

  Whenever the sender of a DATA chunk can benefit from the
  corresponding SACK chunk being sent back without delay, the sender
  MAY set the I-bit in the DATA chunk header.

  Reasons for setting the I-bit include

  o  The sender has not enough queued user data to send the remaining
     DATA chunks due to the Nagle algorithm.

  o  The sending of a DATA chunk fills the congestion or receiver
     window.

  o  The sender is in the SHUTDOWN-PENDING state.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/structs.h |    2 ++
 net/sctp/output.c          |   12 ++++++++++++
 net/sctp/outqueue.c        |   19 ++++++++++++++++++-
 3 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 42d00ce..54ac504 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -764,6 +764,7 @@ struct sctp_chunk {
 		has_asconf:1,		/* IN: have seen an asconf before */
 		tsn_missing_report:2,	/* Data chunk missing counter. */
 		fast_retransmit:2;	/* Is this chunk fast retransmitted? */
+	unsigned nagle_qlen;		/* Queued data length due to Nagle. */
 };
 
 void sctp_chunk_hold(struct sctp_chunk *);
@@ -826,6 +827,7 @@ struct sctp_packet {
 	    has_sack:1,		/* This packet contains a SACK chunk. */
 	    has_auth:1,		/* This packet contains an AUTH chunk */
 	    has_data:1,		/* This packet contains at least 1 DATA chunk */
+	    has_iflag:1,	/* This packet need I-Flag for last DATA chunk */
 	    ipfragok:1,		/* So let ip fragment this packet */
 	    malloced:1;		/* Is it malloced? */
 };
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 951f586..aad3ff5 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -75,6 +75,7 @@ static void sctp_packet_reset(struct sctp_packet *packet)
 	packet->has_cookie_echo = 0;
 	packet->has_sack = 0;
 	packet->has_data = 0;
+	packet->has_iflag = 0;
 	packet->has_auth = 0;
 	packet->ipfragok = 0;
 	packet->auth = NULL;
@@ -447,6 +448,10 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 			} else
 				chunk->resent = 1;
 
+			if (packet->has_iflag &&
+			    list_empty(&packet->chunk_list))
+				chunk->chunk_hdr->flags |= SCTP_DATA_SACK_IMM;
+
 			has_data = 1;
 		}
 
@@ -743,6 +748,13 @@ static void sctp_packet_append_data(struct sctp_packet *packet,
 	else
 		rwnd = 0;
 
+	/* Reasons for setting the I-bit include
+	 * - The sending of a DATA chunk fills the congestion or
+	 *   receiver window.
+	 */
+	if (rwnd = 0 || transport->flight_size >= transport->cwnd)
+		packet->has_iflag = 1;
+
 	asoc->peer.rwnd = rwnd;
 	/* Has been accepted for transmission. */
 	if (!asoc->peer.prsctp_capable)
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index c9f20e2..1193169 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -995,10 +995,21 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 			/* Add the chunk to the packet.  */
 			status = sctp_packet_transmit_chunk(packet, chunk, 0);
 
+			/* The sender is in the SHUTDOWN-PENDING state,
+			 * The sender MAY set the I-bit in the DATA
+			 * chunk header.
+			 */
+			if (asoc->state = SCTP_STATE_SHUTDOWN_PENDING)
+				packet->has_iflag = 1;
+
 			switch (status) {
+			case SCTP_XMIT_NAGLE_DELAY:
+				/* mark this chunks not be sent due to Nagle
+				 * algorithm
+				 */
+				chunk->nagle_qlen = q->out_qlen + 1;
 			case SCTP_XMIT_PMTU_FULL:
 			case SCTP_XMIT_RWND_FULL:
-			case SCTP_XMIT_NAGLE_DELAY:
 				/* We could not append this chunk, so put
 				 * the chunk back on the output queue.
 				 */
@@ -1011,6 +1022,12 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 				break;
 
 			case SCTP_XMIT_OK:
+				/* The sender has not enough queued user data
+				 * to send the remaining DATA chunks due to the
+				 * Nagle algorithm.
+				 */
+				if (chunk->nagle_qlen = q->out_qlen + 1)
+					packet->has_iflag = 1;
 				break;
 
 			default:
-- 
1.6.2.2




