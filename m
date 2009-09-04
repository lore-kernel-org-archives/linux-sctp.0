From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 04 Sep 2009 06:34:06 +0000
Subject: [PATCH 2/2] sctp: remove dup code in net/sctp/output.c
Message-Id: <4AA0B4DE.20404@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Use sctp_packet_reset() instead of dup code.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/output.c |   37 +++++++++++++------------------------
 1 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index a2fcb13..951f586 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -69,6 +69,17 @@ static sctp_xmit_t sctp_packet_will_fit(struct sctp_packet *packet,
 					struct sctp_chunk *chunk,
 					u16 chunk_len);
 
+static void sctp_packet_reset(struct sctp_packet *packet)
+{
+	packet->size = packet->overhead;
+	packet->has_cookie_echo = 0;
+	packet->has_sack = 0;
+	packet->has_data = 0;
+	packet->has_auth = 0;
+	packet->ipfragok = 0;
+	packet->auth = NULL;
+}
+
 /* Config a packet.
  * This appears to be a followup set of initializations.
  */
@@ -80,13 +91,8 @@ struct sctp_packet *sctp_packet_config(struct sctp_packet *packet,
 	SCTP_DEBUG_PRINTK("%s: packet:%p vtag:0x%x\n", __func__,
 			  packet, vtag);
 
+	sctp_packet_reset(packet);
 	packet->vtag = vtag;
-	packet->has_cookie_echo = 0;
-	packet->has_sack = 0;
-	packet->has_auth = 0;
-	packet->has_data = 0;
-	packet->ipfragok = 0;
-	packet->auth = NULL;
 
 	if (ecn_capable && sctp_packet_empty(packet)) {
 		chunk = sctp_get_ecne_prepend(packet->transport->asoc);
@@ -124,29 +130,12 @@ struct sctp_packet *sctp_packet_init(struct sctp_packet *packet,
 	}
 	overhead += sizeof(struct sctphdr);
 	packet->overhead = overhead;
-	packet->size = overhead;
+	sctp_packet_reset(packet);
 	packet->vtag = 0;
-	packet->has_cookie_echo = 0;
-	packet->has_sack = 0;
-	packet->has_auth = 0;
-	packet->has_data = 0;
-	packet->ipfragok = 0;
 	packet->malloced = 0;
-	packet->auth = NULL;
 	return packet;
 }
 
-static void sctp_packet_reset(struct sctp_packet *packet)
-{
-	packet->size = packet->overhead;
-	packet->has_cookie_echo = 0;
-	packet->has_sack = 0;
-	packet->has_data = 0;
-	packet->has_auth = 0;
-	packet->ipfragok = 0;
-	packet->auth = NULL;
-}
-
 /* Free a packet.  */
 void sctp_packet_free(struct sctp_packet *packet)
 {
-- 
1.6.2.2




