From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 19 Apr 2010 08:31:06 +0000
Subject: [PATCH] sctp: remove unnecessary NULL test in sendmsg()
Message-Id: <4BCC14CA.8080905@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

sinfo shuould either be set by the user or set to the default_sifo,
so it can never be NULL.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/socket.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 783d865..5de892f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1791,12 +1791,10 @@ SCTP_STATIC int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
 		goto out_free;
 	}
 
-	if (sinfo) {
-		/* Check for invalid stream. */
-		if (sinfo->sinfo_stream >= asoc->c.sinit_num_ostreams) {
-			err = -EINVAL;
-			goto out_free;
-		}
+	/* Check for invalid stream. */
+	if (sinfo->sinfo_stream >= asoc->c.sinit_num_ostreams) {
+		err = -EINVAL;
+		goto out_free;
 	}
 
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
-- 
1.6.5.2


