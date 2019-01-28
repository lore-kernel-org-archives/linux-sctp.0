From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Jan 2019 07:08:29 +0000
Subject: [PATCH net-next 07/24] sctp: add SCTP_FUTURE_ASSOC for SCTP_PEER_ADDR_THLDS sockopt
Message-Id: <ad87082d72bcf6efccfca7b13adb3a73c72c02ee.1548659198.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1548659198.git.lucien.xin@gmail.com>
 <3ca66b981a0fe9368bd976676fe7450634b091cd.1548659198.git.lucien.xin@gmail.com>
 <bf66a45aa6763646c07e1b8be102466f07fc1648.1548659198.git.lucien.xin@gmail.com>
 <16e83f8259873a6818863586e6a3fcb1e2e3717b.1548659198.git.lucien.xin@gmail.com>
 <088bc37947694e4e80302b075f767a7828ea4a05.1548659198.git.lucien.xin@gmail.com>
 <b6b839acf08b7ed5ea06b36156ab3ad8a4a47cf7.1548659198.git.lucien.xin@gmail.com>
 <285500315e06236e468142d80c6557eae4898b36.1548659198.git.lucien.xin@gmail.com>
In-Reply-To: <285500315e06236e468142d80c6557eae4898b36.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Check with SCTP_FUTURE_ASSOC instead in
sctp_set/getsockopt_paddr_thresholds, it's compatible with 0.

It also adds pf_retrans in sctp_sock to support SCTP_FUTURE_ASSOC.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h |  2 ++
 net/sctp/associola.c       |  2 +-
 net/sctp/socket.c          | 58 ++++++++++++++++++++++++++++++++--------------
 3 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 003020e..a5a46b1 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -199,6 +199,8 @@ struct sctp_sock {
 	__u32 flowlabel;
 	__u8  dscp;
 
+	int pf_retrans;
+
 	/* The initial Path MTU to use for new associations. */
 	__u32 pathmtu;
 
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index b99f163..d2c7d0d 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -101,7 +101,7 @@ static struct sctp_association *sctp_association_init(
 	 * socket values.
 	 */
 	asoc->max_retrans = sp->assocparams.sasoc_asocmaxrxt;
-	asoc->pf_retrans  = net->sctp.pf_retrans;
+	asoc->pf_retrans  = sp->pf_retrans;
 
 	asoc->rto_initial = msecs_to_jiffies(sp->rtoinfo.srto_initial);
 	asoc->rto_max = msecs_to_jiffies(sp->rtoinfo.srto_max);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 7df2123..1d49b7d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3888,11 +3888,25 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 			   sizeof(struct sctp_paddrthlds)))
 		return -EFAULT;
 
-
-	if (sctp_is_any(sk, (const union sctp_addr *)&val.spt_address)) {
-		asoc = sctp_id2assoc(sk, val.spt_assoc_id);
-		if (!asoc)
+	if (!sctp_is_any(sk, (const union sctp_addr *)&val.spt_address)) {
+		trans = sctp_addr_id2transport(sk, &val.spt_address,
+					       val.spt_assoc_id);
+		if (!trans)
 			return -ENOENT;
+
+		if (val.spt_pathmaxrxt)
+			trans->pathmaxrxt = val.spt_pathmaxrxt;
+		trans->pf_retrans = val.spt_pathpfthld;
+
+		return 0;
+	}
+
+	asoc = sctp_id2assoc(sk, val.spt_assoc_id);
+	if (!asoc && val.spt_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
+
+	if (asoc) {
 		list_for_each_entry(trans, &asoc->peer.transport_addr_list,
 				    transports) {
 			if (val.spt_pathmaxrxt)
@@ -3904,14 +3918,11 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 			asoc->pathmaxrxt = val.spt_pathmaxrxt;
 		asoc->pf_retrans = val.spt_pathpfthld;
 	} else {
-		trans = sctp_addr_id2transport(sk, &val.spt_address,
-					       val.spt_assoc_id);
-		if (!trans)
-			return -ENOENT;
+		struct sctp_sock *sp = sctp_sk(sk);
 
 		if (val.spt_pathmaxrxt)
-			trans->pathmaxrxt = val.spt_pathmaxrxt;
-		trans->pf_retrans = val.spt_pathpfthld;
+			sp->pathmaxrxt = val.spt_pathmaxrxt;
+		sp->pf_retrans = val.spt_pathpfthld;
 	}
 
 	return 0;
@@ -4781,6 +4792,7 @@ static int sctp_init_sock(struct sock *sk)
 	 */
 	sp->hbinterval  = net->sctp.hb_interval;
 	sp->pathmaxrxt  = net->sctp.max_retrans_path;
+	sp->pf_retrans  = net->sctp.pf_retrans;
 	sp->pathmtu     = 0; /* allow default discovery */
 	sp->sackdelay   = net->sctp.sack_timeout;
 	sp->sackfreq	= 2;
@@ -6917,14 +6929,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 	if (copy_from_user(&val, (struct sctp_paddrthlds __user *)optval, len))
 		return -EFAULT;
 
-	if (sctp_is_any(sk, (const union sctp_addr *)&val.spt_address)) {
-		asoc = sctp_id2assoc(sk, val.spt_assoc_id);
-		if (!asoc)
-			return -ENOENT;
-
-		val.spt_pathpfthld = asoc->pf_retrans;
-		val.spt_pathmaxrxt = asoc->pathmaxrxt;
-	} else {
+	if (!sctp_is_any(sk, (const union sctp_addr *)&val.spt_address)) {
 		trans = sctp_addr_id2transport(sk, &val.spt_address,
 					       val.spt_assoc_id);
 		if (!trans)
@@ -6932,6 +6937,23 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 
 		val.spt_pathmaxrxt = trans->pathmaxrxt;
 		val.spt_pathpfthld = trans->pf_retrans;
+
+		return 0;
+	}
+
+	asoc = sctp_id2assoc(sk, val.spt_assoc_id);
+	if (!asoc && val.spt_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
+
+	if (asoc) {
+		val.spt_pathpfthld = asoc->pf_retrans;
+		val.spt_pathmaxrxt = asoc->pathmaxrxt;
+	} else {
+		struct sctp_sock *sp = sctp_sk(sk);
+
+		val.spt_pathpfthld = sp->pf_retrans;
+		val.spt_pathmaxrxt = sp->pathmaxrxt;
 	}
 
 	if (put_user(len, optlen) || copy_to_user(optval, &val, len))
-- 
2.1.0
