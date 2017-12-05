From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 05 Dec 2017 15:16:04 +0000
Subject: [PATCH net-next 07/12] sctp: implement ulpevent_data for sctp_stream_interleave
Message-Id: <7dd410b23c38f41fb8402880185f5e583dabbc04.1512486606.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512486606.git.lucien.xin@gmail.com>
 <b830faf5987dbed8b1e724f039348e960b8537e3.1512486606.git.lucien.xin@gmail.com>
 <590ee9b2ecf13733272f9bb1888c60de1f5f47a4.1512486606.git.lucien.xin@gmail.com>
 <4facf144fb29f5b161dd665e3326311001812a1c.1512486606.git.lucien.xin@gmail.com>
 <b8551388363da7b56f7e56132414c1399557a12d.1512486606.git.lucien.xin@gmail.com>
 <ddf7cc34d5fdbdcbe3e8b4e546799c55edff5ca2.1512486606.git.lucien.xin@gmail.com>
 <010d0fbcbdcb70224859dc281e622e0fdf6f46c5.1512486606.git.lucien.xin@gmail.com>
In-Reply-To: <010d0fbcbdcb70224859dc281e622e0fdf6f46c5.1512486606.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

ulpevent_data is added as a member of sctp_stream_interleave, used to
do the most process in ulpq, including to convert data or idata chunk
to event, reasm them in reasm queue and put them in lobby queue in
right order, and deliver them up to user sk rx queue.

This procedure is described in section 2.2.3 of RFC8260.

It adds most functions for idata here to do the similar process as
the old functions for data. But since the details are very different
between them, the old functions can not be reused for idata.

event->ssn and event->ppid settings are moved to ulpevent_data from
sctp_ulpevent_make_rcvmsg, so that sctp_ulpevent_make_rcvmsg could
work for both data and idata.

Note that mid is added in sctp_ulpevent for idata, __packed has to
be used for defining sctp_ulpevent, or it would exceeds the skb cb
that saves a sctp_ulpevent variable for ulp layer process.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/stream_interleave.h |   2 +
 include/net/sctp/structs.h           |   3 +
 include/net/sctp/ulpevent.h          |  20 +-
 net/sctp/sm_sideeffect.c             |   5 +-
 net/sctp/stream_interleave.c         | 418 +++++++++++++++++++++++++++++++++++
 net/sctp/ulpevent.c                  |   2 -
 net/sctp/ulpqueue.c                  |  12 +-
 7 files changed, 451 insertions(+), 11 deletions(-)

diff --git a/include/net/sctp/stream_interleave.h b/include/net/sctp/stream_interleave.h
index d8d1b51..02f60f5 100644
--- a/include/net/sctp/stream_interleave.h
+++ b/include/net/sctp/stream_interleave.h
@@ -39,6 +39,8 @@ struct sctp_stream_interleave {
 					    int len, __u8 flags, gfp_t gfp);
 	void	(*assign_number)(struct sctp_chunk *chunk);
 	bool	(*validate_data)(struct sctp_chunk *chunk);
+	int	(*ulpevent_data)(struct sctp_ulpq *ulpq,
+				 struct sctp_chunk *chunk, gfp_t gfp);
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 348b25e..d7da719 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -411,6 +411,8 @@ void sctp_stream_update(struct sctp_stream *stream, struct sctp_stream *new);
 #define sctp_mid_skip(stream, type, sid, mid) \
 	((stream)->type[sid].mid = mid + 1)
 
+#define sctp_stream_in(asoc, sid) (&(asoc)->stream.in[sid])
+
 /*
  * Pointers to address related SCTP functions.
  * (i.e. things that depend on the address family.)
@@ -1386,6 +1388,7 @@ struct sctp_stream_in {
 		__u16 ssn;
 	};
 	__u32 fsn;
+	char pd_mode;
 };
 
 struct sctp_stream {
diff --git a/include/net/sctp/ulpevent.h b/include/net/sctp/ulpevent.h
index 231dc42..ce4f2aa 100644
--- a/include/net/sctp/ulpevent.h
+++ b/include/net/sctp/ulpevent.h
@@ -45,19 +45,29 @@
 /* A structure to carry information to the ULP (e.g. Sockets API) */
 /* Warning: This sits inside an skb.cb[] area.  Be very careful of
  * growing this structure as it is at the maximum limit now.
+ *
+ * sctp_ulpevent is saved in sk->cb(48 bytes), whose last 4 bytes
+ * have been taken by sock_skb_cb, So here it has to use 'packed'
+ * to make sctp_ulpevent fit into the rest 44 bytes.
  */
 struct sctp_ulpevent {
 	struct sctp_association *asoc;
 	struct sctp_chunk *chunk;
 	unsigned int rmem_len;
-	__u32 ppid;
+	union {
+		__u32 mid;
+		__u16 ssn;
+	};
+	union {
+		__u32 ppid;
+		__u32 fsn;
+	};
 	__u32 tsn;
 	__u32 cumtsn;
 	__u16 stream;
-	__u16 ssn;
 	__u16 flags;
 	__u16 msg_flags;
-};
+} __packed;
 
 /* Retrieve the skb this event sits inside of. */
 static inline struct sk_buff *sctp_event2skb(const struct sctp_ulpevent *ev)
@@ -140,6 +150,10 @@ struct sctp_ulpevent *sctp_ulpevent_make_stream_change_event(
 	const struct sctp_association *asoc, __u16 flags,
 	__u32 strchange_instrms, __u32 strchange_outstrms, gfp_t gfp);
 
+struct sctp_ulpevent *sctp_make_reassembled_event(
+	struct net *net, struct sk_buff_head *queue,
+	struct sk_buff *f_frag, struct sk_buff *l_frag);
+
 void sctp_ulpevent_read_sndrcvinfo(const struct sctp_ulpevent *event,
 				   struct msghdr *);
 void sctp_ulpevent_read_rcvinfo(const struct sctp_ulpevent *event,
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index df94d77..9d25efb 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1483,8 +1483,9 @@ static int sctp_cmd_interpreter(enum sctp_event event_type,
 			pr_debug("%s: sm_sideff: chunk_up:%p, ulpq:%p\n",
 				 __func__, cmd->obj.chunk, &asoc->ulpq);
 
-			sctp_ulpq_tail_data(&asoc->ulpq, cmd->obj.chunk,
-					    GFP_ATOMIC);
+			asoc->stream.si->ulpevent_data(&asoc->ulpq,
+						       cmd->obj.chunk,
+						       GFP_ATOMIC);
 			break;
 
 		case SCTP_CMD_EVENT_ULP:
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 3d8733b..8238311 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -29,8 +29,10 @@
  *    Xin Long <lucien.xin@gmail.com>
  */
 
+#include <net/busy_poll.h>
 #include <net/sctp/sctp.h>
 #include <net/sctp/sm.h>
+#include <net/sctp/ulpevent.h>
 #include <linux/sctp.h>
 
 static struct sctp_chunk *sctp_make_idatafrag_empty(
@@ -129,12 +131,427 @@ static bool sctp_validate_idata(struct sctp_chunk *chunk)
 	return !MID_lt(mid, sctp_mid_peek(stream, in, sid));
 }
 
+static void sctp_intl_store_reasm(struct sctp_ulpq *ulpq,
+				  struct sctp_ulpevent *event)
+{
+	struct sctp_ulpevent *cevent;
+	struct sk_buff *pos;
+
+	pos = skb_peek_tail(&ulpq->reasm);
+	if (!pos) {
+		__skb_queue_tail(&ulpq->reasm, sctp_event2skb(event));
+		return;
+	}
+
+	cevent = sctp_skb2event(pos);
+
+	if (event->stream = cevent->stream &&
+	    event->mid = cevent->mid &&
+	    (cevent->msg_flags & SCTP_DATA_FIRST_FRAG ||
+	     (!(event->msg_flags & SCTP_DATA_FIRST_FRAG) &&
+	      event->fsn > cevent->fsn))) {
+		__skb_queue_tail(&ulpq->reasm, sctp_event2skb(event));
+		return;
+	}
+
+	if ((event->stream = cevent->stream &&
+	     MID_lt(cevent->mid, event->mid)) ||
+	    event->stream > cevent->stream) {
+		__skb_queue_tail(&ulpq->reasm, sctp_event2skb(event));
+		return;
+	}
+
+	skb_queue_walk(&ulpq->reasm, pos) {
+		cevent = sctp_skb2event(pos);
+
+		if (event->stream < cevent->stream ||
+		    (event->stream = cevent->stream &&
+		     MID_lt(event->mid, cevent->mid)))
+			break;
+
+		if (event->stream = cevent->stream &&
+		    event->mid = cevent->mid &&
+		    !(cevent->msg_flags & SCTP_DATA_FIRST_FRAG) &&
+		    (event->msg_flags & SCTP_DATA_FIRST_FRAG ||
+		     event->fsn < cevent->fsn))
+			break;
+	}
+
+	__skb_queue_before(&ulpq->reasm, pos, sctp_event2skb(event));
+}
+
+static struct sctp_ulpevent *sctp_intl_retrieve_partial(
+						struct sctp_ulpq *ulpq,
+						struct sctp_ulpevent *event)
+{
+	struct sk_buff *first_frag = NULL;
+	struct sk_buff *last_frag = NULL;
+	struct sctp_ulpevent *retval;
+	struct sctp_stream_in *sin;
+	struct sk_buff *pos;
+	__u32 next_fsn = 0;
+	int is_last = 0;
+
+	sin = sctp_stream_in(ulpq->asoc, event->stream);
+
+	skb_queue_walk(&ulpq->reasm, pos) {
+		struct sctp_ulpevent *cevent = sctp_skb2event(pos);
+
+		if (cevent->stream < event->stream)
+			continue;
+
+		if (cevent->stream > event->stream ||
+		    cevent->mid != sin->mid)
+			break;
+
+		switch (cevent->msg_flags & SCTP_DATA_FRAG_MASK) {
+		case SCTP_DATA_FIRST_FRAG:
+			goto out;
+		case SCTP_DATA_MIDDLE_FRAG:
+			if (!first_frag) {
+				if (cevent->fsn = sin->fsn) {
+					first_frag = pos;
+					last_frag = pos;
+					next_fsn = cevent->fsn + 1;
+				}
+			} else if (cevent->fsn = next_fsn) {
+				last_frag = pos;
+				next_fsn++;
+			} else {
+				goto out;
+			}
+			break;
+		case SCTP_DATA_LAST_FRAG:
+			if (!first_frag) {
+				if (cevent->fsn = sin->fsn) {
+					first_frag = pos;
+					last_frag = pos;
+					next_fsn = 0;
+					is_last = 1;
+				}
+			} else if (cevent->fsn = next_fsn) {
+				last_frag = pos;
+				next_fsn = 0;
+				is_last = 1;
+			}
+			goto out;
+		default:
+			goto out;
+		}
+	}
+
+out:
+	if (!first_frag)
+		return NULL;
+
+	retval = sctp_make_reassembled_event(sock_net(ulpq->asoc->base.sk),
+					     &ulpq->reasm, first_frag,
+					     last_frag);
+	if (retval) {
+		sin->fsn = next_fsn;
+		if (is_last) {
+			retval->msg_flags |= MSG_EOR;
+			sin->pd_mode = 0;
+		}
+	}
+
+	return retval;
+}
+
+static struct sctp_ulpevent *sctp_intl_retrieve_reassembled(
+						struct sctp_ulpq *ulpq,
+						struct sctp_ulpevent *event)
+{
+	struct sctp_association *asoc = ulpq->asoc;
+	struct sk_buff *pos, *first_frag = NULL;
+	struct sctp_ulpevent *retval = NULL;
+	struct sk_buff *pd_first = NULL;
+	struct sk_buff *pd_last = NULL;
+	struct sctp_stream_in *sin;
+	__u32 next_fsn = 0;
+	__u32 pd_point = 0;
+	__u32 pd_len = 0;
+	__u32 mid = 0;
+
+	sin = sctp_stream_in(ulpq->asoc, event->stream);
+
+	skb_queue_walk(&ulpq->reasm, pos) {
+		struct sctp_ulpevent *cevent = sctp_skb2event(pos);
+
+		if (cevent->stream < event->stream)
+			continue;
+		if (cevent->stream > event->stream)
+			break;
+
+		if (MID_lt(cevent->mid, event->mid))
+			continue;
+		if (MID_lt(event->mid, cevent->mid))
+			break;
+
+		switch (cevent->msg_flags & SCTP_DATA_FRAG_MASK) {
+		case SCTP_DATA_FIRST_FRAG:
+			if (cevent->mid = sin->mid) {
+				pd_first = pos;
+				pd_last = pos;
+				pd_len = pos->len;
+			}
+
+			first_frag = pos;
+			next_fsn = 0;
+			mid = cevent->mid;
+			break;
+
+		case SCTP_DATA_MIDDLE_FRAG:
+			if (first_frag && cevent->mid = mid &&
+			    cevent->fsn = next_fsn) {
+				next_fsn++;
+				if (pd_first) {
+					pd_last = pos;
+					pd_len += pos->len;
+				}
+			} else {
+				first_frag = NULL;
+			}
+			break;
+
+		case SCTP_DATA_LAST_FRAG:
+			if (first_frag && cevent->mid = mid &&
+			    cevent->fsn = next_fsn)
+				goto found;
+			else
+				first_frag = NULL;
+			break;
+		}
+	}
+
+	if (!pd_first)
+		goto out;
+
+	pd_point = sctp_sk(asoc->base.sk)->pd_point;
+	if (pd_point && pd_point <= pd_len) {
+		retval = sctp_make_reassembled_event(sock_net(asoc->base.sk),
+						     &ulpq->reasm,
+						     pd_first, pd_last);
+		if (retval) {
+			sin->fsn = next_fsn;
+			sin->pd_mode = 1;
+		}
+	}
+	goto out;
+
+found:
+	retval = sctp_make_reassembled_event(sock_net(asoc->base.sk),
+					     &ulpq->reasm,
+					     first_frag, pos);
+	if (retval)
+		retval->msg_flags |= MSG_EOR;
+
+out:
+	return retval;
+}
+
+static struct sctp_ulpevent *sctp_intl_reasm(struct sctp_ulpq *ulpq,
+					     struct sctp_ulpevent *event)
+{
+	struct sctp_ulpevent *retval = NULL;
+	struct sctp_stream_in *sin;
+
+	if (SCTP_DATA_NOT_FRAG = (event->msg_flags & SCTP_DATA_FRAG_MASK)) {
+		event->msg_flags |= MSG_EOR;
+		return event;
+	}
+
+	sctp_intl_store_reasm(ulpq, event);
+
+	sin = sctp_stream_in(ulpq->asoc, event->stream);
+	if (sin->pd_mode && event->mid = sin->mid &&
+	    event->fsn = sin->fsn)
+		retval = sctp_intl_retrieve_partial(ulpq, event);
+
+	if (!retval)
+		retval = sctp_intl_retrieve_reassembled(ulpq, event);
+
+	return retval;
+}
+
+static void sctp_intl_store_ordered(struct sctp_ulpq *ulpq,
+				    struct sctp_ulpevent *event)
+{
+	struct sctp_ulpevent *cevent;
+	struct sk_buff *pos;
+
+	pos = skb_peek_tail(&ulpq->lobby);
+	if (!pos) {
+		__skb_queue_tail(&ulpq->lobby, sctp_event2skb(event));
+		return;
+	}
+
+	cevent = (struct sctp_ulpevent *)pos->cb;
+	if (event->stream = cevent->stream &&
+	    MID_lt(cevent->mid, event->mid)) {
+		__skb_queue_tail(&ulpq->lobby, sctp_event2skb(event));
+		return;
+	}
+
+	if (event->stream > cevent->stream) {
+		__skb_queue_tail(&ulpq->lobby, sctp_event2skb(event));
+		return;
+	}
+
+	skb_queue_walk(&ulpq->lobby, pos) {
+		cevent = (struct sctp_ulpevent *)pos->cb;
+
+		if (cevent->stream > event->stream)
+			break;
+
+		if (cevent->stream = event->stream &&
+		    MID_lt(event->mid, cevent->mid))
+			break;
+	}
+
+	__skb_queue_before(&ulpq->lobby, pos, sctp_event2skb(event));
+}
+
+static void sctp_intl_retrieve_ordered(struct sctp_ulpq *ulpq,
+				       struct sctp_ulpevent *event)
+{
+	struct sk_buff_head *event_list;
+	struct sctp_stream *stream;
+	struct sk_buff *pos, *tmp;
+	__u16 sid = event->stream;
+
+	stream  = &ulpq->asoc->stream;
+	event_list = (struct sk_buff_head *)sctp_event2skb(event)->prev;
+
+	sctp_skb_for_each(pos, &ulpq->lobby, tmp) {
+		struct sctp_ulpevent *cevent = (struct sctp_ulpevent *)pos->cb;
+
+		if (cevent->stream > sid)
+			break;
+
+		if (cevent->stream < sid)
+			continue;
+
+		if (cevent->mid != sctp_mid_peek(stream, in, sid))
+			break;
+
+		sctp_mid_next(stream, in, sid);
+
+		__skb_unlink(pos, &ulpq->lobby);
+
+		__skb_queue_tail(event_list, pos);
+	}
+}
+
+static struct sctp_ulpevent *sctp_intl_order(struct sctp_ulpq *ulpq,
+					     struct sctp_ulpevent *event)
+{
+	struct sctp_stream *stream;
+	__u16 sid;
+
+	if (event->msg_flags & SCTP_DATA_UNORDERED)
+		return event;
+
+	stream  = &ulpq->asoc->stream;
+	sid = event->stream;
+
+	if (event->mid != sctp_mid_peek(stream, in, sid)) {
+		sctp_intl_store_ordered(ulpq, event);
+		return NULL;
+	}
+
+	sctp_mid_next(stream, in, sid);
+
+	sctp_intl_retrieve_ordered(ulpq, event);
+
+	return event;
+}
+
+static int sctp_enqueue_event(struct sctp_ulpq *ulpq,
+			      struct sctp_ulpevent *event)
+{
+	struct sk_buff *skb = sctp_event2skb(event);
+	struct sock *sk = ulpq->asoc->base.sk;
+	struct sctp_sock *sp = sctp_sk(sk);
+	struct sk_buff_head *skb_list;
+
+	skb_list = (struct sk_buff_head *)skb->prev;
+
+	if (sk->sk_shutdown & RCV_SHUTDOWN &&
+	    (sk->sk_shutdown & SEND_SHUTDOWN ||
+	     !sctp_ulpevent_is_notification(event)))
+		goto out_free;
+
+	if (!sctp_ulpevent_is_notification(event)) {
+		sk_mark_napi_id(sk, skb);
+		sk_incoming_cpu_update(sk);
+	}
+
+	if (!sctp_ulpevent_is_enabled(event, &sp->subscribe))
+		goto out_free;
+
+	if (skb_list)
+		skb_queue_splice_tail_init(skb_list,
+					   &sk->sk_receive_queue);
+	else
+		__skb_queue_tail(&sk->sk_receive_queue, skb);
+
+	if (!sp->data_ready_signalled) {
+		sp->data_ready_signalled = 1;
+		sk->sk_data_ready(sk);
+	}
+
+	return 1;
+
+out_free:
+	if (skb_list)
+		sctp_queue_purge_ulpevents(skb_list);
+	else
+		sctp_ulpevent_free(event);
+
+	return 0;
+}
+
+static int sctp_ulpevent_idata(struct sctp_ulpq *ulpq,
+			       struct sctp_chunk *chunk, gfp_t gfp)
+{
+	struct sctp_ulpevent *event;
+	struct sk_buff_head temp;
+	int event_eor = 0;
+
+	event = sctp_ulpevent_make_rcvmsg(chunk->asoc, chunk, gfp);
+	if (!event)
+		return -ENOMEM;
+
+	event->mid = ntohl(chunk->subh.idata_hdr->mid);
+	if (event->msg_flags & SCTP_DATA_FIRST_FRAG)
+		event->ppid = chunk->subh.idata_hdr->ppid;
+	else
+		event->fsn = ntohl(chunk->subh.idata_hdr->fsn);
+
+	event = sctp_intl_reasm(ulpq, event);
+	if (event && event->msg_flags & MSG_EOR) {
+		skb_queue_head_init(&temp);
+		__skb_queue_tail(&temp, sctp_event2skb(event));
+
+		event = sctp_intl_order(ulpq, event);
+	}
+
+	if (event) {
+		event_eor = (event->msg_flags & MSG_EOR) ? 1 : 0;
+		sctp_enqueue_event(ulpq, event);
+	}
+
+	return event_eor;
+}
+
 static struct sctp_stream_interleave sctp_stream_interleave_0 = {
 	.data_chunk_len		= sizeof(struct sctp_data_chunk),
 	/* DATA process functions */
 	.make_datafrag		= sctp_make_datafrag_empty,
 	.assign_number		= sctp_chunk_assign_ssn,
 	.validate_data		= sctp_validate_data,
+	.ulpevent_data		= sctp_ulpq_tail_data,
 };
 
 static struct sctp_stream_interleave sctp_stream_interleave_1 = {
@@ -143,6 +560,7 @@ static struct sctp_stream_interleave sctp_stream_interleave_1 = {
 	.make_datafrag		= sctp_make_idatafrag_empty,
 	.assign_number		= sctp_chunk_assign_mid,
 	.validate_data		= sctp_validate_idata,
+	.ulpevent_data		= sctp_ulpevent_idata,
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream)
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index 650b634..d3218f3 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -705,8 +705,6 @@ struct sctp_ulpevent *sctp_ulpevent_make_rcvmsg(struct sctp_association *asoc,
 	sctp_ulpevent_receive_data(event, asoc);
 
 	event->stream = ntohs(chunk->subh.data_hdr->stream);
-	event->ssn = ntohs(chunk->subh.data_hdr->ssn);
-	event->ppid = chunk->subh.data_hdr->ppid;
 	if (chunk->chunk_hdr->flags & SCTP_DATA_UNORDERED) {
 		event->flags |= SCTP_UNORDERED;
 		event->cumtsn = sctp_tsnmap_get_ctsn(&asoc->peer.tsn_map);
diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index a71be33..0d07f2a 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -104,6 +104,9 @@ int sctp_ulpq_tail_data(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk,
 	if (!event)
 		return -ENOMEM;
 
+	event->ssn = ntohs(chunk->subh.data_hdr->ssn);
+	event->ppid = chunk->subh.data_hdr->ppid;
+
 	/* Do reassembly if needed.  */
 	event = sctp_ulpq_reasm(ulpq, event);
 
@@ -328,9 +331,10 @@ static void sctp_ulpq_store_reasm(struct sctp_ulpq *ulpq,
  * payload was fragmented on the way and ip had to reassemble them.
  * We add the rest of skb's to the first skb's fraglist.
  */
-static struct sctp_ulpevent *sctp_make_reassembled_event(struct net *net,
-	struct sk_buff_head *queue, struct sk_buff *f_frag,
-	struct sk_buff *l_frag)
+struct sctp_ulpevent *sctp_make_reassembled_event(struct net *net,
+						  struct sk_buff_head *queue,
+						  struct sk_buff *f_frag,
+						  struct sk_buff *l_frag)
 {
 	struct sk_buff *pos;
 	struct sk_buff *new = NULL;
@@ -853,7 +857,7 @@ static struct sctp_ulpevent *sctp_ulpq_order(struct sctp_ulpq *ulpq,
 	struct sctp_stream *stream;
 
 	/* Check if this message needs ordering.  */
-	if (SCTP_DATA_UNORDERED & event->msg_flags)
+	if (event->msg_flags & SCTP_DATA_UNORDERED)
 		return event;
 
 	/* Note: The stream ID must be verified before this routine.  */
-- 
2.1.0

