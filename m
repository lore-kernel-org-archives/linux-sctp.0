From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 30 May 2018 17:18:02 +0000
Subject: [PATCH lksctp-tools 11/12] build: add two defines for Partial Delivery extensions on sctp_pdapi_even
Message-Id: <40436869dc3b94ac89eebbb83767684b67694965.1527700680.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

HAVE_SCTP_PDAPI_EVENT_PDAPI_STREAM and HAVE_SCTP_PDAPI_EVENT_PDAPI_SEQ, for
sctp_pdapi_event.pdapi_stream and sctp_pdapi_event.pdapi_seq respectively.

Both fields were added together, but I couldn't find 1 name that describes
both at once and makes sense.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 configure.ac                  | 6 ++++++
 src/include/netinet/sctp.h.in | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/configure.ac b/configure.ac
index 1558579a385b87bf5afc76cd2548e0c51628d708..4cdc1339a19a9e2d17ee5a133a3d0f532539118c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -89,6 +89,12 @@ LKSCTP_CHECK_DECL([SCTP_RECONFIG_SUPPORTED], [HAVE_SCTP_STREAM_RECONFIG])
 # sctp_peeloff_flags was added on v4.13, 2cb5c8e378d1
 LKSCTP_CHECK_TYPE([sctp_peeloff_flags_arg_t], [HAVE_SCTP_PEELOFF_FLAGS])
 
+# New members to sctp_pdapi_event, added on v4.16, 65f5e357839e
+LKSCTP_CHECK_MEMBER([struct sctp_pdapi_event.pdapi_stream],
+		    [HAVE_SCTP_PDAPI_EVENT_PDAPI_STREAM])
+LKSCTP_CHECK_MEMBER([struct sctp_pdapi_event.pdapi_seq],
+		    [HAVE_SCTP_PDAPI_EVENT_PDAPI_SEQ])
+
 AC_CONFIG_HEADERS([src/include/netinet/sctp.h])
 AC_CONFIG_FILES([lksctp-tools.spec
 		Makefile
diff --git a/src/include/netinet/sctp.h.in b/src/include/netinet/sctp.h.in
index 0c856a837c08a8768ab6f4d5c81c1c3cce1d4378..04932a6474bddfe4af7cbc1de0c4ab501a2d31c5 100644
--- a/src/include/netinet/sctp.h.in
+++ b/src/include/netinet/sctp.h.in
@@ -65,6 +65,8 @@ extern "C" {
 #undef HAVE_SCTP_STREAM_CHANGE_EVENT
 #undef HAVE_SCTP_STREAM_RECONFIG
 #undef HAVE_SCTP_PEELOFF_FLAGS
+#undef HAVE_SCTP_PDAPI_EVENT_PDAPI_STREAM
+#undef HAVE_SCTP_PDAPI_EVENT_PDAPI_SEQ
 
 int sctp_bindx(int sd, struct sockaddr *addrs, int addrcnt, int flags);
 
-- 
2.14.3

