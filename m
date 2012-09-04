From: Wei Yongjun <weiyj.lk@gmail.com>
Date: Tue, 04 Sep 2012 09:58:16 +0000
Subject: [PATCH] sctp: use list_move_tail instead of list_del/list_add_tail
Message-Id: <CAPgLHd_w3-iAT66PW2i_jYyqmNrF-fKczcUEdBemPMvWX+fbOQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, sri@us.ibm.com, davem@davemloft.net
Cc: yongjun_wei@trendmicro.com.cn, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 net/sctp/outqueue.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index e7aa177c..d10cbf1 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -589,9 +589,8 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 		 * next chunk.
 		 */
 		if (chunk->tsn_gap_acked) {
-			list_del(&chunk->transmitted_list);
-			list_add_tail(&chunk->transmitted_list,
-					&transport->transmitted);
+			list_move_tail(&chunk->transmitted_list,
+				       &transport->transmitted);
 			continue;
 		}
 
@@ -655,9 +654,8 @@ redo:
 			/* The append was successful, so add this chunk to
 			 * the transmitted list.
 			 */
-			list_del(&chunk->transmitted_list);
-			list_add_tail(&chunk->transmitted_list,
-					&transport->transmitted);
+			list_move_tail(&chunk->transmitted_list,
+				       &transport->transmitted);
 
 			/* Mark the chunk as ineligible for fast retransmit
 			 * after it is retransmitted.


