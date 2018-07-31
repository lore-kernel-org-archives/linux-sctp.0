From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 31 Jul 2018 08:53:14 +0000
Subject: [PATCH lksctp-tools 6/9] sctp_xconnect: fix covscan warnings
Message-Id: <e6029fc7c4141de8ebd6f09a55483d8d585b6486.1533027042.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

check sctp_sendmsg returned value in sctp_xconnect.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 src/apps/sctp_xconnect.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/src/apps/sctp_xconnect.c b/src/apps/sctp_xconnect.c
index c319761..6759c0e 100644
--- a/src/apps/sctp_xconnect.c
+++ b/src/apps/sctp_xconnect.c
@@ -256,15 +256,15 @@ void data_received(struct msghdr *inmessage, int len, int stream, int socket) {
 			(char *)inmessage->msg_iov->iov_base);
 
 		if (active) {
-			sctp_sendmsg(socket,
-				ping,
-				strlen(ping) + 1,
-				(struct sockaddr *)&server_loop,
-				sizeof (server_loop),
-				ppid,
-				0,
-				stream,
-				0, 0);
+			error = sctp_sendmsg(socket, ping, strlen(ping) + 1,
+					     (struct sockaddr *)&server_loop,
+					     sizeof(server_loop), ppid, 0,
+					     stream, 0, 0);
+			if (error < 0) {
+				printf("Send Failure: %s.\n",
+				       strerror(errno));
+				DUMP_CORE;
+			}
 		}
 	}
 }
-- 
2.1.0

