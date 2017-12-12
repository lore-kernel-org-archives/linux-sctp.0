From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 12 Dec 2017 09:25:54 +0000
Subject: [PATCH net-next 3/8] sctp: implement validate_ftsn for sctp_stream_interleave
Message-Id: <807b1707f79b11d5883d71ea771e98e8f7af3ead.1513070662.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1513070662.git.lucien.xin@gmail.com>
 <9b8315277069d021d8a6b581b7304af624a45c61.1513070662.git.lucien.xin@gmail.com>
 <dbe7bd0f6197086a6a4b4d28f0d63ee1073414e8.1513070662.git.lucien.xin@gmail.com>
In-Reply-To: <dbe7bd0f6197086a6a4b4d28f0d63ee1073414e8.1513070662.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

validate_ftsn is added as a member of sctp_stream_interleave, used to
validate ssn/chunk type for fwdtsn or mid (message id)/chunk type for
ifwdtsn, called in sctp_sf_eat_fwd_tsn, just as validate_data.

If this check fails, an abort packet will be sent, as said in section
2.3.1 of RFC8260.

As ifwdtsn and fwdtsn chunks have different length, it also defines
ftsn_chunk_len for sctp_stream_interleave to describe the chunk size.
Then it replaces all sizeof(struct sctp_fwdtsn_chunk) with
sctp_ftsnchk_len.

It also adds the process for ifwdtsn in rx path. As Marcelo pointed
out, there's no need to add event table for ifwdtsn, but just share
prsctp_chunk_event_table with fwdtsn's. It would drop fwdtsn chunk
for ifwdtsn and drop ifwdtsn chunk for fwdtsn by calling validate_ftsn
in sctp_sf_eat_fwd_tsn.

After this patch, the ifwdtsn can be accepted.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/stream_interleave.h |  2 ++
 include/net/sctp/structs.h           | 10 ++++++++
 net/sctp/sm_statefuns.c              | 24 +++++++-------------
 net/sctp/sm_statetable.c             |  3 ++-
 net/sctp/stream_interleave.c         | 44 ++++++++++++++++++++++++++++++++++++
 5 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/include/net/sctp/stream_interleave.h b/include/net/sctp/stream_interleave.h
index 66267db..0db15b5 100644
--- a/include/net/sctp/stream_interleave.h
+++ b/include/net/sctp/stream_interleave.h
@@ -33,6 +33,7 @@
 
 struct sctp_stream_interleave {
 	__u16	data_chunk_len;
+	__u16	ftsn_chunk_len;
 	/* (I-)DATA process */
 	struct sctp_chunk *(*make_datafrag)(const struct sctp_association *asoc,
 					    const struct sctp_sndrcvinfo *sinfo,
@@ -49,6 +50,7 @@ struct sctp_stream_interleave {
 	void	(*abort_pd)(struct sctp_ulpq *ulpq, gfp_t gfp);
 	/* (I-)FORWARD-TSN process */
 	void	(*generate_ftsn)(struct sctp_outq *q, __u32 ctsn);
+	bool	(*validate_ftsn)(struct sctp_chunk *chunk);
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index b7720d6..8ac4d5c 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1443,6 +1443,16 @@ static inline __u16 sctp_datahdr_len(const struct sctp_stream *stream)
 	return stream->si->data_chunk_len - sizeof(struct sctp_chunkhdr);
 }
 
+static inline __u16 sctp_ftsnchk_len(const struct sctp_stream *stream)
+{
+	return stream->si->ftsn_chunk_len;
+}
+
+static inline __u16 sctp_ftsnhdr_len(const struct sctp_stream *stream)
+{
+	return stream->si->ftsn_chunk_len - sizeof(struct sctp_chunkhdr);
+}
+
 /* SCTP_GET_ASSOC_STATS counters */
 struct sctp_priv_assoc_stats {
 	/* Maximum observed rto in the association during subsequent
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index c609c54..541f347 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3957,7 +3957,6 @@ enum sctp_disposition sctp_sf_eat_fwd_tsn(struct net *net,
 {
 	struct sctp_fwdtsn_hdr *fwdtsn_hdr;
 	struct sctp_chunk *chunk = arg;
-	struct sctp_fwdtsn_skip *skip;
 	__u16 len;
 	__u32 tsn;
 
@@ -3971,7 +3970,7 @@ enum sctp_disposition sctp_sf_eat_fwd_tsn(struct net *net,
 		return sctp_sf_unk_chunk(net, ep, asoc, type, arg, commands);
 
 	/* Make sure that the FORWARD_TSN chunk has valid length.  */
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_fwdtsn_chunk)))
+	if (!sctp_chunk_length_valid(chunk, sctp_ftsnchk_len(&asoc->stream)))
 		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
 						  commands);
 
@@ -3990,14 +3989,11 @@ enum sctp_disposition sctp_sf_eat_fwd_tsn(struct net *net,
 	if (sctp_tsnmap_check(&asoc->peer.tsn_map, tsn) < 0)
 		goto discard_noforce;
 
-	/* Silently discard the chunk if stream-id is not valid */
-	sctp_walk_fwdtsn(skip, chunk) {
-		if (ntohs(skip->stream) >= asoc->stream.incnt)
-			goto discard_noforce;
-	}
+	if (!asoc->stream.si->validate_ftsn(chunk))
+		goto discard_noforce;
 
 	sctp_add_cmd_sf(commands, SCTP_CMD_REPORT_FWDTSN, SCTP_U32(tsn));
-	if (len > sizeof(struct sctp_fwdtsn_hdr))
+	if (len > sctp_ftsnhdr_len(&asoc->stream))
 		sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_FWDTSN,
 				SCTP_CHUNK(chunk));
 
@@ -4028,7 +4024,6 @@ enum sctp_disposition sctp_sf_eat_fwd_tsn_fast(
 {
 	struct sctp_fwdtsn_hdr *fwdtsn_hdr;
 	struct sctp_chunk *chunk = arg;
-	struct sctp_fwdtsn_skip *skip;
 	__u16 len;
 	__u32 tsn;
 
@@ -4042,7 +4037,7 @@ enum sctp_disposition sctp_sf_eat_fwd_tsn_fast(
 		return sctp_sf_unk_chunk(net, ep, asoc, type, arg, commands);
 
 	/* Make sure that the FORWARD_TSN chunk has a valid length.  */
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_fwdtsn_chunk)))
+	if (!sctp_chunk_length_valid(chunk, sctp_ftsnchk_len(&asoc->stream)))
 		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
 						  commands);
 
@@ -4061,14 +4056,11 @@ enum sctp_disposition sctp_sf_eat_fwd_tsn_fast(
 	if (sctp_tsnmap_check(&asoc->peer.tsn_map, tsn) < 0)
 		goto gen_shutdown;
 
-	/* Silently discard the chunk if stream-id is not valid */
-	sctp_walk_fwdtsn(skip, chunk) {
-		if (ntohs(skip->stream) >= asoc->stream.incnt)
-			goto gen_shutdown;
-	}
+	if (!asoc->stream.si->validate_ftsn(chunk))
+		goto gen_shutdown;
 
 	sctp_add_cmd_sf(commands, SCTP_CMD_REPORT_FWDTSN, SCTP_U32(tsn));
-	if (len > sizeof(struct sctp_fwdtsn_hdr))
+	if (len > sctp_ftsnhdr_len(&asoc->stream))
 		sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_FWDTSN,
 				SCTP_CHUNK(chunk));
 
diff --git a/net/sctp/sm_statetable.c b/net/sctp/sm_statetable.c
index 8c9bb41..03a5d7e 100644
--- a/net/sctp/sm_statetable.c
+++ b/net/sctp/sm_statetable.c
@@ -992,7 +992,8 @@ static const struct sctp_sm_table_entry *sctp_chunk_event_lookup(
 		return &chunk_event_table[cid][state];
 
 	if (net->sctp.prsctp_enable) {
-		if (cid = SCTP_CID_FWD_TSN)
+		if (cid = SCTP_CID_FWD_TSN ||
+		    (net->sctp.intl_enable && cid = SCTP_CID_I_FWD_TSN))
 			return &prsctp_chunk_event_table[0][state];
 	}
 
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 2ead372..cc4a5e3 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1153,8 +1153,49 @@ static void sctp_generate_iftsn(struct sctp_outq *q, __u32 ctsn)
 	}
 }
 
+#define _sctp_walk_ifwdtsn(pos, chunk, end) \
+	for (pos = chunk->subh.ifwdtsn_hdr->skip; \
+	     (void *)pos < (void *)chunk->subh.ifwdtsn_hdr->skip + (end); pos++)
+
+#define sctp_walk_ifwdtsn(pos, ch) \
+	_sctp_walk_ifwdtsn((pos), (ch), ntohs((ch)->chunk_hdr->length) - \
+					sizeof(struct sctp_ifwdtsn_chunk))
+
+static bool sctp_validate_fwdtsn(struct sctp_chunk *chunk)
+{
+	struct sctp_fwdtsn_skip *skip;
+	__u16 incnt;
+
+	if (chunk->chunk_hdr->type != SCTP_CID_FWD_TSN)
+		return false;
+
+	incnt = chunk->asoc->stream.incnt;
+	sctp_walk_fwdtsn(skip, chunk)
+		if (ntohs(skip->stream) >= incnt)
+			return false;
+
+	return true;
+}
+
+static bool sctp_validate_iftsn(struct sctp_chunk *chunk)
+{
+	struct sctp_ifwdtsn_skip *skip;
+	__u16 incnt;
+
+	if (chunk->chunk_hdr->type != SCTP_CID_I_FWD_TSN)
+		return false;
+
+	incnt = chunk->asoc->stream.incnt;
+	sctp_walk_ifwdtsn(skip, chunk)
+		if (ntohs(skip->stream) >= incnt)
+			return false;
+
+	return true;
+}
+
 static struct sctp_stream_interleave sctp_stream_interleave_0 = {
 	.data_chunk_len		= sizeof(struct sctp_data_chunk),
+	.ftsn_chunk_len		= sizeof(struct sctp_fwdtsn_chunk),
 	/* DATA process functions */
 	.make_datafrag		= sctp_make_datafrag_empty,
 	.assign_number		= sctp_chunk_assign_ssn,
@@ -1166,10 +1207,12 @@ static struct sctp_stream_interleave sctp_stream_interleave_0 = {
 	.abort_pd		= sctp_ulpq_abort_pd,
 	/* FORWARD-TSN process functions */
 	.generate_ftsn		= sctp_generate_fwdtsn,
+	.validate_ftsn		= sctp_validate_fwdtsn,
 };
 
 static struct sctp_stream_interleave sctp_stream_interleave_1 = {
 	.data_chunk_len		= sizeof(struct sctp_idata_chunk),
+	.ftsn_chunk_len		= sizeof(struct sctp_ifwdtsn_chunk),
 	/* I-DATA process functions */
 	.make_datafrag		= sctp_make_idatafrag_empty,
 	.assign_number		= sctp_chunk_assign_mid,
@@ -1181,6 +1224,7 @@ static struct sctp_stream_interleave sctp_stream_interleave_1 = {
 	.abort_pd		= sctp_intl_abort_pd,
 	/* I-FORWARD-TSN process functions */
 	.generate_ftsn		= sctp_generate_iftsn,
+	.validate_ftsn		= sctp_validate_iftsn,
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream)
-- 
2.1.0

