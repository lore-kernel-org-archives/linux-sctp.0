From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 27 Apr 2010 03:31:58 +0000
Subject: [PATCH 2/2] sctp: COOKIE-ACK should back to where the COOKIE-ECHO
Message-Id: <4BD65AAE.5090700@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BD174DC.40308@cn.fujitsu.com>
In-Reply-To: <4BD174DC.40308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patch fixed to send COOKIE-ACK back to where the COOKIE-ECHO
came from, and if COOKIE ACK is sent to an UNCONFIRMED address,
bundled it with a HEARTBEAT including a nonce. Based on RFC4960:

  Section 6.4.  Multi-Homed SCTP Endpoints

  An endpoint SHOULD transmit reply chunks (e.g., SACK, HEARTBEAT ACK,
  etc.) to the same destination transport address from which it
  received the DATA or control chunk to which it is replying.

  Section 5.4.  Path Verification:

  -  A COOKIE ACK MAY be sent to an UNCONFIRMED address, but it MUST be
     bundled with a HEARTBEAT including a nonce.  An implementation
     that does NOT support bundling MUST NOT send a COOKIE ACK to an
     UNCONFIRMED address.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/output.c        |   22 ++++++++++++++++++++++
 net/sctp/outqueue.c      |    1 +
 net/sctp/sm_make_chunk.c |    3 +++
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index fad261d..a68a57d 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -260,6 +260,25 @@ static sctp_xmit_t sctp_packet_bundle_sack(struct sctp_packet *pkt,
 	return retval;
 }
 
+/* Try to bundle a HEARTBEAT with the packet. */
+static sctp_xmit_t sctp_packet_bundle_hb(struct sctp_packet *pkt,
+					 struct sctp_chunk *chunk)
+{
+	sctp_xmit_t retval = SCTP_XMIT_OK;
+
+	if (pkt->transport->state = SCTP_UNCONFIRMED &&
+	    chunk->chunk_hdr->type = SCTP_CID_COOKIE_ACK) {
+		struct sctp_transport *transport = pkt->transport;
+		struct sctp_chunk *hb;
+
+		hb = sctp_make_heartbeat(transport->asoc, transport);
+		if (hb)
+			retval = sctp_packet_append_chunk(pkt, hb);
+	}
+
+	return retval;
+}
+
 /* Append a chunk to the offered packet reporting back any inability to do
  * so.
  */
@@ -329,6 +348,9 @@ sctp_xmit_t sctp_packet_append_chunk(struct sctp_packet *packet,
 	list_add_tail(&chunk->list, &packet->chunk_list);
 	packet->size += chunk_len;
 	chunk->transport = packet->transport;
+
+	/* Try to bundle HEARTBEAT chunk */
+	retval = sctp_packet_bundle_hb(packet, chunk);
 finish:
 	return retval;
 }
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index abfc0b8..322ecd1 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -788,6 +788,7 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 			 */
 			if (chunk->chunk_hdr->type != SCTP_CID_HEARTBEAT &&
 			    chunk->chunk_hdr->type != SCTP_CID_HEARTBEAT_ACK &&
+			    chunk->chunk_hdr->type != SCTP_CID_COOKIE_ACK &&
 			    chunk->chunk_hdr->type != SCTP_CID_ASCONF_ACK)
 				new_transport = asoc->peer.active_path;
 		}
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 04c45dd..b9f08f0 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -584,6 +584,9 @@ struct sctp_chunk *sctp_make_cookie_ack(const struct sctp_association *asoc,
 	if (retval && chunk)
 		retval->transport = chunk->transport;
 
+	if (retval && !retval->transport)
+		retval->dest = chunk->source;
+
 	return retval;
 }
 
-- 
1.6.5.2


