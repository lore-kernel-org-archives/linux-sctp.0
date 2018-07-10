From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 10 Jul 2018 11:07:04 +0000
Subject: [PATCH lksctp-tools 2/2] build: add two defines for Peer Address Parameters extensions on sctp_paddr
Message-Id: <a78e25c78f33ad644df454d214395fbfff23ebc4.1531220086.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

HAVE_SCTP_SPP_IPV6_FLOWLABEL and HAVE_SCTP_SPP_DSCP, for
sctp_paddrparams.spp_ipv6_flowlabel and sctp_paddrparams.spp_dscp
respectively.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 configure.ac                  | 6 ++++++
 src/include/netinet/sctp.h.in | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/configure.ac b/configure.ac
index d4f80f2..b2136b6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -103,6 +103,12 @@ LKSCTP_CHECK_MEMBER([struct sendv_prinfo.sctp_prinfo],
 # added on v4.16, 30f6ebf65bc4
 LKSCTP_CHECK_DECL([SCTP_AUTH_NO_AUTH], [HAVE_SCTP_AUTH_NO_AUTH])
 
+# New members to sctp_paddrparams, added on v4.18, 0b0dce7a36fb
+LKSCTP_CHECK_MEMBER([struct sctp_paddrparams.spp_ipv6_flowlabel],
+		    [HAVE_SCTP_SPP_IPV6_FLOWLABEL])
+LKSCTP_CHECK_MEMBER([struct sctp_paddrparams.spp_dscp],
+		    [HAVE_SCTP_SPP_DSCP])
+
 AC_CONFIG_HEADERS([src/include/netinet/sctp.h])
 AC_CONFIG_FILES([lksctp-tools.spec
 		Makefile
diff --git a/src/include/netinet/sctp.h.in b/src/include/netinet/sctp.h.in
index 0b7ba03..c049077 100644
--- a/src/include/netinet/sctp.h.in
+++ b/src/include/netinet/sctp.h.in
@@ -69,6 +69,8 @@ extern "C" {
 #undef HAVE_SCTP_PDAPI_EVENT_PDAPI_SEQ
 #undef HAVE_SCTP_SENDV
 #undef HAVE_SCTP_AUTH_NO_AUTH
+#undef HAVE_SCTP_SPP_IPV6_FLOWLABEL
+#undef HAVE_SCTP_SPP_DSCP
 
 int sctp_bindx(int sd, struct sockaddr *addrs, int addrcnt, int flags);
 
-- 
2.1.0

