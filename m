From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 05 Dec 2017 15:16:03 +0000
Subject: [PATCH net-next 06/12] sctp: implement validate_data for sctp_stream_interleave
Message-Id: <010d0fbcbdcb70224859dc281e622e0fdf6f46c5.1512486606.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512486606.git.lucien.xin@gmail.com>
 <b830faf5987dbed8b1e724f039348e960b8537e3.1512486606.git.lucien.xin@gmail.com>
 <590ee9b2ecf13733272f9bb1888c60de1f5f47a4.1512486606.git.lucien.xin@gmail.com>
 <4facf144fb29f5b161dd665e3326311001812a1c.1512486606.git.lucien.xin@gmail.com>
 <b8551388363da7b56f7e56132414c1399557a12d.1512486606.git.lucien.xin@gmail.com>
 <ddf7cc34d5fdbdcbe3e8b4e546799c55edff5ca2.1512486606.git.lucien.xin@gmail.com>
In-Reply-To: <ddf7cc34d5fdbdcbe3e8b4e546799c55edff5ca2.1512486606.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

validate_data is added as a member of sctp_stream_interleave, used
to validate ssn/chunk type for data or mid (message id)/chunk type
for idata, called in sctp_eat_data.

If this check fails, an abort packet will be sent, as says in
section 2.2.3 of RFC8260.

It also adds the process for idata in rx path. As Marcelo pointed
out, there's no need to add event table for idata, but just share
chunk_event_table with data's. It would drop data chunk for idata
and drop idata chunk for data by calling validate_data in
sctp_eat_data.

As last patch did, it also replaces sizeof(struct sctp_data_chunk)
with sctp_datachk_len for rx path.

After this patch, the idata can be accepted and delivered to ulp
layer.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/sm.h                |  6 ++++++
 include/net/sctp/stream_interleave.h |  1 +
 include/net/sctp/structs.h           |  6 +++++-
 net/sctp/sm_statefuns.c              | 21 ++++++++-----------
 net/sctp/sm_statetable.c             |  3 +++
 net/sctp/stream_interleave.c         | 39 ++++++++++++++++++++++++++++++++++++
 6 files changed, 62 insertions(+), 14 deletions(-)

diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index ca1db89..0993b49 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -359,6 +359,12 @@ static inline __u16 sctp_data_size(struct sctp_chunk *chunk)
 	 typecheck(__u32, b) && \
 	 ((__s32)((a) - (b)) <= 0))
 
+/* Compare two MIDs */
+#define MID_lt(a, b)	\
+	(typecheck(__u32, a) && \
+	 typecheck(__u32, b) && \
+	 ((__s32)((a) - (b)) < 0))
+
 /* Compare two SSNs */
 #define SSN_lt(a,b)		\
 	(typecheck(__u16, a) && \
diff --git a/include/net/sctp/stream_interleave.h b/include/net/sctp/stream_interleave.h
index 99f399e..d8d1b51 100644
--- a/include/net/sctp/stream_interleave.h
+++ b/include/net/sctp/stream_interleave.h
@@ -38,6 +38,7 @@ struct sctp_stream_interleave {
 					    const struct sctp_sndrcvinfo *sinfo,
 					    int len, __u8 flags, gfp_t gfp);
 	void	(*assign_number)(struct sctp_chunk *chunk);
+	bool	(*validate_data)(struct sctp_chunk *chunk);
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index bd2249d..348b25e 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1381,7 +1381,11 @@ struct sctp_stream_out {
 };
 
 struct sctp_stream_in {
-	__u16	ssn;
+	union {
+		__u32 mid;
+		__u16 ssn;
+	};
+	__u32 fsn;
 };
 
 struct sctp_stream {
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 8f8ccde..c609c54 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3013,7 +3013,7 @@ enum sctp_disposition sctp_sf_eat_data_6_2(struct net *net,
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
 
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_data_chunk)))
+	if (!sctp_chunk_length_valid(chunk, sctp_datachk_len(&asoc->stream)))
 		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
 						  commands);
 
@@ -3034,7 +3034,7 @@ enum sctp_disposition sctp_sf_eat_data_6_2(struct net *net,
 	case SCTP_IERROR_PROTO_VIOLATION:
 		return sctp_sf_abort_violation(net, ep, asoc, chunk, commands,
 					       (u8 *)chunk->subh.data_hdr,
-					       sizeof(struct sctp_datahdr));
+					       sctp_datahdr_len(&asoc->stream));
 	default:
 		BUG();
 	}
@@ -3133,7 +3133,7 @@ enum sctp_disposition sctp_sf_eat_data_fast_4_4(
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
 
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_data_chunk)))
+	if (!sctp_chunk_length_valid(chunk, sctp_datachk_len(&asoc->stream)))
 		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
 						  commands);
 
@@ -3150,7 +3150,7 @@ enum sctp_disposition sctp_sf_eat_data_fast_4_4(
 	case SCTP_IERROR_PROTO_VIOLATION:
 		return sctp_sf_abort_violation(net, ep, asoc, chunk, commands,
 					       (u8 *)chunk->subh.data_hdr,
-					       sizeof(struct sctp_datahdr));
+					       sctp_datahdr_len(&asoc->stream));
 	default:
 		BUG();
 	}
@@ -6244,14 +6244,12 @@ static int sctp_eat_data(const struct sctp_association *asoc,
 	struct sctp_chunk *err;
 	enum sctp_verb deliver;
 	size_t datalen;
-	u8 ordered = 0;
-	u16 ssn, sid;
 	__u32 tsn;
 	int tmp;
 
 	data_hdr = (struct sctp_datahdr *)chunk->skb->data;
 	chunk->subh.data_hdr = data_hdr;
-	skb_pull(chunk->skb, sizeof(*data_hdr));
+	skb_pull(chunk->skb, sctp_datahdr_len(&asoc->stream));
 
 	tsn = ntohl(data_hdr->tsn);
 	pr_debug("%s: TSN 0x%x\n", __func__, tsn);
@@ -6299,7 +6297,7 @@ static int sctp_eat_data(const struct sctp_association *asoc,
 	 * Actually, allow a little bit of overflow (up to a MTU).
 	 */
 	datalen = ntohs(chunk->chunk_hdr->length);
-	datalen -= sizeof(struct sctp_data_chunk);
+	datalen -= sctp_datachk_len(&asoc->stream);
 
 	deliver = SCTP_CMD_CHUNK_ULP;
 
@@ -6394,7 +6392,6 @@ static int sctp_eat_data(const struct sctp_association *asoc,
 		SCTP_INC_STATS(net, SCTP_MIB_INORDERCHUNKS);
 		if (chunk->asoc)
 			chunk->asoc->stats.iodchunks++;
-		ordered = 1;
 	}
 
 	/* RFC 2960 6.5 Stream Identifier and Stream Sequence Number
@@ -6405,8 +6402,7 @@ static int sctp_eat_data(const struct sctp_association *asoc,
 	 * with cause set to "Invalid Stream Identifier" (See Section 3.3.10)
 	 * and discard the DATA chunk.
 	 */
-	sid = ntohs(data_hdr->stream);
-	if (sid >= asoc->stream.incnt) {
+	if (ntohs(data_hdr->stream) >= asoc->stream.incnt) {
 		/* Mark tsn as received even though we drop it */
 		sctp_add_cmd_sf(commands, SCTP_CMD_REPORT_TSN, SCTP_U32(tsn));
 
@@ -6427,8 +6423,7 @@ static int sctp_eat_data(const struct sctp_association *asoc,
 	 * SSN is smaller then the next expected one.  If it is, it wrapped
 	 * and is invalid.
 	 */
-	ssn = ntohs(data_hdr->ssn);
-	if (ordered && SSN_lt(ssn, sctp_ssn_peek(&asoc->stream, in, sid)))
+	if (!asoc->stream.si->validate_data(chunk))
 		return SCTP_IERROR_PROTO_VIOLATION;
 
 	/* Send the data up to the user.  Note:  Schedule  the
diff --git a/net/sctp/sm_statetable.c b/net/sctp/sm_statetable.c
index 79b6bee..8c9bb41 100644
--- a/net/sctp/sm_statetable.c
+++ b/net/sctp/sm_statetable.c
@@ -985,6 +985,9 @@ static const struct sctp_sm_table_entry *sctp_chunk_event_lookup(
 	if (state > SCTP_STATE_MAX)
 		return &bug;
 
+	if (net->sctp.intl_enable && cid = SCTP_CID_I_DATA)
+		cid = SCTP_CID_DATA;
+
 	if (cid <= SCTP_CID_BASE_MAX)
 		return &chunk_event_table[cid][state];
 
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 3ac47e7..3d8733b 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -92,11 +92,49 @@ static void sctp_chunk_assign_mid(struct sctp_chunk *chunk)
 	}
 }
 
+static bool sctp_validate_data(struct sctp_chunk *chunk)
+{
+	const struct sctp_stream *stream;
+	__u16 sid, ssn;
+
+	if (chunk->chunk_hdr->type != SCTP_CID_DATA)
+		return false;
+
+	if (chunk->chunk_hdr->flags & SCTP_DATA_UNORDERED)
+		return true;
+
+	stream = &chunk->asoc->stream;
+	sid = sctp_chunk_stream_no(chunk);
+	ssn = ntohs(chunk->subh.data_hdr->ssn);
+
+	return !SSN_lt(ssn, sctp_ssn_peek(stream, in, sid));
+}
+
+static bool sctp_validate_idata(struct sctp_chunk *chunk)
+{
+	struct sctp_stream *stream;
+	__u32 mid;
+	__u16 sid;
+
+	if (chunk->chunk_hdr->type != SCTP_CID_I_DATA)
+		return false;
+
+	if (chunk->chunk_hdr->flags & SCTP_DATA_UNORDERED)
+		return true;
+
+	stream = &chunk->asoc->stream;
+	sid = sctp_chunk_stream_no(chunk);
+	mid = ntohl(chunk->subh.idata_hdr->mid);
+
+	return !MID_lt(mid, sctp_mid_peek(stream, in, sid));
+}
+
 static struct sctp_stream_interleave sctp_stream_interleave_0 = {
 	.data_chunk_len		= sizeof(struct sctp_data_chunk),
 	/* DATA process functions */
 	.make_datafrag		= sctp_make_datafrag_empty,
 	.assign_number		= sctp_chunk_assign_ssn,
+	.validate_data		= sctp_validate_data,
 };
 
 static struct sctp_stream_interleave sctp_stream_interleave_1 = {
@@ -104,6 +142,7 @@ static struct sctp_stream_interleave sctp_stream_interleave_1 = {
 	/* I-DATA process functions */
 	.make_datafrag		= sctp_make_idatafrag_empty,
 	.assign_number		= sctp_chunk_assign_mid,
+	.validate_data		= sctp_validate_idata,
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream)
-- 
2.1.0

