From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Wed, 26 May 2010 09:51:25 +0000
Subject: [PATCH 3/4] sctp: kill abandoned SCTP_CMD_TRANSMIT command
Message-Id: <4BFCEF1D.7090806@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Remove SCTP_CMD_TRANSMIT command as it never be used.


Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 include/net/sctp/command.h |    1 -
 net/sctp/sm_sideeffect.c   |    6 ------
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
index 2c55a7e..78227b3 100644
--- a/include/net/sctp/command.h
+++ b/include/net/sctp/command.h
@@ -73,7 +73,6 @@ typedef enum {
 	SCTP_CMD_INIT_FAILED,   /* High level, do init failure work. */
 	SCTP_CMD_REPORT_DUP,	/* Report a duplicate TSN.  */
 	SCTP_CMD_STRIKE,	/* Mark a strike against a transport.  */
-	SCTP_CMD_TRANSMIT,      /* Transmit the outqueue. */
 	SCTP_CMD_HB_TIMERS_START,    /* Start the heartbeat timers. */
 	SCTP_CMD_HB_TIMER_UPDATE,    /* Update a heartbeat timers.  */
 	SCTP_CMD_HB_TIMERS_STOP,     /* Stop the heartbeat timers.  */
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 22e6702..8ccaf69 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1420,12 +1420,6 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
 					SCTP_RTXR_T3_RTX);
 			break;
 
-		case SCTP_CMD_TRANSMIT:
-			/* Kick start transmission. */
-			error = sctp_outq_uncork(&asoc->outqueue);
-			local_cork = 0;
-			break;
-
 		case SCTP_CMD_ECN_CE:
 			/* Do delayed CE processing.   */
 			sctp_do_ecn_ce_work(asoc, cmd->obj.u32);
-- 
1.7.0




