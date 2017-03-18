From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 18 Mar 2017 12:03:59 +0000
Subject: [PATCH net] sctp: out_qlen should be updated when pruning unsent queue
Message-Id: <16cb6e6d2ef47481123bc3ff1b99e8abf5334d14.1489838639.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

This patch is to fix the issue that sctp_prsctp_prune_sent forgot
to update q->out_qlen when removing a chunk from unsent queue.

Fixes: 8dbdf1f5b09c ("sctp: implement prsctp PRIO policy")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/outqueue.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index db352e5..025ccff 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -382,17 +382,18 @@ static int sctp_prsctp_prune_sent(struct sctp_association *asoc,
 }
 
 static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
-				    struct sctp_sndrcvinfo *sinfo,
-				    struct list_head *queue, int msg_len)
+				    struct sctp_sndrcvinfo *sinfo, int msg_len)
 {
+	struct sctp_outq *q = &asoc->outqueue;
 	struct sctp_chunk *chk, *temp;
 
-	list_for_each_entry_safe(chk, temp, queue, list) {
+	list_for_each_entry_safe(chk, temp, &q->out_chunk_list, list) {
 		if (!SCTP_PR_PRIO_ENABLED(chk->sinfo.sinfo_flags) ||
 		    chk->sinfo.sinfo_timetolive <= sinfo->sinfo_timetolive)
 			continue;
 
 		list_del_init(&chk->list);
+		q->out_qlen -= chk->skb->len;
 		asoc->sent_cnt_removable--;
 		asoc->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
 
@@ -431,9 +432,7 @@ void sctp_prsctp_prune(struct sctp_association *asoc,
 			return;
 	}
 
-	sctp_prsctp_prune_unsent(asoc, sinfo,
-				 &asoc->outqueue.out_chunk_list,
-				 msg_len);
+	sctp_prsctp_prune_unsent(asoc, sinfo, msg_len);
 }
 
 /* Mark all the eligible packets on a transport for retransmission.  */
-- 
2.1.0

