From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 08 Dec 2017 13:03:59 +0000
Subject: [PATCHv2 net-next 02/12] sctp: add asoc intl_enable negotiation during 4 shakehands
Message-Id: <7347f16f5b620ed98fdb5f7ac54db4a70e1fd27e.1512738021.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512738021.git.lucien.xin@gmail.com>
 <2fef1243f8181062aeb17f7052e5b022ec274a8e.1512738021.git.lucien.xin@gmail.com>
In-Reply-To: <2fef1243f8181062aeb17f7052e5b022ec274a8e.1512738021.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

asoc intl_enable will be set when local sp strm_interleave is set
and there's I-DATA chunk in init and init_ack extensions, as said
in section 2.2.1 of RFC8260.

asoc intl_enable indicates all data will be sent as I-DATA chunks.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 include/linux/sctp.h     |  3 +++
 net/sctp/sm_make_chunk.c | 18 ++++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index da803df..6d2bd64 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -102,6 +102,9 @@ enum sctp_cid {
 	/* AUTH Extension Section 4.1 */
 	SCTP_CID_AUTH			= 0x0F,
 
+	/* sctp ndata 5.1. I-DATA */
+	SCTP_CID_I_DATA			= 0x40,
+
 	/* PR-SCTP Sec 3.2 */
 	SCTP_CID_FWD_TSN		= 0xC0,
 
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 9bf575f..da33c85 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -228,7 +228,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	struct sctp_inithdr init;
 	union sctp_params addrs;
 	struct sctp_sock *sp;
-	__u8 extensions[4];
+	__u8 extensions[5];
 	size_t chunksize;
 	__be16 types[2];
 	int num_ext = 0;
@@ -278,6 +278,11 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	if (sp->adaptation_ind)
 		chunksize += sizeof(aiparam);
 
+	if (sp->strm_interleave) {
+		extensions[num_ext] = SCTP_CID_I_DATA;
+		num_ext += 1;
+	}
+
 	chunksize += vparam_len;
 
 	/* Account for AUTH related parameters */
@@ -392,7 +397,7 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
 	struct sctp_inithdr initack;
 	union sctp_params addrs;
 	struct sctp_sock *sp;
-	__u8 extensions[4];
+	__u8 extensions[5];
 	size_t chunksize;
 	int num_ext = 0;
 	int cookie_len;
@@ -442,6 +447,11 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
 	if (sp->adaptation_ind)
 		chunksize += sizeof(aiparam);
 
+	if (asoc->intl_enable) {
+		extensions[num_ext] = SCTP_CID_I_DATA;
+		num_ext += 1;
+	}
+
 	if (asoc->peer.auth_capable) {
 		auth_random = (struct sctp_paramhdr *)asoc->c.auth_random;
 		chunksize += ntohs(auth_random->length);
@@ -2032,6 +2042,10 @@ static void sctp_process_ext_param(struct sctp_association *asoc,
 			if (net->sctp.addip_enable)
 				asoc->peer.asconf_capable = 1;
 			break;
+		case SCTP_CID_I_DATA:
+			if (sctp_sk(asoc->base.sk)->strm_interleave)
+				asoc->intl_enable = 1;
+			break;
 		default:
 			break;
 		}
-- 
2.1.0

