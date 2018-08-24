From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 24 Aug 2018 12:53:00 +0000
Subject: [PATCH 3/3] build: 0b0dce7a36fb actually belongs to v4.19
Message-Id: <08972985460e9c9d7fbd516ad95fa0f40b9cc557.1535062650.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Typo or not, this commit actually belongs to v4.19 and made me wonder why
on v4.18 it didn't find this feature.

Fixes: 817f0bfa248f ("build: add two defines for Peer Address Parameters extensions on sctp_paddrparams")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index f55775af76ff7a464688d21ccfff39fcd1c54451..5de5c763005e1485a38348bf4157b308568b486e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -101,7 +101,7 @@ LKSCTP_CHECK_TYPE([struct sctp_prinfo], [HAVE_SCTP_SENDV])
 # added on v4.16, 30f6ebf65bc4
 LKSCTP_CHECK_DECL([SCTP_AUTH_NO_AUTH], [HAVE_SCTP_AUTH_NO_AUTH])
 
-# New members to sctp_paddrparams, added on v4.18, 0b0dce7a36fb
+# New members to sctp_paddrparams, added on v4.19, 0b0dce7a36fb
 LKSCTP_CHECK_MEMBER([struct sctp_paddrparams.spp_ipv6_flowlabel],
 		    [HAVE_SCTP_SPP_IPV6_FLOWLABEL])
 LKSCTP_CHECK_MEMBER([struct sctp_paddrparams.spp_dscp],
-- 
2.17.1
