From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 19 Feb 2009 09:33:04 +0000
Subject: [PATCH 4/4] sctp: heartbeats exceed maximum retransmssion limit
Message-Id: <499D2750.7030606@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

The number of HEARTBEAT chunks that an association may transmit is
limited by Association.Max.Retrans count; however, the code allows
us to send one extra heartbeat.

This patch limits the number of heartbeats to the maximum count.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_statefuns.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 3e7f6d2..ac7bf6d 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -962,7 +962,7 @@ sctp_disposition_t sctp_sf_sendbeat_8_3(const struct sctp_endpoint *ep,
 {
 	struct sctp_transport *transport = (struct sctp_transport *) arg;
 
-	if (asoc->overall_error_count > asoc->max_retrans) {
+	if (asoc->overall_error_count >= asoc->max_retrans) {
 		sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR,
 				SCTP_ERROR(ETIMEDOUT));
 		/* CMD_ASSOC_FAILED calls CMD_DELETE_TCB. */
-- 
1.5.3.8




