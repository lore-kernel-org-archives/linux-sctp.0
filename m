From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 21 Mar 2016 20:37:53 +0000
Subject: [PATCHv4] sctp: Don't add the shutdown timer if its already been added
Message-Id: <1458592673-31247-1-git-send-email-nhorman@tuxdriver.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This BUG halt was recently reported:

PID: 2879   TASK: c16adaa0  CPU: 1   COMMAND: "sctpn"
 #0 [f418dd28] crash_kexec at c04a7d8c
 #1 [f418dd7c] oops_end at c0863e02
 #2 [f418dd90] do_invalid_op at c040aaca
 #3 [f418de28] error_code (via invalid_op) at c08631a5
    EAX: f34baac0  EBX: 00000090  ECX: f418deb0  EDX: f5542950  EBP: 00000000
    DS:  007b      ESI: f34ba800  ES:  007b      EDI: f418dea0  GS:  00e0
    CS:  0060      EIP: c046fa5e  ERR: ffffffff  EFLAGS: 00010286
 #4 [f418de5c] add_timer at c046fa5e
 #5 [f418de68] sctp_do_sm at f8db8c77 [sctp]
 #6 [f418df30] sctp_primitive_SHUTDOWN at f8dcc1b5 [sctp]
 #7 [f418df48] inet_shutdown at c080baf9
 #8 [f418df5c] sys_shutdown at c079eedf
 #9 [f418df70] sys_socketcall at c079fe88
    EAX: ffffffda  EBX: 0000000d  ECX: bfceea90  EDX: 0937af98
    DS:  007b      ESI: 0000000c  ES:  007b      EDI: b7150ae4
    SS:  007b      ESP: bfceea7c  EBP: bfceeaa8  GS:  0033
    CS:  0073      EIP: b775c424  ERR: 00000066  EFLAGS: 00000282

It appears that the side effect that starts the shutdown timer was processed
multiple times, which can happen as multiple paths can trigger it.  This of
course leads to the BUG halt in add_timer getting called.

Fix seems pretty straightforward, just check before the timer is added if its
already been started.  If it has mod the timer instead to min(current
expiration, new expiration)

Its been tested but not confirmed to fix the problem, as the issue has only
occured in production environments where test kernels are enjoined from being
installed.  It appears to be a sane fix to me though.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Vlad Yasevich <vyasevich@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>

Change notes:

v2) Removed WARN_ON, as its not useful

v3) Actually commit my changes

v4) Reduce code size by rolling expiration update into mod_timer line
---
 net/sctp/sm_sideeffect.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index b5327bb..192ec99 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1480,9 +1480,21 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
 			timeout = asoc->timeouts[cmd->obj.to];
 			BUG_ON(!timeout);
 
-			timer->expires = jiffies + timeout;
-			sctp_association_hold(asoc);
-			add_timer(timer);
+			/*
+			 * SCTP has a hard time with timer starts.  Because we process
+			 * timer starts as side effects, it can be hard to tell if we
+			 * have already started a timer or not, which leads to BUG
+			 * halts when we call add_timer. So here, instead of just starting
+			 * a timer, just determine the shorter of the two
+			 * timeouts and mod the timer to that.
+			 */
+			if (timer_pending(timer)) {
+				if (time_after(timer->expires, (jiffies + timeout)))
+					mod_timer(timer, jiffies + timeout);
+			} else {
+				sctp_association_hold(asoc);
+				mod_timer(timer, jiffies + timeout);
+			}
 			break;
 
 		case SCTP_CMD_TIMER_RESTART:
-- 
2.5.5

