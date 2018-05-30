From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 30 May 2018 17:18:01 +0000
Subject: [PATCH lksctp-tools 10/12] build: add define HAVE_SCTP_PEELOFF_FLAGS
Message-Id: <555e42a521858d59a321241c98088e766f31ed2d.1527700680.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Indicate that SCTP_PEELOFF_FLAGS sockopt is available and, with it, adjust
how we build sctp_peeloff{,_flags}(). We cannot make sctp_peeloff() reuse
sctp_peeloff_flags() because the latter may not be available.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 configure.ac                  |  3 +++
 src/include/netinet/sctp.h.in |  1 +
 src/lib/peeloff.c             | 38 +++++++++++++++++++++++---------------
 3 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/configure.ac b/configure.ac
index daf14e398c6282cbbe56ba8c99abb9c0fc230d83..1558579a385b87bf5afc76cd2548e0c51628d708 100644
--- a/configure.ac
+++ b/configure.ac
@@ -86,6 +86,9 @@ LKSCTP_CHECK_MEMBER([struct sctp_event_subscribe.sctp_stream_reset_event],
 # RFC 6525 (Stream Reconf), finished on v4.12, c0d8bab6ae51
 LKSCTP_CHECK_DECL([SCTP_RECONFIG_SUPPORTED], [HAVE_SCTP_STREAM_RECONFIG])
 
+# sctp_peeloff_flags was added on v4.13, 2cb5c8e378d1
+LKSCTP_CHECK_TYPE([sctp_peeloff_flags_arg_t], [HAVE_SCTP_PEELOFF_FLAGS])
+
 AC_CONFIG_HEADERS([src/include/netinet/sctp.h])
 AC_CONFIG_FILES([lksctp-tools.spec
 		Makefile
diff --git a/src/include/netinet/sctp.h.in b/src/include/netinet/sctp.h.in
index 31750811ad601444f1cf13e64229ba4ac9a1c379..0c856a837c08a8768ab6f4d5c81c1c3cce1d4378 100644
--- a/src/include/netinet/sctp.h.in
+++ b/src/include/netinet/sctp.h.in
@@ -64,6 +64,7 @@ extern "C" {
 #undef HAVE_SCTP_ASSOC_RESET_EVENT
 #undef HAVE_SCTP_STREAM_CHANGE_EVENT
 #undef HAVE_SCTP_STREAM_RECONFIG
+#undef HAVE_SCTP_PEELOFF_FLAGS
 
 int sctp_bindx(int sd, struct sockaddr *addrs, int addrcnt, int flags);
 
diff --git a/src/lib/peeloff.c b/src/lib/peeloff.c
index edd75a0b3cd42a8b6cd219038c9c61ff6d2b000c..a4e1ed9b9bb97342acc9869f51710dd0baf11e1b 100644
--- a/src/lib/peeloff.c
+++ b/src/lib/peeloff.c
@@ -23,34 +23,30 @@
 #include <netinet/sctp.h> /* SCTP_SOCKOPT_BINDX_* */
 #include <errno.h>
 
+#ifdef HAVE_SCTP_PEELOFF_FLAGS
 int
 sctp_peeloff_flags(int fd, sctp_assoc_t associd, unsigned flags)
 {
+	socklen_t peeloff_size = sizeof(sctp_peeloff_flags_arg_t);
 	sctp_peeloff_flags_arg_t peeloff;
-	socklen_t peeloff_size;
 	int err;
 
+	if (!flags)
+		return sctp_peeloff(fd, associd);
+
 	peeloff.p_arg.associd = associd;
 	peeloff.p_arg.sd = 0;
 	peeloff.flags = flags;
 
-
-	if (flags) {
-		peeloff_size = sizeof(sctp_peeloff_flags_arg_t);
-		err = getsockopt(fd, SOL_SCTP, SCTP_SOCKOPT_PEELOFF_FLAGS, &peeloff,
-				 &peeloff_size);
-	} else {
-		peeloff_size = sizeof(sctp_peeloff_arg_t);
-		err = getsockopt(fd, SOL_SCTP, SCTP_SOCKOPT_PEELOFF, &peeloff.p_arg,
-				 &peeloff_size);
-	}
+	err = getsockopt(fd, SOL_SCTP, SCTP_SOCKOPT_PEELOFF_FLAGS, &peeloff,
+			 &peeloff_size);
 
 	if (err < 0)
 		return err;
 
 	return peeloff.p_arg.sd;
-
-} /* sctp_peeloff() */
+}
+#endif
 
 /* Branch off an association into a seperate socket.  This is a new SCTP API
  * described in the section 8.2 of the Sockets API Extensions for SCTP. 
@@ -59,6 +55,18 @@ sctp_peeloff_flags(int fd, sctp_assoc_t associd, unsigned flags)
 int
 sctp_peeloff(int fd, sctp_assoc_t associd)
 {
-	return sctp_peeloff_flags(fd, associd, 0);
-}
+	socklen_t peeloff_size = sizeof(sctp_peeloff_arg_t);
+	sctp_peeloff_arg_t peeloff;
+	int err;
 
+	peeloff.associd = associd;
+	peeloff.sd = 0;
+
+	err = getsockopt(fd, SOL_SCTP, SCTP_SOCKOPT_PEELOFF, &peeloff,
+			 &peeloff_size);
+
+	if (err < 0)
+		return err;
+
+	return peeloff.sd;
+}
-- 
2.14.3

