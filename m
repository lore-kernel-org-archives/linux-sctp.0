From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Jan 2019 07:08:27 +0000
Subject: [PATCH net-next 05/24] sctp: use SCTP_FUTURE_ASSOC for SCTP_MAXSEG sockopt
Message-Id: <b6b839acf08b7ed5ea06b36156ab3ad8a4a47cf7.1548659198.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1548659198.git.lucien.xin@gmail.com>
 <3ca66b981a0fe9368bd976676fe7450634b091cd.1548659198.git.lucien.xin@gmail.com>
 <bf66a45aa6763646c07e1b8be102466f07fc1648.1548659198.git.lucien.xin@gmail.com>
 <16e83f8259873a6818863586e6a3fcb1e2e3717b.1548659198.git.lucien.xin@gmail.com>
 <088bc37947694e4e80302b075f767a7828ea4a05.1548659198.git.lucien.xin@gmail.com>
In-Reply-To: <088bc37947694e4e80302b075f767a7828ea4a05.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Check with SCTP_FUTURE_ASSOC instead in
sctp_set/getsockopt_maxseg, it's compatible with 0.
Also check asoc_id early as other sctp setsockopts does.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index e505e18..f38c912 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3322,7 +3322,7 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 				    current->comm, task_pid_nr(current));
 		if (copy_from_user(&val, optval, optlen))
 			return -EFAULT;
-		params.assoc_id = 0;
+		params.assoc_id = SCTP_FUTURE_ASSOC;
 	} else if (optlen = sizeof(struct sctp_assoc_value)) {
 		if (copy_from_user(&params, optval, optlen))
 			return -EFAULT;
@@ -3332,6 +3332,9 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 	}
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
+	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
 
 	if (val) {
 		int min_len, max_len;
@@ -3349,8 +3352,6 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 		asoc->user_frag = val;
 		sctp_assoc_update_frag_point(asoc);
 	} else {
-		if (params.assoc_id && sctp_style(sk, UDP))
-			return -EINVAL;
 		sp->user_frag = val;
 	}
 
@@ -6503,7 +6504,7 @@ static int sctp_getsockopt_maxseg(struct sock *sk, int len,
 				    "Use of int in maxseg socket option.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		params.assoc_id = 0;
+		params.assoc_id = SCTP_FUTURE_ASSOC;
 	} else if (len >= sizeof(struct sctp_assoc_value)) {
 		len = sizeof(struct sctp_assoc_value);
 		if (copy_from_user(&params, optval, len))
@@ -6512,7 +6513,8 @@ static int sctp_getsockopt_maxseg(struct sock *sk, int len,
 		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id && sctp_style(sk, UDP))
+	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc)
-- 
2.1.0
