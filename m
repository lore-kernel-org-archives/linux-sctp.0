From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 14 Dec 2017 16:41:26 +0000
Subject: [PATCHv2 net-next 2/8] sctp: implement generate_ftsn for sctp_stream_interleave
Message-Id: <5982a46414cdea7856ee17683c5a714b411c7eb4.1513269224.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1513269224.git.lucien.xin@gmail.com>
 <3f8811d3daf19089f75ec75afbca8b397680b6e6.1513269224.git.lucien.xin@gmail.com>
In-Reply-To: <3f8811d3daf19089f75ec75afbca8b397680b6e6.1513269224.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

generate_ftsn is added as a member of sctp_stream_interleave, used to
create fwdtsn or ifwdtsn chunk according to abandoned chunks, called
in sctp_retransmit and sctp_outq_sack.

sctp_generate_iftsn works for ifwdtsn, and sctp_generate_fwdtsn is
still used for making fwdtsn.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/stream_interleave.h |  2 +
 include/net/sctp/structs.h           |  1 +
 net/sctp/outqueue.c                  | 12 +++---
 net/sctp/stream_interleave.c         | 75 ++++++++++++++++++++++++++++++++++++
 4 files changed, 84 insertions(+), 6 deletions(-)

diff --git a/include/net/sctp/stream_interleave.h b/include/net/sctp/stream_interleave.h
index 501b2be..66267db 100644
--- a/include/net/sctp/stream_interleave.h
+++ b/include/net/sctp/stream_interleave.h
@@ -47,6 +47,8 @@ struct sctp_stream_interleave {
 				 struct sctp_chunk *chunk, gfp_t gfp);
 	void	(*start_pd)(struct sctp_ulpq *ulpq, gfp_t gfp);
 	void	(*abort_pd)(struct sctp_ulpq *ulpq, gfp_t gfp);
+	/* (I-)FORWARD-TSN process */
+	void	(*generate_ftsn)(struct sctp_outq *q, __u32 ctsn);
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index a5c3cf4..b7720d6 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1100,6 +1100,7 @@ void sctp_retransmit_mark(struct sctp_outq *, struct sctp_transport *, __u8);
 void sctp_outq_uncork(struct sctp_outq *, gfp_t gfp);
 void sctp_prsctp_prune(struct sctp_association *asoc,
 		       struct sctp_sndrcvinfo *sinfo, int msg_len);
+void sctp_generate_fwdtsn(struct sctp_outq *q, __u32 sack_ctsn);
 /* Uncork and flush an outqueue.  */
 static inline void sctp_outq_cork(struct sctp_outq *q)
 {
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 7d67fee..af9b5eb 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -67,8 +67,6 @@ static void sctp_mark_missing(struct sctp_outq *q,
 			      __u32 highest_new_tsn,
 			      int count_of_newacks);
 
-static void sctp_generate_fwdtsn(struct sctp_outq *q, __u32 sack_ctsn);
-
 static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp);
 
 /* Add data to the front of the queue. */
@@ -591,7 +589,7 @@ void sctp_retransmit(struct sctp_outq *q, struct sctp_transport *transport,
 	 * following the procedures outlined in C1 - C5.
 	 */
 	if (reason = SCTP_RTXR_T3_RTX)
-		sctp_generate_fwdtsn(q, q->asoc->ctsn_ack_point);
+		q->asoc->stream.si->generate_ftsn(q, q->asoc->ctsn_ack_point);
 
 	/* Flush the queues only on timeout, since fast_rtx is only
 	 * triggered during sack processing and the queue
@@ -942,6 +940,7 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 		case SCTP_CID_ECN_ECNE:
 		case SCTP_CID_ASCONF:
 		case SCTP_CID_FWD_TSN:
+		case SCTP_CID_I_FWD_TSN:
 		case SCTP_CID_RECONF:
 			status = sctp_packet_transmit_chunk(packet, chunk,
 							    one_packet, gfp);
@@ -956,7 +955,8 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 			 * sender MUST assure that at least one T3-rtx
 			 * timer is running.
 			 */
-			if (chunk->chunk_hdr->type = SCTP_CID_FWD_TSN) {
+			if (chunk->chunk_hdr->type = SCTP_CID_FWD_TSN ||
+			    chunk->chunk_hdr->type = SCTP_CID_I_FWD_TSN) {
 				sctp_transport_reset_t3_rtx(transport);
 				transport->last_time_sent = jiffies;
 			}
@@ -1372,7 +1372,7 @@ int sctp_outq_sack(struct sctp_outq *q, struct sctp_chunk *chunk)
 
 	asoc->peer.rwnd = sack_a_rwnd;
 
-	sctp_generate_fwdtsn(q, sack_ctsn);
+	asoc->stream.si->generate_ftsn(q, sack_ctsn);
 
 	pr_debug("%s: sack cumulative tsn ack:0x%x\n", __func__, sack_ctsn);
 	pr_debug("%s: cumulative tsn ack of assoc:%p is 0x%x, "
@@ -1795,7 +1795,7 @@ static inline int sctp_get_skip_pos(struct sctp_fwdtsn_skip *skiplist,
 }
 
 /* Create and add a fwdtsn chunk to the outq's control queue if needed. */
-static void sctp_generate_fwdtsn(struct sctp_outq *q, __u32 ctsn)
+void sctp_generate_fwdtsn(struct sctp_outq *q, __u32 ctsn)
 {
 	struct sctp_association *asoc = q->asoc;
 	struct sctp_chunk *ftsn_chunk = NULL;
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 87b9417..2ead372 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1082,6 +1082,77 @@ static void sctp_intl_abort_pd(struct sctp_ulpq *ulpq, gfp_t gfp)
 	sctp_ulpq_flush(ulpq);
 }
 
+static inline int sctp_get_skip_pos(struct sctp_ifwdtsn_skip *skiplist,
+				    int nskips, __be16 stream, __u8 flags)
+{
+	int i;
+
+	for (i = 0; i < nskips; i++)
+		if (skiplist[i].stream = stream &&
+		    skiplist[i].flags = flags)
+			return i;
+
+	return i;
+}
+
+#define SCTP_FTSN_U_BIT	0x1
+static void sctp_generate_iftsn(struct sctp_outq *q, __u32 ctsn)
+{
+	struct sctp_ifwdtsn_skip ftsn_skip_arr[10];
+	struct sctp_association *asoc = q->asoc;
+	struct sctp_chunk *ftsn_chunk = NULL;
+	struct list_head *lchunk, *temp;
+	int nskips = 0, skip_pos;
+	struct sctp_chunk *chunk;
+	__u32 tsn;
+
+	if (!asoc->peer.prsctp_capable)
+		return;
+
+	if (TSN_lt(asoc->adv_peer_ack_point, ctsn))
+		asoc->adv_peer_ack_point = ctsn;
+
+	list_for_each_safe(lchunk, temp, &q->abandoned) {
+		chunk = list_entry(lchunk, struct sctp_chunk, transmitted_list);
+		tsn = ntohl(chunk->subh.data_hdr->tsn);
+
+		if (TSN_lte(tsn, ctsn)) {
+			list_del_init(lchunk);
+			sctp_chunk_free(chunk);
+		} else if (TSN_lte(tsn, asoc->adv_peer_ack_point + 1)) {
+			__be16 sid = chunk->subh.idata_hdr->stream;
+			__be32 mid = chunk->subh.idata_hdr->mid;
+			__u8 flags = 0;
+
+			if (chunk->chunk_hdr->flags & SCTP_DATA_UNORDERED)
+				flags |= SCTP_FTSN_U_BIT;
+
+			asoc->adv_peer_ack_point = tsn;
+			skip_pos = sctp_get_skip_pos(&ftsn_skip_arr[0], nskips,
+						     sid, flags);
+			ftsn_skip_arr[skip_pos].stream = sid;
+			ftsn_skip_arr[skip_pos].reserved = 0;
+			ftsn_skip_arr[skip_pos].flags = flags;
+			ftsn_skip_arr[skip_pos].mid = mid;
+			if (skip_pos = nskips)
+				nskips++;
+			if (nskips = 10)
+				break;
+		} else {
+			break;
+		}
+	}
+
+	if (asoc->adv_peer_ack_point > ctsn)
+		ftsn_chunk = sctp_make_ifwdtsn(asoc, asoc->adv_peer_ack_point,
+					       nskips, &ftsn_skip_arr[0]);
+
+	if (ftsn_chunk) {
+		list_add_tail(&ftsn_chunk->list, &q->control_chunk_list);
+		SCTP_INC_STATS(sock_net(asoc->base.sk), SCTP_MIB_OUTCTRLCHUNKS);
+	}
+}
+
 static struct sctp_stream_interleave sctp_stream_interleave_0 = {
 	.data_chunk_len		= sizeof(struct sctp_data_chunk),
 	/* DATA process functions */
@@ -1093,6 +1164,8 @@ static struct sctp_stream_interleave sctp_stream_interleave_0 = {
 	.renege_events		= sctp_ulpq_renege,
 	.start_pd		= sctp_ulpq_partial_delivery,
 	.abort_pd		= sctp_ulpq_abort_pd,
+	/* FORWARD-TSN process functions */
+	.generate_ftsn		= sctp_generate_fwdtsn,
 };
 
 static struct sctp_stream_interleave sctp_stream_interleave_1 = {
@@ -1106,6 +1179,8 @@ static struct sctp_stream_interleave sctp_stream_interleave_1 = {
 	.renege_events		= sctp_renege_events,
 	.start_pd		= sctp_intl_start_pd,
 	.abort_pd		= sctp_intl_abort_pd,
+	/* I-FORWARD-TSN process functions */
+	.generate_ftsn		= sctp_generate_iftsn,
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream)
-- 
2.1.0

