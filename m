From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 14 Dec 2017 16:41:28 +0000
Subject: [PATCHv2 net-next 4/8] sctp: implement report_ftsn for sctp_stream_interleave
Message-Id: <d19327abb7e1001da4f9f66e06b3dff94b867b18.1513269224.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1513269224.git.lucien.xin@gmail.com>
 <3f8811d3daf19089f75ec75afbca8b397680b6e6.1513269224.git.lucien.xin@gmail.com>
 <5982a46414cdea7856ee17683c5a714b411c7eb4.1513269224.git.lucien.xin@gmail.com>
 <30a1a95a2943469521de456d050717e1d46711fc.1513269224.git.lucien.xin@gmail.com>
In-Reply-To: <30a1a95a2943469521de456d050717e1d46711fc.1513269224.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

report_ftsn is added as a member of sctp_stream_interleave, used to
skip tsn from tsnmap, remove old events from reasm or lobby queue,
and abort pd for data or idata, called for SCTP_CMD_REPORT_FWDTSN
cmd and asoc reset.

sctp_report_iftsn works for ifwdtsn, and sctp_report_fwdtsn works
for fwdtsn. Note that sctp_report_iftsn doesn't do asoc abort_pd,
as stream abort_pd will be done when handling ifwdtsn. But when
ftsn is equal with ftsn, which means asoc reset, asoc abort_pd has
to be done.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/stream_interleave.h |  1 +
 net/sctp/sm_sideeffect.c             |  9 +------
 net/sctp/stream.c                    |  6 ++---
 net/sctp/stream_interleave.c         | 48 ++++++++++++++++++++++++++++++++++++
 4 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/include/net/sctp/stream_interleave.h b/include/net/sctp/stream_interleave.h
index 0db15b5..0b55c70 100644
--- a/include/net/sctp/stream_interleave.h
+++ b/include/net/sctp/stream_interleave.h
@@ -51,6 +51,7 @@ struct sctp_stream_interleave {
 	/* (I-)FORWARD-TSN process */
 	void	(*generate_ftsn)(struct sctp_outq *q, __u32 ctsn);
 	bool	(*validate_ftsn)(struct sctp_chunk *chunk);
+	void	(*report_ftsn)(struct sctp_ulpq *ulpq, __u32 ftsn);
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream);
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 8adde71..be7c6dbd 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1368,14 +1368,7 @@ static int sctp_cmd_interpreter(enum sctp_event event_type,
 			break;
 
 		case SCTP_CMD_REPORT_FWDTSN:
-			/* Move the Cumulattive TSN Ack ahead. */
-			sctp_tsnmap_skip(&asoc->peer.tsn_map, cmd->obj.u32);
-
-			/* purge the fragmentation queue */
-			sctp_ulpq_reasm_flushtsn(&asoc->ulpq, cmd->obj.u32);
-
-			/* Abort any in progress partial delivery. */
-			sctp_ulpq_abort_pd(&asoc->ulpq, GFP_ATOMIC);
+			asoc->stream.si->report_ftsn(&asoc->ulpq, cmd->obj.u32);
 			break;
 
 		case SCTP_CMD_PROCESS_FWDTSN:
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 8370e6c..b3a9f37 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -754,8 +754,7 @@ struct sctp_chunk *sctp_process_strreset_tsnreq(
 	 *     performed.
 	 */
 	max_tsn_seen = sctp_tsnmap_get_max_tsn_seen(&asoc->peer.tsn_map);
-	sctp_ulpq_reasm_flushtsn(&asoc->ulpq, max_tsn_seen);
-	sctp_ulpq_abort_pd(&asoc->ulpq, GFP_ATOMIC);
+	asoc->stream.si->report_ftsn(&asoc->ulpq, max_tsn_seen);
 
 	/* G1: Compute an appropriate value for the Receiver's Next TSN -- the
 	 *     TSN that the peer should use to send the next DATA chunk.  The
@@ -1024,8 +1023,7 @@ struct sctp_chunk *sctp_process_strreset_resp(
 						&asoc->peer.tsn_map);
 			LIST_HEAD(temp);
 
-			sctp_ulpq_reasm_flushtsn(&asoc->ulpq, mtsn);
-			sctp_ulpq_abort_pd(&asoc->ulpq, GFP_ATOMIC);
+			asoc->stream.si->report_ftsn(&asoc->ulpq, mtsn);
 
 			sctp_tsnmap_init(&asoc->peer.tsn_map,
 					 SCTP_TSN_MAP_INITIAL,
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index cc4a5e3..f62771cc 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1193,6 +1193,52 @@ static bool sctp_validate_iftsn(struct sctp_chunk *chunk)
 	return true;
 }
 
+static void sctp_report_fwdtsn(struct sctp_ulpq *ulpq, __u32 ftsn)
+{
+	/* Move the Cumulattive TSN Ack ahead. */
+	sctp_tsnmap_skip(&ulpq->asoc->peer.tsn_map, ftsn);
+	/* purge the fragmentation queue */
+	sctp_ulpq_reasm_flushtsn(ulpq, ftsn);
+	/* Abort any in progress partial delivery. */
+	sctp_ulpq_abort_pd(ulpq, GFP_ATOMIC);
+}
+
+static void sctp_intl_reasm_flushtsn(struct sctp_ulpq *ulpq, __u32 ftsn)
+{
+	struct sk_buff *pos, *tmp;
+
+	skb_queue_walk_safe(&ulpq->reasm, pos, tmp) {
+		struct sctp_ulpevent *event = sctp_skb2event(pos);
+		__u32 tsn = event->tsn;
+
+		if (TSN_lte(tsn, ftsn)) {
+			__skb_unlink(pos, &ulpq->reasm);
+			sctp_ulpevent_free(event);
+		}
+	}
+
+	skb_queue_walk_safe(&ulpq->reasm_uo, pos, tmp) {
+		struct sctp_ulpevent *event = sctp_skb2event(pos);
+		__u32 tsn = event->tsn;
+
+		if (TSN_lte(tsn, ftsn)) {
+			__skb_unlink(pos, &ulpq->reasm_uo);
+			sctp_ulpevent_free(event);
+		}
+	}
+}
+
+static void sctp_report_iftsn(struct sctp_ulpq *ulpq, __u32 ftsn)
+{
+	/* Move the Cumulattive TSN Ack ahead. */
+	sctp_tsnmap_skip(&ulpq->asoc->peer.tsn_map, ftsn);
+	/* purge the fragmentation queue */
+	sctp_intl_reasm_flushtsn(ulpq, ftsn);
+	/* abort only when it's for all data */
+	if (ftsn = sctp_tsnmap_get_max_tsn_seen(&ulpq->asoc->peer.tsn_map))
+		sctp_intl_abort_pd(ulpq, GFP_ATOMIC);
+}
+
 static struct sctp_stream_interleave sctp_stream_interleave_0 = {
 	.data_chunk_len		= sizeof(struct sctp_data_chunk),
 	.ftsn_chunk_len		= sizeof(struct sctp_fwdtsn_chunk),
@@ -1208,6 +1254,7 @@ static struct sctp_stream_interleave sctp_stream_interleave_0 = {
 	/* FORWARD-TSN process functions */
 	.generate_ftsn		= sctp_generate_fwdtsn,
 	.validate_ftsn		= sctp_validate_fwdtsn,
+	.report_ftsn		= sctp_report_fwdtsn,
 };
 
 static struct sctp_stream_interleave sctp_stream_interleave_1 = {
@@ -1225,6 +1272,7 @@ static struct sctp_stream_interleave sctp_stream_interleave_1 = {
 	/* I-FORWARD-TSN process functions */
 	.generate_ftsn		= sctp_generate_iftsn,
 	.validate_ftsn		= sctp_validate_iftsn,
+	.report_ftsn		= sctp_report_iftsn,
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream)
-- 
2.1.0

