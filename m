From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 30 May 2018 17:17:59 +0000
Subject: [PATCH lksctp-tools 08/12] build: add define HAVE_SCTP_STREAM_CHANGE_EVENT
Message-Id: <195c4b6238779d8356d7fa9cd745951c85b9bf4b.1527700680.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Add define to indicate if struct sctp_event_subscribe has the field
sctp_stream_change_event. (it was added on a different kernel version than
sctp_assoc_reset_event)

Note that struct sctp_event_subscribe is defined on kernel UAPI header.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 configure.ac                  | 4 ++++
 src/include/netinet/sctp.h.in | 1 +
 2 files changed, 5 insertions(+)

diff --git a/configure.ac b/configure.ac
index 76c893bcd509bb207a64bd2506d08540a966b7be..1099c34fc2f7dacec2aef79a7301f6a5f63c533b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -79,6 +79,10 @@ LKSCTP_CHECK_MEMBER([struct sctp_event_subscribe.sctp_stream_reset_event],
 #LKSCTP_CHECK_MEMBER([struct sctp_event_subscribe.sctp_assoc_reset_event], \
 #		    [HAVE_SCTP_ASSOC_RESET_EVENT])
 
+# Support for stream change event, added on v4.12, b444153fb5a6
+#LKSCTP_CHECK_MEMBER([struct sctp_event_subscribe.sctp_stream_change_event], \
+#		    [HAVE_SCTP_STREAM_CHANGE_EVENT])
+
 AC_CONFIG_HEADERS([src/include/netinet/sctp.h])
 AC_CONFIG_FILES([lksctp-tools.spec
 		Makefile
diff --git a/src/include/netinet/sctp.h.in b/src/include/netinet/sctp.h.in
index d4f819c690f7704629a4ad59448a32ac3d436ad8..2879c163f808cdb4c2bec6c1b91bd0b5b70a762c 100644
--- a/src/include/netinet/sctp.h.in
+++ b/src/include/netinet/sctp.h.in
@@ -62,6 +62,7 @@ extern "C" {
 
 #undef HAVE_SCTP_STREAM_RESET_EVENT
 #undef HAVE_SCTP_ASSOC_RESET_EVENT
+#undef HAVE_SCTP_STREAM_CHANGE_EVENT
 
 int sctp_bindx(int sd, struct sockaddr *addrs, int addrcnt, int flags);
 
-- 
2.14.3

