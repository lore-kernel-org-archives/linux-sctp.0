From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Jan 2019 07:08:30 +0000
Subject: [PATCH net-next 08/24] sctp: use SCTP_FUTURE_ASSOC for SCTP_PR_SUPPORTED sockopt
Message-Id: <a6316f97dbdcfbde1104e2296df9d8b24958a7df.1548659198.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1548659198.git.lucien.xin@gmail.com>
 <3ca66b981a0fe9368bd976676fe7450634b091cd.1548659198.git.lucien.xin@gmail.com>
 <bf66a45aa6763646c07e1b8be102466f07fc1648.1548659198.git.lucien.xin@gmail.com>
 <16e83f8259873a6818863586e6a3fcb1e2e3717b.1548659198.git.lucien.xin@gmail.com>
 <088bc37947694e4e80302b075f767a7828ea4a05.1548659198.git.lucien.xin@gmail.com>
 <b6b839acf08b7ed5ea06b36156ab3ad8a4a47cf7.1548659198.git.lucien.xin@gmail.com>
 <285500315e06236e468142d80c6557eae4898b36.1548659198.git.lucien.xin@gmail.com>
 <ad87082d72bcf6efccfca7b13adb3a73c72c02ee.1548659198.git.lucien.xin@gmail.com>
In-Reply-To: <ad87082d72bcf6efccfca7b13adb3a73c72c02ee.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Check with SCTP_FUTURE_ASSOC instead in
sctp_set/getsockopt_pr_supported, it's compatible with 0.

It also adjusts some code to keep a same check form as other functions.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1d49b7d..9e2b153 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3965,6 +3965,7 @@ static int sctp_setsockopt_pr_supported(struct sock *sk,
 					unsigned int optlen)
 {
 	struct sctp_assoc_value params;
+	struct sctp_association *asoc;
 
 	if (optlen != sizeof(params))
 		return -EINVAL;
@@ -3972,6 +3973,11 @@ static int sctp_setsockopt_pr_supported(struct sock *sk,
 	if (copy_from_user(&params, optval, optlen))
 		return -EFAULT;
 
+	asoc = sctp_id2assoc(sk, params.assoc_id);
+	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
+
 	sctp_sk(sk)->ep->prsctp_enable = !!params.assoc_value;
 
 	return 0;
@@ -7084,17 +7090,15 @@ static int sctp_getsockopt_pr_supported(struct sock *sk, int len,
 		goto out;
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (asoc) {
-		params.assoc_value = asoc->prsctp_enable;
-	} else if (!params.assoc_id) {
-		struct sctp_sock *sp = sctp_sk(sk);
-
-		params.assoc_value = sp->ep->prsctp_enable;
-	} else {
+	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP)) {
 		retval = -EINVAL;
 		goto out;
 	}
 
+	params.assoc_value = asoc ? asoc->prsctp_enable
+				  : sctp_sk(sk)->ep->prsctp_enable;
+
 	if (put_user(len, optlen))
 		goto out;
 
-- 
2.1.0
