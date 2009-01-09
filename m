From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 09 Jan 2009 05:58:07 +0000
Subject: [PATCH 1/3] lksctp-tools: Fix -e option of sctp_darn
Message-Id: <4966E76F.50304@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

If sctp_darn -e option is used, sctp_darn will send back different message
to which it received. This is because test_print_message() will change the
received message when print out it.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 src/apps/sctp_darn.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/apps/sctp_darn.c b/src/apps/sctp_darn.c
index 14e864f..61673a2 100644
--- a/src/apps/sctp_darn.c
+++ b/src/apps/sctp_darn.c
@@ -720,7 +720,6 @@ command_listen(char *argv0, int sk)
 			}
 			break;
 		}
-		test_print_message(sk, &inmessage, error);
 
 		/* Update the associd when a notification is received on a
 		 * UDP-style socket.
@@ -730,12 +729,13 @@ command_listen(char *argv0, int sk)
 
 		if (echo) {
 			if( !(MSG_NOTIFICATION & inmessage.msg_flags)) {
-				sendto(sk, inmessage.msg_iov->iov_base,
+				sendto(recvsk, inmessage.msg_iov->iov_base,
 				       error, 0, (struct sockaddr *)&msgname,
 				       sizeof(msgname));
 			}
 		}
 
+		test_print_message(sk, &inmessage, error);
 
 		inmessage.msg_control = incmsg;
 		inmessage.msg_controllen = sizeof(incmsg);
-- 
1.5.3.8



