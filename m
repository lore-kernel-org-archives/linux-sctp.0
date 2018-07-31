From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 31 Jul 2018 08:53:16 +0000
Subject: [PATCH lksctp-tools 8/9] lib: fix covscan warnings
Message-Id: <29c6bf7a0a4e3d2e198fbd0838aa91c5a5cabcb7.1533027042.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

change to use define addrs_size as type int before the check
'addrs_size < 0' in lib/connectx, and initialize
outmsg.msg_control in lib/sendmsg.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 src/lib/connectx.c | 6 +++---
 src/lib/sendmsg.c  | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/lib/connectx.c b/src/lib/connectx.c
index 3d1b925..5f4552b 100644
--- a/src/lib/connectx.c
+++ b/src/lib/connectx.c
@@ -66,7 +66,7 @@ static int __connectx_addrsize(const struct sockaddr *addrs,
 
 int __sctp_connectx(int fd, struct sockaddr *addrs, int addrcnt)
 {
-	socklen_t addrs_size = __connectx_addrsize(addrs, addrcnt);
+	int addrs_size = __connectx_addrsize(addrs, addrcnt);
 
 	if (addrs_size < 0)
 		return addrs_size;
@@ -117,7 +117,7 @@ static int __connectx(int fd, struct sockaddr *addrs, socklen_t addrs_size,
 int sctp_connectx2(int fd, struct sockaddr *addrs, int addrcnt,
 		      sctp_assoc_t *id)
 {
-	socklen_t addrs_size = __connectx_addrsize(addrs, addrcnt);
+	int addrs_size = __connectx_addrsize(addrs, addrcnt);
 
 	if (addrs_size < 0)
 		return addrs_size;
@@ -128,7 +128,7 @@ int sctp_connectx2(int fd, struct sockaddr *addrs, int addrcnt,
 int sctp_connectx3(int fd, struct sockaddr *addrs, int addrcnt,
 		      sctp_assoc_t *id)
 {
-	socklen_t addrs_size = __connectx_addrsize(addrs, addrcnt);
+	int addrs_size = __connectx_addrsize(addrs, addrcnt);
 	int status;
 	struct sctp_getaddrs_old param;
 	socklen_t opt_len = sizeof(param);
diff --git a/src/lib/sendmsg.c b/src/lib/sendmsg.c
index ea9c078..4c90b07 100644
--- a/src/lib/sendmsg.c
+++ b/src/lib/sendmsg.c
@@ -87,6 +87,7 @@ sctp_send(int s, const void *msg, size_t len,
 	iov.iov_base = (void *)msg;
 	iov.iov_len = len;
 	outmsg.msg_iovlen = 1;
+	outmsg.msg_control = NULL;
 	outmsg.msg_controllen = 0;
 
 	if (sinfo) {	
-- 
2.1.0

