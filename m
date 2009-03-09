From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 09 Mar 2009 03:21:25 +0000
Subject: [PATCH 6/6] sctp: implement receiver side procedures for the Stream
Message-Id: <49B48B35.2080906@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

STREAM-RESET Extension Section 4.2.1:

   Upon reception of a Stream Reset Chunk each parameter within it
   should be processed.  If some parameters have to be sent back, they
   MUST all be put into one STREAM RESET chunk.  If the received STREAM
   RESET chunk contains at least one request parameter, a SACK chunk
   MUST be sent back and MAY be bundled with the STREAM RESET chunk.  If
   the received STREAM RESET chunk contains at least one request and
   based on the analysis of the Stream Reset Request Sequence Numbers
   this is the last received STREAM RESET chunk, the same STREAM RESET
   chunk has to be sent back in response as earlier.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/constants.h |    5 +-
 include/net/sctp/sm.h        |    3 +
 include/net/sctp/structs.h   |    9 +
 include/net/sctp/ulpevent.h  |    3 +
 net/sctp/associola.c         |    4 +
 net/sctp/sm_make_chunk.c     |  595 ++++++++++++++++++++++++++++++++++++++++++
 net/sctp/sm_statefuns.c      |  128 +++++++++
 net/sctp/sm_statetable.c     |   33 +++
 net/sctp/ssnmap.c            |   20 ++
 net/sctp/ulpevent.c          |   27 ++
 10 files changed, 826 insertions(+), 1 deletions(-)

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 85337c2..8568d31 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -71,10 +71,13 @@ enum { SCTP_DEFAULT_INSTREAMS = SCTP_MAX_STREAM };
 
 #define SCTP_NUM_AUTH_CHUNK_TYPES	1
 
+#define SCTP_NUM_STRRST_CHUNK_TYPES	1
+
 #define SCTP_NUM_CHUNK_TYPES		(SCTP_NUM_BASE_CHUNK_TYPES + \
 					 SCTP_NUM_ADDIP_CHUNK_TYPES +\
 					 SCTP_NUM_PRSCTP_CHUNK_TYPES +\
-					 SCTP_NUM_AUTH_CHUNK_TYPES)
+					 SCTP_NUM_AUTH_CHUNK_TYPES +\
+					 SCTP_NUM_STRRST_CHUNK_TYPES)
 
 /* These are the different flavours of event.  */
 typedef enum {
diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index 4f40111..0883c4b 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -146,6 +146,7 @@ sctp_state_fn_t sctp_sf_do_9_2_reshutack;
 sctp_state_fn_t sctp_sf_eat_fwd_tsn;
 sctp_state_fn_t sctp_sf_eat_fwd_tsn_fast;
 sctp_state_fn_t sctp_sf_eat_auth;
+sctp_state_fn_t sctp_sf_do_stream_reset;
 
 /* Prototypes for primitive event state functions.  */
 sctp_state_fn_t sctp_sf_do_prm_asoc;
@@ -267,6 +268,8 @@ struct sctp_chunk *sctp_make_auth(const struct sctp_association *asoc);
 struct sctp_chunk *sctp_make_stream_reset(struct sctp_association *asoc,
 					  __u16 flags, __u16 nstreams,
 					  __u16 *streamlist);
+struct sctp_chunk *sctp_process_stream_reset(struct sctp_association *asoc,
+					     struct sctp_chunk *strrst);
 
 void sctp_chunk_assign_tsn(struct sctp_chunk *);
 void sctp_chunk_assign_ssn(struct sctp_chunk *);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index a16d35c..f6d02af 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -462,6 +462,11 @@ union sctp_params {
 	struct sctp_chunks_param *chunks;
 	struct sctp_hmac_algo_param *hmac_algo;
 	struct sctp_addip_param *addip;
+	struct sctp_reset_out_req *rstout;
+	struct sctp_reset_in_req *rstin;
+	struct sctp_reset_tsn_req *rsttsn;
+	struct sctp_reset_tsn_res *rstres;
+	struct sctp_add_stream *rstadd;
 };
 
 /* RFC 2960.  Section 3.3.5 Heartbeat.
@@ -505,6 +510,8 @@ struct sctp_ssnmap {
 
 struct sctp_ssnmap *sctp_ssnmap_new(__u16 in, __u16 out,
 				    gfp_t gfp);
+struct sctp_ssnmap *sctp_ssnmap_resize(struct sctp_ssnmap *map,
+				       __u16 in, __u16 out, gfp_t gfp);
 void sctp_ssnmap_free(struct sctp_ssnmap *map);
 void sctp_ssnmap_clear(struct sctp_ssnmap *map);
 
@@ -1925,6 +1932,8 @@ struct sctp_association {
 
 	/* Cache the STREAM-RESET chunk last send */
 	struct sctp_chunk *strrst_last_stream_reset;
+	/* Cache the lsat two respone result it send */
+	struct sctp_chunk *strrst_last_reset_response;
 
 	/* Need to send an ECNE Chunk? */
 	char need_ecne;
diff --git a/include/net/sctp/ulpevent.h b/include/net/sctp/ulpevent.h
index 7ea12e8..5596cae 100644
--- a/include/net/sctp/ulpevent.h
+++ b/include/net/sctp/ulpevent.h
@@ -132,6 +132,9 @@ struct sctp_ulpevent *sctp_ulpevent_make_authkey(
 	const struct sctp_association *asoc, __u16 key_id,
 	__u32 indication, gfp_t gfp);
 
+struct sctp_ulpevent *sctp_ulpevent_make_stream_reset(
+	const struct sctp_association *asoc, __u16 flags, gfp_t gfp);
+
 void sctp_ulpevent_read_sndrcvinfo(const struct sctp_ulpevent *event,
 	struct msghdr *);
 __u16 sctp_ulpevent_get_notification_type(const struct sctp_ulpevent *event);
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index a2e585d..495929a 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -450,6 +450,10 @@ void sctp_association_free(struct sctp_association *asoc)
 	if (asoc->addip_last_asconf)
 		sctp_chunk_free(asoc->addip_last_asconf);
 
+	/* Free any cached STREAM-RESET response chunk*/
+	if (asoc->strrst_last_reset_response)
+		sctp_chunk_free(asoc->strrst_last_reset_response);
+
 	/* Free any cached STREAM-RESET chunk. */
 	if (asoc->strrst_last_stream_reset)
 		sctp_chunk_free(asoc->strrst_last_stream_reset);
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 9a27454..b4d88bb 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3467,6 +3467,57 @@ static void sctp_add_stream_reset_tsn(struct sctp_chunk *retval, __u32 seq_req)
 	sctp_addto_chunk(retval, sizeof(tsn), &tsn);
 }
 
+/* STREAM-RESET 3.2.4 Stream Reset Response Parameter
+ *
+ *      0                   1                   2                   3
+ *      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |     Parameter Type = 0x0010   |      Parameter Length         |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |           Stream Reset Response Sequence Number               |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |                            Result                             |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |                   Sender's next TSN (optional)                |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |                 Receiver's next TSN   (optional)              |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ * Create a Stream Reset Response Parameter for SSN/TSN Reset Request
+ * Parameter and add it to STREAM-RESET chunk.
+ */
+static void sctp_add_stream_reset_tsn_res(struct sctp_chunk *retval,
+					  __u32 seq_res, __u32 result,
+					  __u32 snd_tsn, __u32 rcv_tsn)
+{
+	struct sctp_reset_tsn_res res;
+
+	res.param_hdr.type = SCTP_PARAM_RESET_RESPONSE;
+	res.param_hdr.length = htons(sizeof(struct sctp_reset_tsn_res));
+	res.response_seq = htonl(seq_res);;
+	res.result = result;
+	res.senders_next_tsn = htonl(snd_tsn);
+	res.receivers_next_tsn = htonl(rcv_tsn);
+
+	sctp_addto_chunk(retval, sizeof(res), &res);
+}
+
+/* Create a Stream Reset Response Parameter for the other Request Parameter
+ * and add it to STREAM-RESET chunk.
+ */
+static void sctp_add_stream_reset_res(struct sctp_chunk *retval,
+				       __u32 seq_res, __u32 result)
+{
+	struct sctp_reset_res res;
+
+	res.param_hdr.type = SCTP_PARAM_RESET_RESPONSE;
+	res.param_hdr.length = htons(sizeof(struct sctp_reset_res));
+	res.response_seq = htonl(seq_res);
+	res.result = result;
+
+	sctp_addto_chunk(retval, sizeof(res), &res);
+}
+
 /* STREAM-RESET 3.2.5 Add Streams
  *
  *      0                   1                   2                   3
@@ -3553,3 +3604,547 @@ struct sctp_chunk *sctp_make_stream_reset(struct sctp_association *asoc,
 	return retval;
 }
 
+/* Reset incoming streams to '0' as the next expected stream
+ * sequence number
+ */
+static void sctp_do_stream_reset_in(struct sctp_association *asoc,
+				    int number_entries, __u16 *streamlist)
+{
+	struct sctp_stream *in = &asoc->ssnmap->in;
+	struct sctp_ulpevent *ev;
+	int i;
+
+	/* If no Stream Numbers are listed in the parameter, then all
+	 * incoming streams MUST be reset to '0' as the next expected stream
+	 * sequence number.  If specific Stream Numbers are listed, then
+	 * only these specific streams MUST be reset to '0' and all other
+	 * non-listed stream sequence numbers remain unchanged.
+	 */
+	if (number_entries) {
+		for (i = 0; i < number_entries; i++)
+			sctp_ssn_skip(in, ntohs(streamlist[i]), -1);
+	} else {
+		for (i = 0; i < asoc->c.sinit_max_instreams; i++)
+			sctp_ssn_skip(in, i, -1);
+	}
+
+	ev = sctp_ulpevent_make_stream_reset(asoc,
+			SCTP_STREAM_RESET_INBOUND, GFP_ATOMIC);
+	if (ev)
+		sctp_ulpq_tail_event(&asoc->ulpq, ev);
+}
+
+/* Reset outgoing streams to '0' as the next expected stream sequence
+ * number
+ */
+static void sctp_do_stream_reset_out(struct sctp_association *asoc,
+				int number_entries, __u16 *streamlist)
+{
+	struct sctp_stream *out = &asoc->ssnmap->out;
+	struct sctp_ulpevent *ev;
+	int i;
+
+	if (number_entries) {
+		for (i = 0; i < number_entries; i++)
+			sctp_ssn_skip(out, ntohs(streamlist[i]), -1);
+	} else {
+		for (i = 0; i < asoc->c.sinit_num_ostreams; i++)
+			sctp_ssn_skip(out, i, -1);
+	}
+
+	ev = sctp_ulpevent_make_stream_reset(asoc,
+			SCTP_STREAM_RESET_OUTBOUND, GFP_ATOMIC);
+	if (ev)
+		sctp_ulpq_tail_event(&asoc->ulpq, ev);
+}
+
+static int sctp_check_ssn(__u16 *ssn, int n, __u16 max)
+{
+	int i;
+
+	for (i = 0; i < n; i++)
+		if (ntohs(ssn[i]) >= max)
+			return 1;
+	return 0;
+}
+
+/* Lookup a request paramter for response sequence number */
+static struct sctp_paramhdr *sctp_lookup_stream_reset_req(__u32 seq,
+	struct sctp_chunk *chunk)
+{
+	struct sctp_strrst_chunk *strrst;
+	union sctp_params param;
+
+	if (!chunk)
+		return NULL;
+
+	strrst = (struct sctp_strrst_chunk *)chunk->chunk_hdr;
+
+	sctp_walk_params(param, strrst, params) {
+		if (seq = param.rsttsn->request_seq)
+			return param.p;
+	}
+
+	return NULL;
+}
+
+/* Lookup a response paramter for request sequence number */
+static struct sctp_paramhdr *sctp_lookup_stream_reset_resp(__u32 seq,
+	struct sctp_chunk *chunk)
+{
+	struct sctp_strrst_chunk *strrst;
+	union sctp_params param;
+
+	if (!chunk)
+		return NULL;
+
+	strrst = (struct sctp_strrst_chunk *)chunk->chunk_hdr;
+
+	sctp_walk_params(param, strrst, params) {
+		if (param.p->type = SCTP_PARAM_RESET_OUT_REQUEST) {
+			if (seq = param.rstout->response_seq)
+				return param.p;
+		} else if (param.p->type = SCTP_PARAM_RESET_RESPONSE) {
+			if (seq = param.rstres->response_seq)
+				return param.p;
+		}
+	}
+
+	return NULL;
+}
+
+/* STREAM-RESET Section 4.2.2
+ * Receiver side procedures for the Outgoing SSN Reset Request Parameter
+ */
+static void sctp_process_reset_out_request(struct sctp_association *asoc,
+					   struct sctp_paramhdr *phdr,
+					   struct sctp_chunk *retval)
+{
+	struct sctp_reset_out_req *out = (struct sctp_reset_out_req *)phdr;
+	__u32 request_seq = ntohl(out->request_seq);
+	__u32 response_seq = ntohl(out->response_seq);
+	__u32 result = SCTP_STREAM_RESET_BAD_SEQNO;
+	struct sctp_paramhdr *resp;
+	int entries = (ntohs(phdr->length) - sizeof(*out)) >> 1;
+
+	if (request_seq = asoc->peer.strrst_seq + 1) {
+		if (response_seq != asoc->strrst_seq - 1)
+			goto err;
+
+		/* This Outgoing SSN Reset Request Parameter is sent in response
+		 * to an Incoming SSN Reset Request Parameter
+		 */
+		resp = sctp_lookup_stream_reset_req(out->response_seq,
+			       asoc->strrst_last_stream_reset);
+		if (resp && resp->type != SCTP_PARAM_RESET_IN_REQUEST)
+			goto err;
+
+		if (sctp_check_ssn(out->stream, entries,
+				   asoc->c.sinit_max_instreams)) {
+			result = SCTP_STREAM_RESET_WRONG_SSN;
+			goto err;
+		}
+
+		sctp_do_stream_reset_in(asoc, entries, out->stream);
+
+		/* E6  A Stream Reset Response Parameter is put into a STREAM
+		 * RESET chunk indicating successful processing.
+		 */
+		asoc->peer.strrst_seq++;
+		result = SCTP_STREAM_RESET_PERFORMED;
+	} else if (request_seq = asoc->peer.strrst_seq ||
+		   request_seq = asoc->peer.strrst_seq - 1) {
+		resp = sctp_lookup_stream_reset_resp(out->request_seq,
+					asoc->strrst_last_reset_response);
+		if (resp) {
+			sctp_addto_chunk(retval, ntohs(resp->length), resp);
+			return;
+		}
+	}
+
+err:
+	/* E7  The STREAM RESET chunk is sent after the incoming STREAM RESET
+	 * chunk is processed completely.
+	 */
+	sctp_add_stream_reset_res(retval, request_seq, result);
+}
+
+/* STREAM-RESET Section 4.2.3
+ * Receiver side procedures for the Incoming SSN Reset Request Parameter
+ */
+static void sctp_process_reset_in_request(struct sctp_association *asoc,
+					  struct sctp_paramhdr *phdr,
+					  struct sctp_chunk *retval)
+{
+	struct sctp_reset_in_req *in = (struct sctp_reset_in_req *)phdr;
+	struct sctp_paramhdr *resp;
+	__u32 result = SCTP_STREAM_RESET_BAD_SEQNO;
+	__u32 seq = ntohl(in->request_seq);
+	int entries = (ntohs(phdr->length) - sizeof(*in)) >> 1;
+
+	if (seq = asoc->peer.strrst_seq + 1) {
+		if (asoc->strrst_last_stream_reset) {
+			result = SCTP_STREAM_RESET_TRY_LATER;
+			goto err;
+		}
+
+		if (sctp_check_ssn(in->stream, entries,
+				   asoc->c.sinit_num_ostreams)) {
+			result = SCTP_STREAM_RESET_WRONG_SSN;
+			goto err;
+		}
+
+		/* F1  An Outgoing Stream Reset Request Parameter MUST be put
+		 * into an STREAM RESET chunk according to Section 4.1.2.
+		 */
+		sctp_add_stream_reset_out(retval, asoc->strrst_seq++, seq,
+					  asoc->next_tsn - 1, entries * 2,
+					  in->stream);
+
+		/* F2  The STREAM RESET chunk is sent after the incoming STREAM
+		 * RESET chunk is processed completely.
+		 */
+		asoc->peer.strrst_seq++;
+		asoc->strrst_last_stream_reset = retval;
+
+		return;
+	} else if (seq = asoc->peer.strrst_seq) {
+		resp = sctp_lookup_stream_reset_resp(in->request_seq,
+					asoc->strrst_last_stream_reset);
+		if (!resp) {
+			result = SCTP_STREAM_RESET_BAD_SEQNO;
+			goto err;
+		}
+
+		/* Dup Incoming SSN Reset Request Parameter */
+		sctp_addto_chunk(retval, ntohs(resp->length), resp);
+		return;
+	}
+err:
+	sctp_add_stream_reset_res(retval, seq, result);
+}
+
+/* STREAM-RESET Section 4.2.4
+ * Receiver side procedures for the SSN/TSN Reset Request Parameter
+ */
+static void sctp_process_reset_tsn_request(struct sctp_association *asoc,
+					   struct sctp_paramhdr *phdr,
+					   struct sctp_chunk *retval)
+{
+	struct sctp_reset_tsn_req *tsn = (struct sctp_reset_tsn_req *)phdr;
+	__u32 request_seq = ntohl(tsn->request_seq);
+	__u32 result = SCTP_STREAM_RESET_BAD_SEQNO;
+	__u32 next_tsn_s, next_tsn_r;
+	struct sctp_paramhdr *resp;
+	struct sctp_sackhdr sackh;
+
+	if (request_seq = asoc->peer.strrst_seq + 1) {
+		/* G1  Compute an appropriate value for the Receiver's next
+		 * TSN, the TSN the peer should use to send the next DATA
+		 * chunk.  Note that an appropriate value should be larger
+		 * than the highest TSN last received plus a delta of at
+		 * least 500 additional TSN's.
+		 */
+		next_tsn_r = sctp_tsnmap_get_max_tsn_seen(&asoc->peer.tsn_map) +
+				500;
+
+		/* G2  Compute an appropriate value for the local endpoints
+		 * next TSN, i.e. the receiver of the SSN/TSN reset chunks next
+		 * TSN to be assigned.  Note that an appropriate value should
+		 * be larger than the endpoints current next TSN to send by at
+		 * least one TSN.
+		 */
+		next_tsn_s = asoc->next_tsn + 1;
+
+		/* G3  Do the same processing as if a SACK chunk with no gap
+		 * report and a cumulative TSN ACK of Sender's next TSN - 1
+		 * was received.
+		 */
+		memset(&sackh, 0, sizeof(struct sctp_sackhdr));
+		sackh.cum_tsn_ack = htonl(next_tsn_s - 1);
+		asoc->next_tsn++;
+		sctp_outq_sack(&asoc->outqueue, &sackh);
+
+		/* G4  Do the same processing as if an FWD-TSN chunk with all
+		 * streams affected and a new cumulative TSN ACK of Receiver's
+		 * next TSN - 1 was received.
+		 */
+		sctp_tsnmap_skip(&asoc->peer.tsn_map, next_tsn_r - 1);
+		sctp_ulpq_reasm_flushtsn(&asoc->ulpq, next_tsn_r - 1);
+		sctp_ulpq_abort_pd(&asoc->ulpq, GFP_ATOMIC);
+
+		/* G5  All incoming and outgoing streams MUST be reset to '0'
+		 * as the next expected and outgoing stream sequence numbers,
+		 * respectively.
+		 */
+		sctp_do_stream_reset_in(asoc, 0, NULL);
+		sctp_do_stream_reset_out(asoc, 0, NULL);
+
+		/* G6  A Stream Reset Response Parameter is put into a STREAM
+		 * RESET chunk indicating successful processing.
+		 */
+		result = SCTP_STREAM_RESET_PERFORMED;
+		sctp_add_stream_reset_tsn_res(retval, request_seq, result,
+					      next_tsn_s, next_tsn_r);
+
+		/* G7  The STREAM RESET chunk is sent after the incoming STREAM
+		 * RESET chunk is processed completely.
+		 */
+		asoc->peer.strrst_seq++;
+
+		return;
+	} else if (request_seq = asoc->peer.strrst_seq) {
+		resp = sctp_lookup_stream_reset_resp(tsn->request_seq,
+					asoc->strrst_last_reset_response);
+		if (resp) {
+			sctp_addto_chunk(retval, ntohs(resp->length), resp);
+			return;
+		}
+	}
+
+	sctp_add_stream_reset_res(retval, request_seq, result);
+}
+
+/* STREAM-RESET Section 4.2.5
+ * Receiver side procedures for addition of streams
+ */
+static void sctp_process_add_stream(struct sctp_association *asoc,
+				    struct sctp_paramhdr *phdr,
+				    struct sctp_chunk *retval)
+{
+	struct sctp_add_stream *add = (struct sctp_add_stream *)phdr;
+	__u32 request_seq = ntohl(add->request_seq);
+	__u32 num_streams = ntohs(add->num_streams);
+	__u32 result = SCTP_STREAM_RESET_BAD_SEQNO;
+	struct sctp_paramhdr *resp;
+	struct sctp_ssnmap *new;
+
+	if (request_seq = asoc->peer.strrst_seq + 1) {
+		/* When an SCTP endpoint receives a stream reset request adding
+		 * additional streams, it MUST send a response parameter either
+		 * acknowledging or rejecting the request.  If the response is
+		 * successful the receiver MUST add the requested number of
+		 * inbound streams to the association, initializing the next
+		 * expected stream sequence number to be 0.
+		 */
+		new = sctp_ssnmap_resize(asoc->ssnmap,
+				asoc->c.sinit_max_instreams + num_streams,
+				asoc->c.sinit_num_ostreams, GFP_ATOMIC);
+		if (new) {
+			asoc->ssnmap = new;
+			asoc->c.sinit_max_instreams += num_streams;
+			result = SCTP_STREAM_RESET_PERFORMED;
+		} else
+			result = SCTP_STREAM_RESET_DENIED;
+
+		asoc->peer.strrst_seq++;
+	} else if (request_seq = asoc->peer.strrst_seq) {
+		resp = sctp_lookup_stream_reset_resp(add->request_seq,
+					asoc->strrst_last_reset_response);
+		if (resp) {
+			sctp_addto_chunk(retval, ntohs(resp->length), resp);
+			return;
+		}
+	}
+
+	sctp_add_stream_reset_res(retval, request_seq, result);
+}
+
+/* STREAM-RESET Section 4.2.6
+ * Receiver side procedures for the Stream Reset Response Parameter
+ */
+static void sctp_process_reset_response(struct sctp_association *asoc,
+					struct sctp_paramhdr *phdr,
+					struct sctp_chunk *retval)
+{
+	struct sctp_reset_res *res = (struct sctp_reset_res *)phdr;
+	struct sctp_paramhdr *req;
+	struct sctp_ulpevent *ev;
+	__u32 response_seq = ntohl(res->response_seq);
+
+	/* Dup stream reset response parameter */
+	if (!asoc->strrst_last_stream_reset)
+		return;
+
+	/* Wrong Sequence Number */
+	if (response_seq != asoc->strrst_seq - 1 &&
+	    response_seq != asoc->strrst_seq - 2)
+		return;
+
+	/* Find a request parameter in last request chunk */
+	req = sctp_lookup_stream_reset_req(res->response_seq,
+				       asoc->strrst_last_stream_reset);
+	if (!req)
+		return;
+
+	/* H2  If the Result field does not indicate successful processing an
+	 * Upper Layer Notification SHOULD be sent to inform the local
+	 * endpoint of the failure to reset its outbound streams.
+	 * Afterwards processing of this response is complete.
+	 */
+	if (res->result != SCTP_STREAM_RESET_PERFORMED) {
+		ev = sctp_ulpevent_make_stream_reset(asoc,
+			SCTP_STREAM_RESET_FAILED, GFP_ATOMIC);
+		if (ev)
+			sctp_ulpq_tail_event(&asoc->ulpq, ev);
+
+		goto out;
+	}
+
+	switch (req->type) {
+	case SCTP_PARAM_RESET_OUT_REQUEST:
+	{
+		struct sctp_reset_out_req *out;
+		int entries;
+
+		/* H3  If the request was an Outgoing Stream Reset Request the
+		 * affected streams should now be reset and all queued data
+		 * should be processed now and assigning of stream sequence
+		 * numbers is allowed again.  Optionally an Upper Layer
+		 * Notification SHOULD be sent to inform the local endpoint
+		 * that the outbound streams have been reset.
+		 */
+		out = (struct sctp_reset_out_req *)req;
+		entries = (ntohs(req->length) - sizeof(*out)) >> 1;
+
+		sctp_do_stream_reset_out(asoc, entries, out->stream);
+
+		break;
+	}
+	case SCTP_PARAM_RESET_TSN_REQUEST:
+	{
+		struct sctp_reset_tsn_res *tsnres;
+		struct sctp_sackhdr sackh;
+		__u32 next_tsn_s, next_tsn_r;
+
+		/* H4  If the request was a SSN/TSN Reset Request new DATA
+		 * should be sent from Receiver's next TSN and beginning with
+		 * stream sequence number '0' for all outgoing streams.  All
+		 * incoming streams are also reset to '0' as the next expected
+		 * stream sequence number. The peer will send DATA chunks
+		 * starting with Sender's next TSN.
+		 */
+		tsnres = (struct sctp_reset_tsn_res *)phdr;
+		next_tsn_s = ntohl(tsnres->senders_next_tsn);
+		next_tsn_r = ntohl(tsnres->receivers_next_tsn);
+
+		/* Do the same processing as if a SACK chunk with no gap report
+		 * and a cumulative TSN ACK of Receiver's next TSN - 1 was
+		 * received.
+		 */
+		asoc->next_tsn = next_tsn_r;
+		memset(&sackh, 0, sizeof(struct sctp_sackhdr));
+		sackh.cum_tsn_ack = htonl(next_tsn_r - 1);
+		sctp_outq_sack(&asoc->outqueue, &sackh);
+
+		/* Do the same processing as if an FWD-TSN chunk with all
+		 * streams affected and a new cumulative TSN ACK of Sender's
+		 * next TSN - 1 was received.
+		 */
+		sctp_tsnmap_skip(&asoc->peer.tsn_map, next_tsn_s - 1);
+		sctp_ulpq_reasm_flushtsn(&asoc->ulpq, next_tsn_s - 1);
+		sctp_ulpq_abort_pd(&asoc->ulpq, GFP_ATOMIC);
+
+		sctp_do_stream_reset_in(asoc, 0, NULL);
+		sctp_do_stream_reset_out(asoc, 0, NULL);
+
+		break;
+	}
+	case SCTP_PARAM_ADD_STREAM:
+	{
+		struct sctp_add_stream *add = (struct sctp_add_stream *)req;
+		 __u32 num_streams = ntohs(add->num_streams);
+		struct sctp_ssnmap *new;
+
+		new = sctp_ssnmap_resize(asoc->ssnmap,
+				asoc->c.sinit_max_instreams,
+				asoc->c.sinit_num_ostreams + num_streams,
+				GFP_ATOMIC);
+
+		if (!new)
+			break;
+
+		asoc->ssnmap = new;
+		asoc->c.sinit_num_ostreams += num_streams;
+		break;
+	}
+	default:
+		break;
+	}
+
+out:
+	if (response_seq = asoc->strrst_seq - 1) {
+		sctp_chunk_free(asoc->strrst_last_stream_reset);
+		asoc->strrst_last_stream_reset = NULL;
+	}
+}
+
+/* Receiver side procedures for the unknown Stream Reset Parameter */
+static void sctp_process_reset_unknown(struct sctp_association *asoc,
+				       struct sctp_paramhdr *phdr,
+				       struct sctp_chunk *retval)
+{
+	struct sctp_reset_in_req *in = (struct sctp_reset_in_req *)phdr;
+
+	sctp_add_stream_reset_res(retval, in->request_seq,
+				     SCTP_STREAM_RESET_DENIED);
+}
+
+/* STREAM-RESET Section 4.2.1
+ * Receiver side procedures for the Stream Reset Chunk
+ *
+ * Process an incoming STREAM-RESET chunk with the next expected seq no. and
+ * return an STREAM-RESET chunk to be sent in response.
+ */
+struct sctp_chunk *sctp_process_stream_reset(struct sctp_association *asoc,
+				       struct sctp_chunk *chunk)
+{
+	struct sctp_strrst_chunk *strrst;
+	struct sctp_chunk *retval = NULL;
+	union sctp_params param;
+
+	strrst = (struct sctp_strrst_chunk *)chunk->chunk_hdr;
+
+	sctp_walk_params(param, strrst, params) {
+		if (retval = NULL &&
+		    param.p->type != SCTP_PARAM_RESET_RESPONSE) {
+			retval = sctp_make_chunk(asoc, SCTP_CID_STREAM_RESET, 0,
+						 chunk->chunk_hdr->length +
+						 sizeof(struct sctp_reset_res));
+			if (!retval)
+				return NULL;
+		}
+
+		switch (param.p->type) {
+		case SCTP_PARAM_RESET_OUT_REQUEST:
+			sctp_process_reset_out_request(asoc, param.p, retval);
+			break;
+		case SCTP_PARAM_RESET_IN_REQUEST:
+			sctp_process_reset_in_request(asoc, param.p, retval);
+			break;
+		case SCTP_PARAM_RESET_TSN_REQUEST:
+			sctp_process_reset_tsn_request(asoc, param.p, retval);
+			break;
+		case SCTP_PARAM_RESET_RESPONSE:
+			sctp_process_reset_response(asoc, param.p, NULL);
+			break;
+		case SCTP_PARAM_ADD_STREAM:
+			sctp_process_add_stream(asoc, param.p, retval);
+			break;
+		default:
+			sctp_process_reset_unknown(asoc, param.p, retval);
+			break;
+		}
+	}
+
+	if (retval && retval != asoc->strrst_last_stream_reset) {
+		if (asoc->strrst_last_reset_response)
+			sctp_chunk_free(asoc->strrst_last_reset_response);
+
+		sctp_chunk_hold(retval);
+		asoc->strrst_last_reset_response = retval;
+	}
+
+	return retval;
+}
+
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 1a001d7..cb69edc 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3970,6 +3970,134 @@ sctp_disposition_t sctp_sf_eat_auth(const struct sctp_endpoint *ep,
 	return SCTP_DISPOSITION_CONSUME;
 }
 
+/* STRRST Section 4.2 Upon reception of an STREAM RESET Chunk.  */
+sctp_disposition_t sctp_sf_do_stream_reset(const struct sctp_endpoint *ep,
+				    const struct sctp_association *asoc,
+				    const sctp_subtype_t type,
+				    void *arg,
+				    sctp_cmd_seq_t *commands)
+{
+	struct sctp_chunk *chunk = arg;
+	struct sctp_chunk *strrst_res;
+	struct sctp_strrst_chunk *strrst;
+	union sctp_params param;
+	int num_requests = 0, all_acked = 0;
+	int out_num = 0, in_num = 0, res_num = 0, total = 0;
+
+	/* Make sure that the peer has STREAM-RESET capable */
+	if (!asoc->peer.strrst_capable)
+		return sctp_sf_unk_chunk(ep, asoc, type, arg, commands);
+
+	if (!sctp_vtag_verify(chunk, asoc)) {
+		sctp_add_cmd_sf(commands, SCTP_CMD_REPORT_BAD_TAG,
+				SCTP_NULL());
+		return sctp_sf_pdiscard(ep, asoc, type, arg, commands);
+	}
+
+	/* Make sure that the STREAM RESET chunk has a valid length.  */
+	if (!sctp_chunk_length_valid(chunk, sizeof(sctp_strrst_chunk_t)))
+		return sctp_sf_violation_chunklen(ep, asoc, type, arg,
+						  commands);
+
+	/* Make sure that the STREAM RESET parameters have valid length. */
+	strrst = (struct sctp_strrst_chunk *)chunk->chunk_hdr;
+	sctp_walk_params(param, strrst, params) {
+		if (param.p->length < sizeof(struct sctp_reset_tsn_req))
+			return sctp_sf_violation_paramlen(ep, asoc, type, arg,
+							  param.v, commands);
+		switch (param.p->type) {
+		case SCTP_PARAM_RESET_OUT_REQUEST:
+			out_num++;
+
+			/* In case that this Outgoing SSN Reset Request
+			 * Parameter is sent in response to an Incoming SSN
+			 * Reset Request Parameter this parameter is also an
+			 * implicit response to the incoming request.  Then this
+			 * field holds the Stream Reset Request Sequence Number
+			 * of the incoming request.
+			 */
+			if (ntohl(param.rstout->response_seq) =
+			    asoc->strrst_seq - 1)
+				all_acked = 1;
+
+			num_requests++;
+			break;
+		case SCTP_PARAM_RESET_RESPONSE:
+			res_num++;
+			if (ntohl(param.rstres->response_seq) =
+			    asoc->strrst_seq - 1)
+				all_acked = 1;
+			break;
+		case SCTP_PARAM_RESET_IN_REQUEST:
+			in_num++;
+		case SCTP_PARAM_RESET_TSN_REQUEST:
+		case SCTP_PARAM_ADD_STREAM:
+			num_requests++;
+			break;
+		}
+		total++;
+	}
+
+	if (param.v != (void *)chunk->chunk_end)
+		return sctp_sf_violation_paramlen(ep, asoc, type, arg,
+						  param.v, commands);
+
+	/* Note each STREAM RESET chunk holds at least one parameter and at most
+	 * two parameters.  Only the following combinations are allowed:
+	 * 1.  Outgoing SSN Reset Request Parameter.
+	 * 2.  Incoming SSN Reset Request Parameter.
+	 * 3.  Outgoing SSN Reset Request Parameter, Incoming SSN Reset Request
+	 *     Parameter.
+	 * 4.  SSN/TSN Reset Request Parameter.
+	 * 5.  Stream Reset Response Parameter.
+	 * 6.  Stream Reset Response Parameter, Outgoing SSN Reset Request
+	 *     Parameter.
+	 * 7.  Stream Reset Response Parameter, Stream Reset Response Parameter.
+	 */
+	if (total > 2 || (total = 2 && !((in_num = 1 && out_num = 1) ||
+				(res_num > 0 && res_num + out_num = 2))))
+		return sctp_sf_violation_chunk(ep, asoc, type, arg, commands);
+
+	/* If all Stream Reset Request Sequence Numbers the Stream Reset Timer
+	 * is running for are acknowledged, stop the Stream Reset Timer.
+	 */
+	if (asoc->strrst_last_stream_reset && all_acked) {
+		sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_STOP,
+			SCTP_TO(SCTP_EVENT_TIMEOUT_T6_RTO));
+	}
+
+	/* If the received STREAM RESET chunk contains at least one request
+	 * parameter, a SACK chunk MUST be sent back and MAY be bundled with
+	 * the STREAM RESET chunk.
+	 */
+	if (num_requests > 0)
+		sctp_add_cmd_sf(commands, SCTP_CMD_GEN_SACK, SCTP_FORCE());
+
+	strrst_res = sctp_process_stream_reset((struct sctp_association *)
+						asoc, chunk);
+	if (!strrst_res)
+		return (num_requests = 0) ? SCTP_DISPOSITION_CONSUME :
+			SCTP_DISPOSITION_NOMEM;
+
+	/* After packaging the Stream Reset Chunk and sending it to the peer
+	 * the sender MUST start a 'Stream Reset Timer' when the STREAM RESET
+	 * chunk contains at least one request parameter.
+	 * This is only used for Outgoing SSN Reset Request Parameter which is
+	 * sent in response to an Incoming SSN Request Parameter the Stream
+	 * Reset Request*/
+	if (strrst_res = asoc->strrst_last_stream_reset) {
+		sctp_chunk_hold(strrst_res);
+		sctp_add_cmd_sf(commands, SCTP_CMD_SETUP_T6,
+			SCTP_CHUNK(strrst_res));
+		sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_START,
+			SCTP_TO(SCTP_EVENT_TIMEOUT_T6_RTO));
+	}
+
+	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(strrst_res));
+
+	return SCTP_DISPOSITION_CONSUME;
+}
+
 /*
  * Process an unknown chunk.
  *
diff --git a/net/sctp/sm_statetable.c b/net/sctp/sm_statetable.c
index 40c9472..b86157d 100644
--- a/net/sctp/sm_statetable.c
+++ b/net/sctp/sm_statetable.c
@@ -551,6 +551,34 @@ static const sctp_sm_table_entry_t auth_chunk_event_table[SCTP_NUM_AUTH_CHUNK_TY
 	TYPE_SCTP_AUTH,
 }; /*state_fn_t auth_chunk_event_table[][] */
 
+#define TYPE_SCTP_STREAM_RESET { \
+	/* SCTP_STATE_EMPTY */ \
+	TYPE_SCTP_FUNC(sctp_sf_ootb), \
+	/* SCTP_STATE_CLOSED */ \
+	TYPE_SCTP_FUNC(sctp_sf_discard_chunk), \
+	/* SCTP_STATE_COOKIE_WAIT */ \
+	TYPE_SCTP_FUNC(sctp_sf_discard_chunk), \
+	/* SCTP_STATE_COOKIE_ECHOED */ \
+	TYPE_SCTP_FUNC(sctp_sf_discard_chunk), \
+	/* SCTP_STATE_ESTABLISHED */ \
+	TYPE_SCTP_FUNC(sctp_sf_do_stream_reset), \
+	/* SCTP_STATE_SHUTDOWN_PENDING */ \
+	TYPE_SCTP_FUNC(sctp_sf_do_stream_reset), \
+	/* SCTP_STATE_SHUTDOWN_SENT */ \
+	TYPE_SCTP_FUNC(sctp_sf_do_stream_reset), \
+	/* SCTP_STATE_SHUTDOWN_RECEIVED */ \
+	TYPE_SCTP_FUNC(sctp_sf_do_stream_reset), \
+	/* SCTP_STATE_SHUTDOWN_ACK_SENT */ \
+	TYPE_SCTP_FUNC(sctp_sf_discard_chunk), \
+} /* TYPE_SCTP_STREAM_RESET */
+
+/* The primary index for this table is the chunk type.
+ * The secondary index for this table is the state.
+ */
+static const sctp_sm_table_entry_t stream_reset_chunk_event_table[SCTP_NUM_STRRST_CHUNK_TYPES][SCTP_STATE_NUM_STATES] = {
+	TYPE_SCTP_STREAM_RESET,
+}; /*state_fn_t stream_reset_chunk_event_table[][] */
+
 static const sctp_sm_table_entry_t
 chunk_event_table_unknown[SCTP_STATE_NUM_STATES] = {
 	/* SCTP_STATE_EMPTY */
@@ -1053,5 +1081,10 @@ static const sctp_sm_table_entry_t *sctp_chunk_event_lookup(sctp_cid_t cid,
 			return &auth_chunk_event_table[0][state];
 	}
 
+	if (sctp_strrst_enable) {
+		if (cid = SCTP_CID_STREAM_RESET)
+			return &stream_reset_chunk_event_table[0][state];
+	}
+
 	return &chunk_event_table_unknown[state];
 }
diff --git a/net/sctp/ssnmap.c b/net/sctp/ssnmap.c
index 737d330..01abf90 100644
--- a/net/sctp/ssnmap.c
+++ b/net/sctp/ssnmap.c
@@ -107,6 +107,26 @@ static struct sctp_ssnmap *sctp_ssnmap_init(struct sctp_ssnmap *map, __u16 in,
 	return map;
 }
 
+/* Resize the ssnmap to new length. */
+struct sctp_ssnmap *sctp_ssnmap_resize(struct sctp_ssnmap *map,
+					__u16 in, __u16 out, gfp_t gfp)
+{
+	struct sctp_ssnmap *new;
+
+	new = sctp_ssnmap_new(in, out, gfp);
+	if (!new)
+		return NULL;
+
+	memcpy(new->in.ssn, map->in.ssn,
+	       (in > map->in.len) ? map->in.len : in);
+	memcpy(new->out.ssn, map->out.ssn,
+	       (out > map->out.len) ? map->out.len : out);
+
+	sctp_ssnmap_free(map);
+
+	return new;
+}
+
 /* Clear out the ssnmap streams.  */
 void sctp_ssnmap_clear(struct sctp_ssnmap *map)
 {
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index 5f186ca..4a7cc61 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -862,6 +862,33 @@ fail:
 }
 
 
+struct sctp_ulpevent *sctp_ulpevent_make_stream_reset(
+	const struct sctp_association *asoc, __u16 flags, gfp_t gfp)
+{
+	struct sctp_ulpevent *event;
+	struct sctp_stream_reset_event *rst;
+	struct sk_buff *skb;
+	__u32 length = sizeof(struct sctp_stream_reset_event);
+
+	event = sctp_ulpevent_new(length, MSG_NOTIFICATION, gfp);
+	if (!event)
+		goto fail;
+
+	skb = sctp_event2skb(event);
+	rst = (struct sctp_stream_reset_event *)skb_put(skb, length);
+
+	rst->strrst_type = SCTP_STREAM_RESET_EVENT;
+	rst->strrst_flags = flags;
+	rst->strrst_length = length;
+
+	sctp_ulpevent_set_owner(event, asoc);
+	rst->strrst_assoc_id = sctp_assoc2id(asoc);
+
+	return event;
+fail:
+	return NULL;
+}
+
 /* Return the notification type, assuming this is a notification
  * event.
  */
-- 
1.5.3.8




