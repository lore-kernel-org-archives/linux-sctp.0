From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 10 Sep 2009 03:19:48 +0000
Subject: [PATCH] sctp: fix the sendmsg() flag SCTP_EOF to comply to spec
Message-Id: <4AA87054.3070201@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

It should be possible to send a message and set the SCTP_EOF flag
at the same time, but we don't support it yet. This patch fix the
sendmsg() flag SCTP_EOF to comply to spec.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/socket.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 89af37a..d48e18c 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1540,13 +1540,12 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
 		goto out_nounlock;
 	}
 
-	/* If SCTP_EOF is set, no data can be sent. Disallow sending zero
-	 * length messages when SCTP_EOF|SCTP_ABORT is not set.
+	/* Disallow sending zero length messages when SCTP_EOF|SCTP_ABORT
+	 * is not set.
 	 * If SCTP_ABORT is set, the message length could be non zero with
 	 * the msg_iov set to the user abort reason.
 	 */
-	if (((sinfo_flags & SCTP_EOF) && (msg_len > 0)) ||
-	    (!(sinfo_flags & (SCTP_EOF|SCTP_ABORT)) && (msg_len = 0))) {
+	if (!(sinfo_flags & (SCTP_EOF|SCTP_ABORT)) && (msg_len = 0)) {
 		err = -EINVAL;
 		goto out_nounlock;
 	}
@@ -1603,7 +1602,7 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
 			goto out_unlock;
 		}
 
-		if (sinfo_flags & SCTP_EOF) {
+		if ((sinfo_flags & SCTP_EOF) && msg_len = 0) {
 			SCTP_DEBUG_PRINTK("Shutting down association: %p\n",
 					  asoc);
 			sctp_primitive_SHUTDOWN(asoc, NULL);
@@ -1835,6 +1834,12 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
 	else
 		err = msg_len;
 
+	if (sinfo_flags & SCTP_EOF) {
+		SCTP_DEBUG_PRINTK("Shutting down association: %p\n",
+				  asoc);
+		sctp_primitive_SHUTDOWN(asoc, NULL);
+	}
+
 	/* If we are already past ASSOCIATE, the lower
 	 * layers are responsible for association cleanup.
 	 */
-- 
1.6.2.2




