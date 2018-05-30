From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 30 May 2018 17:18:03 +0000
Subject: [PATCH lksctp-tools 12/12] build: add define HAVE_SCTP_SENDV
Message-Id: <8bb7da037b136fc80d92febbebc5656613b90e49.1527700680.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

To indicate whether SENDV/RECVV operations are supported.
If not, the library must not try to build such unit tests nor run then.
It then also hides the symbols in netinet/sctp.h that are related to it.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 configure.ac                  | 4 ++++
 src/func_tests/Makefile.am    | 9 +++++++--
 src/include/netinet/sctp.h.in | 7 +++++++
 src/lib/recvmsg.c             | 2 ++
 src/lib/sendmsg.c             | 2 ++
 src/testlib/sctputil.h        | 5 +++++
 6 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 4cdc1339a19a9e2d17ee5a133a3d0f532539118c..765115de5d9a169a588e2b2186dde46ce34a2c1c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -95,6 +95,10 @@ LKSCTP_CHECK_MEMBER([struct sctp_pdapi_event.pdapi_stream],
 LKSCTP_CHECK_MEMBER([struct sctp_pdapi_event.pdapi_seq],
 		    [HAVE_SCTP_PDAPI_EVENT_PDAPI_SEQ])
 
+# PR-SCTP field used to probe for sendv/recvv support, added on v4.17
+LKSCTP_CHECK_MEMBER([struct sendv_prinfo.sctp_prinfo],
+		    [HAVE_SCTP_SENDV])
+
 AC_CONFIG_HEADERS([src/include/netinet/sctp.h])
 AC_CONFIG_FILES([lksctp-tools.spec
 		Makefile
diff --git a/src/func_tests/Makefile.am b/src/func_tests/Makefile.am
index 1f51356f750c727c066d67b89e5db84697839ff3..495adcf352caf2aa446b4dec599a289a6bb05205 100644
--- a/src/func_tests/Makefile.am
+++ b/src/func_tests/Makefile.am
@@ -30,7 +30,6 @@ PASSING_KERN_TESTS = \
 	test_recvmsg \
 	test_timetolive \
 	test_sctp_sendrecvmsg \
-	test_sctp_sendvrecvv \
 	test_getname \
 	test_tcp_style\
 	test_1_to_1_socket_bind_listen \
@@ -59,10 +58,16 @@ PASSING_V6_KERN_TESTS = \
 	test_peeloff_v6 \
 	test_timetolive_v6 \
 	test_sctp_sendrecvmsg_v6 \
-	test_sctp_sendvrecvv_v6 \
 	test_getname_v6 \
 	test_tcp_style_v6
 
+if HAVE_SCTP_SENDV
+PASSING_KERN_TESTS += \
+	test_sctp_sendvrecvv
+PASSING_V6_KERN_TESTS += \
+	test_sctp_sendvrecvv_v6
+endif
+
 noinst_PROGRAMS = ${PASSING_KERN_TESTS} ${PASSING_V6_KERN_TESTS}
 
 $(top_builddir)/src/lib/libsctp.la:
diff --git a/src/include/netinet/sctp.h.in b/src/include/netinet/sctp.h.in
index 04932a6474bddfe4af7cbc1de0c4ab501a2d31c5..bc8acc9377f988bad6809b5b98ea9cb8b6de89e6 100644
--- a/src/include/netinet/sctp.h.in
+++ b/src/include/netinet/sctp.h.in
@@ -67,6 +67,7 @@ extern "C" {
 #undef HAVE_SCTP_PEELOFF_FLAGS
 #undef HAVE_SCTP_PDAPI_EVENT_PDAPI_STREAM
 #undef HAVE_SCTP_PDAPI_EVENT_PDAPI_SEQ
+#undef HAVE_SCTP_SENDV
 
 int sctp_bindx(int sd, struct sockaddr *addrs, int addrcnt, int flags);
 
@@ -131,6 +132,7 @@ int sctp_recvmsg(int s, void *msg, size_t len, struct sockaddr *from,
 int sctp_getaddrlen(sa_family_t family);
 
 
+#ifdef HAVE_SCTP_SENDV
 /* sendv infotype */
 enum {
 	SCTP_SENDV_NOINFO,
@@ -144,14 +146,18 @@ enum {
 #define SCTP_SEND_SNDINFO_VALID		0x1
 #define SCTP_SEND_PRINFO_VALID		0x2
 #define SCTP_SEND_AUTHINFO_VALID	0x4
+#endif
 
 struct sctp_sendv_spa {
 	uint32_t sendv_flags;
 	struct sctp_sndinfo sendv_sndinfo;
+#ifdef HAVE_SCTP_SENDV
 	struct sctp_prinfo sendv_prinfo;
 	struct sctp_authinfo sendv_authinfo;
+#endif
 };
 
+#ifdef HAVE_SCTP_SENDV
 int sctp_sendv(int s, const struct iovec *iov, int iovcnt,
 	       struct sockaddr *addrs, int addrcnt, void *info,
 	       socklen_t infolen, unsigned int infotype, int flags);
@@ -172,6 +178,7 @@ struct sctp_recvv_rn {
 int sctp_recvv(int s, const struct iovec *iov, int iovlen,
 	       struct sockaddr *from, socklen_t *fromlen, void *info,
 	       socklen_t *infolen, unsigned int *infotype, int *flags);
+#endif
 
 #ifdef __cplusplus
 }
diff --git a/src/lib/recvmsg.c b/src/lib/recvmsg.c
index 7c1dcad746a11d042108826a27d99067d7e5060c..88fe061b091926d3ab6897b6a992ba818004c916 100644
--- a/src/lib/recvmsg.c
+++ b/src/lib/recvmsg.c
@@ -100,6 +100,7 @@ int sctp_recvmsg(int s, void *msg, size_t len, struct sockaddr *from,
 	return (error);
 }
 
+#ifdef HAVE_SCTP_SENDV
 int sctp_recvv(int s, const struct iovec *iov, int iovlen,
 	       struct sockaddr *from, socklen_t *fromlen, void *info,
 	       socklen_t *infolen, unsigned int *infotype, int *flags)
@@ -187,3 +188,4 @@ int sctp_recvv(int s, const struct iovec *iov, int iovlen,
 
 	return error;
 }
+#endif
diff --git a/src/lib/sendmsg.c b/src/lib/sendmsg.c
index a67c1c8395041badd14c990815351e4938e36288..ea9c078f1543705f11031edc72b8d87d813e2faa 100644
--- a/src/lib/sendmsg.c
+++ b/src/lib/sendmsg.c
@@ -108,6 +108,7 @@ sctp_send(int s, const void *msg, size_t len,
 	return sendmsg(s, &outmsg, flags);
 }
 
+#ifdef HAVE_SCTP_SENDV
 static struct cmsghdr *sctp_sendv_store_cmsg(struct cmsghdr *cmsg, int *cmsglen,
 					     int type, int len, void *data)
 {
@@ -234,3 +235,4 @@ int sctp_sendv(int s, const struct iovec *iov, int iovcnt,
 
 	return err;
 }
+#endif
diff --git a/src/testlib/sctputil.h b/src/testlib/sctputil.h
index dda91696838511d14dfd26a5910aa1100118467a..9dbabd4762e0693d755f898659ed4d376ea7b21c 100644
--- a/src/testlib/sctputil.h
+++ b/src/testlib/sctputil.h
@@ -292,6 +292,7 @@ static inline int test_sctp_send(int s, const void *msg, size_t len,
 	return error;			
 }
 
+#ifdef HAVE_SCTP_SENDV
 static inline int test_sctp_sendv(int s, const struct iovec *iov, int iovcnt,
 				  struct sockaddr *addrs, int addrcnt,
 				  void *info, socklen_t infolen,
@@ -309,6 +310,7 @@ static inline int test_sctp_sendv(int s, const struct iovec *iov, int iovcnt,
 			 error, errno);
 	return error;
 }
+#endif
 
 static inline int test_sctp_recvmsg(int sk, void *msg, size_t len,
 				    struct sockaddr *from, socklen_t *fromlen,
@@ -321,6 +323,7 @@ static inline int test_sctp_recvmsg(int sk, void *msg, size_t len,
 	return error;			
 }
 
+#ifdef HAVE_SCTP_SENDV
 static inline int test_sctp_recvv(int s, const struct iovec *iov, int iovlen,
 				  struct sockaddr *from, socklen_t *fromlen,
 				  void *info, socklen_t *infolen,
@@ -332,6 +335,8 @@ static inline int test_sctp_recvv(int s, const struct iovec *iov, int iovlen,
 		tst_brkm(TBROK, tst_exit, "sctp_recvmsg: %s", strerror(errno));
 	return error;
 }
+#endif
+
 static inline void *test_malloc(size_t size)
 {
 	void *buf = malloc(size);
-- 
2.14.3

