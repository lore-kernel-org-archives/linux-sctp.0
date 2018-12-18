From: Jianwen Ji <jijianwen@gmail.com>
Date: Tue, 18 Dec 2018 06:40:37 +0000
Subject: [PATCH] Fix error->errno typos
Message-Id: <20181218064037.19171-1-jijianwen@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Signed-off-by: Jianwen Ji <jijianwen@gmail.com>
---
 src/apps/sctp_status.c | 2 +-
 src/apps/sctp_test.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/apps/sctp_status.c b/src/apps/sctp_status.c
index 46e9ca2..8563cbe 100644
--- a/src/apps/sctp_status.c
+++ b/src/apps/sctp_status.c
@@ -529,7 +529,7 @@ int receive_r(int sk)
 		DEBUG_PRINT(DEBUG_MIN, "\trecvmsg(sk=%d) ", sk);
 
 		error = recvmsg(sk, &inmessage, MSG_WAITALL);
-		if (error < 0 && error != EAGAIN) {
+		if (error < 0 && errno != EAGAIN) {
 			fprintf(stderr, "\n\t\t*** recvmsg: %s ***\n\n",
 					strerror(errno));
 			fflush(stdout);
diff --git a/src/apps/sctp_test.c b/src/apps/sctp_test.c
index 4aa2d13..cd7654b 100644
--- a/src/apps/sctp_test.c
+++ b/src/apps/sctp_test.c
@@ -870,7 +870,7 @@ int receive_r(int sk, int once)
 		DEBUG_PRINT(DEBUG_MIN, "\trecvmsg(sk=%d) ", sk);
 
 		error = recvmsg(recvsk, &inmessage, MSG_WAITALL);
-		if (error < 0 && error != EAGAIN) {
+		if (error < 0 && errno != EAGAIN) {
 			if (errno = ENOTCONN && socket_type = SOCK_STREAM &&
 			    role = SERVER) {
 				printf("No association is present now!!\n");
-- 
2.9.5
