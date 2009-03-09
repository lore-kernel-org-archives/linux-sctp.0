From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 09 Mar 2009 03:17:02 +0000
Subject: [PATCH 3/6] sctp: implement initializations for STREAM-RESET extension
Message-Id: <49B48A2E.1030101@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Using the Supported Extensions Parameter in either the INIT or INIT-ACK
to indication for support of the STREAM-RESET extension. If the chunk
value '0x82' does NOT appear in the supported extensions list of
chunks, then the sender MUST NOT send any stream reset request to the
peer and any request by the application for such service SHOULD be
responded to with an appropriate error indicating the peer SCTP stack
does not support the stream reset extension.

Stream Reset Request Sequence Number is a monotonically increasing
number that is initialized to the same value as the Initial TSN number.
It is increased by 1.

Stream Reset Response Sequence Number holds the Stream Reset Request
Sequence Number of the incoming request.  In the other case it holds
the next expected Stream Reset Request Sequence Number - 1.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/structs.h |   14 ++++++++++++++
 net/sctp/associola.c       |    7 +++++++
 net/sctp/sm_make_chunk.c   |   28 ++++++++++++++++++++++++++--
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index b92226b..24dc286 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1578,6 +1578,7 @@ struct sctp_association {
 		__u8    asconf_capable;  /* Does peer support ADDIP? */
 		__u8    prsctp_capable;  /* Can peer do PR-SCTP? */
 		__u8	auth_capable;	 /* Is peer doing SCTP-AUTH? */
+		__u8    strrst_capable;  /* Does peer support STREAM-RESET? */
 
 		__u32   adaptation_ind;	 /* Adaptation Code point. */
 
@@ -1603,6 +1604,13 @@ struct sctp_association {
 		sctp_random_param_t *peer_random;
 		sctp_chunks_param_t *peer_chunks;
 		sctp_hmac_algo_param_t *peer_hmacs;
+
+		/* STREAM-RESET Section 3.2.1 Outgoing SSN Reset Request
+		 * Parameter This field holds the Stream Reset Request Sequence
+		 * Number of the incoming request. In the other case it holds
+		 * the next expected Stream Reset Request Sequence Number - 1.
+		 */
+		__u32 strrst_seq;
 	} peer;
 
 	/* State       : A state variable indicating what state the
@@ -1909,6 +1917,12 @@ struct sctp_association {
 
 	__u16 active_key_id;
 
+	/* STREAM-RESET Section 3.2.1 Outgoing SSN Reset Request Parameter
+	 * It is a monotonically increasing number that is initialized to the
+	 * same value as the Initial TSN number.  It is increased by 1.
+	 */
+	__u32 strrst_seq;
+
 	/* Need to send an ECNE Chunk? */
 	char need_ecne;
 
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index f4b2304..d8b2e25 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -250,6 +250,13 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
 	INIT_LIST_HEAD(&asoc->peer.transport_addr_list);
 	asoc->peer.transport_count = 0;
 
+	/* STREAM-RESET Extension 3.2.1 Outgoing SSN Reset Request Parameter
+	 *
+	 * It is a monotonically increasing number that is initialized to the
+	 * same value as the Initial TSN number.  It is increased by 1.
+	 */
+	asoc->strrst_seq = asoc->c.initial_tsn;
+
 	/* RFC 2960 5.1 Normal Establishment of an Association
 	 *
 	 * After the reception of the first data chunk in an
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 9484f33..d39499f 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -183,7 +183,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	sctp_adaptation_ind_param_t aiparam;
 	sctp_supported_ext_param_t ext_param;
 	int num_ext = 0;
-	__u8 extensions[3];
+	__u8 extensions[4];
 	sctp_paramhdr_t *auth_chunks = NULL,
 			*auth_hmacs = NULL;
 
@@ -250,6 +250,11 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 		num_ext += 1;
 	}
 
+	if (sctp_strrst_enable) {
+		extensions[num_ext] = SCTP_CID_STREAM_RESET;
+		num_ext += 1;
+	}
+
 	/* If we have any extensions to report, account for that */
 	if (num_ext)
 		chunksize += sizeof(sctp_supported_ext_param_t) + num_ext;
@@ -339,7 +344,7 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
 	sctp_adaptation_ind_param_t aiparam;
 	sctp_supported_ext_param_t ext_param;
 	int num_ext = 0;
-	__u8 extensions[3];
+	__u8 extensions[4];
 	sctp_paramhdr_t *auth_chunks = NULL,
 			*auth_hmacs = NULL,
 			*auth_random = NULL;
@@ -403,6 +408,11 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
 		num_ext += 1;
 	}
 
+	if (asoc->peer.strrst_capable) {
+		extensions[num_ext] = SCTP_CID_STREAM_RESET;
+		num_ext += 1;
+	}
+
 	if (num_ext)
 		chunksize += sizeof(sctp_supported_ext_param_t) + num_ext;
 
@@ -1724,6 +1734,7 @@ no_hmac:
 	retval->next_tsn = retval->c.initial_tsn;
 	retval->ctsn_ack_point = retval->next_tsn - 1;
 	retval->addip_serial = retval->c.initial_tsn;
+	retval->strrst_seq = retval->c.initial_tsn;
 	retval->adv_peer_ack_point = retval->ctsn_ack_point;
 	retval->peer.prsctp_capable = retval->c.prsctp_capable;
 	retval->peer.adaptation_ind = retval->c.adaptation_ind;
@@ -1907,6 +1918,10 @@ static void sctp_process_ext_param(struct sctp_association *asoc,
 			    if (sctp_addip_enable)
 				    asoc->peer.asconf_capable = 1;
 			    break;
+		    case SCTP_CID_STREAM_RESET:
+			    if (sctp_strrst_enable)
+				    asoc->peer.strrst_capable = 1;
+			    break;
 		    default:
 			    break;
 		}
@@ -2329,6 +2344,15 @@ int sctp_process_init(struct sctp_association *asoc, sctp_cid_t cid,
 	 * association to the same value as the Initial TSN.
 	 */
 	asoc->peer.addip_serial = asoc->peer.i.initial_tsn - 1;
+
+	/* STREAM-RESET Section 3.2.1 Outgoing SSN Reset Request Parameter
+	 *
+	 * This field holds the Stream Reset Request Sequence Number
+	 * of the incoming request. In the other case it holds the
+	 * next expected Stream Reset Request Sequence Number - 1.
+	 */
+	asoc->peer.strrst_seq = asoc->peer.i.initial_tsn - 1;
+
 	return 1;
 
 clean_up:
-- 
1.5.3.8




