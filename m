From: Chunbo Luo <chunbo.luo@windriver.com>
Date: Mon, 24 Aug 2009 09:37:17 +0000
Subject: [PATCH v2] sctp: fix the check for path failure detection
Message-Id: <1251106637-434-1-git-send-email-chunbo.luo@windriver.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, chunbo.luo@windriver.com

The transport error count should be incremented when an outstanding
HB is not acknowledged. And the path failure detection should be done
before sending out the HB.

Signed-off-by: Chunbo Luo <chunbo.luo@windriver.com>
---
 net/sctp/sm_sideeffect.c |    6 +++++-
 net/sctp/sm_statefuns.c  |    8 ++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 86426aa..fbdf4de 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -446,7 +446,11 @@ static void sctp_do_8_2_transport_strike(struct sctp_association *asoc,
 	if (transport->state != SCTP_UNCONFIRMED)
 		asoc->overall_error_count++;
 
-	if (transport->state != SCTP_INACTIVE &&
+	/*
+	 * The transport error count is incremented when an outstanding HB
+	 * is not acknowledged. 
+	 */
+	if (transport->hb_sent && transport->state != SCTP_INACTIVE &&
 	    (transport->error_count++ >= transport->pathmaxrxt)) {
 		SCTP_DEBUG_PRINTK_IPADDR("transport_strike:association %p",
 					 " transport IP: port:%d failed.\n",
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 7288192..7f77099 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -981,10 +981,6 @@ sctp_disposition_t sctp_sf_sendbeat_8_3(const struct sctp_endpoint *ep,
 	 */
 
 	if (transport->param_flags & SPP_HB_ENABLE) {
-		if (SCTP_DISPOSITION_NOMEM =
-				sctp_sf_heartbeat(ep, asoc, type, arg,
-						  commands))
-			return SCTP_DISPOSITION_NOMEM;
 		/* Set transport error counter and association error counter
 		 * when sending heartbeat.
 		 */
@@ -992,6 +988,10 @@ sctp_disposition_t sctp_sf_sendbeat_8_3(const struct sctp_endpoint *ep,
 				SCTP_TRANSPORT(transport));
 		sctp_add_cmd_sf(commands, SCTP_CMD_TRANSPORT_HB_SENT,
 				SCTP_TRANSPORT(transport));
+		if (SCTP_DISPOSITION_NOMEM =
+				sctp_sf_heartbeat(ep, asoc, type, arg,
+						  commands))
+			return SCTP_DISPOSITION_NOMEM;
 	}
 	sctp_add_cmd_sf(commands, SCTP_CMD_HB_TIMER_UPDATE,
 			SCTP_TRANSPORT(transport));
-- 
1.6.4

