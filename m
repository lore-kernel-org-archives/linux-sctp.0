From: Horacio Sanson <hsanson@gmail.com>
Date: Wed, 17 Dec 2008 07:04:39 +0000
Subject: [PATCH] lksctp-tools: replace sinfo_timetolive with sinfo_pr_value.
Message-Id: <1229497479-10198-2-git-send-email-hsanson@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Horacio Sanson <horacio@skillupjapan.co.jp>

Modified all relevant structures in all header and source files to
replace the deprecated sinfo_timetolive field with the newer
sinfo_pr_policy and sinfo_pr_value.

Added a new sctp_sinfo_pr_policy enum that contains the different PR policy
definitions: SCTP_PR_SCTP_NONE and SCTP_PR_SCTP_TTL. And modified the
values of sctp_sinfo_flags so they use the higher byte only and leave the
lower byte free for sctp_pr_policy values.
---
 src/func_tests/test_sctp_sendrecvmsg.c |    7 ++++---
 src/func_tests/test_timetolive.c       |   20 ++++++++++++--------
 src/include/netinet/sctp.h             |   24 ++++++++++++++++++------
 src/lib/sendmsg.c                      |    9 +++++++--
 src/testlib/sctputil.h                 |    4 ++--
 5 files changed, 43 insertions(+), 21 deletions(-)

diff --git a/src/func_tests/test_sctp_sendrecvmsg.c b/src/func_tests/test_sctp_sendrecvmsg.c
index c275e45..be10f01 100644
--- a/src/func_tests/test_sctp_sendrecvmsg.c
+++ b/src/func_tests/test_sctp_sendrecvmsg.c
@@ -243,7 +243,7 @@ int main(int argc, char *argv[])
 	/* Now send a message that will timeout. */
 	test_sctp_sendmsg(sk1, ttlmsg, strlen(ttlmsg) + 1,
 			  (struct sockaddr *)&loop2, sizeof(loop2),
-			  ppid, 0, stream, 2000, 0);
+			  ppid, SCTP_PR_SCTP_TTL, stream, 2000, 0);
 
 	tst_resm(TPASS, "sctp_sendmsg with ttl");
 
@@ -259,7 +259,7 @@ int main(int argc, char *argv[])
 	ttlfrag[sizeof(ttlfrag)-1] = '\0';
 	test_sctp_sendmsg(sk1, ttlfrag, sizeof(ttlfrag),
 			  (struct sockaddr *)&loop2, sizeof(loop2),
-			  ppid, 0, stream, 2000, 0);
+			  ppid, SCTP_PR_SCTP_TTL, stream, 2000, 0);
 
 	tst_resm(TPASS, "sctp_sendmsg fragmented msg with ttl");
 
@@ -335,7 +335,8 @@ int main(int argc, char *argv[])
 	snd_sinfo.sinfo_ppid = rand();
 	snd_sinfo.sinfo_flags = 0; 
 	snd_sinfo.sinfo_stream = 2; 
-	snd_sinfo.sinfo_timetolive = 0; 
+	snd_sinfo.sinfo_pr_policy = SCTP_PR_SCTP_NONE;
+	snd_sinfo.sinfo_pr_value = 0;
 	snd_sinfo.sinfo_assoc_id = associd1; 
 	test_sctp_send(sk1, message, strlen(message) + 1, &snd_sinfo,
 		       MSG_NOSIGNAL);
diff --git a/src/func_tests/test_timetolive.c b/src/func_tests/test_timetolive.c
index d9bdf1b..583542e 100644
--- a/src/func_tests/test_timetolive.c
+++ b/src/func_tests/test_timetolive.c
@@ -39,14 +39,14 @@
 
 /*
  * This is a basic functional test for the SCTP kernel 
- * implementation of sndrcvinfo.sinfo_timetolive.
+ * implementation of sndrcvinfo.sinfo_pr_value.
  *
  * 1) Create two sockets, the listening socket sets its RECVBUF small
  * 2) Create a connection.  Send enough data to the non-reading listener
  * to fill the RCVBUF.
- * 5) Set sinfo_timetolive on a message and send.
- * 6) Disable sinfo_timetolive on a message and send.
- * 7) Wait sinfo_timetolive.
+ * 5) Set sinfo_pr_value and sinfo_pr_policy on a message and send.
+ * 6) Disable sinfo_pr_policy on a message and send.
+ * 7) Wait sinfo_pr_value.
  * 8) Read out all the data at the receiver.
  * 9) Make sure timed out message did not make it.
  * 10) Make sure that the message with no timeout makes it to the receiver.
@@ -288,7 +288,8 @@ int main(int argc, char *argv[])
 	outmessage.msg_name = NULL;
 	outmessage.msg_namelen = 0;
 	sinfo->sinfo_assoc_id = associd1;
-	sinfo->sinfo_timetolive = 0;
+	sinfo->sinfo_pr_policy = SCTP_PR_SCTP_NONE;
+	sinfo->sinfo_pr_value = 0;
 	test_sendmsg(sk1, &outmessage, MSG_NOSIGNAL,
 			 gstatus.sstat_rwnd+RWND_SLOP);
 
@@ -300,7 +301,8 @@ int main(int argc, char *argv[])
 	outmessage.msg_name = NULL;
 	outmessage.msg_namelen = 0;
 	sinfo->sinfo_assoc_id = associd1;
-	sinfo->sinfo_timetolive = 2000;
+	sinfo->sinfo_pr_policy = SCTP_PR_SCTP_TTL;
+	sinfo->sinfo_pr_value = 2000;
 	test_sendmsg(sk1, &outmessage, MSG_NOSIGNAL, strlen(ttlmsg) + 1);
 
 	tst_resm(TPASS, "Send a message with timeout");
@@ -313,7 +315,8 @@ int main(int argc, char *argv[])
 	outmessage.msg_name = NULL;
 	outmessage.msg_namelen = 0;
 	sinfo->sinfo_assoc_id = associd1;
-	sinfo->sinfo_timetolive = 0;
+	sinfo->sinfo_pr_policy = SCTP_PR_SCTP_NONE;
+	sinfo->sinfo_pr_value = 0;
 	test_sendmsg(sk1, &outmessage, MSG_NOSIGNAL, strlen(nottlmsg)+1);
 
 	tst_resm(TPASS, "Send a message with no timeout");
@@ -328,7 +331,8 @@ int main(int argc, char *argv[])
 	outmessage.msg_name = NULL;
 	outmessage.msg_namelen = 0;
 	sinfo->sinfo_assoc_id = associd1;
-	sinfo->sinfo_timetolive = 2000;
+	sinfo->sinfo_pr_policy = SCTP_PR_SCTP_TTL;
+	sinfo->sinfo_pr_value = 2000;
 	test_sendmsg(sk1, &outmessage, MSG_NOSIGNAL, sizeof(ttlfrag));
 
 	tst_resm(TPASS, "Send a fragmented message with timeout");
diff --git a/src/include/netinet/sctp.h b/src/include/netinet/sctp.h
index ae557a5..70c1fce 100644
--- a/src/include/netinet/sctp.h
+++ b/src/include/netinet/sctp.h
@@ -184,9 +184,10 @@ struct sctp_sndrcvinfo {
 	__u16 sinfo_stream;
 	__u16 sinfo_ssn;
 	__u16 sinfo_flags;
+	__u16 sinfo_pr_policy;
 	__u32 sinfo_ppid;
 	__u32 sinfo_context;
-	__u32 sinfo_timetolive;
+	__u32 sinfo_pr_value;
 	__u32 sinfo_tsn;
 	__u32 sinfo_cumtsn;
 	sctp_assoc_t sinfo_assoc_id;
@@ -200,12 +201,23 @@ struct sctp_sndrcvinfo {
  */
 
 enum sctp_sinfo_flags {
-	SCTP_UNORDERED = 1,  /* Send/receive message unordered. */
-	SCTP_ADDR_OVER = 2,  /* Override the primary destination. */
-	SCTP_ABORT=4,        /* Send an ABORT message to the peer. */
-	SCTP_EOF=MSG_FIN,    /* Initiate graceful shutdown process. */
+	SCTP_EOF       = MSG_FIN,    /* Initiate graceful shutdown process. */
+	SCTP_UNORDERED = 0x0400,     /* Send/receive message unordered. */
+	SCTP_ADDR_OVER = 0x0800,     /* Override the primary destination. */
+	SCTP_ABORT     = 0x1000,     /* Send an ABORT message to the peer. */
 };
 
+/*
+ *  sinfo_pr_policy: 16 bits (unsigned integer)
+ *
+ *   This field may contain the partial reliability used to
+ *   send the message.
+ */
+
+enum sctp_sinfo_pr_policy {
+	SCTP_PR_SCTP_NONE = 0x0000,  /* Reliable transmission */
+	SCTP_PR_SCTP_TTL  = 0x0001,  /* Timed partial reliability */
+};
 
 typedef union {
 	__u8   			raw;
@@ -816,7 +828,7 @@ int sctp_freeladdrs(struct sockaddr *addrs);
  */
 int sctp_sendmsg(int s, const void *msg, size_t len, struct sockaddr *to,
 		 socklen_t tolen, uint32_t ppid, uint32_t flags,
-		 uint16_t stream_no, uint32_t timetolive, uint32_t context);
+		 uint16_t stream_no, uint32_t pr_value, uint32_t context);
 
 /* This library function assist the user with sending a message without
  * dealing directly with the CMSG header.
diff --git a/src/lib/sendmsg.c b/src/lib/sendmsg.c
index 1de592d..459cd70 100644
--- a/src/lib/sendmsg.c
+++ b/src/lib/sendmsg.c
@@ -31,7 +31,7 @@
 int
 sctp_sendmsg(int s, const void *msg, size_t len, struct sockaddr *to,
 	     socklen_t tolen, uint32_t ppid, uint32_t flags,
-	     uint16_t stream_no, uint32_t timetolive, uint32_t context)
+	     uint16_t stream_no, uint32_t pr_value, uint32_t context)
 {
 	struct msghdr outmsg;
 	struct iovec iov;
@@ -61,9 +61,14 @@ sctp_sendmsg(int s, const void *msg, size_t len, struct sockaddr *to,
 	sinfo->sinfo_ppid = ppid;
 	sinfo->sinfo_flags = flags;
 	sinfo->sinfo_stream = stream_no;
-	sinfo->sinfo_timetolive = timetolive;
+	sinfo->sinfo_pr_policy = sinfo->sinfo_flags & 0xff;
+	sinfo->sinfo_pr_value = pr_value;
 	sinfo->sinfo_context = context;
 
+	/* TODO: what to do if sinfo_pr_policy is invalid? */
+	if(sinfo->sinfo_pr_policy > SCTP_PR_SCTP_TTL)
+	    sinfo->sinfo_pr_policy = SCTP_PR_SCTP_NONE;
+
 	return sendmsg(s, &outmsg, 0);
 }
 
diff --git a/src/testlib/sctputil.h b/src/testlib/sctputil.h
index 347c91b..ecdcc8c 100644
--- a/src/testlib/sctputil.h
+++ b/src/testlib/sctputil.h
@@ -270,11 +270,11 @@ static inline int test_sctp_peeloff(int sk, sctp_assoc_t assoc_id)
 static inline int test_sctp_sendmsg(int s, const void *msg, size_t len,
 				    struct sockaddr *to, socklen_t tolen,
 				    uint32_t ppid, uint32_t flags,
-				    uint16_t stream_no, uint32_t timetolive,
+				    uint16_t stream_no, uint32_t pr_value,
 				    uint32_t context)
 {
 	int error = sctp_sendmsg(s, msg, len, to, tolen, ppid, flags, stream_no,
-	  		         timetolive, context);
+				 pr_value, context);
 	if (len != error)
 		tst_brkm(TBROK, tst_exit, "sctp_sendmsg: error:%d errno:%d",
 			 error, errno);
-- 
1.5.6.3

