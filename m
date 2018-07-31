From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 31 Jul 2018 08:53:17 +0000
Subject: [PATCH lksctp-tools 9/9] func_tests: fix covscan warnings
Message-Id: <565317fe15ba3a6e65ee1ffd850b5669613f16ee.1533027042.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

use the right socket parameter when calling test_sendto in
func_tests/test_1_to_1_sendto; and use 48, the ascii code
of '0', when calling memset in func_tests/test_timetolive,
since memset requires 'int' type.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 src/func_tests/test_1_to_1_rtoinfo.c   | 1 +
 src/func_tests/test_1_to_1_sendto.c    | 2 +-
 src/func_tests/test_sctp_sendrecvmsg.c | 2 +-
 src/func_tests/test_timetolive.c       | 2 +-
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/func_tests/test_1_to_1_rtoinfo.c b/src/func_tests/test_1_to_1_rtoinfo.c
index 02dd477..1651df1 100644
--- a/src/func_tests/test_1_to_1_rtoinfo.c
+++ b/src/func_tests/test_1_to_1_rtoinfo.c
@@ -82,6 +82,7 @@ main(void)
 	srtoinfo.srto_initial`;
 	srtoinfo.srto_max0;
 	srtoinfo.srto_min@;
+	srtoinfo.srto_assoc_id = 0;
 
 	/*TEST2 Setting the values using setsockopt()*/
 	ret = setsockopt(sd, IPPROTO_SCTP, SCTP_RTOINFO, &srtoinfo, 
diff --git a/src/func_tests/test_1_to_1_sendto.c b/src/func_tests/test_1_to_1_sendto.c
index 8f5804c..56b102a 100644
--- a/src/func_tests/test_1_to_1_sendto.c
+++ b/src/func_tests/test_1_to_1_sendto.c
@@ -150,7 +150,7 @@ main(int argc, char *argv[])
 
 	/*send() TEST4: Sending less number of data from the buffer*/
 	/*Sending only 5 bytes so that only hello is received*/
-	test_sendto(sk, message, 5 , flag, (const struct sockaddr *)&conn_addr,
+	test_sendto(sk1, message, 5, flag, (const struct sockaddr *)&conn_addr,
 		    len);
 	test_recv(acpt_sk, message_rcv, 5, flag);
 	
diff --git a/src/func_tests/test_sctp_sendrecvmsg.c b/src/func_tests/test_sctp_sendrecvmsg.c
index 33d013c..ceccd5a 100644
--- a/src/func_tests/test_sctp_sendrecvmsg.c
+++ b/src/func_tests/test_sctp_sendrecvmsg.c
@@ -248,7 +248,7 @@ int main(int argc, char *argv[])
 	tst_resm(TPASS, "sctp_sendmsg with zero ttl");
 
 	/* And finally a fragmented message that will time out. */
-	memset(ttlfrag, '0', sizeof(ttlfrag));
+	memset(ttlfrag, 48, sizeof(ttlfrag)); /* 48 is the ascii of '0' */
 	ttlfrag[sizeof(ttlfrag)-1] = '\0';
 	test_sctp_sendmsg(sk1, ttlfrag, sizeof(ttlfrag),
 			  (struct sockaddr *)&loop2, sizeof(loop2),
diff --git a/src/func_tests/test_timetolive.c b/src/func_tests/test_timetolive.c
index 85325da..58d76f0 100644
--- a/src/func_tests/test_timetolive.c
+++ b/src/func_tests/test_timetolive.c
@@ -310,7 +310,7 @@ int main(int argc, char *argv[])
 	/* And finally a fragmented message that will time out. */
 	sinfo->sinfo_ppid = ppid;
 	sinfo->sinfo_stream = stream;
-	memset(ttlfrag, '0', sizeof(ttlfrag));
+	memset(ttlfrag, 48, sizeof(ttlfrag)); /* 48 is the ascii of '0' */
 	ttlfrag[sizeof(ttlfrag)-1] = '\0';
 	outmessage.msg_iov->iov_base = ttlfrag;
         outmessage.msg_iov->iov_len = sizeof(ttlfrag);
-- 
2.1.0

