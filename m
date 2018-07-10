From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 10 Jul 2018 11:07:03 +0000
Subject: [PATCH lksctp-tools 1/2] build: add define HAVE_SCTP_AUTH_NO_AUTH
Message-Id: <d938eaa3ee77d1fc9bc1c1b29ddd06a2b2ccba41.1531220086.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Add define to indicate if SCTP_AUTH_NO_AUTH notification would be
generated when creating an asoc without authentication supported
on peer.

Note that SCTP_AUTH_NO_AUTH is defined on kernel UAPI header. It
also fixes that test_1_to_1_events fails on v4.16 and newer kernel.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 configure.ac                        |  4 ++++
 src/func_tests/test_1_to_1_events.c | 11 +++++++++++
 src/include/netinet/sctp.h.in       |  1 +
 3 files changed, 16 insertions(+)

diff --git a/configure.ac b/configure.ac
index 765115d..d4f80f2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -99,6 +99,10 @@ LKSCTP_CHECK_MEMBER([struct sctp_pdapi_event.pdapi_seq],
 LKSCTP_CHECK_MEMBER([struct sendv_prinfo.sctp_prinfo],
 		    [HAVE_SCTP_SENDV])
 
+# This event indicates that the peer does not support SCTP authentication,
+# added on v4.16, 30f6ebf65bc4
+LKSCTP_CHECK_DECL([SCTP_AUTH_NO_AUTH], [HAVE_SCTP_AUTH_NO_AUTH])
+
 AC_CONFIG_HEADERS([src/include/netinet/sctp.h])
 AC_CONFIG_FILES([lksctp-tools.spec
 		Makefile
diff --git a/src/func_tests/test_1_to_1_events.c b/src/func_tests/test_1_to_1_events.c
index 3525346..46439bf 100644
--- a/src/func_tests/test_1_to_1_events.c
+++ b/src/func_tests/test_1_to_1_events.c
@@ -166,6 +166,17 @@ main(int argc, char *argv[])
 	
 	tst_resm(TPASS, "COMM_UP notification on server socket - SUCCESS");
 
+#ifdef HAVE_SCTP_AUTH_NO_AUTH
+	error = test_recvmsg(acpt_sk, &inmessage, MSG_WAITALL);
+	test_check_msg_notification(&inmessage,
+				    error,
+				    sizeof(struct sctp_authkey_event),
+				    SCTP_AUTHENTICATION_EVENT,
+				    SCTP_AUTH_NO_AUTH);
+
+	tst_resm(TPASS, "AUTH_NO_AUTH notification on server socket - SUCCESS");
+#endif
+
 	inmessage.msg_control = incmsg;
 	inmessage.msg_controllen = sizeof(incmsg);
 	error = test_recvmsg(acpt_sk, &inmessage, MSG_WAITALL);
diff --git a/src/include/netinet/sctp.h.in b/src/include/netinet/sctp.h.in
index bc8acc9..0b7ba03 100644
--- a/src/include/netinet/sctp.h.in
+++ b/src/include/netinet/sctp.h.in
@@ -68,6 +68,7 @@ extern "C" {
 #undef HAVE_SCTP_PDAPI_EVENT_PDAPI_STREAM
 #undef HAVE_SCTP_PDAPI_EVENT_PDAPI_SEQ
 #undef HAVE_SCTP_SENDV
+#undef HAVE_SCTP_AUTH_NO_AUTH
 
 int sctp_bindx(int sd, struct sockaddr *addrs, int addrcnt, int flags);
 
-- 
2.1.0

