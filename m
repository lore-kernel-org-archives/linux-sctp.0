From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Jan 2019 07:08:38 +0000
Subject: [PATCH net-next 16/24] sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for SCTP_MAX_BURST soc
Message-Id: <1788c2da8ddb39854267ea1321d725635a7c983e.1548659198.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1548659198.git.lucien.xin@gmail.com>
 <3ca66b981a0fe9368bd976676fe7450634b091cd.1548659198.git.lucien.xin@gmail.com>
 <bf66a45aa6763646c07e1b8be102466f07fc1648.1548659198.git.lucien.xin@gmail.com>
 <16e83f8259873a6818863586e6a3fcb1e2e3717b.1548659198.git.lucien.xin@gmail.com>
 <088bc37947694e4e80302b075f767a7828ea4a05.1548659198.git.lucien.xin@gmail.com>
 <b6b839acf08b7ed5ea06b36156ab3ad8a4a47cf7.1548659198.git.lucien.xin@gmail.com>
 <285500315e06236e468142d80c6557eae4898b36.1548659198.git.lucien.xin@gmail.com>
 <ad87082d72bcf6efccfca7b13adb3a73c72c02ee.1548659198.git.lucien.xin@gmail.com>
 <a6316f97dbdcfbde1104e2296df9d8b24958a7df.1548659198.git.lucien.xin@gmail.com>
 <17140f5cc5fc1961e3e7cf74888affd55e0e6c06.1548659198.git.lucien.xin@gmail.com>
 <ea9e2c6de0c242a440773e99e22a59a72b77776d.1548659198.git.lucien.xin@gmail.com>
 <33a798e9b29f2dcbe6dd132cb801b4960d1411a5.1548659198.git.lucien.xin@gmail.com>
 <d2e888e961165b773dfbf68847af5f2d0ac864c0.1548659198.git.lucien.xin@gmail.com>
 <5d9d0bf635fb89cc3933b256e5e41dd3958c61d6.1548659198.git.lucien.xin@gmail.com>
 <b4094ac0945bbea9ebe455b4357e983400bfe8bb.1548659198.git.lucien.xin@gmail.com>
 <4a601f978a5364fb8f5c4ee97e314eb28087917f.1548659198.git.lucien.xin@gmail.com>
In-Reply-To: <4a601f978a5364fb8f5c4ee97e314eb28087917f.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Check with SCTP_ALL_ASSOC instead in sctp_setsockopt_maxburst and
check with SCTP_FUTURE_ASSOC instead in sctp_getsockopt_maxburst,
it's compatible with 0.

SCTP_CURRENT_ASSOC is supported for SCTP_CONTEXT in this patch.
It also adjusts some code to keep a same check form as other
functions.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 51 +++++++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 36387be..bba352e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3639,11 +3639,9 @@ static int sctp_setsockopt_maxburst(struct sock *sk,
 				    char __user *optval,
 				    unsigned int optlen)
 {
+	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_assoc_value params;
-	struct sctp_sock *sp;
 	struct sctp_association *asoc;
-	int val;
-	int assoc_id = 0;
 
 	if (optlen = sizeof(int)) {
 		pr_warn_ratelimited(DEPRECATED
@@ -3651,25 +3649,34 @@ static int sctp_setsockopt_maxburst(struct sock *sk,
 				    "Use of int in max_burst socket option deprecated.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		if (copy_from_user(&val, optval, optlen))
+		if (copy_from_user(&params.assoc_value, optval, optlen))
 			return -EFAULT;
+		params.assoc_id = SCTP_FUTURE_ASSOC;
 	} else if (optlen = sizeof(struct sctp_assoc_value)) {
 		if (copy_from_user(&params, optval, optlen))
 			return -EFAULT;
-		val = params.assoc_value;
-		assoc_id = params.assoc_id;
 	} else
 		return -EINVAL;
 
-	sp = sctp_sk(sk);
+	asoc = sctp_id2assoc(sk, params.assoc_id);
+	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
-	if (assoc_id != 0) {
-		asoc = sctp_id2assoc(sk, assoc_id);
-		if (!asoc)
-			return -EINVAL;
-		asoc->max_burst = val;
-	} else
-		sp->max_burst = val;
+	if (asoc) {
+		asoc->max_burst = params.assoc_value;
+
+		return 0;
+	}
+
+	if (params.assoc_id = SCTP_FUTURE_ASSOC ||
+	    params.assoc_id = SCTP_ALL_ASSOC)
+		sp->max_burst = params.assoc_value;
+
+	if (params.assoc_id = SCTP_CURRENT_ASSOC ||
+	    params.assoc_id = SCTP_ALL_ASSOC)
+		list_for_each_entry(asoc, &sp->ep->asocs, asocs)
+			asoc->max_burst = params.assoc_value;
 
 	return 0;
 }
@@ -6678,7 +6685,6 @@ static int sctp_getsockopt_maxburst(struct sock *sk, int len,
 				    int __user *optlen)
 {
 	struct sctp_assoc_value params;
-	struct sctp_sock *sp;
 	struct sctp_association *asoc;
 
 	if (len = sizeof(int)) {
@@ -6687,7 +6693,7 @@ static int sctp_getsockopt_maxburst(struct sock *sk, int len,
 				    "Use of int in max_burst socket option.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		params.assoc_id = 0;
+		params.assoc_id = SCTP_FUTURE_ASSOC;
 	} else if (len >= sizeof(struct sctp_assoc_value)) {
 		len = sizeof(struct sctp_assoc_value);
 		if (copy_from_user(&params, optval, len))
@@ -6695,15 +6701,12 @@ static int sctp_getsockopt_maxburst(struct sock *sk, int len,
 	} else
 		return -EINVAL;
 
-	sp = sctp_sk(sk);
+	asoc = sctp_id2assoc(sk, params.assoc_id);
+	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
-	if (params.assoc_id != 0) {
-		asoc = sctp_id2assoc(sk, params.assoc_id);
-		if (!asoc)
-			return -EINVAL;
-		params.assoc_value = asoc->max_burst;
-	} else
-		params.assoc_value = sp->max_burst;
+	params.assoc_value = asoc ? asoc->max_burst : sctp_sk(sk)->max_burst;
 
 	if (len = sizeof(int)) {
 		if (copy_to_user(optval, &params.assoc_value, len))
-- 
2.1.0
