From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:47:06 +0000
Subject: [PATCH 31/49] sctp: pass a kernel pointer to sctp_setsockopt_paddr_thresholds
Message-Id: <20200521174724.2635475-32-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200521174724.2635475-1-hch@lst.de>
In-Reply-To: <20200521174724.2635475-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Use the kernel pointer that sctp_setsockopt has available instead of
directly handling the user pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 53 ++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 04eac086831f0..a2aa1e309d595 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3836,10 +3836,9 @@ static int sctp_setsockopt_auto_asconf(struct sock *sk, int *val,
  * http://www.ietf.org/id/draft-nishida-tsvwg-sctp-failover-05.txt
  */
 static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
-					    char __user *optval,
+					    struct sctp_paddrthlds_v2 *val,
 					    unsigned int optlen, bool v2)
 {
-	struct sctp_paddrthlds_v2 val;
 	struct sctp_transport *trans;
 	struct sctp_association *asoc;
 	int len;
@@ -3847,55 +3846,53 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 	len = v2 ? sizeof(val) : sizeof(struct sctp_paddrthlds);
 	if (optlen < len)
 		return -EINVAL;
-	if (copy_from_user(&val, optval, len))
-		return -EFAULT;
 
-	if (v2 && val.spt_pathpfthld > val.spt_pathcpthld)
+	if (v2 && val->spt_pathpfthld > val->spt_pathcpthld)
 		return -EINVAL;
 
-	if (!sctp_is_any(sk, (const union sctp_addr *)&val.spt_address)) {
-		trans = sctp_addr_id2transport(sk, &val.spt_address,
-					       val.spt_assoc_id);
+	if (!sctp_is_any(sk, (const union sctp_addr *)&val->spt_address)) {
+		trans = sctp_addr_id2transport(sk, &val->spt_address,
+					       val->spt_assoc_id);
 		if (!trans)
 			return -ENOENT;
 
-		if (val.spt_pathmaxrxt)
-			trans->pathmaxrxt = val.spt_pathmaxrxt;
+		if (val->spt_pathmaxrxt)
+			trans->pathmaxrxt = val->spt_pathmaxrxt;
 		if (v2)
-			trans->ps_retrans = val.spt_pathcpthld;
-		trans->pf_retrans = val.spt_pathpfthld;
+			trans->ps_retrans = val->spt_pathcpthld;
+		trans->pf_retrans = val->spt_pathpfthld;
 
 		return 0;
 	}
 
-	asoc = sctp_id2assoc(sk, val.spt_assoc_id);
-	if (!asoc && val.spt_assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, val->spt_assoc_id);
+	if (!asoc && val->spt_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
 		list_for_each_entry(trans, &asoc->peer.transport_addr_list,
 				    transports) {
-			if (val.spt_pathmaxrxt)
-				trans->pathmaxrxt = val.spt_pathmaxrxt;
+			if (val->spt_pathmaxrxt)
+				trans->pathmaxrxt = val->spt_pathmaxrxt;
 			if (v2)
-				trans->ps_retrans = val.spt_pathcpthld;
-			trans->pf_retrans = val.spt_pathpfthld;
+				trans->ps_retrans = val->spt_pathcpthld;
+			trans->pf_retrans = val->spt_pathpfthld;
 		}
 
-		if (val.spt_pathmaxrxt)
-			asoc->pathmaxrxt = val.spt_pathmaxrxt;
+		if (val->spt_pathmaxrxt)
+			asoc->pathmaxrxt = val->spt_pathmaxrxt;
 		if (v2)
-			asoc->ps_retrans = val.spt_pathcpthld;
-		asoc->pf_retrans = val.spt_pathpfthld;
+			asoc->ps_retrans = val->spt_pathcpthld;
+		asoc->pf_retrans = val->spt_pathpfthld;
 	} else {
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		if (val.spt_pathmaxrxt)
-			sp->pathmaxrxt = val.spt_pathmaxrxt;
+		if (val->spt_pathmaxrxt)
+			sp->pathmaxrxt = val->spt_pathmaxrxt;
 		if (v2)
-			sp->ps_retrans = val.spt_pathcpthld;
-		sp->pf_retrans = val.spt_pathpfthld;
+			sp->ps_retrans = val->spt_pathcpthld;
+		sp->pf_retrans = val->spt_pathpfthld;
 	}
 
 	return 0;
@@ -4686,11 +4683,11 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_auto_asconf(sk, kopt, optlen);
 		break;
 	case SCTP_PEER_ADDR_THLDS:
-		retval = sctp_setsockopt_paddr_thresholds(sk, optval, optlen,
+		retval = sctp_setsockopt_paddr_thresholds(sk, kopt, optlen,
 							  false);
 		break;
 	case SCTP_PEER_ADDR_THLDS_V2:
-		retval = sctp_setsockopt_paddr_thresholds(sk, optval, optlen,
+		retval = sctp_setsockopt_paddr_thresholds(sk, kopt, optlen,
 							  true);
 		break;
 	case SCTP_RECVRCVINFO:
-- 
2.26.2
