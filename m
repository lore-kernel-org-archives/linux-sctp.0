From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 09 Mar 2009 03:20:04 +0000
Subject: [PATCH 5/6] sctp: implement sender side procedures for the Stream
Message-Id: <49B48AE4.2020805@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

STREAM-RESET Extension Section 4.1.1:

   Note that before sending a Stream Reset Chunk the sender MUST ensure
   that the peer advertised support for the stream reset extension.  The
   indication for support of the extensions MUST be determined using the
   Supported Extensions Parameter in either the INIT or INIT-ACK.  This
   parameter is defined in [RFC5061].  If the chunk value '0x82' does
   NOT appear in the supported extensions list of chunks, then the
   sender MUST NOT send any stream reset request to the peer and any
   request by the application for such service SHOULD be responded to
   with an appropriate error indicating the peer SCTP stack does not
   support the stream reset extension.

   After packaging the Stream Reset Chunk and sending it to the peer the
   sender MUST start a 'Stream Reset Timer' when the STREAM RESET chunk
   contains at least one request parameter.  If it contains no request
   parameter, the Stream Reset Timer MUST NOT be started.  This timer
   MUST use the same value as SCTP's Data transmission timer (i.e. the
   RTO timer) and MUST use exponential backoff doubling the value at
   every expiration.  If the timer does expire, besides doubling the
   value, the sender MUST retransmit the Stream Reset Chunk, increment
   the appropriate error counts (both for the association and the
   destination), and do threshold management possibly destroying the
   association if SCTP retransmission thresholds are surpassed.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/command.h   |    1 +
 include/net/sctp/constants.h |    4 +-
 include/net/sctp/sctp.h      |    2 +
 include/net/sctp/sm.h        |    5 +
 include/net/sctp/structs.h   |    3 +
 net/sctp/associola.c         |    5 +
 net/sctp/outqueue.c          |    1 +
 net/sctp/primitive.c         |    4 +
 net/sctp/proc.c              |    1 +
 net/sctp/sm_make_chunk.c     |  185 ++++++++++++++++++++++++++++++++++++++++++
 net/sctp/sm_sideeffect.c     |   29 +++++++
 net/sctp/sm_statefuns.c      |   67 +++++++++++++++
 net/sctp/sm_statetable.c     |   44 ++++++++++
 net/sctp/socket.c            |  131 +++++++++++++++++++++++++++++
 14 files changed, 481 insertions(+), 1 deletions(-)

diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
index 3b96680..e7128a9 100644
--- a/include/net/sctp/command.h
+++ b/include/net/sctp/command.h
@@ -106,6 +106,7 @@ typedef enum {
 	SCTP_CMD_ASSOC_SHKEY,    /* generate the association shared keys */
 	SCTP_CMD_T1_RETRAN,	 /* Mark for retransmission after T1 timeout  */
 	SCTP_CMD_UPDATE_INITTAG, /* Update peer inittag */
+	SCTP_CMD_SETUP_T6,	 /* STREAM-RESET, setup T6 RTO timer */
 	SCTP_CMD_LAST
 } sctp_verb_t;
 
diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index b05b055..85337c2 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -101,6 +101,7 @@ typedef enum {
 	SCTP_EVENT_TIMEOUT_T3_RTX,
 	SCTP_EVENT_TIMEOUT_T4_RTO,
 	SCTP_EVENT_TIMEOUT_T5_SHUTDOWN_GUARD,
+	SCTP_EVENT_TIMEOUT_T6_RTO,
 	SCTP_EVENT_TIMEOUT_HEARTBEAT,
 	SCTP_EVENT_TIMEOUT_SACK,
 	SCTP_EVENT_TIMEOUT_AUTOCLOSE,
@@ -125,9 +126,10 @@ typedef enum {
 	SCTP_PRIMITIVE_SEND,
 	SCTP_PRIMITIVE_REQUESTHEARTBEAT,
 	SCTP_PRIMITIVE_ASCONF,
+	SCTP_PRIMITIVE_STREAMRESET,
 } sctp_event_primitive_t;
 
-#define SCTP_EVENT_PRIMITIVE_MAX	SCTP_PRIMITIVE_ASCONF
+#define SCTP_EVENT_PRIMITIVE_MAX	SCTP_PRIMITIVE_STREAMRESET
 #define SCTP_NUM_PRIMITIVE_TYPES	(SCTP_EVENT_PRIMITIVE_MAX + 1)
 
 /* We define here a utility type for manipulating subtypes.
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 9e226be..b3723e5 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -151,6 +151,7 @@ int sctp_primitive_ABORT(struct sctp_association *, void *arg);
 int sctp_primitive_SEND(struct sctp_association *, void *arg);
 int sctp_primitive_REQUESTHEARTBEAT(struct sctp_association *, void *arg);
 int sctp_primitive_ASCONF(struct sctp_association *, void *arg);
+int sctp_primitive_STREAMRESET(struct sctp_association *, void *arg);
 
 /*
  * sctp/input.c
@@ -260,6 +261,7 @@ enum
 	SCTP_MIB_T3_RTX_EXPIREDS,
 	SCTP_MIB_T4_RTO_EXPIREDS,
 	SCTP_MIB_T5_SHUTDOWN_GUARD_EXPIREDS,
+	SCTP_MIB_T6_RTO_EXPIREDS,
 	SCTP_MIB_DELAY_SACK_EXPIREDS,
 	SCTP_MIB_AUTOCLOSE_EXPIREDS,
 	SCTP_MIB_T1_RETRANSMITS,
diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index c1dd893..4f40111 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -120,6 +120,7 @@ sctp_state_fn_t sctp_sf_t1_cookie_timer_expire;
 sctp_state_fn_t sctp_sf_t2_timer_expire;
 sctp_state_fn_t sctp_sf_t4_timer_expire;
 sctp_state_fn_t sctp_sf_t5_timer_expire;
+sctp_state_fn_t sctp_sf_t6_timer_expire;
 sctp_state_fn_t sctp_sf_sendbeat_8_3;
 sctp_state_fn_t sctp_sf_beat_8_3;
 sctp_state_fn_t sctp_sf_backbeat_8_3;
@@ -163,6 +164,7 @@ sctp_state_fn_t sctp_sf_error_shutdown;
 sctp_state_fn_t sctp_sf_ignore_primitive;
 sctp_state_fn_t sctp_sf_do_prm_requestheartbeat;
 sctp_state_fn_t sctp_sf_do_prm_asconf;
+sctp_state_fn_t sctp_sf_do_prm_stream_reset;
 
 /* Prototypes for other event state functions.  */
 sctp_state_fn_t sctp_sf_do_9_2_start_shutdown;
@@ -262,6 +264,9 @@ struct sctp_chunk *sctp_make_fwdtsn(const struct sctp_association *asoc,
 				    __u32 new_cum_tsn, size_t nstreams,
 				    struct sctp_fwdtsn_skip *skiplist);
 struct sctp_chunk *sctp_make_auth(const struct sctp_association *asoc);
+struct sctp_chunk *sctp_make_stream_reset(struct sctp_association *asoc,
+					  __u16 flags, __u16 nstreams,
+					  __u16 *streamlist);
 
 void sctp_chunk_assign_tsn(struct sctp_chunk *);
 void sctp_chunk_assign_ssn(struct sctp_chunk *);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 24dc286..a16d35c 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1923,6 +1923,9 @@ struct sctp_association {
 	 */
 	__u32 strrst_seq;
 
+	/* Cache the STREAM-RESET chunk last send */
+	struct sctp_chunk *strrst_last_stream_reset;
+
 	/* Need to send an ECNE Chunk? */
 	char need_ecne;
 
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index d8b2e25..a2e585d 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -167,6 +167,7 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
 	asoc->timeouts[SCTP_EVENT_TIMEOUT_SACK] = asoc->sackdelay;
 	asoc->timeouts[SCTP_EVENT_TIMEOUT_AUTOCLOSE]  		sp->autoclose * HZ;
+	asoc->timeouts[SCTP_EVENT_TIMEOUT_T6_RTO] = 0;
 
 	/* Initilizes the timers */
 	for (i = SCTP_EVENT_TIMEOUT_NONE; i < SCTP_NUM_TIMEOUT_TYPES; ++i)
@@ -449,6 +450,10 @@ void sctp_association_free(struct sctp_association *asoc)
 	if (asoc->addip_last_asconf)
 		sctp_chunk_free(asoc->addip_last_asconf);
 
+	/* Free any cached STREAM-RESET chunk. */
+	if (asoc->strrst_last_stream_reset)
+		sctp_chunk_free(asoc->strrst_last_stream_reset);
+
 	/* AUTH - Free the endpoint shared keys */
 	sctp_auth_destroy_keys(&asoc->endpoint_shared_keys);
 
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index d765fc5..6f0ddc5 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -856,6 +856,7 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 		case SCTP_CID_ECN_ECNE:
 		case SCTP_CID_ASCONF:
 		case SCTP_CID_FWD_TSN:
+		case SCTP_CID_STREAM_RESET:
 			status = sctp_packet_transmit_chunk(packet, chunk,
 							    one_packet);
 			if (status  != SCTP_XMIT_OK) {
diff --git a/net/sctp/primitive.c b/net/sctp/primitive.c
index 8cb4f06..da82df1 100644
--- a/net/sctp/primitive.c
+++ b/net/sctp/primitive.c
@@ -217,3 +217,7 @@ DECLARE_PRIMITIVE(REQUESTHEARTBEAT);
 */
 
 DECLARE_PRIMITIVE(ASCONF);
+
+/* STREAM-RESET 3.1 STREAM RESET Chunk */
+DECLARE_PRIMITIVE(STREAMRESET);
+
diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index f268910..aa52b28 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -64,6 +64,7 @@ static struct snmp_mib sctp_snmp_list[] = {
 	SNMP_MIB_ITEM("SctpT3RtxExpireds", SCTP_MIB_T3_RTX_EXPIREDS),
 	SNMP_MIB_ITEM("SctpT4RtoExpireds", SCTP_MIB_T4_RTO_EXPIREDS),
 	SNMP_MIB_ITEM("SctpT5ShutdownGuardExpireds", SCTP_MIB_T5_SHUTDOWN_GUARD_EXPIREDS),
+	SNMP_MIB_ITEM("SctpT6RtoExpireds", SCTP_MIB_T6_RTO_EXPIREDS),
 	SNMP_MIB_ITEM("SctpDelaySackExpireds", SCTP_MIB_DELAY_SACK_EXPIREDS),
 	SNMP_MIB_ITEM("SctpAutocloseExpireds", SCTP_MIB_AUTOCLOSE_EXPIREDS),
 	SNMP_MIB_ITEM("SctpT3Retransmits", SCTP_MIB_T3_RETRANSMITS),
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index d39499f..9a27454 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3368,3 +3368,188 @@ struct sctp_chunk *sctp_make_fwdtsn(const struct sctp_association *asoc,
 
 	return retval;
 }
+
+/* STREAM-RESET 3.2.1 Outgoing SSN Reset Request Parameter
+ *
+ *      0                   1                   2                   3
+ *      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |     Parameter Type = 0x000d   |      Parameter Length         |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |             Stream Reset Request Sequence Number              |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |             Stream Reset Response Sequence Number             |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |                Senders Last Assigned TSN                      |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |  Stream Number 1 (optional)   |    Stream Number 2 (optional) |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     /                            ......                             /
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |  Stream Number N-1 (optional) |    Stream Number N (optional) |
+ *      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ * Create an Outgoing SSN Reset Request Parameter and add it to
+ * STREAM-RESET chunk.
+ */
+static void sctp_add_stream_reset_out(struct sctp_chunk *retval,
+			__u32 seq_req, __u32 seq_res, __u32 next_tsn,
+			int len, void *streams)
+{
+	struct sctp_reset_out_req out;
+
+	out.param_hdr.type = SCTP_PARAM_RESET_OUT_REQUEST;
+	out.param_hdr.length = htons(sizeof(struct sctp_reset_out_req) + len);
+	out.request_seq = htonl(seq_req);
+	out.response_seq = htonl(seq_res);
+	out.send_reset_at_tsn = htonl(next_tsn);
+
+	sctp_addto_chunk(retval, sizeof(out), &out);
+
+	if (len > 0)
+		sctp_addto_param(retval, len, streams);
+}
+
+/* STREAM-RESET 3.2.2 Incoming SSN Reset Request Parameter
+ *
+ *      0                   1                   2                   3
+ *      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |     Parameter Type = 0x000e   |      Parameter Length         |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |            Stream Reset Request Sequence Number               |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |  Stream Number 1 (optional)   |    Stream Number 2 (optional) |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     /                            ......                             /
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |  Stream Number N-1 (optional) |    Stream Number N (optional) |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ * Create an Incoming SSN Reset Request Parameter and add it to
+ * STREAM-RESET chunk.
+ */
+static void sctp_add_stream_reset_in(struct sctp_chunk *retval,
+			__u32 seq_req, int len, void *streams)
+{
+	struct sctp_reset_in_req in;
+
+	in.param_hdr.type = SCTP_PARAM_RESET_IN_REQUEST;
+	in.param_hdr.length = htons(sizeof(struct sctp_reset_in_req) + len);
+	in.request_seq = htonl(seq_req);
+
+	sctp_addto_chunk(retval, sizeof(in), &in);
+
+	if (len > 0)
+		sctp_addto_param(retval, len, streams);
+}
+
+/* STREAM-RESET 3.2.3 SSN/TSN Reset Request Parameter
+ *
+ *      0                   1                   2                   3
+ *      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |     Parameter Type = 0x000f   |      Parameter Length         |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |           Stream Reset Request Sequence Number                |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ * Create a SSN/TSN Reset Request Parameter and add it to STREAM-RESET chunk.
+ */
+static void sctp_add_stream_reset_tsn(struct sctp_chunk *retval, __u32 seq_req)
+{
+	struct sctp_reset_tsn_req tsn;
+
+	tsn.param_hdr.type = SCTP_PARAM_RESET_TSN_REQUEST;
+	tsn.param_hdr.length = htons(sizeof(struct sctp_reset_tsn_req));
+	tsn.request_seq = htonl(seq_req);
+
+	sctp_addto_chunk(retval, sizeof(tsn), &tsn);
+}
+
+/* STREAM-RESET 3.2.5 Add Streams
+ *
+ *      0                   1                   2                   3
+ *      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |     Parameter Type = 0x0011   |      Parameter Length      |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |            Stream Reset Request Sequence Number               |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |      Number of new streams    |         Reserved              |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ * Create an Add Streams Parameter and add it to STREAM-RESET chunk.
+ */
+static void sctp_add_stream_reset_add(struct sctp_chunk *retval,
+				      __u32 seq_req, __u32 nstreams)
+{
+	struct sctp_add_stream add;
+
+	add.param_hdr.type = SCTP_PARAM_ADD_STREAM;
+	add.param_hdr.length = htons(sizeof(struct sctp_add_stream));
+	add.request_seq = htonl(seq_req);
+	add.num_streams = htons(nstreams);
+	add.reserved = 0;
+
+	sctp_addto_chunk(retval, sizeof(add), &add);
+}
+
+/* STREAM-RESET 3.1 STREAM RESET Chunk
+ *
+ *      0                   1                   2                   3
+ *      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     | Type = 0x82   |  Chunk Flags  |      Chunk Length             |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |                    Stream Reset Parameter                     |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *     |                    Stream Reset Parameter (optional)          |
+ *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ *
+ * Create an STREAM-RESET chunk with enough space for the parameter.
+ */
+struct sctp_chunk *sctp_make_stream_reset(struct sctp_association *asoc,
+					  __u16 flags, __u16 nstreams,
+					  __u16 *streamlist)
+{
+	struct sctp_chunk *retval;
+	size_t length = sizeof(struct sctp_strrst_chunk);
+
+	if (flags & SCTP_STREAM_RESET_OUT)
+		length += WORD_ROUND(sizeof(struct sctp_reset_out_req) +
+				     nstreams * 2);
+
+	if (flags & SCTP_STREAM_RESET_IN)
+		length += WORD_ROUND(sizeof(struct sctp_reset_in_req) +
+				     nstreams * 2);
+
+	if (flags & SCTP_STREAM_RESET_TSN)
+		length += sizeof(struct sctp_reset_tsn_req);
+
+	if (flags & SCTP_STREAM_RESET_ADD)
+		length += sizeof(struct sctp_add_stream);
+
+	retval = sctp_make_chunk(asoc, SCTP_CID_STREAM_RESET, 0, length);
+	if (!retval)
+		return NULL;
+
+	if (flags & SCTP_STREAM_RESET_OUT)
+		sctp_add_stream_reset_out(retval, asoc->strrst_seq++,
+			asoc->peer.strrst_seq, asoc->next_tsn - 1,
+			nstreams * 2, streamlist);
+
+	if (flags & SCTP_STREAM_RESET_IN)
+		sctp_add_stream_reset_in(retval, asoc->strrst_seq++,
+			nstreams * 2, streamlist);
+
+	if (flags & SCTP_STREAM_RESET_TSN)
+		sctp_add_stream_reset_tsn(retval, asoc->strrst_seq++);
+
+	if (flags & SCTP_STREAM_RESET_ADD)
+		sctp_add_stream_reset_add(retval, asoc->strrst_seq++,
+					  nstreams);
+
+	return retval;
+}
+
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index e2020eb..baf8fb0 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -404,6 +404,12 @@ static void sctp_generate_sack_event(unsigned long data)
 	sctp_generate_timeout_event(asoc, SCTP_EVENT_TIMEOUT_SACK);
 }
 
+static void sctp_generate_t6_rto_event(unsigned long data)
+{
+	struct sctp_association *asoc = (struct sctp_association *) data;
+	sctp_generate_timeout_event(asoc, SCTP_EVENT_TIMEOUT_T6_RTO);
+}
+
 sctp_timer_event_t *sctp_timer_events[SCTP_NUM_TIMEOUT_TYPES] = {
 	NULL,
 	sctp_generate_t1_cookie_event,
@@ -412,6 +418,7 @@ sctp_timer_event_t *sctp_timer_events[SCTP_NUM_TIMEOUT_TYPES] = {
 	NULL,
 	sctp_generate_t4_rto_event,
 	sctp_generate_t5_shutdown_guard_event,
+	sctp_generate_t6_rto_event,
 	NULL,
 	sctp_generate_sack_event,
 	sctp_generate_autoclose_event,
@@ -782,6 +789,24 @@ static void sctp_cmd_setup_t4(sctp_cmd_seq_t *cmds,
 	chunk->transport = t;
 }
 
+/*
+ * STREAM-RESET Section 4.1.1 Sender side procedures for the Stream Reset Chunk
+ *
+ * After packaging the Stream Reset Chunk and sending it to the peer the
+ * sender MUST start a 'Stream Reset Timer' when the STREAM RESET chunk
+ * contains at least one request parameter.
+ */
+static void sctp_cmd_setup_t6(sctp_cmd_seq_t *cmds,
+				struct sctp_association *asoc,
+				struct sctp_chunk *chunk)
+{
+	struct sctp_transport *t;
+
+	t = asoc->peer.active_path;
+	asoc->timeouts[SCTP_EVENT_TIMEOUT_T6_RTO] = t->rto;
+	chunk->transport = t;
+}
+
 /* Process an incoming Operation Error Chunk. */
 static void sctp_cmd_process_operr(sctp_cmd_seq_t *cmds,
 				   struct sctp_association *asoc,
@@ -1574,6 +1599,10 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
 			asoc->peer.i.init_tag = cmd->obj.u32;
 			break;
 
+		case SCTP_CMD_SETUP_T6:
+			sctp_cmd_setup_t6(commands, asoc, cmd->obj.ptr);
+			break;
+
 		default:
 			printk(KERN_WARNING "Impossible command: %u, %p\n",
 			       cmd->verb, cmd->obj.ptr);
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 55a61aa..1a001d7 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4982,6 +4982,22 @@ sctp_disposition_t sctp_sf_do_prm_asconf(const struct sctp_endpoint *ep,
 	return SCTP_DISPOSITION_CONSUME;
 }
 
+/* STREAM-RESET Section 4.1 Sender side procedures */
+sctp_disposition_t sctp_sf_do_prm_stream_reset(const struct sctp_endpoint *ep,
+					const struct sctp_association *asoc,
+					const sctp_subtype_t type,
+					void *arg,
+					sctp_cmd_seq_t *commands)
+{
+	struct sctp_chunk *chunk = arg;
+
+	sctp_add_cmd_sf(commands, SCTP_CMD_SETUP_T6, SCTP_CHUNK(chunk));
+	sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_START,
+			SCTP_TO(SCTP_EVENT_TIMEOUT_T6_RTO));
+	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(chunk));
+	return SCTP_DISPOSITION_CONSUME;
+}
+
 /*
  * Ignore the primitive event
  *
@@ -5588,6 +5604,57 @@ sctp_disposition_t sctp_sf_autoclose_timer_expire(
 	return disposition;
 }
 
+/*
+ * STREAM-RESET Section 4.1.1 Sender side procedures for the Stream Reset Chunk
+ *
+ * If the timer does expire, besides doubling the value, the sender MUST
+ * retransmit the Stream Reset Chunk, increment the appropriate error
+ * counts (both for the association and the destination), and do threshold
+ * management possibly destroying the association if SCTP retransmission
+ * thresholds are surpassed.
+ */
+sctp_disposition_t sctp_sf_t6_timer_expire(
+	const struct sctp_endpoint *ep,
+	const struct sctp_association *asoc,
+	const sctp_subtype_t type,
+	void *arg,
+	sctp_cmd_seq_t *commands)
+{
+	struct sctp_chunk *chunk = asoc->strrst_last_stream_reset;
+	struct sctp_transport *transport = chunk->transport;
+
+	SCTP_INC_STATS(SCTP_MIB_T6_RTO_EXPIREDS);
+
+	/* Increment the appropriate error counts */
+	sctp_add_cmd_sf(commands, SCTP_CMD_STRIKE, SCTP_TRANSPORT(transport));
+
+	/* Reconfig T6 timer and transport. */
+	sctp_add_cmd_sf(commands, SCTP_CMD_SETUP_T6, SCTP_CHUNK(chunk));
+
+	/* do threshold management possibly destroying the association if
+	 * SCTP retransmission thresholds are surpassed
+	 */
+	if (asoc->overall_error_count >= asoc->max_retrans) {
+		sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_STOP,
+				SCTP_TO(SCTP_EVENT_TIMEOUT_T6_RTO));
+		sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR,
+				SCTP_ERROR(ETIMEDOUT));
+		sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
+				SCTP_PERR(SCTP_ERROR_NO_ERROR));
+		SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
+		SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
+		return SCTP_DISPOSITION_ABORT;
+	}
+
+	sctp_chunk_hold(chunk);
+	sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(chunk));
+
+	sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_RESTART,
+			SCTP_TO(SCTP_EVENT_TIMEOUT_T6_RTO));
+
+	return SCTP_DISPOSITION_CONSUME;
+}
+
 /*****************************************************************************
  * These are sa state functions which could apply to all types of events.
  ****************************************************************************/
diff --git a/net/sctp/sm_statetable.c b/net/sctp/sm_statetable.c
index 5c8186d..40c9472 100644
--- a/net/sctp/sm_statetable.c
+++ b/net/sctp/sm_statetable.c
@@ -700,6 +700,27 @@ chunk_event_table_unknown[SCTP_STATE_NUM_STATES] = {
 	TYPE_SCTP_FUNC(sctp_sf_error_shutdown), \
 } /* TYPE_SCTP_PRIMITIVE_REQUESTHEARTBEAT */
 
+#define TYPE_SCTP_PRIMITIVE_STREAMRESET { \
+	/* SCTP_STATE_EMPTY */ \
+	TYPE_SCTP_FUNC(sctp_sf_bug), \
+	/* SCTP_STATE_CLOSED */ \
+	TYPE_SCTP_FUNC(sctp_sf_error_closed), \
+	/* SCTP_STATE_COOKIE_WAIT */ \
+	TYPE_SCTP_FUNC(sctp_sf_error_closed), \
+	/* SCTP_STATE_COOKIE_ECHOED */ \
+	TYPE_SCTP_FUNC(sctp_sf_error_closed), \
+	/* SCTP_STATE_ESTABLISHED */ \
+	TYPE_SCTP_FUNC(sctp_sf_do_prm_stream_reset), \
+	/* SCTP_STATE_SHUTDOWN_PENDING */ \
+	TYPE_SCTP_FUNC(sctp_sf_do_prm_stream_reset), \
+	/* SCTP_STATE_SHUTDOWN_SENT */ \
+	TYPE_SCTP_FUNC(sctp_sf_do_prm_stream_reset), \
+	/* SCTP_STATE_SHUTDOWN_RECEIVED */ \
+	TYPE_SCTP_FUNC(sctp_sf_do_prm_stream_reset), \
+	/* SCTP_STATE_SHUTDOWN_ACK_SENT */ \
+	TYPE_SCTP_FUNC(sctp_sf_error_shutdown), \
+} /* TYPE_SCTP_PRIMITIVE_STREAMRESET */
+
 /* The primary index for this table is the primitive type.
  * The secondary index for this table is the state.
  */
@@ -710,6 +731,7 @@ static const sctp_sm_table_entry_t primitive_event_table[SCTP_NUM_PRIMITIVE_TYPE
 	TYPE_SCTP_PRIMITIVE_SEND,
 	TYPE_SCTP_PRIMITIVE_REQUESTHEARTBEAT,
 	TYPE_SCTP_PRIMITIVE_ASCONF,
+	TYPE_SCTP_PRIMITIVE_STREAMRESET,
 };
 
 #define TYPE_SCTP_OTHER_NO_PENDING_TSN  { \
@@ -906,6 +928,27 @@ static const sctp_sm_table_entry_t other_event_table[SCTP_NUM_OTHER_TYPES][SCTP_
 	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
 }
 
+#define TYPE_SCTP_EVENT_TIMEOUT_T6_RTO { \
+	/* SCTP_STATE_EMPTY */ \
+	TYPE_SCTP_FUNC(sctp_sf_bug), \
+	/* SCTP_STATE_CLOSED */ \
+	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
+	/* SCTP_STATE_COOKIE_WAIT */ \
+	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
+	/* SCTP_STATE_COOKIE_ECHOED */ \
+	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
+	/* SCTP_STATE_ESTABLISHED */ \
+	TYPE_SCTP_FUNC(sctp_sf_t6_timer_expire), \
+	/* SCTP_STATE_SHUTDOWN_PENDING */ \
+	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
+	/* SCTP_STATE_SHUTDOWN_SENT */ \
+	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
+	/* SCTP_STATE_SHUTDOWN_RECEIVED */ \
+	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
+	/* SCTP_STATE_SHUTDOWN_ACK_SENT */ \
+	TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
+}
+
 #define TYPE_SCTP_EVENT_TIMEOUT_HEARTBEAT { \
 	/* SCTP_STATE_EMPTY */ \
 	TYPE_SCTP_FUNC(sctp_sf_bug), \
@@ -977,6 +1020,7 @@ static const sctp_sm_table_entry_t timeout_event_table[SCTP_NUM_TIMEOUT_TYPES][S
 	TYPE_SCTP_EVENT_TIMEOUT_T3_RTX,
 	TYPE_SCTP_EVENT_TIMEOUT_T4_RTO,
 	TYPE_SCTP_EVENT_TIMEOUT_T5_SHUTDOWN_GUARD,
+	TYPE_SCTP_EVENT_TIMEOUT_T6_RTO,
 	TYPE_SCTP_EVENT_TIMEOUT_HEARTBEAT,
 	TYPE_SCTP_EVENT_TIMEOUT_SACK,
 	TYPE_SCTP_EVENT_TIMEOUT_AUTOCLOSE,
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index bbd3cd2..33d6c58 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -602,6 +602,25 @@ out:
 	return retval;
 }
 
+static int sctp_send_stream_reset(struct sctp_association *asoc,
+				  struct sctp_chunk *chunk)
+{
+	int retval = 0;
+
+	if (asoc->strrst_last_stream_reset)
+		return -EBUSY;
+
+	/* Hold the chunk until an Response is received. */
+	sctp_chunk_hold(chunk);
+	retval = sctp_primitive_STREAMRESET(asoc, chunk);
+	if (retval)
+		sctp_chunk_free(chunk);
+	else
+		asoc->strrst_last_stream_reset = chunk;
+
+	return retval;
+}
+
 /* Remove a list of addresses from bind addresses list.  Do not remove the
  * last address.
  *
@@ -3276,6 +3295,115 @@ static int sctp_setsockopt_del_key(struct sock *sk,
 
 }
 
+static int sctp_setsockopt_reset_stream(struct sock *sk,
+					char __user *optval,
+					int optlen)
+{
+	struct sctp_stream_reset *streams;
+	struct sctp_association *asoc;
+	struct sctp_chunk *chunk;
+	int ret = 0, i;
+	__u16 nstreams;
+
+	if (!sctp_strrst_enable)
+		return -EPERM;
+
+	if (optlen < sizeof(struct sctp_stream_reset))
+		return -EINVAL;
+
+	streams = kmalloc(optlen, GFP_KERNEL);
+	if (!streams)
+		return -ENOMEM;
+
+	if (copy_from_user(streams, optval, optlen)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	nstreams = streams->strrst_number_of_streams;
+	if ((nstreams * 2 > optlen - sizeof(struct sctp_stream_reset) &&
+	     streams->strrst_flags != SCTP_STREAM_RESET_ADD) ||
+	    (nstreams != 0 && streams->strrst_flags = SCTP_STREAM_RESET_TSN) ||
+	    (nstreams = 0 && streams->strrst_flags = SCTP_STREAM_RESET_ADD)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	asoc = sctp_id2assoc(sk, streams->strrst_assoc_id);
+	if (!asoc) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!asoc->peer.strrst_capable) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	if (!sctp_state(asoc, ESTABLISHED)) {
+		ret = -ENOTCONN;
+		goto out;
+	}
+
+	if (asoc->strrst_last_stream_reset)
+		return -EBUSY;
+
+	/* STREAM-RESET 3.1 STREAM RESET Chunk
+	 *
+	 * Note each STREAM RESET chunk holds at least one parameter and at most
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
+	switch (streams->strrst_flags) {
+	case SCTP_STREAM_RESET_IN:
+	case SCTP_STREAM_RESET_OUT:
+	case SCTP_STREAM_RESET_BOTH:
+	{
+		__u16 *list = streams->strrst_streams;
+		for (i = 0; i < nstreams; i++) {
+			if ((streams->strrst_flags & SCTP_STREAM_RESET_IN) &&
+			    list[i] >= asoc->c.sinit_max_instreams) {
+				ret = -EINVAL;
+				goto out;
+			}
+			if ((streams->strrst_flags & SCTP_STREAM_RESET_OUT) &&
+			    list[i] >= asoc->c.sinit_num_ostreams) {
+				ret = -EINVAL;
+				goto out;
+			}
+			list[i] = htons(list[i]);
+		}
+		break;
+	}
+	case SCTP_STREAM_RESET_TSN:
+	case SCTP_STREAM_RESET_ADD:
+		break;
+	default:
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Create an STREAM-RESET chunk with request parameters */
+	chunk = sctp_make_stream_reset(asoc, streams->strrst_flags,
+				       nstreams, streams->strrst_streams);
+	if (!chunk) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = sctp_send_stream_reset(asoc, chunk);
+out:
+	kfree(streams);
+	return ret;
+}
 
 /* API 6.2 setsockopt(), getsockopt()
  *
@@ -3423,6 +3551,9 @@ SCTP_STATIC int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_AUTH_DELETE_KEY:
 		retval = sctp_setsockopt_del_key(sk, optval, optlen);
 		break;
+	case SCTP_RESET_STREAMS:
+		retval = sctp_setsockopt_reset_stream(sk, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
-- 
1.5.3.8




