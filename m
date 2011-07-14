From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Date: Thu, 14 Jul 2011 00:10:29 +0000
Subject: [PATCH 01/10] net: sctp: fix checksum marking for outgoing packets
Message-Id: <d67799da9624127ffabf05226c0f20090be4f785.1310601401.git.mirq-linux@rere.qmqm.pl>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1310601401.git.mirq-linux@rere.qmqm.pl>
In-Reply-To: <cover.1310601401.git.mirq-linux@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: netdev@vger.kernel.org
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>, Sridhar Samudrala <sri@us.ibm.com>, linux-sctp@vger.kernel.org

Packets to devices without NETIF_F_SCTP_CSUM (including NETIF_F_NO_CSUM)
should be properly checksummed because the packets can be diverted or
rerouted after construction. This still leaves packets diverted from
NETIF_F_SCTP_CSUM-enabled devices with broken checksums. Fixing this
needs implementing software offload fallback in networking core.

For users of sctp_checksum_disable, skb->ip_summed should be left as
CHECKSUM_NONE and not CHECKSUM_UNNECESSARY as per include/linux/skbuff.h.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 net/sctp/output.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index b4f3cf0..08b3cea 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -500,23 +500,20 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	 * Note: Adler-32 is no longer applicable, as has been replaced
 	 * by CRC32-C as described in <draft-ietf-tsvwg-sctpcsum-02.txt>.
 	 */
-	if (!sctp_checksum_disable &&
-	    !(dst->dev->features & (NETIF_F_NO_CSUM | NETIF_F_SCTP_CSUM))) {
-		__u32 crc32 = sctp_start_cksum((__u8 *)sh, cksum_buf_len);
+	if (!sctp_checksum_disable) {
+		if (!(dst->dev->features & NETIF_F_SCTP_CSUM)) {
+			__u32 crc32 = sctp_start_cksum((__u8 *)sh, cksum_buf_len);
 
-		/* 3) Put the resultant value into the checksum field in the
-		 *    common header, and leave the rest of the bits unchanged.
-		 */
-		sh->checksum = sctp_end_cksum(crc32);
-	} else {
-		if (dst->dev->features & NETIF_F_SCTP_CSUM) {
+			/* 3) Put the resultant value into the checksum field in the
+			 *    common header, and leave the rest of the bits unchanged.
+			 */
+			sh->checksum = sctp_end_cksum(crc32);
+		} else {
 			/* no need to seed pseudo checksum for SCTP */
 			nskb->ip_summed = CHECKSUM_PARTIAL;
 			nskb->csum_start = (skb_transport_header(nskb) -
 			                    nskb->head);
 			nskb->csum_offset = offsetof(struct sctphdr, checksum);
-		} else {
-			nskb->ip_summed = CHECKSUM_UNNECESSARY;
 		}
 	}
 
-- 
1.7.5.4

