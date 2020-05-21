From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:46:43 +0000
Subject: [PATCH 08/49] sctp: pass a kernel pointer to sctp_setsockopt_delayed_ack
Message-Id: <20200521174724.2635475-9-hch@lst.de>
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
 net/sctp/socket.c | 49 +++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 0498cf21923e8..3763f124f9fea 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2748,17 +2748,14 @@ static void sctp_apply_asoc_delayed_ack(struct sctp_sack_info *params,
  */
 
 static int sctp_setsockopt_delayed_ack(struct sock *sk,
-				       char __user *optval, unsigned int optlen)
+				       struct sctp_sack_info *params,
+				       unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_sack_info params;
 
 	if (optlen = sizeof(struct sctp_sack_info)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-
-		if (params.sack_delay = 0 && params.sack_freq = 0)
+		if (params->sack_delay = 0 && params->sack_freq = 0)
 			return 0;
 	} else if (optlen = sizeof(struct sctp_assoc_value)) {
 		pr_warn_ratelimited(DEPRECATED
@@ -2766,59 +2763,57 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
 				    "Use of struct sctp_assoc_value in delayed_ack socket option.\n"
 				    "Use struct sctp_sack_info instead\n",
 				    current->comm, task_pid_nr(current));
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
 
-		if (params.sack_delay = 0)
-			params.sack_freq = 1;
+		if (params->sack_delay = 0)
+			params->sack_freq = 1;
 		else
-			params.sack_freq = 0;
+			params->sack_freq = 0;
 	} else
 		return -EINVAL;
 
 	/* Validate value parameter. */
-	if (params.sack_delay > 500)
+	if (params->sack_delay > 500)
 		return -EINVAL;
 
 	/* Get association, if sack_assoc_id != SCTP_FUTURE_ASSOC and the
 	 * socket is a one to many style socket, and an association
 	 * was not found, then the id was invalid.
 	 */
-	asoc = sctp_id2assoc(sk, params.sack_assoc_id);
-	if (!asoc && params.sack_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->sack_assoc_id);
+	if (!asoc && params->sack_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		sctp_apply_asoc_delayed_ack(&params, asoc);
+		sctp_apply_asoc_delayed_ack(params, asoc);
 
 		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
-		params.sack_assoc_id = SCTP_FUTURE_ASSOC;
+		params->sack_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (params.sack_assoc_id = SCTP_FUTURE_ASSOC ||
-	    params.sack_assoc_id = SCTP_ALL_ASSOC) {
-		if (params.sack_delay) {
-			sp->sackdelay = params.sack_delay;
+	if (params->sack_assoc_id = SCTP_FUTURE_ASSOC ||
+	    params->sack_assoc_id = SCTP_ALL_ASSOC) {
+		if (params->sack_delay) {
+			sp->sackdelay = params->sack_delay;
 			sp->param_flags  				sctp_spp_sackdelay_enable(sp->param_flags);
 		}
-		if (params.sack_freq = 1) {
+		if (params->sack_freq = 1) {
 			sp->param_flags  				sctp_spp_sackdelay_disable(sp->param_flags);
-		} else if (params.sack_freq > 1) {
-			sp->sackfreq = params.sack_freq;
+		} else if (params->sack_freq > 1) {
+			sp->sackfreq = params->sack_freq;
 			sp->param_flags  				sctp_spp_sackdelay_enable(sp->param_flags);
 		}
 	}
 
-	if (params.sack_assoc_id = SCTP_CURRENT_ASSOC ||
-	    params.sack_assoc_id = SCTP_ALL_ASSOC)
+	if (params->sack_assoc_id = SCTP_CURRENT_ASSOC ||
+	    params->sack_assoc_id = SCTP_ALL_ASSOC)
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs)
-			sctp_apply_asoc_delayed_ack(&params, asoc);
+			sctp_apply_asoc_delayed_ack(params, asoc);
 
 	return 0;
 }
@@ -4694,7 +4689,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_DELAYED_SACK:
-		retval = sctp_setsockopt_delayed_ack(sk, optval, optlen);
+		retval = sctp_setsockopt_delayed_ack(sk, kopt, optlen);
 		break;
 	case SCTP_PARTIAL_DELIVERY_POINT:
 		retval = sctp_setsockopt_partial_delivery_point(sk, optval, optlen);
-- 
2.26.2
