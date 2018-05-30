From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 30 May 2018 17:18:00 +0000
Subject: [PATCH lksctp-tools 09/12] build: add define HAVE_SCTP_STREAM_RECONFIG
Message-Id: <539de0eb43fa18f7d781878d89c97922003980aa.1527700680.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This is to indicate that applications can use Stream Reconfig, even though
the library doesn't provide any helpers on it at the moment.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 configure.ac                  | 3 +++
 src/include/netinet/sctp.h.in | 1 +
 2 files changed, 4 insertions(+)

diff --git a/configure.ac b/configure.ac
index 1099c34fc2f7dacec2aef79a7301f6a5f63c533b..daf14e398c6282cbbe56ba8c99abb9c0fc230d83 100644
--- a/configure.ac
+++ b/configure.ac
@@ -83,6 +83,9 @@ LKSCTP_CHECK_MEMBER([struct sctp_event_subscribe.sctp_stream_reset_event],
 #LKSCTP_CHECK_MEMBER([struct sctp_event_subscribe.sctp_stream_change_event], \
 #		    [HAVE_SCTP_STREAM_CHANGE_EVENT])
 
+# RFC 6525 (Stream Reconf), finished on v4.12, c0d8bab6ae51
+LKSCTP_CHECK_DECL([SCTP_RECONFIG_SUPPORTED], [HAVE_SCTP_STREAM_RECONFIG])
+
 AC_CONFIG_HEADERS([src/include/netinet/sctp.h])
 AC_CONFIG_FILES([lksctp-tools.spec
 		Makefile
diff --git a/src/include/netinet/sctp.h.in b/src/include/netinet/sctp.h.in
index 2879c163f808cdb4c2bec6c1b91bd0b5b70a762c..31750811ad601444f1cf13e64229ba4ac9a1c379 100644
--- a/src/include/netinet/sctp.h.in
+++ b/src/include/netinet/sctp.h.in
@@ -63,6 +63,7 @@ extern "C" {
 #undef HAVE_SCTP_STREAM_RESET_EVENT
 #undef HAVE_SCTP_ASSOC_RESET_EVENT
 #undef HAVE_SCTP_STREAM_CHANGE_EVENT
+#undef HAVE_SCTP_STREAM_RECONFIG
 
 int sctp_bindx(int sd, struct sockaddr *addrs, int addrcnt, int flags);
 
-- 
2.14.3

