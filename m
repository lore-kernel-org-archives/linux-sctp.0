From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 08 Jul 2019 16:57:06 +0000
Subject: [PATCH net-next 3/4] sctp: rename asoc intl_enable to asoc peer.intl_capable
Message-Id: <acc7f14e1ddd65d0515074c030c63fd339261b46.1562604972.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1562604972.git.lucien.xin@gmail.com>
 <988dac46cfecb6ae4fa21e40bf16da6faf3da6ab.1562604972.git.lucien.xin@gmail.com>
 <40a905e7b9733c7bdca74af31ab86586fbb91cd0.1562604972.git.lucien.xin@gmail.com>
In-Reply-To: <40a905e7b9733c7bdca74af31ab86586fbb91cd0.1562604972.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

To keep consistent with other asoc features, we move intl_enable
to peer.intl_capable in asoc.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h   | 33 +++++++++++++++++----------------
 net/sctp/sm_make_chunk.c     |  4 ++--
 net/sctp/socket.c            |  2 +-
 net/sctp/stream_interleave.c |  4 ++--
 net/sctp/stream_sched.c      |  2 +-
 5 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 7f35b8e..c41b57b 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1679,28 +1679,30 @@ struct sctp_association {
 		__be16 addip_disabled_mask;
 
 		/* These are capabilities which our peer advertised.  */
-		__u8	ecn_capable:1,      /* Can peer do ECN? */
+		__u16	ecn_capable:1,      /* Can peer do ECN? */
 			ipv4_address:1,     /* Peer understands IPv4 addresses? */
 			ipv6_address:1,     /* Peer understands IPv6 addresses? */
 			hostname_address:1, /* Peer understands DNS addresses? */
 			asconf_capable:1,   /* Does peer support ADDIP? */
 			prsctp_capable:1,   /* Can peer do PR-SCTP? */
 			reconf_capable:1,   /* Can peer do RE-CONFIG? */
-			auth_capable:1;     /* Is peer doing SCTP-AUTH? */
-
-		/* sack_needed : This flag indicates if the next received
-		 *             : packet is to be responded to with a
-		 *             : SACK. This is initialized to 0.  When a packet
-		 *             : is received sack_cnt is incremented. If this value
-		 *             : reaches 2 or more, a SACK is sent and the
-		 *             : value is reset to 0. Note: This is used only
-		 *             : when no DATA chunks are received out of
-		 *             : order.  When DATA chunks are out of order,
-		 *             : SACK's are not delayed (see Section 6).
-		 */
-		__u8    sack_needed:1,     /* Do we need to sack the peer? */
+			intl_capable:1,     /* Can peer do INTERLEAVE */
+			auth_capable:1,     /* Is peer doing SCTP-AUTH? */
+			/* sack_needed:
+			 *   This flag indicates if the next received
+			 *   packet is to be responded to with a
+			 *   SACK. This is initialized to 0.  When a packet
+			 *   is received sack_cnt is incremented. If this value
+			 *   reaches 2 or more, a SACK is sent and the
+			 *   value is reset to 0. Note: This is used only
+			 *   when no DATA chunks are received out of
+			 *   order.  When DATA chunks are out of order,
+			 *   SACK's are not delayed (see Section 6).
+			 */
+			sack_needed:1,     /* Do we need to sack the peer? */
 			sack_generation:1,
 			zero_window_announced:1;
+
 		__u32	sack_cnt;
 
 		__u32   adaptation_ind;	 /* Adaptation Code point. */
@@ -2049,8 +2051,7 @@ struct sctp_association {
 
 	__u8 need_ecne:1,	/* Need to send an ECNE Chunk? */
 	     temp:1,		/* Is it a temporary association? */
-	     force_delay:1,
-	     intl_enable:1;
+	     force_delay:1;
 
 	__u8 strreset_enable;
 	__u8 strreset_outstanding; /* request param count on the fly */
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 227bbac..31ab2c6 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -438,7 +438,7 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
 	if (sp->adaptation_ind)
 		chunksize += sizeof(aiparam);
 
-	if (asoc->intl_enable) {
+	if (asoc->peer.intl_capable) {
 		extensions[num_ext] = SCTP_CID_I_DATA;
 		num_ext += 1;
 	}
@@ -2028,7 +2028,7 @@ static void sctp_process_ext_param(struct sctp_association *asoc,
 			break;
 		case SCTP_CID_I_DATA:
 			if (sctp_sk(asoc->base.sk)->strm_interleave)
-				asoc->intl_enable = 1;
+				asoc->peer.intl_capable = 1;
 			break;
 		default:
 			break;
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index da2a3c2..b679b61 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7710,7 +7710,7 @@ static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
 		goto out;
 	}
 
-	params.assoc_value = asoc ? asoc->intl_enable
+	params.assoc_value = asoc ? asoc->peer.intl_capable
 				  : sctp_sk(sk)->strm_interleave;
 
 	if (put_user(len, optlen))
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index afbf122..40c40be 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1358,6 +1358,6 @@ void sctp_stream_interleave_init(struct sctp_stream *stream)
 	struct sctp_association *asoc;
 
 	asoc = container_of(stream, struct sctp_association, stream);
-	stream->si = asoc->intl_enable ? &sctp_stream_interleave_1
-				       : &sctp_stream_interleave_0;
+	stream->si = asoc->peer.intl_capable ? &sctp_stream_interleave_1
+					     : &sctp_stream_interleave_0;
 }
diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index b8fa7ab..99e5f69 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -228,7 +228,7 @@ int sctp_sched_get_value(struct sctp_association *asoc, __u16 sid,
 void sctp_sched_dequeue_done(struct sctp_outq *q, struct sctp_chunk *ch)
 {
 	if (!list_is_last(&ch->frag_list, &ch->msg->chunks) &&
-	    !q->asoc->intl_enable) {
+	    !q->asoc->peer.intl_capable) {
 		struct sctp_stream_out *sout;
 		__u16 sid;
 
-- 
2.1.0
