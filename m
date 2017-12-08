From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 08 Dec 2017 13:04:06 +0000
Subject: [PATCHv2 net-next 09/12] sctp: implement renege_events for sctp_stream_interleave
Message-Id: <1a253f52ab5310dcad8f518652e50b959043d8b2.1512738021.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512738021.git.lucien.xin@gmail.com>
 <2fef1243f8181062aeb17f7052e5b022ec274a8e.1512738021.git.lucien.xin@gmail.com>
 <7347f16f5b620ed98fdb5f7ac54db4a70e1fd27e.1512738021.git.lucien.xin@gmail.com>
 <9a2bf9495313a79f0bbffb8edaaef25269804feb.1512738021.git.lucien.xin@gmail.com>
 <ed729ca6023dea0812e4caa4d5da3259df375127.1512738021.git.lucien.xin@gmail.com>
 <be593df99566267deff68ff477d2355dfffada80.1512738021.git.lucien.xin@gmail.com>
 <083a620b71eb0446997f308372bdbe2d1e0fdc55.1512738021.git.lucien.xin@gmail.com>
 <9b28c98bbb59126b2be7b81cd4bd16336f99ba69.1512738021.git.lucien.xin@gmail.com>
 <47320a14e77bc56bcce883b79aebc0509386f9e5.1512738021.git.lucien.xin@gmail.com>
In-Reply-To: <47320a14e77bc56bcce883b79aebc0509386f9e5.1512738021.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

renege_events is added as a member of sctp_stream_interleave, used to
renege some old data or idata in reasm or lobby queue properly to free
some memory for the new data when there's memory stress.

It defines sctp_renege_events for idata, and leaves sctp_ulpq_renege
as it is for data.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 include/net/sctp/stream_interleave.h |   2 +
 include/net/sctp/ulpqueue.h          |   9 +--
 net/sctp/sm_sideeffect.c             |   5 +-
 net/sctp/stream_interleave.c         | 109 +++++++++++++++++++++++++++++++++++
 net/sctp/ulpqueue.c                  |   4 +-
 5 files changed, 119 insertions(+), 10 deletions(-)

diff --git a/include/net/sctp/stream_interleave.h b/include/net/sctp/stream_interleave.h
index a0f61bc..16a71cb 100644
--- a/include/net/sctp/stream_interleave.h
+++ b/include/net/sctp/stream_interleave.h
@@ -43,6 +43,8 @@ struct sctp_stream_interleave {
 				 struct sctp_chunk *chunk, gfp_t gfp);
 	int	(*enqueue_event)(struct sctp_ulpq *ulpq,
 				 struct sctp_ulpevent *event);
+	void	(*renege_events)(struct sctp_ulpq *ulpq,
+				 struct sctp_chunk *chunk, gfp_t gfp);
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream);
diff --git a/include/net/sctp/ulpqueue.h b/include/net/sctp/ulpqueue.h
index e0dce07..eb98c71 100644
--- a/include/net/sctp/ulpqueue.h
+++ b/include/net/sctp/ulpqueue.h
@@ -76,11 +76,8 @@ int sctp_clear_pd(struct sock *sk, struct sctp_association *asoc);
 void sctp_ulpq_skip(struct sctp_ulpq *ulpq, __u16 sid, __u16 ssn);
 
 void sctp_ulpq_reasm_flushtsn(struct sctp_ulpq *, __u32);
-#endif /* __sctp_ulpqueue_h__ */
-
-
-
-
-
 
+__u16 sctp_ulpq_renege_list(struct sctp_ulpq *ulpq,
+			    struct sk_buff_head *list, __u16 needed);
 
+#endif /* __sctp_ulpqueue_h__ */
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index f4e5eca..2bec17a 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1735,8 +1735,9 @@ static int sctp_cmd_interpreter(enum sctp_event event_type,
 			break;
 
 		case SCTP_CMD_RENEGE:
-			sctp_ulpq_renege(&asoc->ulpq, cmd->obj.chunk,
-					 GFP_ATOMIC);
+			asoc->stream.si->renege_events(&asoc->ulpq,
+						       cmd->obj.chunk,
+						       GFP_ATOMIC);
 			break;
 
 		case SCTP_CMD_SETUP_T4:
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index e853972..d62ad5c 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -545,6 +545,113 @@ static int sctp_ulpevent_idata(struct sctp_ulpq *ulpq,
 	return event_eor;
 }
 
+static struct sctp_ulpevent *sctp_intl_retrieve_first(struct sctp_ulpq *ulpq)
+{
+	struct sctp_stream_in *csin, *sin = NULL;
+	struct sk_buff *first_frag = NULL;
+	struct sk_buff *last_frag = NULL;
+	struct sctp_ulpevent *retval;
+	struct sk_buff *pos;
+	__u32 next_fsn = 0;
+	__u16 sid = 0;
+
+	skb_queue_walk(&ulpq->reasm, pos) {
+		struct sctp_ulpevent *cevent = sctp_skb2event(pos);
+
+		csin = sctp_stream_in(ulpq->asoc, cevent->stream);
+		if (csin->pd_mode)
+			continue;
+
+		switch (cevent->msg_flags & SCTP_DATA_FRAG_MASK) {
+		case SCTP_DATA_FIRST_FRAG:
+			if (first_frag)
+				goto out;
+			if (cevent->mid = csin->mid) {
+				first_frag = pos;
+				last_frag = pos;
+				next_fsn = 0;
+				sin = csin;
+				sid = cevent->stream;
+			}
+			break;
+		case SCTP_DATA_MIDDLE_FRAG:
+			if (!first_frag)
+				break;
+			if (cevent->stream = sid &&
+			    cevent->mid = sin->mid &&
+			    cevent->fsn = next_fsn) {
+				next_fsn++;
+				last_frag = pos;
+			} else {
+				goto out;
+			}
+			break;
+		case SCTP_DATA_LAST_FRAG:
+			if (first_frag)
+				goto out;
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (!first_frag)
+		return NULL;
+
+out:
+	retval = sctp_make_reassembled_event(sock_net(ulpq->asoc->base.sk),
+					     &ulpq->reasm, first_frag,
+					     last_frag);
+	if (retval) {
+		sin->fsn = next_fsn;
+		sin->pd_mode = 1;
+	}
+
+	return retval;
+}
+
+static void sctp_intl_start_pd(struct sctp_ulpq *ulpq, gfp_t gfp)
+{
+	struct sctp_ulpevent *event;
+
+	if (skb_queue_empty(&ulpq->reasm))
+		return;
+
+	do {
+		event = sctp_intl_retrieve_first(ulpq);
+		if (event)
+			sctp_enqueue_event(ulpq, event);
+	} while (event);
+}
+
+static void sctp_renege_events(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk,
+			       gfp_t gfp)
+{
+	struct sctp_association *asoc = ulpq->asoc;
+	__u32 freed = 0;
+	__u16 needed;
+
+	if (chunk) {
+		needed = ntohs(chunk->chunk_hdr->length);
+		needed -= sizeof(struct sctp_idata_chunk);
+	} else {
+		needed = SCTP_DEFAULT_MAXWINDOW;
+	}
+
+	if (skb_queue_empty(&asoc->base.sk->sk_receive_queue)) {
+		freed = sctp_ulpq_renege_list(ulpq, &ulpq->lobby, needed);
+		if (freed < needed)
+			freed += sctp_ulpq_renege_list(ulpq, &ulpq->reasm,
+						       needed);
+	}
+
+	if (chunk && freed >= needed)
+		if (sctp_ulpevent_idata(ulpq, chunk, gfp) <= 0)
+			sctp_intl_start_pd(ulpq, gfp);
+
+	sk_mem_reclaim(asoc->base.sk);
+}
+
 static struct sctp_stream_interleave sctp_stream_interleave_0 = {
 	.data_chunk_len		= sizeof(struct sctp_data_chunk),
 	/* DATA process functions */
@@ -553,6 +660,7 @@ static struct sctp_stream_interleave sctp_stream_interleave_0 = {
 	.validate_data		= sctp_validate_data,
 	.ulpevent_data		= sctp_ulpq_tail_data,
 	.enqueue_event		= sctp_ulpq_tail_event,
+	.renege_events		= sctp_ulpq_renege,
 };
 
 static struct sctp_stream_interleave sctp_stream_interleave_1 = {
@@ -563,6 +671,7 @@ static struct sctp_stream_interleave sctp_stream_interleave_1 = {
 	.validate_data		= sctp_validate_idata,
 	.ulpevent_data		= sctp_ulpevent_idata,
 	.enqueue_event		= sctp_enqueue_event,
+	.renege_events		= sctp_renege_events,
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream)
diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index 0d07f2a..76ec514 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -978,8 +978,8 @@ void sctp_ulpq_skip(struct sctp_ulpq *ulpq, __u16 sid, __u16 ssn)
 	sctp_ulpq_reap_ordered(ulpq, sid);
 }
 
-static __u16 sctp_ulpq_renege_list(struct sctp_ulpq *ulpq,
-		struct sk_buff_head *list, __u16 needed)
+__u16 sctp_ulpq_renege_list(struct sctp_ulpq *ulpq, struct sk_buff_head *list,
+			    __u16 needed)
 {
 	__u16 freed = 0;
 	__u32 tsn, last_tsn;
-- 
2.1.0

