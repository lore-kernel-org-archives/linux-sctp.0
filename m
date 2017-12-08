From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 08 Dec 2017 13:04:08 +0000
Subject: [PATCHv2 net-next 11/12] sctp: implement abort_pd for sctp_stream_interleave
Message-Id: <549d6775140d1e976e9cd184a76f7fa64a2bafab.1512738021.git.lucien.xin@gmail.com>
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
 <1a253f52ab5310dcad8f518652e50b959043d8b2.1512738021.git.lucien.xin@gmail.com>
 <0de955e81dc688c578d1b54ab7de5bcda70acfcb.1512738021.git.lucien.xin@gmail.com>
In-Reply-To: <0de955e81dc688c578d1b54ab7de5bcda70acfcb.1512738021.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

abort_pd is added as a member of sctp_stream_interleave, used to abort
partial delivery for data or idata, called in sctp_cmd_assoc_failed.

Since stream interleave allows to do partial delivery for each stream
at the same time, sctp_intl_abort_pd for idata would be very different
from the old function sctp_ulpq_abort_pd for data.

Note that sctp_ulpevent_make_pdapi will support per stream in this
patch by adding pdapi_stream and pdapi_seq in sctp_pdapi_event, as
described in section 6.1.7 of RFC6458.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 include/net/sctp/stream_interleave.h |  1 +
 include/net/sctp/ulpevent.h          |  3 +-
 include/uapi/linux/sctp.h            |  2 +
 net/sctp/sm_sideeffect.c             |  2 +-
 net/sctp/stream_interleave.c         | 99 ++++++++++++++++++++++++++++++++++++
 net/sctp/ulpevent.c                  |  9 ++--
 net/sctp/ulpqueue.c                  |  2 +-
 7 files changed, 112 insertions(+), 6 deletions(-)

diff --git a/include/net/sctp/stream_interleave.h b/include/net/sctp/stream_interleave.h
index 317d9b3..501b2be 100644
--- a/include/net/sctp/stream_interleave.h
+++ b/include/net/sctp/stream_interleave.h
@@ -46,6 +46,7 @@ struct sctp_stream_interleave {
 	void	(*renege_events)(struct sctp_ulpq *ulpq,
 				 struct sctp_chunk *chunk, gfp_t gfp);
 	void	(*start_pd)(struct sctp_ulpq *ulpq, gfp_t gfp);
+	void	(*abort_pd)(struct sctp_ulpq *ulpq, gfp_t gfp);
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream);
diff --git a/include/net/sctp/ulpevent.h b/include/net/sctp/ulpevent.h
index ce4f2aa..51b4e06 100644
--- a/include/net/sctp/ulpevent.h
+++ b/include/net/sctp/ulpevent.h
@@ -122,7 +122,8 @@ struct sctp_ulpevent *sctp_ulpevent_make_shutdown_event(
 
 struct sctp_ulpevent *sctp_ulpevent_make_pdapi(
 	const struct sctp_association *asoc,
-	__u32 indication, gfp_t gfp);
+	__u32 indication, __u32 sid, __u32 seq,
+	__u32 flags, gfp_t gfp);
 
 struct sctp_ulpevent *sctp_ulpevent_make_adaptation_indication(
 	const struct sctp_association *asoc, gfp_t gfp);
diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 6ed934c..4c4db14 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -460,6 +460,8 @@ struct sctp_pdapi_event {
 	__u32 pdapi_length;
 	__u32 pdapi_indication;
 	sctp_assoc_t pdapi_assoc_id;
+	__u32 pdapi_stream;
+	__u32 pdapi_seq;
 };
 
 enum { SCTP_PARTIAL_DELIVERY_ABORTED=0, };
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 3671054..8adde71 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -632,7 +632,7 @@ static void sctp_cmd_assoc_failed(struct sctp_cmd_seq *commands,
 	struct sctp_chunk *abort;
 
 	/* Cancel any partial delivery in progress. */
-	sctp_ulpq_abort_pd(&asoc->ulpq, GFP_ATOMIC);
+	asoc->stream.si->abort_pd(&asoc->ulpq, GFP_ATOMIC);
 
 	if (event_type = SCTP_EVENT_T_CHUNK && subtype.chunk = SCTP_CID_ABORT)
 		event = sctp_ulpevent_make_assoc_change(asoc, 0, SCTP_COMM_LOST,
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 4dce8d3..d15645e 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -652,6 +652,103 @@ static void sctp_renege_events(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk,
 	sk_mem_reclaim(asoc->base.sk);
 }
 
+static void sctp_intl_stream_abort_pd(struct sctp_ulpq *ulpq, __u16 sid,
+				      __u32 mid, __u16 flags, gfp_t gfp)
+{
+	struct sock *sk = ulpq->asoc->base.sk;
+	struct sctp_ulpevent *ev = NULL;
+
+	if (!sctp_ulpevent_type_enabled(SCTP_PARTIAL_DELIVERY_EVENT,
+					&sctp_sk(sk)->subscribe))
+		return;
+
+	ev = sctp_ulpevent_make_pdapi(ulpq->asoc, SCTP_PARTIAL_DELIVERY_ABORTED,
+				      sid, mid, flags, gfp);
+	if (ev) {
+		__skb_queue_tail(&sk->sk_receive_queue, sctp_event2skb(ev));
+
+		if (!sctp_sk(sk)->data_ready_signalled) {
+			sctp_sk(sk)->data_ready_signalled = 1;
+			sk->sk_data_ready(sk);
+		}
+	}
+}
+
+static void sctp_intl_reap_ordered(struct sctp_ulpq *ulpq, __u16 sid)
+{
+	struct sctp_stream *stream = &ulpq->asoc->stream;
+	struct sctp_ulpevent *cevent, *event = NULL;
+	struct sk_buff_head *lobby = &ulpq->lobby;
+	struct sk_buff *pos, *tmp;
+	struct sk_buff_head temp;
+	__u16 csid;
+	__u32 cmid;
+
+	skb_queue_head_init(&temp);
+	sctp_skb_for_each(pos, lobby, tmp) {
+		cevent = (struct sctp_ulpevent *)pos->cb;
+		csid = cevent->stream;
+		cmid = cevent->mid;
+
+		if (csid > sid)
+			break;
+
+		if (csid < sid)
+			continue;
+
+		if (!MID_lt(cmid, sctp_mid_peek(stream, in, csid)))
+			break;
+
+		__skb_unlink(pos, lobby);
+		if (!event)
+			event = sctp_skb2event(pos);
+
+		__skb_queue_tail(&temp, pos);
+	}
+
+	if (!event && pos != (struct sk_buff *)lobby) {
+		cevent = (struct sctp_ulpevent *)pos->cb;
+		csid = cevent->stream;
+		cmid = cevent->mid;
+
+		if (csid = sid && cmid = sctp_mid_peek(stream, in, csid)) {
+			sctp_mid_next(stream, in, csid);
+			__skb_unlink(pos, lobby);
+			__skb_queue_tail(&temp, pos);
+			event = sctp_skb2event(pos);
+		}
+	}
+
+	if (event) {
+		sctp_intl_retrieve_ordered(ulpq, event);
+		sctp_enqueue_event(ulpq, event);
+	}
+}
+
+static void sctp_intl_abort_pd(struct sctp_ulpq *ulpq, gfp_t gfp)
+{
+	struct sctp_stream *stream = &ulpq->asoc->stream;
+	__u16 sid;
+
+	for (sid = 0; sid < stream->incnt; sid++) {
+		struct sctp_stream_in *sin = &stream->in[sid];
+		__u32 mid;
+
+		if (sin->pd_mode) {
+			sin->pd_mode = 0;
+
+			mid = sin->mid;
+			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0, gfp);
+			sctp_mid_skip(stream, in, sid, mid);
+
+			sctp_intl_reap_ordered(ulpq, sid);
+		}
+	}
+
+	/* intl abort pd happens only when all data needs to be cleaned */
+	sctp_ulpq_flush(ulpq);
+}
+
 static struct sctp_stream_interleave sctp_stream_interleave_0 = {
 	.data_chunk_len		= sizeof(struct sctp_data_chunk),
 	/* DATA process functions */
@@ -662,6 +759,7 @@ static struct sctp_stream_interleave sctp_stream_interleave_0 = {
 	.enqueue_event		= sctp_ulpq_tail_event,
 	.renege_events		= sctp_ulpq_renege,
 	.start_pd		= sctp_ulpq_partial_delivery,
+	.abort_pd		= sctp_ulpq_abort_pd,
 };
 
 static struct sctp_stream_interleave sctp_stream_interleave_1 = {
@@ -674,6 +772,7 @@ static struct sctp_stream_interleave sctp_stream_interleave_1 = {
 	.enqueue_event		= sctp_enqueue_event,
 	.renege_events		= sctp_renege_events,
 	.start_pd		= sctp_intl_start_pd,
+	.abort_pd		= sctp_intl_abort_pd,
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream)
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index d3218f3..84207ad 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -730,8 +730,9 @@ struct sctp_ulpevent *sctp_ulpevent_make_rcvmsg(struct sctp_association *asoc,
  *   various events.
  */
 struct sctp_ulpevent *sctp_ulpevent_make_pdapi(
-	const struct sctp_association *asoc, __u32 indication,
-	gfp_t gfp)
+					const struct sctp_association *asoc,
+					__u32 indication, __u32 sid, __u32 seq,
+					__u32 flags, gfp_t gfp)
 {
 	struct sctp_ulpevent *event;
 	struct sctp_pdapi_event *pd;
@@ -752,7 +753,9 @@ struct sctp_ulpevent *sctp_ulpevent_make_pdapi(
 	 *   Currently unused.
 	 */
 	pd->pdapi_type = SCTP_PARTIAL_DELIVERY_EVENT;
-	pd->pdapi_flags = 0;
+	pd->pdapi_flags = flags;
+	pd->pdapi_stream = sid;
+	pd->pdapi_seq = seq;
 
 	/* pdapi_length: 32 bits (unsigned integer)
 	 *
diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index 76ec514..dd53daa 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -1144,7 +1144,7 @@ void sctp_ulpq_abort_pd(struct sctp_ulpq *ulpq, gfp_t gfp)
 				       &sctp_sk(sk)->subscribe))
 		ev = sctp_ulpevent_make_pdapi(ulpq->asoc,
 					      SCTP_PARTIAL_DELIVERY_ABORTED,
-					      gfp);
+					      0, 0, 0, gfp);
 	if (ev)
 		__skb_queue_tail(&sk->sk_receive_queue, sctp_event2skb(ev));
 
-- 
2.1.0

