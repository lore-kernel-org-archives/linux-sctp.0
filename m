From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 30 May 2018 17:17:58 +0000
Subject: [PATCH lksctp-tools 07/12] build: add define HAVE_SCTP_ASSOC_RESET_EVENT
Message-Id: <79f559e14bcbe89975dc9e882b95e23cfcc00cc7.1527700680.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Add define to indicate if struct sctp_event_subscribe has the field
sctp_assoc_reset_event. (it was added on a different kernel version than
sctp_stream_reset_event)

Note that struct sctp_event_subscribe is defined on kernel UAPI header.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 configure.ac                  | 4 ++++
 src/include/netinet/sctp.h.in | 1 +
 2 files changed, 5 insertions(+)

diff --git a/configure.ac b/configure.ac
index 8bb2a892328e995a39744fa3f2b8e76d3082b638..76c893bcd509bb207a64bd2506d08540a966b7be 100644
--- a/configure.ac
+++ b/configure.ac
@@ -75,6 +75,10 @@ AC_CHECK_FUNCS([bzero gethostbyname gettimeofday memmove memset select socket \
 LKSCTP_CHECK_MEMBER([struct sctp_event_subscribe.sctp_stream_reset_event],
 		    [HAVE_SCTP_STREAM_RESET_EVENT])
 
+# Support for assoc reset event, added on v4.12, c95129d127c6
+#LKSCTP_CHECK_MEMBER([struct sctp_event_subscribe.sctp_assoc_reset_event], \
+#		    [HAVE_SCTP_ASSOC_RESET_EVENT])
+
 AC_CONFIG_HEADERS([src/include/netinet/sctp.h])
 AC_CONFIG_FILES([lksctp-tools.spec
 		Makefile
diff --git a/src/include/netinet/sctp.h.in b/src/include/netinet/sctp.h.in
index 42f7ce02416467978c2d750b3dae154f47e665b5..d4f819c690f7704629a4ad59448a32ac3d436ad8 100644
--- a/src/include/netinet/sctp.h.in
+++ b/src/include/netinet/sctp.h.in
@@ -61,6 +61,7 @@ extern "C" {
 #define HAVE_SCTP_CANSET_PRIMARY
 
 #undef HAVE_SCTP_STREAM_RESET_EVENT
+#undef HAVE_SCTP_ASSOC_RESET_EVENT
 
 int sctp_bindx(int sd, struct sockaddr *addrs, int addrcnt, int flags);
 
-- 
2.14.3

