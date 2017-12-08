From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 08 Dec 2017 13:04:02 +0000
Subject: [PATCHv2 net-next 05/12] sctp: implement assign_number for sctp_stream_interleave
Message-Id: <be593df99566267deff68ff477d2355dfffada80.1512738021.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512738021.git.lucien.xin@gmail.com>
 <2fef1243f8181062aeb17f7052e5b022ec274a8e.1512738021.git.lucien.xin@gmail.com>
 <7347f16f5b620ed98fdb5f7ac54db4a70e1fd27e.1512738021.git.lucien.xin@gmail.com>
 <9a2bf9495313a79f0bbffb8edaaef25269804feb.1512738021.git.lucien.xin@gmail.com>
 <ed729ca6023dea0812e4caa4d5da3259df375127.1512738021.git.lucien.xin@gmail.com>
In-Reply-To: <ed729ca6023dea0812e4caa4d5da3259df375127.1512738021.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

assign_number is added as a member of sctp_stream_interleave, used
to assign ssn for data or mid (message id) for idata, called in
sctp_packet_append_data. sctp_chunk_assign_ssn is left as it is,
and sctp_chunk_assign_mid is added for sctp_stream_interleave_1.

This procedure is described in section 2.2.2 of RFC8260.

All sizeof(struct sctp_data_chunk) in tx path is replaced with
sctp_datachk_len, to make it right for idata as well. And also
adjust sctp_chunk_is_data for SCTP_CID_I_DATA.

After this patch, idata can be built and sent in tx path.

Note that if sp strm_interleave is set, it has to wait_connect in
sctp_sendmsg, as asoc intl_enable need to be known after 4 shake-
hands, to decide if it should use data or idata later. data and
idata can't be mixed to send in one asoc.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 include/net/sctp/constants.h         |  9 +++++----
 include/net/sctp/sctp.h              |  4 ++--
 include/net/sctp/sm.h                |  2 +-
 include/net/sctp/stream_interleave.h |  1 +
 include/net/sctp/structs.h           | 18 +++++++++++++++++-
 net/sctp/output.c                    |  5 +++--
 net/sctp/socket.c                    | 17 +++++++++++++++--
 net/sctp/stream_interleave.c         | 37 ++++++++++++++++++++++++++++++++++++
 net/sctp/ulpevent.c                  |  4 ++--
 9 files changed, 83 insertions(+), 14 deletions(-)

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index deaafa9..20ff237 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -145,12 +145,13 @@ SCTP_SUBTYPE_CONSTRUCTOR(OTHER,		enum sctp_event_other,	other)
 SCTP_SUBTYPE_CONSTRUCTOR(PRIMITIVE,	enum sctp_event_primitive, primitive)
 
 
-#define sctp_chunk_is_data(a) (a->chunk_hdr->type = SCTP_CID_DATA)
+#define sctp_chunk_is_data(a) (a->chunk_hdr->type = SCTP_CID_DATA || \
+			       a->chunk_hdr->type = SCTP_CID_I_DATA)
 
 /* Calculate the actual data size in a data chunk */
-#define SCTP_DATA_SNDSIZE(c) ((int)((unsigned long)(c->chunk_end)\
-		       		- (unsigned long)(c->chunk_hdr)\
-				- sizeof(struct sctp_data_chunk)))
+#define SCTP_DATA_SNDSIZE(c) ((int)((unsigned long)(c->chunk_end) - \
+				    (unsigned long)(c->chunk_hdr) - \
+				    sctp_datachk_len(&c->asoc->stream)))
 
 /* Internal error codes */
 enum sctp_ierror {
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 906a9c0..63ac57e 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -444,13 +444,13 @@ static inline int sctp_frag_point(const struct sctp_association *asoc, int pmtu)
 	int frag = pmtu;
 
 	frag -= sp->pf->af->net_header_len;
-	frag -= sizeof(struct sctphdr) + sizeof(struct sctp_data_chunk);
+	frag -= sizeof(struct sctphdr) + sctp_datachk_len(&asoc->stream);
 
 	if (asoc->user_frag)
 		frag = min_t(int, frag, asoc->user_frag);
 
 	frag = SCTP_TRUNC4(min_t(int, frag, SCTP_MAX_CHUNK_LEN -
-					    sizeof(struct sctp_data_chunk)));
+					    sctp_datachk_len(&asoc->stream)));
 
 	return frag;
 }
diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index f950186..ca1db89 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -343,7 +343,7 @@ static inline __u16 sctp_data_size(struct sctp_chunk *chunk)
 	__u16 size;
 
 	size = ntohs(chunk->chunk_hdr->length);
-	size -= sizeof(struct sctp_data_chunk);
+	size -= sctp_datahdr_len(&chunk->asoc->stream);
 
 	return size;
 }
diff --git a/include/net/sctp/stream_interleave.h b/include/net/sctp/stream_interleave.h
index 7b9fa8d..99f399e 100644
--- a/include/net/sctp/stream_interleave.h
+++ b/include/net/sctp/stream_interleave.h
@@ -37,6 +37,7 @@ struct sctp_stream_interleave {
 	struct sctp_chunk *(*make_datafrag)(const struct sctp_association *asoc,
 					    const struct sctp_sndrcvinfo *sinfo,
 					    int len, __u8 flags, gfp_t gfp);
+	void	(*assign_number)(struct sctp_chunk *chunk);
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 96cc898..fd93973 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -399,6 +399,18 @@ void sctp_stream_update(struct sctp_stream *stream, struct sctp_stream *new);
 #define sctp_ssn_skip(stream, type, sid, ssn) \
 	((stream)->type[sid].ssn = ssn + 1)
 
+/* What is the current MID number for this stream? */
+#define sctp_mid_peek(stream, type, sid) \
+	((stream)->type[sid].mid)
+
+/* Return the next MID number for this stream.  */
+#define sctp_mid_next(stream, type, sid) \
+	((stream)->type[sid].mid++)
+
+/* Skip over this mid and all below. */
+#define sctp_mid_skip(stream, type, sid, mid) \
+	((stream)->type[sid].mid = mid + 1)
+
 /*
  * Pointers to address related SCTP functions.
  * (i.e. things that depend on the address family.)
@@ -623,6 +635,7 @@ struct sctp_chunk {
 	__u16	rtt_in_progress:1,	/* This chunk used for RTT calc? */
 		has_tsn:1,		/* Does this chunk have a TSN yet? */
 		has_ssn:1,		/* Does this chunk have a SSN yet? */
+#define has_mid has_ssn
 		singleton:1,		/* Only chunk in the packet? */
 		end_of_packet:1,	/* Last chunk in the packet? */
 		ecn_ce_done:1,		/* Have we processed the ECN CE bit? */
@@ -1360,7 +1373,10 @@ struct sctp_stream_out_ext {
 };
 
 struct sctp_stream_out {
-	__u16	ssn;
+	union {
+		__u32 mid;
+		__u16 ssn;
+	};
 	__u8	state;
 	struct sctp_stream_out_ext *ext;
 };
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 4a865cd..01a26ee0 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -313,6 +313,7 @@ static enum sctp_xmit __sctp_packet_append_chunk(struct sctp_packet *packet,
 	/* We believe that this chunk is OK to add to the packet */
 	switch (chunk->chunk_hdr->type) {
 	case SCTP_CID_DATA:
+	case SCTP_CID_I_DATA:
 		/* Account for the data being in the packet */
 		sctp_packet_append_data(packet, chunk);
 		/* Disallow SACK bundling after DATA. */
@@ -724,7 +725,7 @@ static enum sctp_xmit sctp_packet_can_append_data(struct sctp_packet *packet,
 	 * or delay in hopes of bundling a full sized packet.
 	 */
 	if (chunk->skb->len + q->out_qlen > transport->pathmtu -
-		packet->overhead - sizeof(struct sctp_data_chunk) - 4)
+	    packet->overhead - sctp_datachk_len(&chunk->asoc->stream) - 4)
 		/* Enough data queued to fill a packet */
 		return SCTP_XMIT_OK;
 
@@ -759,7 +760,7 @@ static void sctp_packet_append_data(struct sctp_packet *packet,
 
 	asoc->peer.rwnd = rwnd;
 	sctp_chunk_assign_tsn(chunk);
-	sctp_chunk_assign_ssn(chunk);
+	asoc->stream.si->assign_number(chunk);
 }
 
 static enum sctp_xmit sctp_packet_will_fit(struct sctp_packet *packet,
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 8c33463..036f945 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2002,7 +2002,20 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 		if (err < 0)
 			goto out_free;
 
-		wait_connect = true;
+		/* If stream interleave is enabled, wait_connect has to be
+		 * done earlier than data enqueue, as it needs to make data
+		 * or idata according to asoc->intl_enable which is set
+		 * after connection is done.
+		 */
+		if (sctp_sk(asoc->base.sk)->strm_interleave) {
+			timeo = sock_sndtimeo(sk, 0);
+			err = sctp_wait_for_connect(asoc, &timeo);
+			if (err)
+				goto out_unlock;
+		} else {
+			wait_connect = true;
+		}
+
 		pr_debug("%s: we associated primitively\n", __func__);
 	}
 
@@ -3180,7 +3193,7 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 		if (val = 0) {
 			val = asoc->pathmtu - sp->pf->af->net_header_len;
 			val -= sizeof(struct sctphdr) +
-			       sizeof(struct sctp_data_chunk);
+			       sctp_datachk_len(&asoc->stream);
 		}
 		asoc->user_frag = val;
 		asoc->frag_point = sctp_frag_point(asoc, asoc->pathmtu);
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 397c3c1..3ac47e7 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -57,16 +57,53 @@ static struct sctp_chunk *sctp_make_idatafrag_empty(
 	return retval;
 }
 
+static void sctp_chunk_assign_mid(struct sctp_chunk *chunk)
+{
+	struct sctp_stream *stream;
+	struct sctp_chunk *lchunk;
+	__u32 cfsn = 0;
+	__u16 sid;
+
+	if (chunk->has_mid)
+		return;
+
+	sid = sctp_chunk_stream_no(chunk);
+	stream = &chunk->asoc->stream;
+
+	list_for_each_entry(lchunk, &chunk->msg->chunks, frag_list) {
+		struct sctp_idatahdr *hdr;
+
+		lchunk->has_mid = 1;
+
+		if (lchunk->chunk_hdr->flags & SCTP_DATA_UNORDERED)
+			continue;
+
+		hdr = lchunk->subh.idata_hdr;
+
+		if (lchunk->chunk_hdr->flags & SCTP_DATA_FIRST_FRAG)
+			hdr->ppid = lchunk->sinfo.sinfo_ppid;
+		else
+			hdr->fsn = htonl(cfsn++);
+
+		if (lchunk->chunk_hdr->flags & SCTP_DATA_LAST_FRAG)
+			hdr->mid = htonl(sctp_mid_next(stream, out, sid));
+		else
+			hdr->mid = htonl(sctp_mid_peek(stream, out, sid));
+	}
+}
+
 static struct sctp_stream_interleave sctp_stream_interleave_0 = {
 	.data_chunk_len		= sizeof(struct sctp_data_chunk),
 	/* DATA process functions */
 	.make_datafrag		= sctp_make_datafrag_empty,
+	.assign_number		= sctp_chunk_assign_ssn,
 };
 
 static struct sctp_stream_interleave sctp_stream_interleave_1 = {
 	.data_chunk_len		= sizeof(struct sctp_idata_chunk),
 	/* I-DATA process functions */
 	.make_datafrag		= sctp_make_idatafrag_empty,
+	.assign_number		= sctp_chunk_assign_mid,
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream)
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index 5447228..650b634 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -443,8 +443,8 @@ struct sctp_ulpevent *sctp_ulpevent_make_send_failed(
 		goto fail;
 
 	/* Pull off the common chunk header and DATA header.  */
-	skb_pull(skb, sizeof(struct sctp_data_chunk));
-	len -= sizeof(struct sctp_data_chunk);
+	skb_pull(skb, sctp_datachk_len(&asoc->stream));
+	len -= sctp_datachk_len(&asoc->stream);
 
 	/* Embed the event fields inside the cloned skb.  */
 	event = sctp_skb2event(skb);
-- 
2.1.0

