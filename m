From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:00 +0000
Subject: [PATCH 23/51] sctp: pass a kernel pointer to sctp_setsockopt_maxburst
Message-Id: <20200719072228.112645-24-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200719072228.112645-1-hch@lst.de>
In-Reply-To: <20200719072228.112645-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Use the kernel pointer that sctp_setsockopt has available instead of
directly handling the user pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 874cec73153052..ac7dff849290dc 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3482,12 +3482,13 @@ static int sctp_setsockopt_partial_delivery_point(struct sock *sk, u32 *val,
  * future associations inheriting the socket value.
  */
 static int sctp_setsockopt_maxburst(struct sock *sk,
-				    char __user *optval,
+				    struct sctp_assoc_value *params,
 				    unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
+	sctp_assoc_t assoc_id;
+	u32 assoc_value;
 
 	if (optlen = sizeof(int)) {
 		pr_warn_ratelimited(DEPRECATED
@@ -3495,37 +3496,33 @@ static int sctp_setsockopt_maxburst(struct sock *sk,
 				    "Use of int in max_burst socket option deprecated.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		if (copy_from_user(&params.assoc_value, optval, optlen))
-			return -EFAULT;
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		assoc_id = SCTP_FUTURE_ASSOC;
+		assoc_value = *((int *)params);
 	} else if (optlen = sizeof(struct sctp_assoc_value)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
+		assoc_id = params->assoc_id;
+		assoc_value = params->assoc_value;
 	} else
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
-	    sctp_style(sk, UDP))
+	asoc = sctp_id2assoc(sk, assoc_id);
+	if (!asoc && assoc_id > SCTP_ALL_ASSOC && sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		asoc->max_burst = params.assoc_value;
+		asoc->max_burst = assoc_value;
 
 		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (params.assoc_id = SCTP_FUTURE_ASSOC ||
-	    params.assoc_id = SCTP_ALL_ASSOC)
-		sp->max_burst = params.assoc_value;
+	if (assoc_id = SCTP_FUTURE_ASSOC || assoc_id = SCTP_ALL_ASSOC)
+		sp->max_burst = assoc_value;
 
-	if (params.assoc_id = SCTP_CURRENT_ASSOC ||
-	    params.assoc_id = SCTP_ALL_ASSOC)
+	if (assoc_id = SCTP_CURRENT_ASSOC || assoc_id = SCTP_ALL_ASSOC)
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs)
-			asoc->max_burst = params.assoc_value;
+			asoc->max_burst = assoc_value;
 
 	return 0;
 }
@@ -4699,7 +4696,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_fragment_interleave(sk, kopt, optlen);
 		break;
 	case SCTP_MAX_BURST:
-		retval = sctp_setsockopt_maxburst(sk, optval, optlen);
+		retval = sctp_setsockopt_maxburst(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_CHUNK:
 		retval = sctp_setsockopt_auth_chunk(sk, optval, optlen);
-- 
2.27.0
