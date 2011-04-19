From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 19 Apr 2011 05:11:01 +0000
Subject: [PATCH net-next-2.6 2/8] sctp: fix the comment of sctp_sf_violation_paramlen()
Message-Id: <4DAD1965.7090100@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DAD18AB.3040401@cn.fujitsu.com>
In-Reply-To: <4DAD18AB.3040401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, lksctp <linux-sctp@vger.kernel.org>

From: Shan Wei <shanwei@cn.fujitsu.com>

Update the comment about sctp_sf_violation_paramlen() to be
more precise.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_statefuns.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 7679208..c085472 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4343,8 +4343,9 @@ static sctp_disposition_t sctp_sf_violation_chunklen(
 
 /*
  * Handle a protocol violation when the parameter length is invalid.
- * "Invalid" length is identified as smaller than the minimal length a
- * given parameter can be.
+ * If the length is smaller than the minimum length of a given parameter,
+ * or accumulated length in multi parameters exceeds the end of the chunk,
+ * the length is considered as invalid.
  */
 static sctp_disposition_t sctp_sf_violation_paramlen(
 				     const struct sctp_endpoint *ep,
-- 
1.6.5.2




