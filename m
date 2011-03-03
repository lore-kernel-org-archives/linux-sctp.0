From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 03 Mar 2011 09:29:39 +0000
Subject: [PATCH] sctp: fix the fast retransmit limit
Message-Id: <4D6F5F83.705@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>, Vlad Yasevich <vladislav.yasevich@hp.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, lksctp <linux-sctp@vger.kernel.org>
Cc: Mingyuan Zhu <liyha.zhu@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

If chunk is still lost after fast retransmit, SCTP stack will
never allow the second fast retransmit of this chunk, even if
the peer need we do this. This chunk will be retransmit until
the rtx timeout. This limit is introduce by the following patch:
  sctp: reduce memory footprint of sctp_chunk structure
  (c226ef9b83694311327f3ab0036c6de9c22e9daf)

This patch revert this limit and removed useless SCTP_DONT_FRTX.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/structs.h |    1 -
 net/sctp/outqueue.c        |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index cc9185c..82a0f84 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -751,7 +751,6 @@ struct sctp_chunk {
 
 #define SCTP_CAN_FRTX 0x0
 #define SCTP_NEED_FRTX 0x1
-#define SCTP_DONT_FRTX 0x2
 	__u16	rtt_in_progress:1,	/* This chunk used for RTT calc? */
 		has_tsn:1,		/* Does this chunk have a TSN yet? */
 		has_ssn:1,		/* Does this chunk have a SSN yet? */
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 8c6d379..7ed5862 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -657,7 +657,7 @@ redo:
 			 * after it is retransmitted.
 			 */
 			if (chunk->fast_retransmit = SCTP_NEED_FRTX)
-				chunk->fast_retransmit = SCTP_DONT_FRTX;
+				chunk->fast_retransmit = SCTP_CAN_FRTX;
 
 			q->empty = 0;
 			break;
@@ -679,7 +679,7 @@ redo:
 	if (rtx_timeout || fast_rtx) {
 		list_for_each_entry(chunk1, lqueue, transmitted_list) {
 			if (chunk1->fast_retransmit = SCTP_NEED_FRTX)
-				chunk1->fast_retransmit = SCTP_DONT_FRTX;
+				chunk1->fast_retransmit = SCTP_CAN_FRTX;
 		}
 	}
 
-- 
1.6.5.2


