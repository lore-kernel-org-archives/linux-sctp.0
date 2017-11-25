From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 25 Nov 2017 13:05:35 +0000
Subject: [PATCH net 4/5] sctp: avoid flushing unsent queue when doing asoc reset
Message-Id: <01a98a157b28c058568ccb7b9909e990e7ac7744.1511614961.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1511614961.git.lucien.xin@gmail.com>
 <feb3ee6070cc0f526210fa36752148c0e0704bcf.1511614961.git.lucien.xin@gmail.com>
 <a7c048ec66b002ffa49e91e11b8f363232e238c5.1511614961.git.lucien.xin@gmail.com>
 <49b01e67e4cc1f8a0be85ffefdee51dad6ae3286.1511614961.git.lucien.xin@gmail.com>
In-Reply-To: <49b01e67e4cc1f8a0be85ffefdee51dad6ae3286.1511614961.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Now when doing asoc reset, it cleans up sacked and abandoned queues
by calling sctp_outq_free where it also cleans up unsent, retransmit
and transmitted queues.

It's safe for the sender of response, as these 3 queues are empty at
that time. But when the receiver of response is doing the reset, the
users may already enqueue some chunks into unsent during the time
waiting the response, and these chunks should not be flushed.

To void the chunks in it would be removed, it moves the queue into a
temp list, then gets it back after sctp_outq_free is done.

The patch also fixes some incorrect comments in
sctp_process_strreset_tsnreq.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index f3b7d27..9dd5bfe 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -747,9 +747,10 @@ struct sctp_chunk *sctp_process_strreset_tsnreq(
 		goto out;
 	}
 
-	/* G3: The same processing as though a SACK chunk with no gap report
-	 *     and a cumulative TSN ACK of the Sender's Next TSN minus 1 were
-	 *     received MUST be performed.
+	/* G4: The same processing as though a FWD-TSN chunk (as defined in
+	 *     [RFC3758]) with all streams affected and a new cumulative TSN
+	 *     ACK of the Receiver's Next TSN minus 1 were received MUST be
+	 *     performed.
 	 */
 	max_tsn_seen = sctp_tsnmap_get_max_tsn_seen(&asoc->peer.tsn_map);
 	sctp_ulpq_reasm_flushtsn(&asoc->ulpq, max_tsn_seen);
@@ -764,10 +765,9 @@ struct sctp_chunk *sctp_process_strreset_tsnreq(
 	sctp_tsnmap_init(&asoc->peer.tsn_map, SCTP_TSN_MAP_INITIAL,
 			 init_tsn, GFP_ATOMIC);
 
-	/* G4: The same processing as though a FWD-TSN chunk (as defined in
-	 *     [RFC3758]) with all streams affected and a new cumulative TSN
-	 *     ACK of the Receiver's Next TSN minus 1 were received MUST be
-	 *     performed.
+	/* G3: The same processing as though a SACK chunk with no gap report
+	 *     and a cumulative TSN ACK of the Sender's Next TSN minus 1 were
+	 *     received MUST be performed.
 	 */
 	sctp_outq_free(&asoc->outqueue);
 
@@ -1021,6 +1021,7 @@ struct sctp_chunk *sctp_process_strreset_resp(
 		if (result = SCTP_STRRESET_PERFORMED) {
 			__u32 mtsn = sctp_tsnmap_get_max_tsn_seen(
 						&asoc->peer.tsn_map);
+			LIST_HEAD(temp);
 
 			sctp_ulpq_reasm_flushtsn(&asoc->ulpq, mtsn);
 			sctp_ulpq_abort_pd(&asoc->ulpq, GFP_ATOMIC);
@@ -1029,7 +1030,13 @@ struct sctp_chunk *sctp_process_strreset_resp(
 					 SCTP_TSN_MAP_INITIAL,
 					 stsn, GFP_ATOMIC);
 
+			/* Clean up sacked and abandoned queues only. As the
+			 * out_chunk_list may not be empty, splice it to temp,
+			 * then get it back after sctp_outq_free is done.
+			 */
+			list_splice_init(&asoc->outqueue.out_chunk_list, &temp);
 			sctp_outq_free(&asoc->outqueue);
+			list_splice_init(&temp, &asoc->outqueue.out_chunk_list);
 
 			asoc->next_tsn = rtsn;
 			asoc->ctsn_ack_point = asoc->next_tsn - 1;
-- 
2.1.0

