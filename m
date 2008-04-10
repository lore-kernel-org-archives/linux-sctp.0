From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 10 Apr 2008 19:39:53 +0000
Subject: [PATCH 3/5] [SCTP]: Remove an unused parameter from sctp_cmd_hb_timer_update
Message-Id: <1207856394-19321-4-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1207856394-19321-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1207856394-19321-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net, netdev@vger.kernel.org, Gui Jianfeng <guijianfeng@cn.fujitsu.com>, Vlad Yasevich <vladislav.yasevich@hp.com>

From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

The 'asoc' parameter to sctp_cmd_hb_timer_update() is unused, and
we can remove it.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/sm_sideeffect.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 5fdb623..13beed2 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -589,7 +589,6 @@ static void sctp_cmd_t3_rtx_timers_stop(sctp_cmd_seq_t *cmds,
 
 /* Helper function to update the heartbeat timer. */
 static void sctp_cmd_hb_timer_update(sctp_cmd_seq_t *cmds,
-				     struct sctp_association *asoc,
 				     struct sctp_transport *t)
 {
 	/* Update the heartbeat timer.  */
@@ -1451,7 +1450,7 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
 
 		case SCTP_CMD_HB_TIMER_UPDATE:
 			t = cmd->obj.transport;
-			sctp_cmd_hb_timer_update(commands, asoc, t);
+			sctp_cmd_hb_timer_update(commands, t);
 			break;
 
 		case SCTP_CMD_HB_TIMERS_STOP:
-- 
1.5.3.5

