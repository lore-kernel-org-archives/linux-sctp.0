From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 18 Dec 2017 06:07:25 +0000
Subject: [PATCH net] sctp: fix the issue that a __u16 variable may overflow in sctp_ulpq_renege
Message-Id: <047a7d68a197ff748b48eb8cda4b08fd5b9623fe.1513577245.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Now when reneging events in sctp_ulpq_renege(), the variable freed
could be increased by a __u16 value twice while freed is of __u16
type. It means freed may overflow at the second addition.

This patch is to fix it by using __u32 type for 'freed', while at
it, also to remove 'if (chunk)' check, as all renege commands are
generated in sctp_eat_data and it can't be NULL.

Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/ulpqueue.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index a71be33..e36ec5d 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -1084,29 +1084,21 @@ void sctp_ulpq_partial_delivery(struct sctp_ulpq *ulpq,
 void sctp_ulpq_renege(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk,
 		      gfp_t gfp)
 {
-	struct sctp_association *asoc;
-	__u16 needed, freed;
-
-	asoc = ulpq->asoc;
+	struct sctp_association *asoc = ulpq->asoc;
+	__u32 freed = 0;
+	__u16 needed;
 
-	if (chunk) {
-		needed = ntohs(chunk->chunk_hdr->length);
-		needed -= sizeof(struct sctp_data_chunk);
-	} else
-		needed = SCTP_DEFAULT_MAXWINDOW;
-
-	freed = 0;
+	needed = ntohs(chunk->chunk_hdr->length) -
+		 sizeof(struct sctp_data_chunk);
 
 	if (skb_queue_empty(&asoc->base.sk->sk_receive_queue)) {
 		freed = sctp_ulpq_renege_order(ulpq, needed);
-		if (freed < needed) {
+		if (freed < needed)
 			freed += sctp_ulpq_renege_frags(ulpq, needed - freed);
-		}
 	}
 	/* If able to free enough room, accept this chunk. */
-	if (chunk && (freed >= needed)) {
-		int retval;
-		retval = sctp_ulpq_tail_data(ulpq, chunk, gfp);
+	if (freed >= needed) {
+		int retval = sctp_ulpq_tail_data(ulpq, chunk, gfp);
 		/*
 		 * Enter partial delivery if chunk has not been
 		 * delivered; otherwise, drain the reassembly queue.
-- 
2.1.0

