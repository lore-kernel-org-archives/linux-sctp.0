From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 08 Jul 2019 16:57:07 +0000
Subject: [PATCH net-next 4/4] sctp: rename sp strm_interleave to ep intl_enable
Message-Id: <9143b75d086dbec5aed55e4ba49d90c781f45c9a.1562604972.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1562604972.git.lucien.xin@gmail.com>
 <988dac46cfecb6ae4fa21e40bf16da6faf3da6ab.1562604972.git.lucien.xin@gmail.com>
 <40a905e7b9733c7bdca74af31ab86586fbb91cd0.1562604972.git.lucien.xin@gmail.com>
 <acc7f14e1ddd65d0515074c030c63fd339261b46.1562604972.git.lucien.xin@gmail.com>
In-Reply-To: <acc7f14e1ddd65d0515074c030c63fd339261b46.1562604972.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Like other endpoint features, strm_interleave should be moved to
sctp_endpoint and renamed to intl_enable.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 2 +-
 net/sctp/sm_make_chunk.c   | 4 ++--
 net/sctp/socket.c          | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index c41b57b..ba5c4f6 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -219,7 +219,6 @@ struct sctp_sock {
 		disable_fragments:1,
 		v4mapped:1,
 		frag_interleave:1,
-		strm_interleave:1,
 		recvrcvinfo:1,
 		recvnxtinfo:1,
 		data_ready_signalled:1;
@@ -1324,6 +1323,7 @@ struct sctp_endpoint {
 	struct list_head endpoint_shared_keys;
 	__u16 active_key_id;
 	__u8  auth_enable:1,
+	      intl_enable:1,
 	      prsctp_enable:1,
 	      reconf_enable:1;
 
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 31ab2c6..ed39396 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -269,7 +269,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	if (sp->adaptation_ind)
 		chunksize += sizeof(aiparam);
 
-	if (sp->strm_interleave) {
+	if (asoc->ep->intl_enable) {
 		extensions[num_ext] = SCTP_CID_I_DATA;
 		num_ext += 1;
 	}
@@ -2027,7 +2027,7 @@ static void sctp_process_ext_param(struct sctp_association *asoc,
 				asoc->peer.asconf_capable = 1;
 			break;
 		case SCTP_CID_I_DATA:
-			if (sctp_sk(asoc->base.sk)->strm_interleave)
+			if (asoc->ep->intl_enable)
 				asoc->peer.intl_capable = 1;
 			break;
 		default:
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b679b61..0fc5b90 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1913,7 +1913,7 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 		if (err)
 			goto err;
 
-		if (sp->strm_interleave) {
+		if (asoc->ep->intl_enable) {
 			timeo = sock_sndtimeo(sk, 0);
 			err = sctp_wait_for_connect(asoc, &timeo);
 			if (err) {
@@ -3581,7 +3581,7 @@ static int sctp_setsockopt_fragment_interleave(struct sock *sk,
 	sctp_sk(sk)->frag_interleave = !!val;
 
 	if (!sctp_sk(sk)->frag_interleave)
-		sctp_sk(sk)->strm_interleave = 0;
+		sctp_sk(sk)->ep->intl_enable = 0;
 
 	return 0;
 }
@@ -4484,7 +4484,7 @@ static int sctp_setsockopt_interleaving_supported(struct sock *sk,
 		goto out;
 	}
 
-	sp->strm_interleave = !!params.assoc_value;
+	sp->ep->intl_enable = !!params.assoc_value;
 
 	retval = 0;
 
@@ -7711,7 +7711,7 @@ static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
 	}
 
 	params.assoc_value = asoc ? asoc->peer.intl_capable
-				  : sctp_sk(sk)->strm_interleave;
+				  : sctp_sk(sk)->ep->intl_enable;
 
 	if (put_user(len, optlen))
 		goto out;
-- 
2.1.0
