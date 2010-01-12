From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 12 Jan 2010 08:17:45 +0000
Subject: [PATCH] sctp: discard ABORT chunk with zero verification tag in COOKIE-WAIT
Message-Id: <4B4C3029.1030700@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

In current implementation if ABORT chunk is received with T flag is set
and zero verification tag in COOKIE-WAIT state, the ABORT chunk will be
always accepted. This is because in COOKIE-WAIT state, the endpoint does
not know the peer's verification tag, and it's zero in the endpoint.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/sm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index 851c813..273a8bb 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -437,7 +437,7 @@ sctp_vtag_verify_either(const struct sctp_chunk *chunk,
 	 */
         if ((!sctp_test_T_bit(chunk) &&
              (ntohl(chunk->sctp_hdr->vtag) = asoc->c.my_vtag)) ||
-	    (sctp_test_T_bit(chunk) &&
+	    (sctp_test_T_bit(chunk) && asoc->c.peer_vtag &&
 	     (ntohl(chunk->sctp_hdr->vtag) = asoc->c.peer_vtag))) {
                 return 1;
 	}
-- 
1.6.2.2


