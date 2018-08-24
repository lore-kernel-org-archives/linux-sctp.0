From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 24 Aug 2018 12:52:58 +0000
Subject: [PATCH 1/3] build: remove v4.12 secondary defines in favor of HAVE_SCTP_STREAM_RECONFIG
Message-Id: <3ef2bea46414f3b9659e87351e41d9de90efe5e2.1535062650.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

These were backups, commented out since beginning.
HAVE_SCTP_STREAM_RECONFIG is enough to identify that these are there, so
lets use only one.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 configure.ac                  | 8 --------
 src/include/netinet/sctp.h.in | 2 --
 2 files changed, 10 deletions(-)

diff --git a/configure.ac b/configure.ac
index 2ae36ec9237391266c8f0b92852421962e1b5fa4..dad658c04c946ff30b6df1a739750f0929238907 100644
--- a/configure.ac
+++ b/configure.ac
@@ -82,14 +82,6 @@ AC_CHECK_FUNCS([bzero gethostbyname gettimeofday memmove memset select socket \
 LKSCTP_CHECK_MEMBER([struct sctp_event_subscribe.sctp_stream_reset_event],
 		    [HAVE_SCTP_STREAM_RESET_EVENT])
 
-# Support for assoc reset event, added on v4.12, c95129d127c6
-#LKSCTP_CHECK_MEMBER([struct sctp_event_subscribe.sctp_assoc_reset_event], \
-#		    [HAVE_SCTP_ASSOC_RESET_EVENT])
-
-# Support for stream change event, added on v4.12, b444153fb5a6
-#LKSCTP_CHECK_MEMBER([struct sctp_event_subscribe.sctp_stream_change_event], \
-#		    [HAVE_SCTP_STREAM_CHANGE_EVENT])
-
 # RFC 6525 (Stream Reconf), finished on v4.12, c0d8bab6ae51
 LKSCTP_CHECK_DECL([SCTP_RECONFIG_SUPPORTED], [HAVE_SCTP_STREAM_RECONFIG])
 
diff --git a/src/include/netinet/sctp.h.in b/src/include/netinet/sctp.h.in
index c04907768966e2706882978475bf6fd042cefaa0..2009f1c920cf24f3b0e88c46409ac02bd43c066a 100644
--- a/src/include/netinet/sctp.h.in
+++ b/src/include/netinet/sctp.h.in
@@ -61,8 +61,6 @@ extern "C" {
 #define HAVE_SCTP_CANSET_PRIMARY
 
 #undef HAVE_SCTP_STREAM_RESET_EVENT
-#undef HAVE_SCTP_ASSOC_RESET_EVENT
-#undef HAVE_SCTP_STREAM_CHANGE_EVENT
 #undef HAVE_SCTP_STREAM_RECONFIG
 #undef HAVE_SCTP_PEELOFF_FLAGS
 #undef HAVE_SCTP_PDAPI_EVENT_PDAPI_STREAM
-- 
2.17.1
