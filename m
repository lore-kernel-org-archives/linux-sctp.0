From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 24 Aug 2009 16:26:11 +0000
Subject: [PATCH] sctp: Generate SACKs when we have outbound DATA
Message-Id: <1251131172-20602-2-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

RFC 4960 recommends:

  6.1.  Transmission of DATA Chunks

    Before an endpoint transmits a DATA chunk, if any received DATA
    chunks have not been acknowledged (e.g., due to delayed ack), the
    sender should create a SACK and bundle it with the outbound DATA
    chunk, as long as the size of the final SCTP packet does not exceed
    the current MTU.

As such, if we are sending data and have a pending SACK timer active,
try to send the SACK as well.  We'll only do this if the DATA is allowed
to be sent.

Based on eirlier works for Doug Graham <dgraham@nortel.com> and
Wei Youngjun <yjwei@cn.fujitsu.com>.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/output.c |  133 ++++++++++++++++++++++++++++++++---------------------
 1 files changed, 81 insertions(+), 52 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 94c110d..968b632 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -61,8 +61,13 @@
 #include <net/sctp/checksum.h>
 
 /* Forward declarations for private helpers. */
-static sctp_xmit_t sctp_packet_append_data(struct sctp_packet *packet,
+static sctp_xmit_t sctp_packet_can_append_data(struct sctp_packet *packet,
 					   struct sctp_chunk *chunk);
+static void sctp_packet_append_data(struct sctp_packet *packet,
+					   struct sctp_chunk *chunk);
+static sctp_xmit_t sctp_packet_will_fit(struct sctp_packet *packet,
+					struct sctp_chunk *chunk,
+					u16 chunk_len);
 
 /* Config a packet.
  * This appears to be a followup set of initializations.
@@ -262,13 +267,20 @@ sctp_xmit_t sctp_packet_append_chunk(struct sctp_packet *packet,
 {
 	sctp_xmit_t retval = SCTP_XMIT_OK;
 	__u16 chunk_len = WORD_ROUND(ntohs(chunk->chunk_hdr->length));
-	size_t psize;
-	size_t pmtu;
-	int too_big;
 
 	SCTP_DEBUG_PRINTK("%s: packet:%p chunk:%p\n", __func__, packet,
 			  chunk);
 
+	/* Data chunks are special.  Before seeing what else we can
+	 * bundle into this packet, check to see if we are allowed to
+	 * send this DATA.
+	 */
+	if (sctp_chunk_is_data(chunk)) {
+		retval = sctp_packet_can_append_data(packet, chunk);
+		if (retval != SCTP_XMIT_OK)
+			goto finish;
+	}
+
 	/* Try to bundle AUTH chunk */
 	retval = sctp_packet_bundle_auth(packet, chunk);
 	if (retval != SCTP_XMIT_OK)
@@ -279,51 +291,16 @@ sctp_xmit_t sctp_packet_append_chunk(struct sctp_packet *packet,
 	if (retval != SCTP_XMIT_OK)
 		goto finish;
 
-	psize = packet->size;
-	pmtu  = ((packet->transport->asoc) ?
-		 (packet->transport->asoc->pathmtu) :
-		 (packet->transport->pathmtu));
-
-	too_big = (psize + chunk_len > pmtu);
-
-	/* Decide if we need to fragment or resubmit later. */
-	if (too_big) {
-		/* It's OK to fragmet at IP level if any one of the following
-		 * is true:
-		 * 	1. The packet is empty (meaning this chunk is greater
-		 * 	   the MTU)
-		 * 	2. The chunk we are adding is a control chunk
-		 * 	3. The packet doesn't have any data in it yet and data
-		 * 	requires authentication.
-		 */
-		if (sctp_packet_empty(packet) || !sctp_chunk_is_data(chunk) ||
-		    (!packet->has_data && chunk->auth)) {
-			/* We no longer do re-fragmentation.
-			 * Just fragment at the IP layer, if we
-			 * actually hit this condition
-			 */
-			packet->ipfragok = 1;
-			goto append;
-
-		} else {
-			retval = SCTP_XMIT_PMTU_FULL;
-			goto finish;
-		}
-	}
-
-append:
-	/* We believe that this chunk is OK to add to the packet (as
-	 * long as we have the cwnd for it).
-	 */
+	/* Check to see if this chunk will fit into the packet */
+	retval = sctp_packet_will_fit(packet, chunk, chunk_len);
+	if (retval != SCTP_XMIT_OK)
+		goto finish;
 
-	/* DATA is a special case since we must examine both rwnd and cwnd
-	 * before we send DATA.
-	 */
+	/* We believe that this chunk is OK to add to the packet */
 	switch (chunk->chunk_hdr->type) {
 	    case SCTP_CID_DATA:
-		retval = sctp_packet_append_data(packet, chunk);
-		if (SCTP_XMIT_OK != retval)
-			goto finish;
+		/* Account for the data being in the packet */
+		sctp_packet_append_data(packet, chunk);
 		/* Disallow SACK bundling after DATA. */
 		packet->has_sack = 1;
 		/* Disallow AUTH bundling after DATA */
@@ -633,8 +610,8 @@ nomem:
  * 2nd Level Abstractions
  ********************************************************************/
 
-/* This private function handles the specifics of appending DATA chunks.  */
-static sctp_xmit_t sctp_packet_append_data(struct sctp_packet *packet,
+/* This private function check to see if a chunk can be added */
+static sctp_xmit_t sctp_packet_can_append_data(struct sctp_packet *packet,
 					   struct sctp_chunk *chunk)
 {
 	sctp_xmit_t retval = SCTP_XMIT_OK;
@@ -642,8 +619,7 @@ static sctp_xmit_t sctp_packet_append_data(struct sctp_packet *packet,
 	struct sctp_transport *transport = packet->transport;
 	__u32 max_burst_bytes;
 	struct sctp_association *asoc = transport->asoc;
-	struct sctp_sock *sp = sctp_sk(asoc->base.sk);
-	struct sctp_outq *q = &asoc->outqueue;
+	struct sctp_outq *q;
 
 	/* RFC 2960 6.1  Transmission of DATA Chunks
 	 *
@@ -718,7 +694,8 @@ static sctp_xmit_t sctp_packet_append_data(struct sctp_packet *packet,
 	 * if any previously transmitted data on the connection remains
 	 * unacknowledged.
 	 */
-	if (!sp->nodelay && sctp_packet_empty(packet) &&
+	q = &asoc->outqueue;
+	if (sctp_sk(asoc->base.sk)->nodelay && sctp_packet_empty(packet) &&
 	    q->outstanding_bytes && sctp_state(asoc, ESTABLISHED)) {
 		unsigned len = datasize + q->out_qlen;
 
@@ -732,6 +709,19 @@ static sctp_xmit_t sctp_packet_append_data(struct sctp_packet *packet,
 		}
 	}
 
+finish:
+	return retval;
+}
+
+/* This private function does management things when adding DATA chunk */
+static void sctp_packet_append_data(struct sctp_packet *packet,
+				struct sctp_chunk *chunk)
+{
+	struct sctp_transport *transport = packet->transport;
+	size_t datasize = sctp_data_size(chunk);
+	struct sctp_association *asoc = transport->asoc;
+	u32 rwnd = asoc->peer.rwnd;
+
 	/* Keep track of how many bytes are in flight over this transport. */
 	transport->flight_size += datasize;
 
@@ -754,7 +744,46 @@ static sctp_xmit_t sctp_packet_append_data(struct sctp_packet *packet,
 	/* Has been accepted for transmission. */
 	if (!asoc->peer.prsctp_capable)
 		chunk->msg->can_abandon = 0;
+}
+
+static sctp_xmit_t sctp_packet_will_fit(struct sctp_packet *packet,
+					struct sctp_chunk *chunk,
+					u16 chunk_len)
+{
+	size_t psize;
+	size_t pmtu;
+	int too_big;
+	sctp_xmit_t retval = SCTP_XMIT_OK;
+
+	psize = packet->size;
+	pmtu  = ((packet->transport->asoc) ?
+		(packet->transport->asoc->pathmtu) :
+		(packet->transport->pathmtu));
+
+	too_big = (psize + chunk_len > pmtu);
+
+	/* Decide if we need to fragment or resubmit later. */
+	if (too_big) {
+		/* It's OK to fragmet at IP level if any one of the following
+		 * is true:
+		 * 	1. The packet is empty (meaning this chunk is greater
+		 * 	   the MTU)
+		 * 	2. The chunk we are adding is a control chunk
+		 * 	3. The packet doesn't have any data in it yet and data
+		 * 	requires authentication.
+		 */
+		if (sctp_packet_empty(packet) || !sctp_chunk_is_data(chunk) ||
+		    (!packet->has_data && chunk->auth)) {
+			/* We no longer do re-fragmentation.
+			 * Just fragment at the IP layer, if we
+			 * actually hit this condition
+			 */
+			packet->ipfragok = 1;
+		} else {
+			retval = SCTP_XMIT_PMTU_FULL;
+		}
+	}
 
-finish:
 	return retval;
 }
+
-- 
1.5.4.3

