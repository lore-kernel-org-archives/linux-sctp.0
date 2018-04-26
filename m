From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Apr 2018 19:58:50 +0000
Subject: [PATCH net-next 01/13] sctp: remove old and unused SCTP_MIN_PMTU
Message-Id: <3959797f9a87225ae154a9d3f81cae4fd10f01a1.1524772453.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1524772453.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1524772453.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>

This value is not used anywhere in the code. In essence it is a
duplicate of SCTP_DEFAULT_MINSEGMENT, which is used by the stack.

SCTP_MIN_PMTU value makes more sense, but we should not change to it now
as it would risk breaking applications.

So this patch removes SCTP_MIN_PMTU and adjust the comment above it.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/net/sctp/constants.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 20ff237c5eb2ff358589b30bbd89d636e41b2d92..86f034b524d46178e4d26e868be3a2bf87acac4a 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -254,11 +254,10 @@ enum { SCTP_ARBITRARY_COOKIE_ECHO_LEN = 200 };
 #define SCTP_TSN_MAP_SIZE 4096
 
 /* We will not record more than this many duplicate TSNs between two
- * SACKs.  The minimum PMTU is 576.  Remove all the headers and there
- * is enough room for 131 duplicate reports.  Round down to the
+ * SACKs.  The minimum PMTU is 512.  Remove all the headers and there
+ * is enough room for 117 duplicate reports.  Round down to the
  * nearest power of 2.
  */
-enum { SCTP_MIN_PMTU = 576 };
 enum { SCTP_MAX_DUP_TSNS = 16 };
 enum { SCTP_MAX_GABS = 16 };
 
-- 
2.14.3

