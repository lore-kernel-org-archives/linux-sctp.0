From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 09 May 2008 19:09:55 +0000
Subject: [PATCH] [SCTP]: Add address type check while process paramaters of ASCONF chunk
Message-Id: <1210360195-16524-2-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1210360195-16524-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1210360195-16524-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net, Wei Yongjun <yjwei@cn.fujitsu.com>, Vlad Yasevich <vladislav.yasevich@hp.com>

From: Wei Yongjun <yjwei@cn.fujitsu.com>

If socket is create by AF_INET type, add IPv6 address to asoc will cause
kernel panic while packet is transmitted on that transport.

This patch add address type check before process paramaters of ASCONF
chunk. If peer is not support this address type, return with error
invald parameter.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/sm_make_chunk.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 69a464f..6eeee53 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2827,6 +2827,19 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
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
 
-- 
1.5.3.5

