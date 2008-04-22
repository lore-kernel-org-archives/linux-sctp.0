From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 22 Apr 2008 05:43:44 +0000
Subject: [PATCH 2/2] SCTP: Add address type check while process paramaters
Message-Id: <480D7B10.80001@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

If socket is create by AF_INET type, add IPv6 address to asoc will cause 
kernel panic while packet is transmitted on that transport.

This patch add address type check before process paramaters of ASCONF 
chunk. If peer is not support this address type, return with error 
invald parameter.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

--- a/net/sctp/sm_make_chunk.c	2008-04-18 09:00:59.000000000 -0400
+++ b/net/sctp/sm_make_chunk.c	2008-04-19 06:27:49.000000000 -0400
@@ -2826,6 +2826,19 @@ static __be16 sctp_process_asconf_param(
 	union sctp_addr	addr;
 	union sctp_addr_param *addr_param;
 
+	switch (addr_param->v4.param_hdr.type) {
+	case SCTP_PARAM_IPV6_ADDRESS:
+		if (!asoc->peer.ipv6_address)
+			return SCTP_ERROR_INV_PARAM;
+		break;
+	case SCTP_PARAM_IPV4_ADDRESS:
+		if (!asoc->peer.ipv4_address)
+			return SCTP_ERROR_INV_PARAM;
+		break;
+	default:
+		return SCTP_ERROR_INV_PARAM;
+	}
+
 	addr_param = (union sctp_addr_param *)
 			((void *)asconf_param + sizeof(sctp_addip_param_t));
 


