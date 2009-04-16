From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 16 Apr 2009 06:21:02 +0000
Subject: [PATCH v2] sctp: fix the error code when ASCONF is received with
Message-Id: <49E6CE4E.3080604@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Used Unresolvable Address error cause instead of Invalid Mandatory
Parameter error cause when process ASCONF chunk with invalid address
since address parameters are not mandatory in the ASCONF chunk.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_make_chunk.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 6851ee9..977fa04 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2864,19 +2864,19 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 	switch (addr_param->v4.param_hdr.type) {
 	case SCTP_PARAM_IPV6_ADDRESS:
 		if (!asoc->peer.ipv6_address)
-			return SCTP_ERROR_INV_PARAM;
+			return SCTP_ERROR_DNS_FAILED;
 		break;
 	case SCTP_PARAM_IPV4_ADDRESS:
 		if (!asoc->peer.ipv4_address)
-			return SCTP_ERROR_INV_PARAM;
+			return SCTP_ERROR_DNS_FAILED;
 		break;
 	default:
-		return SCTP_ERROR_INV_PARAM;
+		return SCTP_ERROR_DNS_FAILED;
 	}
 
 	af = sctp_get_af_specific(param_type2af(addr_param->v4.param_hdr.type));
 	if (unlikely(!af))
-		return SCTP_ERROR_INV_PARAM;
+		return SCTP_ERROR_DNS_FAILED;
 
 	af->from_addr_param(&addr, addr_param, htons(asoc->peer.port), 0);
 
@@ -2886,7 +2886,7 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 	 *  make sure we check for that)
 	 */
 	if (!af->is_any(&addr) && !af->addr_valid(&addr, NULL, asconf->skb))
-		return SCTP_ERROR_INV_PARAM;
+		return SCTP_ERROR_DNS_FAILED;
 
 	switch (asconf_param->param_hdr.type) {
 	case SCTP_PARAM_ADD_IP:
@@ -2954,7 +2954,7 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 
 		peer = sctp_assoc_lookup_paddr(asoc, &addr);
 		if (!peer)
-			return SCTP_ERROR_INV_PARAM;
+			return SCTP_ERROR_DNS_FAILED;
 
 		sctp_assoc_set_primary(asoc, peer);
 		break;
-- 
1.5.3.8




