From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 08 Nov 2019 05:20:36 +0000
Subject: [PATCHv4 net-next 5/5] sctp: add SCTP_PEER_ADDR_THLDS_V2 sockopt
Message-Id: <1e71490cd58220df0789cbd67006911d18c546bc.1573190212.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1573190212.git.lucien.xin@gmail.com>
 <d008eb59f963118ae264e0151da79c382f16a69b.1573190212.git.lucien.xin@gmail.com>
 <7fa091e035b70859acbfd74ea06fcb3064c4bef7.1573190212.git.lucien.xin@gmail.com>
 <45e03c4050ed2f122b6a4e19ebd6a532087088d3.1573190212.git.lucien.xin@gmail.com>
 <55f4edd068149ff8bd2c15023f181b07baef7ad0.1573190212.git.lucien.xin@gmail.com>
In-Reply-To: <55f4edd068149ff8bd2c15023f181b07baef7ad0.1573190212.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net, David Laight <david.laight@aculab.com>

Section 7.2 of rfc7829: "Peer Address Thresholds (SCTP_PEER_ADDR_THLDS)
Socket Option" extends 'struct sctp_paddrthlds' with 'spt_pathcpthld'
added to allow a user to change ps_retrans per sock/asoc/transport, as
other 2 paddrthlds: pf_retrans, pathmaxrxt.

Note: to not break the user's program, here to support pf_retrans dump
and setting by adding a new sockopt SCTP_PEER_ADDR_THLDS_V2, and a new
structure sctp_paddrthlds_v2 instead of extending sctp_paddrthlds.

Also, when setting ps_retrans, the value is not allowed to be greater
than pf_retrans.

v1->v2:
  - use SCTP_PEER_ADDR_THLDS_V2 to set/get pf_retrans instead,
    as Marcelo and David Laight suggested.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 include/uapi/linux/sctp.h | 10 +++++++++
 net/sctp/socket.c         | 54 +++++++++++++++++++++++++++++++++++------------
 2 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index a190e4a..28ad40d 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -105,6 +105,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_DEFAULT_SNDINFO	34
 #define SCTP_AUTH_DEACTIVATE_KEY	35
 #define SCTP_REUSE_PORT		36
+#define SCTP_PEER_ADDR_THLDS_V2	37
 
 /* Internal Socket Options. Some of the sctp library functions are
  * implemented using these socket options.
@@ -1087,6 +1088,15 @@ struct sctp_paddrthlds {
 	__u16 spt_pathpfthld;
 };
 
+/* Use a new structure with spt_pathcpthld for back compatibility */
+struct sctp_paddrthlds_v2 {
+	sctp_assoc_t spt_assoc_id;
+	struct sockaddr_storage spt_address;
+	__u16 spt_pathmaxrxt;
+	__u16 spt_pathpfthld;
+	__u16 spt_pathcpthld;
+};
+
 /*
  * Socket Option for Getting the Association/Stream-Specific PR-SCTP Status
  */
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 38d102b..3d2bad2 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3943,18 +3943,22 @@ static int sctp_setsockopt_auto_asconf(struct sock *sk, char __user *optval,
  */
 static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 					    char __user *optval,
-					    unsigned int optlen)
+					    unsigned int optlen, bool v2)
 {
-	struct sctp_paddrthlds val;
+	struct sctp_paddrthlds_v2 val;
 	struct sctp_transport *trans;
 	struct sctp_association *asoc;
+	int len;
 
-	if (optlen < sizeof(struct sctp_paddrthlds))
+	len = v2 ? sizeof(val) : sizeof(struct sctp_paddrthlds);
+	if (optlen < len)
 		return -EINVAL;
-	if (copy_from_user(&val, (struct sctp_paddrthlds __user *)optval,
-			   sizeof(struct sctp_paddrthlds)))
+	if (copy_from_user(&val, optval, len))
 		return -EFAULT;
 
+	if (v2 && val.spt_pathpfthld > val.spt_pathcpthld)
+		return -EINVAL;
+
 	if (!sctp_is_any(sk, (const union sctp_addr *)&val.spt_address)) {
 		trans = sctp_addr_id2transport(sk, &val.spt_address,
 					       val.spt_assoc_id);
@@ -3963,6 +3967,8 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 
 		if (val.spt_pathmaxrxt)
 			trans->pathmaxrxt = val.spt_pathmaxrxt;
+		if (v2)
+			trans->ps_retrans = val.spt_pathcpthld;
 		trans->pf_retrans = val.spt_pathpfthld;
 
 		return 0;
@@ -3978,17 +3984,23 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 				    transports) {
 			if (val.spt_pathmaxrxt)
 				trans->pathmaxrxt = val.spt_pathmaxrxt;
+			if (v2)
+				trans->ps_retrans = val.spt_pathcpthld;
 			trans->pf_retrans = val.spt_pathpfthld;
 		}
 
 		if (val.spt_pathmaxrxt)
 			asoc->pathmaxrxt = val.spt_pathmaxrxt;
+		if (v2)
+			asoc->ps_retrans = val.spt_pathcpthld;
 		asoc->pf_retrans = val.spt_pathpfthld;
 	} else {
 		struct sctp_sock *sp = sctp_sk(sk);
 
 		if (val.spt_pathmaxrxt)
 			sp->pathmaxrxt = val.spt_pathmaxrxt;
+		if (v2)
+			sp->ps_retrans = val.spt_pathcpthld;
 		sp->pf_retrans = val.spt_pathpfthld;
 	}
 
@@ -4778,7 +4790,12 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_auto_asconf(sk, optval, optlen);
 		break;
 	case SCTP_PEER_ADDR_THLDS:
-		retval = sctp_setsockopt_paddr_thresholds(sk, optval, optlen);
+		retval = sctp_setsockopt_paddr_thresholds(sk, optval, optlen,
+							  false);
+		break;
+	case SCTP_PEER_ADDR_THLDS_V2:
+		retval = sctp_setsockopt_paddr_thresholds(sk, optval, optlen,
+							  true);
 		break;
 	case SCTP_RECVRCVINFO:
 		retval = sctp_setsockopt_recvrcvinfo(sk, optval, optlen);
@@ -7217,18 +7234,19 @@ static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
  * http://www.ietf.org/id/draft-nishida-tsvwg-sctp-failover-05.txt
  */
 static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
-					    char __user *optval,
-					    int len,
-					    int __user *optlen)
+					    char __user *optval, int len,
+					    int __user *optlen, bool v2)
 {
-	struct sctp_paddrthlds val;
+	struct sctp_paddrthlds_v2 val;
 	struct sctp_transport *trans;
 	struct sctp_association *asoc;
+	int min;
 
-	if (len < sizeof(struct sctp_paddrthlds))
+	min = v2 ? sizeof(val) : sizeof(struct sctp_paddrthlds);
+	if (len < min)
 		return -EINVAL;
-	len = sizeof(struct sctp_paddrthlds);
-	if (copy_from_user(&val, (struct sctp_paddrthlds __user *)optval, len))
+	len = min;
+	if (copy_from_user(&val, optval, len))
 		return -EFAULT;
 
 	if (!sctp_is_any(sk, (const union sctp_addr *)&val.spt_address)) {
@@ -7239,6 +7257,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 
 		val.spt_pathmaxrxt = trans->pathmaxrxt;
 		val.spt_pathpfthld = trans->pf_retrans;
+		val.spt_pathcpthld = trans->ps_retrans;
 
 		goto out;
 	}
@@ -7251,11 +7270,13 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 	if (asoc) {
 		val.spt_pathpfthld = asoc->pf_retrans;
 		val.spt_pathmaxrxt = asoc->pathmaxrxt;
+		val.spt_pathcpthld = asoc->ps_retrans;
 	} else {
 		struct sctp_sock *sp = sctp_sk(sk);
 
 		val.spt_pathpfthld = sp->pf_retrans;
 		val.spt_pathmaxrxt = sp->pathmaxrxt;
+		val.spt_pathcpthld = sp->ps_retrans;
 	}
 
 out:
@@ -8135,7 +8156,12 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_getsockopt_auto_asconf(sk, len, optval, optlen);
 		break;
 	case SCTP_PEER_ADDR_THLDS:
-		retval = sctp_getsockopt_paddr_thresholds(sk, optval, len, optlen);
+		retval = sctp_getsockopt_paddr_thresholds(sk, optval, len,
+							  optlen, false);
+		break;
+	case SCTP_PEER_ADDR_THLDS_V2:
+		retval = sctp_getsockopt_paddr_thresholds(sk, optval, len,
+							  optlen, true);
 		break;
 	case SCTP_GET_ASSOC_STATS:
 		retval = sctp_getsockopt_assoc_stats(sk, len, optval, optlen);
-- 
2.1.0
