From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 14 May 2009 00:24:29 +0000
Subject: [PATCHv2] sctp: check the unrecognized ASCONF parameter before access
Message-Id: <4A0B64BD.10602@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patch fix to check the unrecognized ASCONF parameter before
access it.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_make_chunk.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index b7acc9c..3d867ce 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2861,6 +2861,11 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 	addr_param = (union sctp_addr_param *)
 			((void *)asconf_param + sizeof(sctp_addip_param_t));
 
+	if (asconf_param->param_hdr.type != SCTP_PARAM_ADD_IP &&
+	    asconf_param->param_hdr.type != SCTP_PARAM_DEL_IP &&
+	    asconf_param->param_hdr.type != SCTP_PARAM_SET_PRIMARY)
+		return SCTP_ERROR_UNKNOWN_PARAM;
+
 	switch (addr_param->v4.param_hdr.type) {
 	case SCTP_PARAM_IPV6_ADDRESS:
 		if (!asoc->peer.ipv6_address)
@@ -2958,9 +2963,6 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 
 		sctp_assoc_set_primary(asoc, peer);
 		break;
-	default:
-		return SCTP_ERROR_UNKNOWN_PARAM;
-		break;
 	}
 
 	return SCTP_ERROR_NO_ERROR;
-- 
1.5.3.8



