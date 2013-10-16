From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 16 Oct 2013 02:01:30 +0000
Subject: [PATCH v4 net 2/3] sctp: Use software crc32 checksum when xfrm transform will happen.
Message-Id: <1381888891-31186-3-git-send-email-vyasevich@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1381888891-31186-1-git-send-email-vyasevich@gmail.com>
In-Reply-To: <1381888891-31186-1-git-send-email-vyasevich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, fan.du@windriver.com, Neil Horman <nhorman@tuxdriver.com>, Steffen Klassert <steffen.klassert@secunet.com>, Vlad Yasevich <vyasevich@gmail.com>

From: Fan Du <fan.du@windriver.com>

igb/ixgbe have hardware sctp checksum support, when this feature is enabled
and also IPsec is armed to protect sctp traffic, ugly things happened as
xfrm_output checks CHECKSUM_PARTIAL to do checksum operation(sum every thing
up and pack the 16bits result in the checksum field). The result is fail
establishment of sctp communication.

Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Fan Du <fan.du@windriver.com>
Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
---
 net/sctp/output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 0ac3a65..d35b54c 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -536,7 +536,8 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	 * by CRC32-C as described in <draft-ietf-tsvwg-sctpcsum-02.txt>.
 	 */
 	if (!sctp_checksum_disable) {
-		if (!(dst->dev->features & NETIF_F_SCTP_CSUM)) {
+		if (!(dst->dev->features & NETIF_F_SCTP_CSUM) ||
+		    (dst_xfrm(dst) != NULL)) {
 			__u32 crc32 = sctp_start_cksum((__u8 *)sh, cksum_buf_len);
 
 			/* 3) Put the resultant value into the checksum field in the
-- 
1.8.3.1

