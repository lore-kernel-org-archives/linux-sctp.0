From: Simon Xu <xu.simon@oracle.com>
Date: Tue, 10 Dec 2013 08:19:22 +0000
Subject: [PATCH] lksctp: Avoid using file descriptor 0 to get ENOTSOCK
Message-Id: <1386663562-791-1-git-send-email-xu.simon@oracle.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On some systems, errno will not be ENOTSOCK when operating on file descriptor
0 in an ssh session:

test_1_to_1_accept_close.c    2  TBROK  :  accept with invalid socketerror:-1, errno:22
test_1_to_1_addrs.c    2  TBROK  :  sctp_getladdrs with invalid socket error:-1, errno:95
test_1_to_1_connect.c    2  TBROK  :  connect with invalid socket error:-1, errno:22
test_1_to_1_recvfrom.c    2  TBROK  :  recvfrom with invalid socket count:0, errno:9
test_1_to_1_recvmsg.c    2  TBROK  :  recvmsg with invalid socket count:0, errno:9
test_1_to_1_send.c    2  TBROK  :  send with invalid socket count:15, errno:9
test_1_to_1_sendmsg.c    2  TBROK  :  sendmsg with invalid socket count:-1, errno:106
test_1_to_1_shutdown.c    2  TBROK  :  shutdown with an invalid socket error:0, errno:9
test_1_to_1_socket_bind_listen.c    6  TBROK  :  bind() with invalid socket descriptor error:-1, errno:22
test_1_to_1_sockopt.c    2  TBROK  :  setsockopt with an invalid socket error:-1, errno:95
test_getname.c    9  TBROK  :  getsockname on an invalid socket error:0 errno:9

This patch gets a non-socket file descriptor by creating a temporary file
to replace file descriptor 0.

Signed-off-by: Simon Xu <xu.simon@oracle.com>
---
 src/func_tests/test_1_to_1_accept_close.c       | 17 ++++++++++---
 src/func_tests/test_1_to_1_addrs.c              | 32 ++++++++++++++++++++-----
 src/func_tests/test_1_to_1_connect.c            | 17 ++++++++++---
 src/func_tests/test_1_to_1_recvfrom.c           | 17 ++++++++++---
 src/func_tests/test_1_to_1_recvmsg.c            | 17 ++++++++++---
 src/func_tests/test_1_to_1_send.c               | 17 ++++++++++---
 src/func_tests/test_1_to_1_sendmsg.c            | 17 ++++++++++---
 src/func_tests/test_1_to_1_shutdown.c           | 17 ++++++++++---
 src/func_tests/test_1_to_1_socket_bind_listen.c | 32 ++++++++++++++++++++-----
 src/func_tests/test_1_to_1_sockopt.c            | 32 ++++++++++++++++++++-----
 src/func_tests/test_getname.c                   | 32 ++++++++++++++++++++-----
 11 files changed, 202 insertions(+), 45 deletions(-)

diff --git a/src/func_tests/test_1_to_1_accept_close.c b/src/func_tests/test_1_to_1_accept_close.c
index ea1c57a..cbb1814 100644
--- a/src/func_tests/test_1_to_1_accept_close.c
+++ b/src/func_tests/test_1_to_1_accept_close.c
@@ -78,6 +78,8 @@ main(int argc, char *argv[])
 	int sk,lstn_sk,clnt_sk[SK_MAX],acpt_sk,pf_class;
 	int new_sk[SK_MAX],clnt2_sk[SK_MAX];
 	int error;
+	int fd, err_no = 0;
+	char filename[21];
 
         struct sockaddr_in conn_addr,lstn_addr,acpt_addr;
 
@@ -134,10 +136,19 @@ main(int argc, char *argv[])
 	tst_resm(TPASS, "accept() with a bad socket descriptor - EBADF");
 
         /*accept() TEST2: Invalid socket ENOTSOCK, Expected error*/
-        error = accept(0, (struct sockaddr *) &acpt_addr, &len);
-        if (error != -1 || errno != ENOTSOCK)
+	strcpy(filename, "/tmp/sctptest.XXXXXX");
+	fd = mkstemp(filename);
+	if (fd = -1)
+		tst_brkm(TBROK, tst_exit, "Failed to mkstemp %s: %s",
+				filename, strerror(errno));
+	error = accept(fd, (struct sockaddr *) &acpt_addr, &len);
+	if (error = -1)
+		err_no = errno;
+	close(fd);
+	unlink(filename);
+	if (error != -1 || err_no != ENOTSOCK)
 		tst_brkm(TBROK, tst_exit, "accept with invalid socket"
-                         "error:%d, errno:%d", error, errno);
+                         "error:%d, errno:%d", error, err_no);
 
 	tst_resm(TPASS, "accept() with invalid socket - ENOTSOCK");
 
diff --git a/src/func_tests/test_1_to_1_addrs.c b/src/func_tests/test_1_to_1_addrs.c
index 40eed7f..5d56918 100644
--- a/src/func_tests/test_1_to_1_addrs.c
+++ b/src/func_tests/test_1_to_1_addrs.c
@@ -92,6 +92,8 @@ main(int argc, char *argv[])
         char * buffer_rcv;
 	char incmsg[CMSG_SPACE(sizeof(sctp_cmsg_data_t))];
 	struct sockaddr *laddrs, *paddrs;
+	int fd, err_no = 0;
+	char filename[21];
 
         struct sockaddr_in conn_addr,lstn_addr,acpt_addr;
 	struct sockaddr_in *addr;
@@ -176,10 +178,19 @@ main(int argc, char *argv[])
 		 "EBADF");
 
 	/*sctp_getladdrs() TEST2: Invalid socket, ENOTSOCK Expected error*/
-	error = sctp_getladdrs(0, 0, &laddrs);
-	if (error != -1 || errno != ENOTSOCK)
+	strcpy(filename, "/tmp/sctptest.XXXXXX");
+	fd = mkstemp(filename);
+	if (fd = -1)
+		tst_brkm(TBROK, tst_exit, "Failed to mkstemp %s: %s",
+				filename, strerror(errno));
+	error = sctp_getladdrs(fd, 0, &laddrs);
+	if (error = -1)
+		err_no = errno;
+	close(fd);
+	unlink(filename);
+	if (error != -1 || err_no != ENOTSOCK)
 		tst_brkm(TBROK, tst_exit, "sctp_getladdrs with invalid socket "
-			 "error:%d, errno:%d", error, errno);
+			 "error:%d, errno:%d", error, err_no);
 
 	tst_resm(TPASS, "sctp_getladdrs() with invalid socket - ENOTSOCK");
 
@@ -225,10 +236,19 @@ main(int argc, char *argv[])
 		 "EBADF");
 
 	/*sctp_getpaddrs() TEST7: Invalid socket, ENOTSOCK Expected error*/
-	error = sctp_getpaddrs(0, 0, &paddrs);
-	if (error != -1 || errno != ENOTSOCK)
+	strcpy(filename, "/tmp/sctptest.XXXXXX");
+	fd = mkstemp(filename);
+	if (fd = -1)
+		tst_brkm(TBROK, tst_exit, "Failed to mkstemp %s: %s",
+				filename, strerror(errno));
+	error = sctp_getpaddrs(fd, 0, &paddrs);
+	if (error = -1)
+		err_no = errno;
+	close(fd);
+	unlink(filename);
+	if (error != -1 || err_no != ENOTSOCK)
 		tst_brkm(TBROK, tst_exit, "sctp_getpaddrs with invalid socket "
-			 "error:%d, errno:%d", error, errno);
+			 "error:%d, errno:%d", error, err_no);
 
 	tst_resm(TPASS, "sctp_getpaddrs() with invalid socket - ENOTSOCK");
 	
diff --git a/src/func_tests/test_1_to_1_connect.c b/src/func_tests/test_1_to_1_connect.c
index b4721af..3ebc599 100644
--- a/src/func_tests/test_1_to_1_connect.c
+++ b/src/func_tests/test_1_to_1_connect.c
@@ -72,6 +72,8 @@ main(int argc, char *argv[])
 	socklen_t len;
 	int sk,lstn_sk,clnt_sk[SK_MAX],acpt_sk[SK_MAX],pf_class;
 	int sk1,clnt2_sk;
+	int fd, err_no = 0;
+	char filename[21];
 
         struct sockaddr_in conn_addr,lstn_addr,acpt_addr;
 
@@ -120,10 +122,19 @@ main(int argc, char *argv[])
 	tst_resm(TPASS, "connect() with bad socket descriptor - EBADF");
 	
 	/*connect () TEST2: Invalid socket, ENOTSOCK Expected error*/
-	error = connect(0, (const struct sockaddr *) &conn_addr, len);
-	if (error != -1 || errno != ENOTSOCK)
+	strcpy(filename, "/tmp/sctptest.XXXXXX");
+	fd = mkstemp(filename);
+	if (fd = -1)
+		tst_brkm(TBROK, tst_exit, "Failed to mkstemp %s: %s",
+				filename, strerror(errno));
+	error = connect(fd, (const struct sockaddr *) &conn_addr, len);
+	if (error = -1)
+		err_no = errno;
+	close(fd);
+	unlink(filename);
+	if (error != -1 || err_no != ENOTSOCK)
 		tst_brkm(TBROK, tst_exit, "connect with invalid socket "
-                         "error:%d, errno:%d", error, errno);
+                         "error:%d, errno:%d", error, err_no);
 
 	tst_resm(TPASS, "connect() with invalid socket - ENOTSOCK");
 
diff --git a/src/func_tests/test_1_to_1_recvfrom.c b/src/func_tests/test_1_to_1_recvfrom.c
index a4bdf6a..0ede562 100644
--- a/src/func_tests/test_1_to_1_recvfrom.c
+++ b/src/func_tests/test_1_to_1_recvfrom.c
@@ -69,6 +69,8 @@ main(int argc, char *argv[])
         char *message = "hello, world!\n";
 	char *message_rcv;
         int count;
+	int fd, err_no = 0;
+	char filename[21];
 
         struct sockaddr_in conn_addr,lstn_addr,svr_addr;
 
@@ -122,11 +124,20 @@ main(int argc, char *argv[])
 	tst_resm(TPASS, "recvfrom() with a bad socket descriptor - EBADF");
 
 	/*recvfrom () TEST2: Invalid socket , ENOTSOCK Expected error*/
-	count = recvfrom(0, message_rcv, msg_count, flag,
+	strcpy(filename, "/tmp/sctptest.XXXXXX");
+	fd = mkstemp(filename);
+	if (fd = -1)
+		tst_brkm(TBROK, tst_exit, "Failed to mkstemp %s: %s",
+				filename, strerror(errno));
+	count = recvfrom(fd, message_rcv, msg_count, flag,
 			 (struct sockaddr *)&svr_addr, &len);
-	if (count != -1 || errno != ENOTSOCK)
+	if (count = -1)
+		err_no = errno;
+	close(fd);
+	unlink(filename);
+	if (count != -1 || err_no != ENOTSOCK)
 		tst_brkm(TBROK, tst_exit, "recvfrom with invalid socket "
-			 "count:%d, errno:%d", count, errno);
+			 "count:%d, errno:%d", count, err_no);
 
 	tst_resm(TPASS, "recvfrom() with invalid socket - ENOTSOCK");
 
diff --git a/src/func_tests/test_1_to_1_recvmsg.c b/src/func_tests/test_1_to_1_recvmsg.c
index ceccc31..5f06bb6 100644
--- a/src/func_tests/test_1_to_1_recvmsg.c
+++ b/src/func_tests/test_1_to_1_recvmsg.c
@@ -67,6 +67,8 @@ main(int argc, char *argv[])
         socklen_t len;
 	int sk,pf_class,lstn_sk,acpt_sk;
 	int flag = 0;
+	int fd, err_no = 0;
+	char filename[21];
 	struct msghdr inmessage;
         char *message = "hello, world!\n";
 	struct iovec iov_rcv;
@@ -128,10 +130,19 @@ main(int argc, char *argv[])
 	tst_resm(TPASS, "recvmsg() with a bad socket descriptor - EBADF");
 
 	/*recvmsg () TEST2: Invalid socket , ENOTSOCK Expected error*/
-	count = recvmsg(0, &inmessage, flag);
-	if (count != -1 || errno != ENOTSOCK)
+	strcpy(filename, "/tmp/sctptest.XXXXXX");
+	fd = mkstemp(filename);
+	if (fd = -1)
+		tst_brkm(TBROK, tst_exit, "Failed to mkstemp %s: %s",
+				filename, strerror(errno));
+	count = recvmsg(fd, &inmessage, flag);
+	if (count = -1)
+		err_no = errno;
+	close(fd);
+	unlink(filename);
+	if (count != -1 || err_no != ENOTSOCK)
 		tst_brkm(TBROK, tst_exit, "recvmsg with invalid socket "
-			 "count:%d, errno:%d", count, errno);
+			 "count:%d, errno:%d", count, err_no);
 
 	tst_resm(TPASS, "recvmsg() with invalid socket - ENOTSOCK");
 
diff --git a/src/func_tests/test_1_to_1_send.c b/src/func_tests/test_1_to_1_send.c
index 4966020..8d9516c 100644
--- a/src/func_tests/test_1_to_1_send.c
+++ b/src/func_tests/test_1_to_1_send.c
@@ -69,6 +69,8 @@ main(int argc, char *argv[])
 	int sk,sk1,pf_class,lstn_sk,acpt_sk,acpt1_sk, flag, count;
         char *message = "hello, world!\n";
         char *message_rcv;
+	int fd, err_no = 0;
+	char filename[21];
 
         struct sockaddr_in conn_addr,lstn_addr,svr_addr;
 
@@ -118,10 +120,19 @@ main(int argc, char *argv[])
 	tst_resm(TPASS, "send() with a bad socket descriptor - EBADF");
 	
 	/*send () TEST2: Invalid socket, ENOTSOCK Expected error*/
-	count = send(0, message, len_snd, flag);
-	if (count != -1 || errno != ENOTSOCK)
+	strcpy(filename, "/tmp/sctptest.XXXXXX");
+	fd = mkstemp(filename);
+	if (fd = -1)
+		tst_brkm(TBROK, tst_exit, "Failed to mkstemp %s: %s",
+				filename, strerror(errno));
+	count = send(fd, message, len_snd, flag);
+	if (count = -1)
+		err_no = errno;
+	close(fd);
+	unlink(filename);
+	if (count != -1 || err_no != ENOTSOCK)
 		tst_brkm(TBROK, tst_exit, "send with invalid socket "
-			 "count:%d, errno:%d", count, errno);
+			 "count:%d, errno:%d", count, err_no);
 
 	tst_resm(TPASS, "send() with invalid socket - ENOTSOCK");
 
diff --git a/src/func_tests/test_1_to_1_sendmsg.c b/src/func_tests/test_1_to_1_sendmsg.c
index 7ac0b54..13c920d 100644
--- a/src/func_tests/test_1_to_1_sendmsg.c
+++ b/src/func_tests/test_1_to_1_sendmsg.c
@@ -86,6 +86,8 @@ main(int argc, char *argv[])
         struct sockaddr_in conn_addr,lstn_addr,svr_addr;
         struct iovec iov_rcv;
 	char incmsg[CMSG_SPACE(sizeof(sctp_cmsg_data_t))];
+	int fd, err_no = 0;
+	char filename[21];
 
 	/* Rather than fflush() throughout the code, set stdout to
          * be unbuffered.
@@ -151,10 +153,19 @@ main(int argc, char *argv[])
 	tst_resm(TPASS, "sendmsg() with a bad socket descriptor - EBADF");
 	
 	/*sendmsg () TEST2: Invalid socket, ENOTSOCK Expected error*/
-	count = sendmsg(0, &outmessage, flag);
-	if (count != -1 || errno != ENOTSOCK)
+	strcpy(filename, "/tmp/sctptest.XXXXXX");
+	fd = mkstemp(filename);
+	if (fd = -1)
+		tst_brkm(TBROK, tst_exit, "Failed to mkstemp %s: %s",
+				filename, strerror(errno));
+	count = sendmsg(fd, &outmessage, flag);
+	if (count = -1)
+		err_no = errno;
+	close(fd);
+	unlink(filename);
+	if (count != -1 || err_no != ENOTSOCK)
 		tst_brkm(TBROK, tst_exit, "sendmsg with invalid socket "
-			 "count:%d, errno:%d", count, errno);
+			 "count:%d, errno:%d", count, err_no);
 
 	tst_resm(TPASS, "sendmsg() with invalid socket - ENOTSOCK");
 
diff --git a/src/func_tests/test_1_to_1_shutdown.c b/src/func_tests/test_1_to_1_shutdown.c
index 3519434..26c5b15 100644
--- a/src/func_tests/test_1_to_1_shutdown.c
+++ b/src/func_tests/test_1_to_1_shutdown.c
@@ -70,6 +70,8 @@ main(int argc, char *argv[])
         char *message = "hello, world!\n";
 	char msgbuf[100];
 	int pf_class;
+	int fd, err_no = 0;
+	char filename[21];
 
         /* Rather than fflush() throughout the code, set stdout to 
 	 * be unbuffered.  
@@ -112,10 +114,19 @@ main(int argc, char *argv[])
 	tst_resm(TPASS, "shutdown() with a bad socket descriptor - EBADF");
 
 	/*shutdown() TEST2: Invalid socket, ENOTSOCK Expected error*/
-        error = shutdown(0, SHUT_WR);
-	if (error != -1 || errno != ENOTSOCK)
+	strcpy(filename, "/tmp/sctptest.XXXXXX");
+	fd = mkstemp(filename);
+	if (fd = -1)
+		tst_brkm(TBROK, tst_exit, "Failed to mkstemp %s: %s",
+				filename, strerror(errno));
+	error = shutdown(fd, SHUT_WR);
+	if (error = -1)
+		err_no = errno;
+	close(fd);
+	unlink(filename);
+	if (error != -1 || err_no != ENOTSOCK)
 		tst_brkm(TBROK, tst_exit, "shutdown with an invalid socket "
-			 "error:%d, errno:%d", error, errno);
+			 "error:%d, errno:%d", error, err_no);
 
 	tst_resm(TPASS, "shutdown() with an invalid socket - ENOTSOCK");
 
diff --git a/src/func_tests/test_1_to_1_socket_bind_listen.c b/src/func_tests/test_1_to_1_socket_bind_listen.c
index 6ba9c98..06c6847 100644
--- a/src/func_tests/test_1_to_1_socket_bind_listen.c
+++ b/src/func_tests/test_1_to_1_socket_bind_listen.c
@@ -85,6 +85,8 @@ main(int argc, char *argv[])
         int sk,pf_class;
 	int error = 0;
 	int uid;
+	int fd, err_no = 0;
+	char filename[21];
 
         struct sockaddr_in bind_addr;
 
@@ -141,10 +143,19 @@ main(int argc, char *argv[])
 	tst_resm(TPASS, "bind() with invalid address length - EINVAL");
 
 	/*bind() TEST6: Invalid socket descriptor, ENOTSOCK Expect Error*/
-	error = bind(0, (struct sockaddr *) &bind_addr, sizeof(bind_addr));
-	if (error != -1 || errno != ENOTSOCK)
+	strcpy(filename, "/tmp/sctptest.XXXXXX");
+	fd = mkstemp(filename);
+	if (fd = -1)
+		tst_brkm(TBROK, tst_exit, "Failed to mkstemp %s: %s",
+				filename, strerror(errno));
+	error = bind(fd, (struct sockaddr *) &bind_addr, sizeof(bind_addr));
+	if (error = -1)
+		err_no = errno;
+	close(fd);
+	unlink(filename);
+	if (error != -1 || err_no != ENOTSOCK)
 		tst_brkm(TBROK, tst_exit, "bind() with invalid socket "
-			 "descriptor error:%d, errno:%d", error, errno);
+			 "descriptor error:%d, errno:%d", error, err_no);
 
 	tst_resm(TPASS, "bind() with invalid socket descriptor - ENOTSOCK");
 
@@ -247,10 +258,19 @@ main(int argc, char *argv[])
 	tst_resm(TPASS, "listen() with bad socket descriptor - EBADF");
 
 	/*listen() TEST14: Invalid socket ENOTSOCK, Expected error*/
-	error = listen(0, 3);
-	if (error != -1 || errno != ENOTSOCK)
+	strcpy(filename, "/tmp/sctptest.XXXXXX");
+	fd = mkstemp(filename);
+	if (fd = -1)
+		tst_brkm(TBROK, tst_exit, "Failed to mkstemp %s: %s",
+				filename, strerror(errno));
+	error = listen(fd, 3);
+	if (error = -1)
+		err_no = errno;
+	close(fd);
+	unlink(filename);
+	if (error != -1 || err_no != ENOTSOCK)
 		tst_brkm(TBROK, tst_exit, "listen() with invalid socket "
-			 "error:%d, errno:%d", error, errno);
+			 "error:%d, errno:%d", error, err_no);
 
 	tst_resm(TPASS, "listen() with invalid socket - ENOTSOCK");
 
diff --git a/src/func_tests/test_1_to_1_sockopt.c b/src/func_tests/test_1_to_1_sockopt.c
index 986533b..49f4eaf 100644
--- a/src/func_tests/test_1_to_1_sockopt.c
+++ b/src/func_tests/test_1_to_1_sockopt.c
@@ -98,6 +98,8 @@ main(void)
 	struct sctp_prim sprimaddr;/*SCTP_PRIMARY_ADDR set*/
 	struct sctp_assocparams sassocparams;  /* SCTP_ASSOCPARAMS set */
 	struct sctp_assocparams gassocparams;  /* SCTP_ASSOCPARAMS get */
+	int fd, err_no = 0;
+	char filename[21];
 
 	/* Rather than fflush() throughout the code, set stdout to
          * be unbuffered.
@@ -118,10 +120,19 @@ main(void)
 	tst_resm(TPASS, "setsockopt() with a bad socket descriptor - EBADF");
 
 	/*setsockopt() TEST2: Invalid socket ENOTSOCK, Expected error*/
-        error = setsockopt(0, IPPROTO_SCTP, 0, 0, 0);
-	if (error != -1 || errno != ENOTSOCK)
+	strcpy(filename, "/tmp/sctptest.XXXXXX");
+	fd = mkstemp(filename);
+	if (fd = -1)
+		tst_brkm(TBROK, tst_exit, "Failed to mkstemp %s: %s",
+				filename, strerror(errno));
+	error = setsockopt(fd, IPPROTO_SCTP, 0, 0, 0);
+	if (error = -1)
+		err_no = errno;
+	close(fd);
+	unlink(filename);
+	if (error != -1 || err_no != ENOTSOCK)
 		tst_brkm(TBROK, tst_exit, "setsockopt with an invalid socket "
-			 "error:%d, errno:%d", error, errno);
+			 "error:%d, errno:%d", error, err_no);
 
 	tst_resm(TPASS, "setsockopt() with an invalid socket - ENOTSOCK");
 
@@ -159,10 +170,19 @@ main(void)
 	tst_resm(TPASS, "getsockopt() with a bad socket descriptor - EBADF");
 
 	/*getsockopt() TEST7: Invalid socket ENOTSOCK, Expected error*/
-        error = getsockopt(0, IPPROTO_SCTP, 0, 0, 0);
-	if (error != -1 || errno != ENOTSOCK)
+	strcpy(filename, "/tmp/sctptest.XXXXXX");
+	fd = mkstemp(filename);
+	if (fd = -1)
+		tst_brkm(TBROK, tst_exit, "Failed to mkstemp %s: %s",
+				filename, strerror(errno));
+	error = getsockopt(fd, IPPROTO_SCTP, 0, 0, 0);
+	if (error = -1)
+		err_no = errno;
+	close(fd);
+	unlink(filename);
+	if (error != -1 || err_no != ENOTSOCK)
 		tst_brkm(TBROK, tst_exit, "getsockopt with an invalid socket "
-			 "error:%d, errno:%d", error, errno);
+			 "error:%d, errno:%d", error, err_no);
 
 	tst_resm(TPASS, "getsockopt() with an invalid socket - ENOTSOCK");
 #if 0
diff --git a/src/func_tests/test_getname.c b/src/func_tests/test_getname.c
index 2340de6..5fc4b3c 100644
--- a/src/func_tests/test_getname.c
+++ b/src/func_tests/test_getname.c
@@ -66,6 +66,8 @@ main(int argc, char *argv[])
 	socklen_t len;
 	int error;
 	int pf_class;
+	int fd, err_no = 0;
+	char filename[21];
 
         /* Rather than fflush() throughout the code, set stdout to 
 	 * be unbuffered.  
@@ -208,10 +210,19 @@ main(int argc, char *argv[])
 	tst_resm(TPASS, "getsockname on a bad socket descriptor - EBADF");
 
 	/*getsockname(): Invalid socket, ENOTSOCK expected error*/
-	error = getsockname(0, (struct sockaddr *)&clt_local_addr, &len);
-	if (error != -1 || errno != ENOTSOCK)
+	strcpy(filename, "/tmp/sctptest.XXXXXX");
+	fd = mkstemp(filename);
+	if (fd = -1)
+		tst_brkm(TBROK, tst_exit, "Failed to mkstemp %s: %s",
+				filename, strerror(errno));
+	error = getsockname(fd, (struct sockaddr *)&clt_local_addr, &len);
+	if (error = -1)
+		err_no = errno;
+	close(fd);
+	unlink(filename);
+	if (error != -1 || err_no != ENOTSOCK)
 		tst_brkm(TBROK, tst_exit, "getsockname on an invalid socket "
-			 "error:%d errno:%d", error, errno);
+			 "error:%d errno:%d", error, err_no);
 
 	tst_resm(TPASS, "getsockname on an invalid socket - ENOTSOCK");
 
@@ -234,10 +245,19 @@ main(int argc, char *argv[])
 	tst_resm(TPASS, "getpeername on a bad socket descriptor - EBADF");
 
 	/*getpeername(): Invalid socket, ENOTSOCK expected error*/
-	error = getpeername(0, (struct sockaddr *)&clt_local_addr, &len);
-	if (error != -1 || errno != ENOTSOCK)
+	strcpy(filename, "/tmp/sctptest.XXXXXX");
+	fd = mkstemp(filename);
+	if (fd = -1)
+		tst_brkm(TBROK, tst_exit, "Failed to mkstemp %s: %s",
+				filename, strerror(errno));
+	error = getpeername(fd, (struct sockaddr *)&clt_local_addr, &len);
+	if (error = -1)
+		err_no = errno;
+	close(fd);
+	unlink(filename);
+	if (error != -1 || err_no != ENOTSOCK)
 		tst_brkm(TBROK, tst_exit, "getpeername on an invalid socket "
-			 "error:%d errno:%d", error, errno);
+			 "error:%d errno:%d", error, err_no);
 
 	tst_resm(TPASS, "getpeername on an invalid socket - ENOTSOCK");
 
-- 
1.8.4.2

