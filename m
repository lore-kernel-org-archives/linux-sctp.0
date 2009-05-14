From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 14 May 2009 00:22:28 +0000
Subject: [PATCHv2] sctp: avoid overwrite the return value of sctp_process_asconf_ack()
Message-Id: <4A0B6444.6090708@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

The return value of sctp_process_asconf_ack() may be
overwritten while process parameters with no error.
This patch fixed the problem.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_make_chunk.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 61cc607..b7acc9c 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3104,7 +3104,7 @@ done:
 }
 
 /* Process a asconf parameter that is successfully acked. */
-static int sctp_asconf_param_success(struct sctp_association *asoc,
+static void sctp_asconf_param_success(struct sctp_association *asoc,
 				     sctp_addip_param_t *asconf_param)
 {
 	struct sctp_af *af;
@@ -3113,7 +3113,6 @@ static int sctp_asconf_param_success(struct sctp_association *asoc,
 	union sctp_addr_param *addr_param;
 	struct sctp_transport *transport;
 	struct sctp_sockaddr_entry *saddr;
-	int retval = 0;
 
 	addr_param = (union sctp_addr_param *)
 			((void *)asconf_param + sizeof(sctp_addip_param_t));
@@ -3136,7 +3135,7 @@ static int sctp_asconf_param_success(struct sctp_association *asoc,
 		break;
 	case SCTP_PARAM_DEL_IP:
 		local_bh_disable();
-		retval = sctp_del_bind_addr(bp, &addr);
+		sctp_del_bind_addr(bp, &addr);
 		local_bh_enable();
 		list_for_each_entry(transport, &asoc->peer.transport_addr_list,
 				transports) {
@@ -3148,8 +3147,6 @@ static int sctp_asconf_param_success(struct sctp_association *asoc,
 	default:
 		break;
 	}
-
-	return retval;
 }
 
 /* Get the corresponding ASCONF response error code from the ASCONF_ACK chunk
@@ -3266,7 +3263,7 @@ int sctp_process_asconf_ack(struct sctp_association *asoc,
 
 		switch (err_code) {
 		case SCTP_ERROR_NO_ERROR:
-			retval = sctp_asconf_param_success(asoc, asconf_param);
+			sctp_asconf_param_success(asoc, asconf_param);
 			break;
 
 		case SCTP_ERROR_RSRC_LOW:
-- 
1.5.3.8



