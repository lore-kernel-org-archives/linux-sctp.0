From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 15 Jan 2010 03:47:20 +0000
Subject: sctp: move chunk from retransmit queue to abandoned list
Message-Id: <4B4FE548.9070705@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

If there is still data waiting to retransmit and remain in
retransmit queue, while doing the next retransmit, if the
chunk is abandoned, we should move it to abandoned list.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/outqueue.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 229690f..8092032 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -390,6 +390,18 @@ void sctp_retransmit_mark(struct sctp_outq *q,
 	struct list_head *lchunk, *ltemp;
 	struct sctp_chunk *chunk;
 
+	/* Walk through the retransmit queue */
+	list_for_each_safe(lchunk, ltemp, &q->retransmit) {
+		chunk = list_entry(lchunk, struct sctp_chunk,
+				   transmitted_list);
+
+		/* If the chunk is abandoned, move it to abandoned list. */
+		if (sctp_chunk_abandoned(chunk)) {
+			list_del_init(lchunk);
+			sctp_insert_list(&q->abandoned, lchunk);
+		}
+	}
+
 	/* Walk through the specified transmitted queue.  */
 	list_for_each_safe(lchunk, ltemp, &transport->transmitted) {
 		chunk = list_entry(lchunk, struct sctp_chunk,
-- 
1.6.2.2


