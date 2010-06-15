From: =?UTF-8?q?Diego=20Elio=20=27Flameeyes=27=20Petten=C3=B2?=
Date: Tue, 15 Jun 2010 16:24:53 +0000
Subject: [PATCH 2/2] Avoid format warnings by using %zu for size_t rather than %d.
Message-Id: <1276619093-3880-3-git-send-email-flameeyes@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

---
 src/apps/bindx_test.c  |    8 ++++----
 src/apps/peel_client.c |    2 +-
 src/apps/peel_server.c |    2 +-
 src/apps/sctp_darn.c   |    2 +-
 src/apps/sctp_test.c   |    4 ++--
 src/testlib/sctputil.c |    2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/src/apps/bindx_test.c b/src/apps/bindx_test.c
index ec7632e..b1c9ffa 100644
--- a/src/apps/bindx_test.c
+++ b/src/apps/bindx_test.c
@@ -66,13 +66,13 @@ int main (int argc, char **argv)
 	cnt = 2;    /* argument iterator */
 	buf_ptr = addr_buf;
 	while (cnt < argc) {
-		printf("bindx_test: INFO: Arg %d: %s", cnt, argv[cnt]);
+		printf("bindx_test: INFO: Arg %zu: %s", cnt, argv[cnt]);
 		fflush(stderr);
 		if (strchr(argv[cnt], ':')) {
 			struct sockaddr_in6 *sa6; 
 
 			sa6 = (struct sockaddr_in6 *)buf_ptr;
-			printf(" IPv6 address number %d", addrs);
+			printf(" IPv6 address number %zu", addrs);
 			sa6->sin6_family = AF_INET6;
 			sa6->sin6_port = port;
 			if (inet_pton(AF_INET6, argv[cnt], &sa6->sin6_addr)) {
@@ -85,7 +85,7 @@ int main (int argc, char **argv)
 			struct sockaddr_in *sa; 
 
 			sa = (struct sockaddr_in *)buf_ptr;
-			printf (" IPv4 address number %d", addrs);
+			printf (" IPv4 address number %zu", addrs);
 			sa->sin_family = AF_INET;
 			sa->sin_port = port;
 			if (inet_pton (AF_INET, argv[cnt], &sa->sin_addr)) {
@@ -100,7 +100,7 @@ int main (int argc, char **argv)
 		cnt++;
 	}
 
-	printf ("bindx_test: INFO: Got %d addrs\n", addrs);
+	printf ("bindx_test: INFO: Got %zu addrs\n", addrs);
   
 	/* Create the socket */
 	sd = socket(PF_INET6, SOCK_SEQPACKET, IPPROTO_SCTP);
diff --git a/src/apps/peel_client.c b/src/apps/peel_client.c
index ede3fbc..2c3f234 100644
--- a/src/apps/peel_client.c
+++ b/src/apps/peel_client.c
@@ -453,7 +453,7 @@ my_sctpReadInput(int fd)
 	errno = 0;
 	sz = recvmsg(fd,&msg,0);
 	if(sz <= 0){
-		printf("Read returns %d errno:%d control len is %d msgflg:%x\n",
+		printf("Read returns %d errno:%d control len is %zu msgflg:%x\n",
 		       sz,errno,
 		       msg.msg_controllen,msg.msg_flags);
 	}
diff --git a/src/apps/peel_server.c b/src/apps/peel_server.c
index 524b471..9b9b065 100644
--- a/src/apps/peel_server.c
+++ b/src/apps/peel_server.c
@@ -436,7 +436,7 @@ my_sctpReadInput(int fd,int maxread)
 	msg.msg_controllen = sizeof(controlVector);
 	errno = 0;
 	sz = recvmsg(fd,&msg,0);
-	printf("Read fd:%d returns %d errno:%d control len is %d msgflg:%x\n",
+	printf("Read fd:%d returns %d errno:%d control len is %zu msgflg:%x\n",
 	       fd,
 	       sz,errno,
 	       msg.msg_controllen,
diff --git a/src/apps/sctp_darn.c b/src/apps/sctp_darn.c
index 625e541..6aa707a 100644
--- a/src/apps/sctp_darn.c
+++ b/src/apps/sctp_darn.c
@@ -1375,7 +1375,7 @@ user_test_check_message(struct msghdr *msg,
 
 	if (msg->msg_controllen != controllen) {
 		fprintf(stderr,
-			"Got control structure of length %d, not %d\n",
+			"Got control structure of length %zu, not %d\n",
 			msg->msg_controllen, controllen);
 		exit(1);
 	}
diff --git a/src/apps/sctp_test.c b/src/apps/sctp_test.c
index 7287d05..6d56660 100644
--- a/src/apps/sctp_test.c
+++ b/src/apps/sctp_test.c
@@ -341,9 +341,9 @@ print_message(const int sk, struct msghdr *msg, size_t msg_len) {
         if (!(MSG_NOTIFICATION & msg->msg_flags)) {
                 int index = 0;
 
-		DEBUG_PRINT(DEBUG_MIN, "Data %d bytes.", msg_len);
+		DEBUG_PRINT(DEBUG_MIN, "Data %zu bytes.", msg_len);
 
-		DEBUG_PRINT(DEBUG_MAX, " First %d bytes: ",
+		DEBUG_PRINT(DEBUG_MAX, " First %zu bytes: ",
 				    (msg_len < BODYSIZE)?msg_len:BODYSIZE);
                 /* Make sure that everything is printable and that we
                  * are NUL terminated...
diff --git a/src/testlib/sctputil.c b/src/testlib/sctputil.c
index abf80fa..297deb5 100644
--- a/src/testlib/sctputil.c
+++ b/src/testlib/sctputil.c
@@ -114,7 +114,7 @@ test_print_message(int sk, struct msghdr *msg, size_t msg_len)
 		/* Make sure that everything is printable and that we
 		 * are NUL terminated...
 		 */
-		printf("DATA(%d):  ", msg_len);
+		printf("DATA(%zu):  ", msg_len);
 		while ( msg_len > 0 ) {
 			char *text;
 			int len;
-- 
1.7.1

