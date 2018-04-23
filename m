From: Oleg Babin <obabin@virtuozzo.com>
Date: Mon, 23 Apr 2018 18:41:05 +0000
Subject: [PATCH net-next 1/2] net/sctp: Make wrappers for accessing in/out streams
Message-Id: <1524508866-317485-2-git-send-email-obabin@virtuozzo.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1524508866-317485-1-git-send-email-obabin@virtuozzo.com>
In-Reply-To: <1524508866-317485-1-git-send-email-obabin@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org, linux-sctp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

This patch introduces wrappers for accessing in/out streams indirectly.
This will enable to replace physically contiguous memory arrays
of streams with flexible arrays (or maybe any other appropriate
mechanism) which do memory allocation on a per-page basis.

Signed-off-by: Oleg Babin <obabin@virtuozzo.com>
---
 include/net/sctp/structs.h   |  30 +++++++-----
 net/sctp/chunk.c             |   6 ++-
 net/sctp/outqueue.c          |  11 +++--
 net/sctp/socket.c            |   4 +-
 net/sctp/stream.c            | 107 +++++++++++++++++++++++++------------------
 net/sctp/stream_interleave.c |   2 +-
 net/sctp/stream_sched.c      |  13 +++---
 net/sctp/stream_sched_prio.c |  22 ++++-----
 net/sctp/stream_sched_rr.c   |   8 ++--
 9 files changed, 116 insertions(+), 87 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index a0ec462..578bb40 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -394,37 +394,37 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 
 /* What is the current SSN number for this stream? */
 #define sctp_ssn_peek(stream, type, sid) \
-	((stream)->type[sid].ssn)
+	(sctp_stream_##type##_ptr((stream), (sid))->ssn)
 
 /* Return the next SSN number for this stream.	*/
 #define sctp_ssn_next(stream, type, sid) \
-	((stream)->type[sid].ssn++)
+	(sctp_stream_##type##_ptr((stream), (sid))->ssn++)
 
 /* Skip over this ssn and all below. */
 #define sctp_ssn_skip(stream, type, sid, ssn) \
-	((stream)->type[sid].ssn = ssn + 1)
+	(sctp_stream_##type##_ptr((stream), (sid))->ssn = ssn + 1)
 
 /* What is the current MID number for this stream? */
 #define sctp_mid_peek(stream, type, sid) \
-	((stream)->type[sid].mid)
+	(sctp_stream_##type##_ptr((stream), (sid))->mid)
 
 /* Return the next MID number for this stream.  */
 #define sctp_mid_next(stream, type, sid) \
-	((stream)->type[sid].mid++)
+	(sctp_stream_##type##_ptr((stream), (sid))->mid++)
 
 /* Skip over this mid and all below. */
 #define sctp_mid_skip(stream, type, sid, mid) \
-	((stream)->type[sid].mid = mid + 1)
+	(sctp_stream_##type##_ptr((stream), (sid))->mid = mid + 1)
 
-#define sctp_stream_in(asoc, sid) (&(asoc)->stream.in[sid])
+#define sctp_stream_in(asoc, sid) sctp_stream_in_ptr(&(asoc)->stream, (sid))
 
 /* What is the current MID_uo number for this stream? */
 #define sctp_mid_uo_peek(stream, type, sid) \
-	((stream)->type[sid].mid_uo)
+	(sctp_stream_##type##_ptr((stream), (sid))->mid_uo)
 
 /* Return the next MID_uo number for this stream.  */
 #define sctp_mid_uo_next(stream, type, sid) \
-	((stream)->type[sid].mid_uo++)
+	(sctp_stream_##type##_ptr((stream), (sid))->mid_uo++)
 
 /*
  * Pointers to address related SCTP functions.
@@ -1428,8 +1428,8 @@ struct sctp_stream_in {
 };
 
 struct sctp_stream {
-	struct sctp_stream_out *out;
-	struct sctp_stream_in *in;
+	struct flex_array *out;
+	struct flex_array *in;
 	__u16 outcnt;
 	__u16 incnt;
 	/* Current stream being sent, if any */
@@ -1451,6 +1451,14 @@ struct sctp_stream {
 	struct sctp_stream_interleave *si;
 };
 
+struct sctp_stream_out *sctp_stream_out_ptr(const struct sctp_stream *stream,
+					    __u16 sid);
+struct sctp_stream_in *sctp_stream_in_ptr(const struct sctp_stream *stream,
+					  __u16 sid);
+
+#define SCTP_SO(s, i) sctp_stream_out_ptr((s), (i))
+#define SCTP_SI(s, i) sctp_stream_in_ptr((s), (i))
+
 #define SCTP_STREAM_CLOSED		0x00
 #define SCTP_STREAM_OPEN		0x01
 
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index be296d6..4b9310e 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -333,7 +333,8 @@ int sctp_chunk_abandoned(struct sctp_chunk *chunk)
 	if (SCTP_PR_TTL_ENABLED(chunk->sinfo.sinfo_flags) &&
 	    time_after(jiffies, chunk->msg->expires_at)) {
 		struct sctp_stream_out *streamout -			&chunk->asoc->stream.out[chunk->sinfo.sinfo_stream];
+			SCTP_SO(&chunk->asoc->stream,
+				chunk->sinfo.sinfo_stream);
 
 		if (chunk->sent_count) {
 			chunk->asoc->abandoned_sent[SCTP_PR_INDEX(TTL)]++;
@@ -347,7 +348,8 @@ int sctp_chunk_abandoned(struct sctp_chunk *chunk)
 	} else if (SCTP_PR_RTX_ENABLED(chunk->sinfo.sinfo_flags) &&
 		   chunk->sent_count > chunk->sinfo.sinfo_timetolive) {
 		struct sctp_stream_out *streamout -			&chunk->asoc->stream.out[chunk->sinfo.sinfo_stream];
+			SCTP_SO(&chunk->asoc->stream,
+				chunk->sinfo.sinfo_stream);
 
 		chunk->asoc->abandoned_sent[SCTP_PR_INDEX(RTX)]++;
 		streamout->ext->abandoned_sent[SCTP_PR_INDEX(RTX)]++;
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index f211b3d..8d5d811 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -80,7 +80,7 @@ static inline void sctp_outq_head_data(struct sctp_outq *q,
 	q->out_qlen += ch->skb->len;
 
 	stream = sctp_chunk_stream_no(ch);
-	oute = q->asoc->stream.out[stream].ext;
+	oute = SCTP_SO(&q->asoc->stream, stream)->ext;
 	list_add(&ch->stream_list, &oute->outq);
 }
 
@@ -101,7 +101,7 @@ static inline void sctp_outq_tail_data(struct sctp_outq *q,
 	q->out_qlen += ch->skb->len;
 
 	stream = sctp_chunk_stream_no(ch);
-	oute = q->asoc->stream.out[stream].ext;
+	oute = SCTP_SO(&q->asoc->stream, stream)->ext;
 	list_add_tail(&ch->stream_list, &oute->outq);
 }
 
@@ -372,7 +372,7 @@ static int sctp_prsctp_prune_sent(struct sctp_association *asoc,
 		sctp_insert_list(&asoc->outqueue.abandoned,
 				 &chk->transmitted_list);
 
-		streamout = &asoc->stream.out[chk->sinfo.sinfo_stream];
+		streamout = SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
 		asoc->sent_cnt_removable--;
 		asoc->abandoned_sent[SCTP_PR_INDEX(PRIO)]++;
 		streamout->ext->abandoned_sent[SCTP_PR_INDEX(PRIO)]++;
@@ -416,7 +416,7 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 		asoc->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
 		if (chk->sinfo.sinfo_stream < asoc->stream.outcnt) {
 			struct sctp_stream_out *streamout -				&asoc->stream.out[chk->sinfo.sinfo_stream];
+				SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
 
 			streamout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
 		}
@@ -1050,6 +1050,7 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 		/* Finally, transmit new packets.  */
 		while ((chunk = sctp_outq_dequeue_data(q)) != NULL) {
 			__u32 sid = ntohs(chunk->subh.data_hdr->stream);
+			__u8 stream_state = SCTP_SO(&asoc->stream, sid)->state;
 
 			/* Has this chunk expired? */
 			if (sctp_chunk_abandoned(chunk)) {
@@ -1059,7 +1060,7 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 				continue;
 			}
 
-			if (asoc->stream.out[sid].state = SCTP_STREAM_CLOSED) {
+			if (stream_state = SCTP_STREAM_CLOSED) {
 				sctp_outq_head_data(q, chunk);
 				goto sctp_flush_out;
 			}
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 80835ac..3442f7c 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1907,7 +1907,7 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 		goto err;
 	}
 
-	if (unlikely(!asoc->stream.out[sinfo->sinfo_stream].ext)) {
+	if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->ext)) {
 		err = sctp_stream_init_ext(&asoc->stream, sinfo->sinfo_stream);
 		if (err)
 			goto err;
@@ -6942,7 +6942,7 @@ static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
 	if (!asoc || params.sprstat_sid >= asoc->stream.outcnt)
 		goto out;
 
-	streamoute = asoc->stream.out[params.sprstat_sid].ext;
+	streamoute = SCTP_SO(&asoc->stream, params.sprstat_sid)->ext;
 	if (!streamoute) {
 		/* Not allocated yet, means all stats are 0 */
 		params.sprstat_abandoned_unsent = 0;
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index f799043..16e36c0 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -37,6 +37,18 @@
 #include <net/sctp/sm.h>
 #include <net/sctp/stream_sched.h>
 
+struct sctp_stream_out *sctp_stream_out_ptr(const struct sctp_stream *stream,
+					    __u16 sid)
+{
+	return ((struct sctp_stream_out *)(stream->out)) + sid;
+}
+
+struct sctp_stream_in *sctp_stream_in_ptr(const struct sctp_stream *stream,
+					  __u16 sid)
+{
+	return ((struct sctp_stream_in *)(stream->in)) + sid;
+}
+
 /* Migrates chunks from stream queues to new stream queues if needed,
  * but not across associations. Also, removes those chunks to streams
  * higher than the new max.
@@ -78,34 +90,35 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
 		 * sctp_stream_update will swap ->out pointers.
 		 */
 		for (i = 0; i < outcnt; i++) {
-			kfree(new->out[i].ext);
-			new->out[i].ext = stream->out[i].ext;
-			stream->out[i].ext = NULL;
+			kfree(SCTP_SO(new, i)->ext);
+			SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
+			SCTP_SO(stream, i)->ext = NULL;
 		}
 	}
 
 	for (i = outcnt; i < stream->outcnt; i++)
-		kfree(stream->out[i].ext);
+		kfree(SCTP_SO(stream, i)->ext);
 }
 
 static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
 				 gfp_t gfp)
 {
-	struct sctp_stream_out *out;
+	struct flex_array *out;
+	size_t elem_size = sizeof(struct sctp_stream_out);
 
-	out = kmalloc_array(outcnt, sizeof(*out), gfp);
+	out = kmalloc_array(outcnt, elem_size, gfp);
 	if (!out)
 		return -ENOMEM;
 
 	if (stream->out) {
 		memcpy(out, stream->out, min(outcnt, stream->outcnt) *
-					 sizeof(*out));
+					 elem_size);
 		kfree(stream->out);
 	}
 
 	if (outcnt > stream->outcnt)
-		memset(out + stream->outcnt, 0,
-		       (outcnt - stream->outcnt) * sizeof(*out));
+		memset(((struct sctp_stream_out *)out) + stream->outcnt, 0,
+		       (outcnt - stream->outcnt) * elem_size);
 
 	stream->out = out;
 
@@ -115,22 +128,23 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
 static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
 				gfp_t gfp)
 {
-	struct sctp_stream_in *in;
+	struct flex_array *in;
+	size_t elem_size = sizeof(struct sctp_stream_in);
 
-	in = kmalloc_array(incnt, sizeof(*stream->in), gfp);
+	in = kmalloc_array(incnt, elem_size, gfp);
 
 	if (!in)
 		return -ENOMEM;
 
 	if (stream->in) {
 		memcpy(in, stream->in, min(incnt, stream->incnt) *
-				       sizeof(*in));
+				       elem_size);
 		kfree(stream->in);
 	}
 
 	if (incnt > stream->incnt)
-		memset(in + stream->incnt, 0,
-		       (incnt - stream->incnt) * sizeof(*in));
+		memset(((struct sctp_stream_in *)in) + stream->incnt, 0,
+		       (incnt - stream->incnt) * elem_size);
 
 	stream->in = in;
 
@@ -162,7 +176,7 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 
 	stream->outcnt = outcnt;
 	for (i = 0; i < stream->outcnt; i++)
-		stream->out[i].state = SCTP_STREAM_OPEN;
+		SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
 
 	sched->init(stream);
 
@@ -193,7 +207,7 @@ int sctp_stream_init_ext(struct sctp_stream *stream, __u16 sid)
 	soute = kzalloc(sizeof(*soute), GFP_KERNEL);
 	if (!soute)
 		return -ENOMEM;
-	stream->out[sid].ext = soute;
+	SCTP_SO(stream, sid)->ext = soute;
 
 	return sctp_sched_init_sid(stream, sid, GFP_KERNEL);
 }
@@ -205,7 +219,7 @@ void sctp_stream_free(struct sctp_stream *stream)
 
 	sched->free(stream);
 	for (i = 0; i < stream->outcnt; i++)
-		kfree(stream->out[i].ext);
+		kfree(SCTP_SO(stream, i)->ext);
 	kfree(stream->out);
 	kfree(stream->in);
 }
@@ -215,12 +229,12 @@ void sctp_stream_clear(struct sctp_stream *stream)
 	int i;
 
 	for (i = 0; i < stream->outcnt; i++) {
-		stream->out[i].mid = 0;
-		stream->out[i].mid_uo = 0;
+		SCTP_SO(stream, i)->mid = 0;
+		SCTP_SO(stream, i)->mid_uo = 0;
 	}
 
 	for (i = 0; i < stream->incnt; i++)
-		stream->in[i].mid = 0;
+		SCTP_SI(stream, i)->mid = 0;
 }
 
 void sctp_stream_update(struct sctp_stream *stream, struct sctp_stream *new)
@@ -271,8 +285,8 @@ static bool sctp_stream_outq_is_empty(struct sctp_stream *stream,
 	for (i = 0; i < str_nums; i++) {
 		__u16 sid = ntohs(str_list[i]);
 
-		if (stream->out[sid].ext &&
-		    !list_empty(&stream->out[sid].ext->outq))
+		if (SCTP_SO(stream, sid)->ext &&
+		    !list_empty(&SCTP_SO(stream, sid)->ext->outq))
 			return false;
 	}
 
@@ -359,11 +373,11 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
 	if (out) {
 		if (str_nums)
 			for (i = 0; i < str_nums; i++)
-				stream->out[str_list[i]].state +				SCTP_SO(stream, str_list[i])->state  						       SCTP_STREAM_CLOSED;
 		else
 			for (i = 0; i < stream->outcnt; i++)
-				stream->out[i].state = SCTP_STREAM_CLOSED;
+				SCTP_SO(stream, i)->state = SCTP_STREAM_CLOSED;
 	}
 
 	asoc->strreset_chunk = chunk;
@@ -378,11 +392,11 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
 
 		if (str_nums)
 			for (i = 0; i < str_nums; i++)
-				stream->out[str_list[i]].state +				SCTP_SO(stream, str_list[i])->state  						       SCTP_STREAM_OPEN;
 		else
 			for (i = 0; i < stream->outcnt; i++)
-				stream->out[i].state = SCTP_STREAM_OPEN;
+				SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
 
 		goto out;
 	}
@@ -416,7 +430,7 @@ int sctp_send_reset_assoc(struct sctp_association *asoc)
 
 	/* Block further xmit of data until this request is completed */
 	for (i = 0; i < stream->outcnt; i++)
-		stream->out[i].state = SCTP_STREAM_CLOSED;
+		SCTP_SO(stream, i)->state = SCTP_STREAM_CLOSED;
 
 	asoc->strreset_chunk = chunk;
 	sctp_chunk_hold(asoc->strreset_chunk);
@@ -427,7 +441,7 @@ int sctp_send_reset_assoc(struct sctp_association *asoc)
 		asoc->strreset_chunk = NULL;
 
 		for (i = 0; i < stream->outcnt; i++)
-			stream->out[i].state = SCTP_STREAM_OPEN;
+			SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
 
 		return retval;
 	}
@@ -607,10 +621,10 @@ struct sctp_chunk *sctp_process_strreset_outreq(
 		}
 
 		for (i = 0; i < nums; i++)
-			stream->in[ntohs(str_p[i])].mid = 0;
+			SCTP_SI(stream, ntohs(str_p[i]))->mid = 0;
 	} else {
 		for (i = 0; i < stream->incnt; i++)
-			stream->in[i].mid = 0;
+			SCTP_SI(stream, i)->mid = 0;
 	}
 
 	result = SCTP_STRRESET_PERFORMED;
@@ -681,11 +695,11 @@ struct sctp_chunk *sctp_process_strreset_inreq(
 
 	if (nums)
 		for (i = 0; i < nums; i++)
-			stream->out[ntohs(str_p[i])].state +			SCTP_SO(stream, ntohs(str_p[i]))->state  					       SCTP_STREAM_CLOSED;
 	else
 		for (i = 0; i < stream->outcnt; i++)
-			stream->out[i].state = SCTP_STREAM_CLOSED;
+			SCTP_SO(stream, i)->state = SCTP_STREAM_CLOSED;
 
 	asoc->strreset_chunk = chunk;
 	asoc->strreset_outstanding = 1;
@@ -784,11 +798,11 @@ struct sctp_chunk *sctp_process_strreset_tsnreq(
 	 *      incoming and outgoing streams.
 	 */
 	for (i = 0; i < stream->outcnt; i++) {
-		stream->out[i].mid = 0;
-		stream->out[i].mid_uo = 0;
+		SCTP_SO(stream, i)->mid = 0;
+		SCTP_SO(stream, i)->mid_uo = 0;
 	}
 	for (i = 0; i < stream->incnt; i++)
-		stream->in[i].mid = 0;
+		SCTP_SI(stream, i)->mid = 0;
 
 	result = SCTP_STRRESET_PERFORMED;
 
@@ -977,15 +991,18 @@ struct sctp_chunk *sctp_process_strreset_resp(
 		       sizeof(__u16);
 
 		if (result = SCTP_STRRESET_PERFORMED) {
+			struct sctp_stream_out *sout;
 			if (nums) {
 				for (i = 0; i < nums; i++) {
-					stream->out[ntohs(str_p[i])].mid = 0;
-					stream->out[ntohs(str_p[i])].mid_uo = 0;
+					sout = SCTP_SO(stream, ntohs(str_p[i]));
+					sout->mid = 0;
+					sout->mid_uo = 0;
 				}
 			} else {
 				for (i = 0; i < stream->outcnt; i++) {
-					stream->out[i].mid = 0;
-					stream->out[i].mid_uo = 0;
+					sout = SCTP_SO(stream, i);
+					sout->mid = 0;
+					sout->mid_uo = 0;
 				}
 			}
 
@@ -993,7 +1010,7 @@ struct sctp_chunk *sctp_process_strreset_resp(
 		}
 
 		for (i = 0; i < stream->outcnt; i++)
-			stream->out[i].state = SCTP_STREAM_OPEN;
+			SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
 
 		*evp = sctp_ulpevent_make_stream_reset_event(asoc, flags,
 			nums, str_p, GFP_ATOMIC);
@@ -1048,15 +1065,15 @@ struct sctp_chunk *sctp_process_strreset_resp(
 			asoc->adv_peer_ack_point = asoc->ctsn_ack_point;
 
 			for (i = 0; i < stream->outcnt; i++) {
-				stream->out[i].mid = 0;
-				stream->out[i].mid_uo = 0;
+				SCTP_SO(stream, i)->mid = 0;
+				SCTP_SO(stream, i)->mid_uo = 0;
 			}
 			for (i = 0; i < stream->incnt; i++)
-				stream->in[i].mid = 0;
+				SCTP_SI(stream, i)->mid = 0;
 		}
 
 		for (i = 0; i < stream->outcnt; i++)
-			stream->out[i].state = SCTP_STREAM_OPEN;
+			SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
 
 		*evp = sctp_ulpevent_make_assoc_reset_event(asoc, flags,
 			stsn, rtsn, GFP_ATOMIC);
@@ -1070,7 +1087,7 @@ struct sctp_chunk *sctp_process_strreset_resp(
 
 		if (result = SCTP_STRRESET_PERFORMED)
 			for (i = number; i < stream->outcnt; i++)
-				stream->out[i].state = SCTP_STREAM_OPEN;
+				SCTP_SO(stream, i)->state = SCTP_STREAM_OPEN;
 		else
 			stream->outcnt = number;
 
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index d3764c1..46f9fb6 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1053,7 +1053,7 @@ static void sctp_intl_abort_pd(struct sctp_ulpq *ulpq, gfp_t gfp)
 	__u16 sid;
 
 	for (sid = 0; sid < stream->incnt; sid++) {
-		struct sctp_stream_in *sin = &stream->in[sid];
+		struct sctp_stream_in *sin = SCTP_SI(stream, sid);
 		__u32 mid;
 
 		if (sin->pd_mode_uo) {
diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index f5fcd42..a6c04a9 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -161,7 +161,7 @@ int sctp_sched_set_sched(struct sctp_association *asoc,
 
 		/* Give the next scheduler a clean slate. */
 		for (i = 0; i < asoc->stream.outcnt; i++) {
-			void *p = asoc->stream.out[i].ext;
+			void *p = SCTP_SO(&asoc->stream, i)->ext;
 
 			if (!p)
 				continue;
@@ -175,7 +175,7 @@ int sctp_sched_set_sched(struct sctp_association *asoc,
 	asoc->outqueue.sched = n;
 	n->init(&asoc->stream);
 	for (i = 0; i < asoc->stream.outcnt; i++) {
-		if (!asoc->stream.out[i].ext)
+		if (!SCTP_SO(&asoc->stream, i)->ext)
 			continue;
 
 		ret = n->init_sid(&asoc->stream, i, GFP_KERNEL);
@@ -217,7 +217,7 @@ int sctp_sched_set_value(struct sctp_association *asoc, __u16 sid,
 	if (sid >= asoc->stream.outcnt)
 		return -EINVAL;
 
-	if (!asoc->stream.out[sid].ext) {
+	if (!SCTP_SO(&asoc->stream, sid)->ext) {
 		int ret;
 
 		ret = sctp_stream_init_ext(&asoc->stream, sid);
@@ -234,7 +234,7 @@ int sctp_sched_get_value(struct sctp_association *asoc, __u16 sid,
 	if (sid >= asoc->stream.outcnt)
 		return -EINVAL;
 
-	if (!asoc->stream.out[sid].ext)
+	if (!SCTP_SO(&asoc->stream, sid)->ext)
 		return 0;
 
 	return asoc->outqueue.sched->get(&asoc->stream, sid, value);
@@ -252,7 +252,7 @@ void sctp_sched_dequeue_done(struct sctp_outq *q, struct sctp_chunk *ch)
 		 * priority stream comes in.
 		 */
 		sid = sctp_chunk_stream_no(ch);
-		sout = &q->asoc->stream.out[sid];
+		sout = SCTP_SO(&q->asoc->stream, sid);
 		q->asoc->stream.out_curr = sout;
 		return;
 	}
@@ -272,8 +272,9 @@ void sctp_sched_dequeue_common(struct sctp_outq *q, struct sctp_chunk *ch)
 int sctp_sched_init_sid(struct sctp_stream *stream, __u16 sid, gfp_t gfp)
 {
 	struct sctp_sched_ops *sched = sctp_sched_ops_from_stream(stream);
+	struct sctp_stream_out_ext *ext = SCTP_SO(stream, sid)->ext;
 
-	INIT_LIST_HEAD(&stream->out[sid].ext->outq);
+	INIT_LIST_HEAD(&ext->outq);
 	return sched->init_sid(stream, sid, gfp);
 }
 
diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
index 7997d35..2245083 100644
--- a/net/sctp/stream_sched_prio.c
+++ b/net/sctp/stream_sched_prio.c
@@ -75,10 +75,10 @@ static struct sctp_stream_priorities *sctp_sched_prio_get_head(
 
 	/* No luck. So we search on all streams now. */
 	for (i = 0; i < stream->outcnt; i++) {
-		if (!stream->out[i].ext)
+		if (!SCTP_SO(stream, i)->ext)
 			continue;
 
-		p = stream->out[i].ext->prio_head;
+		p = SCTP_SO(stream, i)->ext->prio_head;
 		if (!p)
 			/* Means all other streams won't be initialized
 			 * as well.
@@ -165,7 +165,7 @@ static void sctp_sched_prio_sched(struct sctp_stream *stream,
 static int sctp_sched_prio_set(struct sctp_stream *stream, __u16 sid,
 			       __u16 prio, gfp_t gfp)
 {
-	struct sctp_stream_out *sout = &stream->out[sid];
+	struct sctp_stream_out *sout = SCTP_SO(stream, sid);
 	struct sctp_stream_out_ext *soute = sout->ext;
 	struct sctp_stream_priorities *prio_head, *old;
 	bool reschedule = false;
@@ -186,7 +186,7 @@ static int sctp_sched_prio_set(struct sctp_stream *stream, __u16 sid,
 		return 0;
 
 	for (i = 0; i < stream->outcnt; i++) {
-		soute = stream->out[i].ext;
+		soute = SCTP_SO(stream, i)->ext;
 		if (soute && soute->prio_head = old)
 			/* It's still in use, nothing else to do here. */
 			return 0;
@@ -201,7 +201,7 @@ static int sctp_sched_prio_set(struct sctp_stream *stream, __u16 sid,
 static int sctp_sched_prio_get(struct sctp_stream *stream, __u16 sid,
 			       __u16 *value)
 {
-	*value = stream->out[sid].ext->prio_head->prio;
+	*value = SCTP_SO(stream, sid)->ext->prio_head->prio;
 	return 0;
 }
 
@@ -215,7 +215,7 @@ static int sctp_sched_prio_init(struct sctp_stream *stream)
 static int sctp_sched_prio_init_sid(struct sctp_stream *stream, __u16 sid,
 				    gfp_t gfp)
 {
-	INIT_LIST_HEAD(&stream->out[sid].ext->prio_list);
+	INIT_LIST_HEAD(&SCTP_SO(stream, sid)->ext->prio_list);
 	return sctp_sched_prio_set(stream, sid, 0, gfp);
 }
 
@@ -233,9 +233,9 @@ static void sctp_sched_prio_free(struct sctp_stream *stream)
 	 */
 	sctp_sched_prio_unsched_all(stream);
 	for (i = 0; i < stream->outcnt; i++) {
-		if (!stream->out[i].ext)
+		if (!SCTP_SO(stream, i)->ext)
 			continue;
-		prio = stream->out[i].ext->prio_head;
+		prio = SCTP_SO(stream, i)->ext->prio_head;
 		if (prio && list_empty(&prio->prio_sched))
 			list_add(&prio->prio_sched, &list);
 	}
@@ -255,7 +255,7 @@ static void sctp_sched_prio_enqueue(struct sctp_outq *q,
 	ch = list_first_entry(&msg->chunks, struct sctp_chunk, frag_list);
 	sid = sctp_chunk_stream_no(ch);
 	stream = &q->asoc->stream;
-	sctp_sched_prio_sched(stream, stream->out[sid].ext);
+	sctp_sched_prio_sched(stream, SCTP_SO(stream, sid)->ext);
 }
 
 static struct sctp_chunk *sctp_sched_prio_dequeue(struct sctp_outq *q)
@@ -297,7 +297,7 @@ static void sctp_sched_prio_dequeue_done(struct sctp_outq *q,
 	 * this priority.
 	 */
 	sid = sctp_chunk_stream_no(ch);
-	soute = q->asoc->stream.out[sid].ext;
+	soute = SCTP_SO(&q->asoc->stream, sid)->ext;
 	prio = soute->prio_head;
 
 	sctp_sched_prio_next_stream(prio);
@@ -317,7 +317,7 @@ static void sctp_sched_prio_sched_all(struct sctp_stream *stream)
 		__u16 sid;
 
 		sid = sctp_chunk_stream_no(ch);
-		sout = &stream->out[sid];
+		sout = SCTP_SO(stream, sid);
 		if (sout->ext)
 			sctp_sched_prio_sched(stream, sout->ext);
 	}
diff --git a/net/sctp/stream_sched_rr.c b/net/sctp/stream_sched_rr.c
index 1155692..52ba743 100644
--- a/net/sctp/stream_sched_rr.c
+++ b/net/sctp/stream_sched_rr.c
@@ -100,7 +100,7 @@ static int sctp_sched_rr_init(struct sctp_stream *stream)
 static int sctp_sched_rr_init_sid(struct sctp_stream *stream, __u16 sid,
 				  gfp_t gfp)
 {
-	INIT_LIST_HEAD(&stream->out[sid].ext->rr_list);
+	INIT_LIST_HEAD(&SCTP_SO(stream, sid)->ext->rr_list);
 
 	return 0;
 }
@@ -120,7 +120,7 @@ static void sctp_sched_rr_enqueue(struct sctp_outq *q,
 	ch = list_first_entry(&msg->chunks, struct sctp_chunk, frag_list);
 	sid = sctp_chunk_stream_no(ch);
 	stream = &q->asoc->stream;
-	sctp_sched_rr_sched(stream, stream->out[sid].ext);
+	sctp_sched_rr_sched(stream, SCTP_SO(stream, sid)->ext);
 }
 
 static struct sctp_chunk *sctp_sched_rr_dequeue(struct sctp_outq *q)
@@ -154,7 +154,7 @@ static void sctp_sched_rr_dequeue_done(struct sctp_outq *q,
 
 	/* Last chunk on that msg, move to the next stream */
 	sid = sctp_chunk_stream_no(ch);
-	soute = q->asoc->stream.out[sid].ext;
+	soute = SCTP_SO(&q->asoc->stream, sid)->ext;
 
 	sctp_sched_rr_next_stream(&q->asoc->stream);
 
@@ -173,7 +173,7 @@ static void sctp_sched_rr_sched_all(struct sctp_stream *stream)
 		__u16 sid;
 
 		sid = sctp_chunk_stream_no(ch);
-		soute = stream->out[sid].ext;
+		soute = SCTP_SO(stream, sid)->ext;
 		if (soute)
 			sctp_sched_rr_sched(stream, soute);
 	}
-- 
1.8.3.1

