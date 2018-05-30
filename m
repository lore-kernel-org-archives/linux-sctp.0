From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 30 May 2018 17:17:57 +0000
Subject: [PATCH lksctp-tools 06/12] build: add define HAVE_SCTP_STREAM_RESET_EVENT
Message-Id: <071e8cbeb547afcaff28c9eaeaa3afaeb405ee84.1527700680.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Add define to indicate if struct sctp_event_subscribe has the field
sctp_stream_reset_event.

Note that struct sctp_event_subscribe is defined on kernel UAPI header.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 configure.ac                  | 4 ++++
 src/include/netinet/sctp.h.in | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/configure.ac b/configure.ac
index 9598bc83579299b1b1e68bd49cac407e3a0713fb..8bb2a892328e995a39744fa3f2b8e76d3082b638 100644
--- a/configure.ac
+++ b/configure.ac
@@ -71,6 +71,10 @@ AC_FUNC_VPRINTF
 AC_CHECK_FUNCS([bzero gethostbyname gettimeofday memmove memset select socket \
 		strchr strerror strtol strtoul])
 
+# Support for stream reset even, added on v4.11, 35ea82d611da
+LKSCTP_CHECK_MEMBER([struct sctp_event_subscribe.sctp_stream_reset_event],
+		    [HAVE_SCTP_STREAM_RESET_EVENT])
+
 AC_CONFIG_HEADERS([src/include/netinet/sctp.h])
 AC_CONFIG_FILES([lksctp-tools.spec
 		Makefile
diff --git a/src/include/netinet/sctp.h.in b/src/include/netinet/sctp.h.in
index 701f0913aafd91f6a93661700495d40c0c7ec5ec..42f7ce02416467978c2d750b3dae154f47e665b5 100644
--- a/src/include/netinet/sctp.h.in
+++ b/src/include/netinet/sctp.h.in
@@ -60,6 +60,8 @@ extern "C" {
 #define HAVE_SCTP_ADDIP
 #define HAVE_SCTP_CANSET_PRIMARY
 
+#undef HAVE_SCTP_STREAM_RESET_EVENT
+
 int sctp_bindx(int sd, struct sockaddr *addrs, int addrcnt, int flags);
 
 int sctp_connectx(int sd, struct sockaddr *addrs, int addrcnt,
-- 
2.14.3

