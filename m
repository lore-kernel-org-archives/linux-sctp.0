From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 05 Dec 2017 15:16:09 +0000
Subject: [PATCH net-next 12/12] sctp: add support for the process of unordered idata
Message-Id: <06ac53ffb35eeb3528c601012c17ccdb1f84f603.1512486606.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512486606.git.lucien.xin@gmail.com>
 <b830faf5987dbed8b1e724f039348e960b8537e3.1512486606.git.lucien.xin@gmail.com>
 <590ee9b2ecf13733272f9bb1888c60de1f5f47a4.1512486606.git.lucien.xin@gmail.com>
 <4facf144fb29f5b161dd665e3326311001812a1c.1512486606.git.lucien.xin@gmail.com>
 <b8551388363da7b56f7e56132414c1399557a12d.1512486606.git.lucien.xin@gmail.com>
 <ddf7cc34d5fdbdcbe3e8b4e546799c55edff5ca2.1512486606.git.lucien.xin@gmail.com>
 <010d0fbcbdcb70224859dc281e622e0fdf6f46c5.1512486606.git.lucien.xin@gmail.com>
 <7dd410b23c38f41fb8402880185f5e583dabbc04.1512486606.git.lucien.xin@gmail.com>
 <08ec459b56ee8c72c588bdb2350d5619e3678ae5.1512486606.git.lucien.xin@gmail.com>
 <167166ed3ee953dbcee3aef43496d8c7b44c6b95.1512486606.git.lucien.xin@gmail.com>
 <ee787d191e0c861159d4d4fabb9db13d2168e55f.1512486606.git.lucien.xin@gmail.com>
 <9ef61f4b411eb7245ccfb6cd5b0d8eb7cf6b23cb.1512486606.git.lucien.xin@gmail.com>
In-Reply-To: <9ef61f4b411eb7245ccfb6cd5b0d8eb7cf6b23cb.1512486606.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Unordered idata process is more complicated than unordered data:

 - It has to add mid into sctp_stream_out to save the next mid value,
   which is separated from ordered idata's.

 - To support pd for unordered idata, another mid and pd_mode need to
   be added to save the message id and pd state in sctp_stream_in.

 - To make  unordered idata reasm easier, it adds a new event queue
   to save frags for idata.

The patch mostly adds the samilar reasm functions for unordered idata
as ordered idata's, and also adjusts some other codes on assign_mid,
abort_pd and ulpevent_data for idata.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h   |  14 +-
 include/net/sctp/ulpqueue.h  |   1 +
 net/sctp/socket.c            |  23 ++-
 net/sctp/stream_interleave.c | 377 ++++++++++++++++++++++++++++++++++++++++---
 net/sctp/ulpqueue.c          |   5 +
 5 files changed, 392 insertions(+), 28 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index d7da719..e43ed30 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -413,6 +413,14 @@ void sctp_stream_update(struct sctp_stream *stream, struct sctp_stream *new);
 
 #define sctp_stream_in(asoc, sid) (&(asoc)->stream.in[sid])
 
+/* What is the current MID_uo number for this stream? */
+#define sctp_mid_uo_peek(stream, type, sid) \
+	((stream)->type[sid].mid_uo)
+
+/* Return the next MID_uo number for this stream.  */
+#define sctp_mid_uo_next(stream, type, sid) \
+	((stream)->type[sid].mid_uo++)
+
 /*
  * Pointers to address related SCTP functions.
  * (i.e. things that depend on the address family.)
@@ -1378,8 +1386,9 @@ struct sctp_stream_out {
 		__u32 mid;
 		__u16 ssn;
 	};
-	__u8	state;
+	__u32 mid_uo;
 	struct sctp_stream_out_ext *ext;
+	__u8 state;
 };
 
 struct sctp_stream_in {
@@ -1387,8 +1396,11 @@ struct sctp_stream_in {
 		__u32 mid;
 		__u16 ssn;
 	};
+	__u32 mid_uo;
 	__u32 fsn;
+	__u32 fsn_uo;
 	char pd_mode;
+	char pd_mode_uo;
 };
 
 struct sctp_stream {
diff --git a/include/net/sctp/ulpqueue.h b/include/net/sctp/ulpqueue.h
index eb98c71..bb0ecba 100644
--- a/include/net/sctp/ulpqueue.h
+++ b/include/net/sctp/ulpqueue.h
@@ -45,6 +45,7 @@ struct sctp_ulpq {
 	char pd_mode;
 	struct sctp_association *asoc;
 	struct sk_buff_head reasm;
+	struct sk_buff_head reasm_uo;
 	struct sk_buff_head lobby;
 };
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index fe2cab9..db8e7cc 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -201,6 +201,22 @@ static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
 		cb(chunk);
 }
 
+static void sctp_for_each_rx_skb(struct sctp_association *asoc, struct sock *sk,
+				 void (*cb)(struct sk_buff *, struct sock *))
+
+{
+	struct sk_buff *skb, *tmp;
+
+	sctp_skb_for_each(skb, &asoc->ulpq.lobby, tmp)
+		cb(skb, sk);
+
+	sctp_skb_for_each(skb, &asoc->ulpq.reasm, tmp)
+		cb(skb, sk);
+
+	sctp_skb_for_each(skb, &asoc->ulpq.reasm_uo, tmp)
+		cb(skb, sk);
+}
+
 /* Verify that this is a valid address. */
 static inline int sctp_verify_addr(struct sock *sk, union sctp_addr *addr,
 				   int len)
@@ -1554,6 +1570,7 @@ static void sctp_close(struct sock *sk, long timeout)
 
 		if (data_was_unread || !skb_queue_empty(&asoc->ulpq.lobby) ||
 		    !skb_queue_empty(&asoc->ulpq.reasm) ||
+		    !skb_queue_empty(&asoc->ulpq.reasm_uo) ||
 		    (sock_flag(sk, SOCK_LINGER) && !sk->sk_lingertime)) {
 			struct sctp_chunk *chunk;
 
@@ -8507,11 +8524,7 @@ static void sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 
 	}
 
-	sctp_skb_for_each(skb, &assoc->ulpq.reasm, tmp)
-		sctp_skb_set_owner_r_frag(skb, newsk);
-
-	sctp_skb_for_each(skb, &assoc->ulpq.lobby, tmp)
-		sctp_skb_set_owner_r_frag(skb, newsk);
+	sctp_for_each_rx_skb(assoc, newsk, sctp_skb_set_owner_r_frag);
 
 	/* Set the type of socket to indicate that it is peeled off from the
 	 * original UDP-style socket or created with the accept() call on a
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 1014de2..c469703 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -74,12 +74,10 @@ static void sctp_chunk_assign_mid(struct sctp_chunk *chunk)
 
 	list_for_each_entry(lchunk, &chunk->msg->chunks, frag_list) {
 		struct sctp_idatahdr *hdr;
+		__u32 mid;
 
 		lchunk->has_mid = 1;
 
-		if (lchunk->chunk_hdr->flags & SCTP_DATA_UNORDERED)
-			continue;
-
 		hdr = lchunk->subh.idata_hdr;
 
 		if (lchunk->chunk_hdr->flags & SCTP_DATA_FIRST_FRAG)
@@ -87,10 +85,16 @@ static void sctp_chunk_assign_mid(struct sctp_chunk *chunk)
 		else
 			hdr->fsn = htonl(cfsn++);
 
-		if (lchunk->chunk_hdr->flags & SCTP_DATA_LAST_FRAG)
-			hdr->mid = htonl(sctp_mid_next(stream, out, sid));
-		else
-			hdr->mid = htonl(sctp_mid_peek(stream, out, sid));
+		if (lchunk->chunk_hdr->flags & SCTP_DATA_UNORDERED) {
+			mid = lchunk->chunk_hdr->flags & SCTP_DATA_LAST_FRAG ?
+				sctp_mid_uo_next(stream, out, sid) :
+				sctp_mid_uo_peek(stream, out, sid);
+		} else {
+			mid = lchunk->chunk_hdr->flags & SCTP_DATA_LAST_FRAG ?
+				sctp_mid_next(stream, out, sid) :
+				sctp_mid_peek(stream, out, sid);
+		}
+		hdr->mid = htonl(mid);
 	}
 }
 
@@ -449,9 +453,6 @@ static struct sctp_ulpevent *sctp_intl_order(struct sctp_ulpq *ulpq,
 	struct sctp_stream *stream;
 	__u16 sid;
 
-	if (event->msg_flags & SCTP_DATA_UNORDERED)
-		return event;
-
 	stream  = &ulpq->asoc->stream;
 	sid = event->stream;
 
@@ -512,6 +513,317 @@ static int sctp_enqueue_event(struct sctp_ulpq *ulpq,
 	return 0;
 }
 
+static void sctp_intl_store_reasm_uo(struct sctp_ulpq *ulpq,
+				     struct sctp_ulpevent *event)
+{
+	struct sctp_ulpevent *cevent;
+	struct sk_buff *pos;
+
+	pos = skb_peek_tail(&ulpq->reasm_uo);
+	if (!pos) {
+		__skb_queue_tail(&ulpq->reasm_uo, sctp_event2skb(event));
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
+		__skb_queue_tail(&ulpq->reasm_uo, sctp_event2skb(event));
+		return;
+	}
+
+	if ((event->stream = cevent->stream &&
+	     MID_lt(cevent->mid, event->mid)) ||
+	    event->stream > cevent->stream) {
+		__skb_queue_tail(&ulpq->reasm_uo, sctp_event2skb(event));
+		return;
+	}
+
+	skb_queue_walk(&ulpq->reasm_uo, pos) {
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
+	__skb_queue_before(&ulpq->reasm_uo, pos, sctp_event2skb(event));
+}
+
+static struct sctp_ulpevent *sctp_intl_retrieve_partial_uo(
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
+	skb_queue_walk(&ulpq->reasm_uo, pos) {
+		struct sctp_ulpevent *cevent = sctp_skb2event(pos);
+
+		if (cevent->stream < event->stream)
+			continue;
+		if (cevent->stream > event->stream)
+			break;
+
+		if (MID_lt(cevent->mid, sin->mid_uo))
+			continue;
+		if (MID_lt(sin->mid_uo, cevent->mid))
+			break;
+
+		switch (cevent->msg_flags & SCTP_DATA_FRAG_MASK) {
+		case SCTP_DATA_FIRST_FRAG:
+			goto out;
+		case SCTP_DATA_MIDDLE_FRAG:
+			if (!first_frag) {
+				if (cevent->fsn = sin->fsn_uo) {
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
+				if (cevent->fsn = sin->fsn_uo) {
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
+					     &ulpq->reasm_uo, first_frag,
+					     last_frag);
+	if (retval) {
+		sin->fsn_uo = next_fsn;
+		if (is_last) {
+			retval->msg_flags |= MSG_EOR;
+			sin->pd_mode_uo = 0;
+		}
+	}
+
+	return retval;
+}
+
+static struct sctp_ulpevent *sctp_intl_retrieve_reassembled_uo(
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
+	skb_queue_walk(&ulpq->reasm_uo, pos) {
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
+			if (!sin->pd_mode_uo) {
+				sin->mid_uo = cevent->mid;
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
+						     &ulpq->reasm_uo,
+						     pd_first, pd_last);
+		if (retval) {
+			sin->fsn_uo = next_fsn;
+			sin->pd_mode_uo = 1;
+		}
+	}
+	goto out;
+
+found:
+	retval = sctp_make_reassembled_event(sock_net(asoc->base.sk),
+					     &ulpq->reasm_uo,
+					     first_frag, pos);
+	if (retval)
+		retval->msg_flags |= MSG_EOR;
+
+out:
+	return retval;
+}
+
+static struct sctp_ulpevent *sctp_intl_reasm_uo(struct sctp_ulpq *ulpq,
+						struct sctp_ulpevent *event)
+{
+	struct sctp_ulpevent *retval = NULL;
+	struct sctp_stream_in *sin;
+
+	if (SCTP_DATA_NOT_FRAG = (event->msg_flags & SCTP_DATA_FRAG_MASK)) {
+		event->msg_flags |= MSG_EOR;
+		return event;
+	}
+
+	sctp_intl_store_reasm_uo(ulpq, event);
+
+	sin = sctp_stream_in(ulpq->asoc, event->stream);
+	if (sin->pd_mode_uo && event->mid = sin->mid_uo &&
+	    event->fsn = sin->fsn_uo)
+		retval = sctp_intl_retrieve_partial_uo(ulpq, event);
+
+	if (!retval)
+		retval = sctp_intl_retrieve_reassembled_uo(ulpq, event);
+
+	return retval;
+}
+
+static struct sctp_ulpevent *sctp_intl_retrieve_first_uo(struct sctp_ulpq *ulpq)
+{
+	struct sctp_stream_in *csin, *sin;
+	struct sk_buff *first_frag = NULL;
+	struct sk_buff *last_frag = NULL;
+	struct sctp_ulpevent *retval;
+	struct sk_buff *pos;
+	__u32 next_fsn = 0;
+	__u16 sid = 0;
+
+	skb_queue_walk(&ulpq->reasm_uo, pos) {
+		struct sctp_ulpevent *cevent = sctp_skb2event(pos);
+
+		csin = sctp_stream_in(ulpq->asoc, cevent->stream);
+		if (csin->pd_mode_uo)
+			continue;
+
+		switch (cevent->msg_flags & SCTP_DATA_FRAG_MASK) {
+		case SCTP_DATA_FIRST_FRAG:
+			if (first_frag)
+				goto out;
+			first_frag = pos;
+			last_frag = pos;
+			next_fsn = 0;
+			sin = csin;
+			sid = cevent->stream;
+			sin->mid_uo = cevent->mid;
+			break;
+		case SCTP_DATA_MIDDLE_FRAG:
+			if (!first_frag)
+				break;
+			if (cevent->stream = sid &&
+			    cevent->mid = sin->mid_uo &&
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
+					     &ulpq->reasm_uo, first_frag,
+					     last_frag);
+	if (retval) {
+		sin->fsn_uo = next_fsn;
+		sin->pd_mode_uo = 1;
+	}
+
+	return retval;
+}
+
 static int sctp_ulpevent_idata(struct sctp_ulpq *ulpq,
 			       struct sctp_chunk *chunk, gfp_t gfp)
 {
@@ -529,12 +841,16 @@ static int sctp_ulpevent_idata(struct sctp_ulpq *ulpq,
 	else
 		event->fsn = ntohl(chunk->subh.idata_hdr->fsn);
 
-	event = sctp_intl_reasm(ulpq, event);
-	if (event && event->msg_flags & MSG_EOR) {
-		skb_queue_head_init(&temp);
-		__skb_queue_tail(&temp, sctp_event2skb(event));
+	if (!(event->msg_flags & SCTP_DATA_UNORDERED)) {
+		event = sctp_intl_reasm(ulpq, event);
+		if (event && event->msg_flags & MSG_EOR) {
+			skb_queue_head_init(&temp);
+			__skb_queue_tail(&temp, sctp_event2skb(event));
 
-		event = sctp_intl_order(ulpq, event);
+			event = sctp_intl_order(ulpq, event);
+		}
+	} else {
+		event = sctp_intl_reasm_uo(ulpq, event);
 	}
 
 	if (event) {
@@ -614,14 +930,21 @@ static void sctp_intl_start_pd(struct sctp_ulpq *ulpq, gfp_t gfp)
 {
 	struct sctp_ulpevent *event;
 
-	if (skb_queue_empty(&ulpq->reasm))
-		return;
+	if (!skb_queue_empty(&ulpq->reasm)) {
+		do {
+			event = sctp_intl_retrieve_first(ulpq);
+			if (event)
+				sctp_enqueue_event(ulpq, event);
+		} while (event);
+	}
 
-	do {
-		event = sctp_intl_retrieve_first(ulpq);
-		if (event)
-			sctp_enqueue_event(ulpq, event);
-	} while (event);
+	if (!skb_queue_empty(&ulpq->reasm_uo)) {
+		do {
+			event = sctp_intl_retrieve_first_uo(ulpq);
+			if (event)
+				sctp_enqueue_event(ulpq, event);
+		} while (event);
+	}
 }
 
 static void sctp_renege_events(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk,
@@ -643,6 +966,9 @@ static void sctp_renege_events(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk,
 		if (freed < needed)
 			freed += sctp_ulpq_renege_list(ulpq, &ulpq->reasm,
 						       needed);
+		if (freed < needed)
+			freed += sctp_ulpq_renege_list(ulpq, &ulpq->reasm_uo,
+						       needed);
 	}
 
 	if (chunk && freed >= needed)
@@ -734,6 +1060,13 @@ static void sctp_intl_abort_pd(struct sctp_ulpq *ulpq, gfp_t gfp)
 		struct sctp_stream_in *sin = &stream->in[sid];
 		__u32 mid;
 
+		if (sin->pd_mode_uo) {
+			sin->pd_mode_uo = 0;
+
+			mid = sin->mid_uo;
+			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1, gfp);
+		}
+
 		if (sin->pd_mode) {
 			sin->pd_mode = 0;
 
diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index dd53daa..97fae53 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -60,6 +60,7 @@ struct sctp_ulpq *sctp_ulpq_init(struct sctp_ulpq *ulpq,
 
 	ulpq->asoc = asoc;
 	skb_queue_head_init(&ulpq->reasm);
+	skb_queue_head_init(&ulpq->reasm_uo);
 	skb_queue_head_init(&ulpq->lobby);
 	ulpq->pd_mode  = 0;
 
@@ -83,6 +84,10 @@ void sctp_ulpq_flush(struct sctp_ulpq *ulpq)
 		sctp_ulpevent_free(event);
 	}
 
+	while ((skb = __skb_dequeue(&ulpq->reasm_uo)) != NULL) {
+		event = sctp_skb2event(skb);
+		sctp_ulpevent_free(event);
+	}
 }
 
 /* Dispose of a ulpqueue.  */
-- 
2.1.0

