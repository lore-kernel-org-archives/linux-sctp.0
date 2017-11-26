From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 26 Nov 2017 12:56:07 +0000
Subject: [PATCH net] sctp: use right member as the param of list_for_each_entry
Message-Id: <4c3e5049eae1f90d5b74588fa0e115393a173056.1511700966.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Commit d04adf1b3551 ("sctp: reset owner sk for data chunks on out queues
when migrating a sock") made a mistake that using 'list' as the param of
list_for_each_entry to traverse the retransmit, sacked and abandoned
queues, while chunks are using 'transmitted_list' to link into these
queues.

It could cause NULL dereference panic if there are chunks in any of these
queues when peeling off one asoc.

So use the chunk member 'transmitted_list' instead in this patch.

Fixes: d04adf1b3551 ("sctp: reset owner sk for data chunks on out queues when migrating a sock")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 3204a9b..014847e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -188,13 +188,13 @@ static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
 		list_for_each_entry(chunk, &t->transmitted, transmitted_list)
 			cb(chunk);
 
-	list_for_each_entry(chunk, &q->retransmit, list)
+	list_for_each_entry(chunk, &q->retransmit, transmitted_list)
 		cb(chunk);
 
-	list_for_each_entry(chunk, &q->sacked, list)
+	list_for_each_entry(chunk, &q->sacked, transmitted_list)
 		cb(chunk);
 
-	list_for_each_entry(chunk, &q->abandoned, list)
+	list_for_each_entry(chunk, &q->abandoned, transmitted_list)
 		cb(chunk);
 
 	list_for_each_entry(chunk, &q->out_chunk_list, list)
-- 
2.1.0

