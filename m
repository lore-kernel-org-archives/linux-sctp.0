From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 24 Aug 2018 12:52:59 +0000
Subject: [PATCH 2/3] build: fix probing for HAVE_SCTP_SENDV
Message-Id: <a92b9f8a78ab6e74894d944ed76239fd834660f9.1535062650.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Somehow it was using a type that is non-existent. The right one is
sctp_prinfo, introduced on ed63afb8a318 ("sctp: add support for PR-SCTP
Information for sendmsg"), present on v4.17.

Fixes: 1b798f1ca3b5 ("build: add define HAVE_SCTP_AUTH_NO_AUTH")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 configure.ac | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index dad658c04c946ff30b6df1a739750f0929238907..f55775af76ff7a464688d21ccfff39fcd1c54451 100644
--- a/configure.ac
+++ b/configure.ac
@@ -94,9 +94,8 @@ LKSCTP_CHECK_MEMBER([struct sctp_pdapi_event.pdapi_stream],
 LKSCTP_CHECK_MEMBER([struct sctp_pdapi_event.pdapi_seq],
 		    [HAVE_SCTP_PDAPI_EVENT_PDAPI_SEQ])
 
-# PR-SCTP field used to probe for sendv/recvv support, added on v4.17
-LKSCTP_CHECK_MEMBER([struct sendv_prinfo.sctp_prinfo],
-		    [HAVE_SCTP_SENDV])
+# PR-SCTP struct used to probe for sendv/recvv support, added on v4.17
+LKSCTP_CHECK_TYPE([struct sctp_prinfo], [HAVE_SCTP_SENDV])
 
 # This event indicates that the peer does not support SCTP authentication,
 # added on v4.16, 30f6ebf65bc4
-- 
2.17.1
