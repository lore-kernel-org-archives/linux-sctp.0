From: Petr Malat <oss@malat.biz>
Date: Thu, 02 Jul 2020 08:01:26 +0000
Subject: [PATCH] sctp: Wake up all processes after closing the connection
Message-Id: <20200702080126.8951-1-oss@malat.biz>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

All waiters need to be woken up after a state change to ESTABLISHED,
CLOSED or SHUTDOWN_RECEIVED, as that's the time when they all should
react - for example all threads blocked in send() must return an
error when the connection is closed, not only one of them.

This solves the problem of threads sleeping indefinitely in
sctp_sendmsg_to_asoc() when the connection was closed while multiple
threads were waiting for SNDBUF.

Signed-off-by: Petr Malat <oss@malat.biz>
---
 net/sctp/sm_sideeffect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 9f36fe911d08..ae08b1805b45 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -892,11 +892,11 @@ static void sctp_cmd_new_state(struct sctp_cmd_seq *cmds,
 	if (sctp_state(asoc, ESTABLISHED) ||
 	    sctp_state(asoc, CLOSED) ||
 	    sctp_state(asoc, SHUTDOWN_RECEIVED)) {
-		/* Wake up any processes waiting in the asoc's wait queue in
+		/* Wake up all processes waiting in the asoc's wait queue in
 		 * sctp_wait_for_connect() or sctp_wait_for_sndbuf().
 		 */
 		if (waitqueue_active(&asoc->wait))
-			wake_up_interruptible(&asoc->wait);
+			wake_up_interruptible_all(&asoc->wait);
 
 		/* Wake up any processes waiting in the sk's sleep queue of
 		 * a TCP-style or UDP-style peeled-off socket in
-- 
2.20.1
