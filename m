From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Jan 2019 07:08:34 +0000
Subject: [PATCH net-next 12/24] sctp: use SCTP_FUTURE_ASSOC and add SCTP_CURRENT_ASSOC for SCTP_DELAYED_SACK 
Message-Id: <d2e888e961165b773dfbf68847af5f2d0ac864c0.1548659198.git.lucien.xin@gmail.com>
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
In-Reply-To: <33a798e9b29f2dcbe6dd132cb801b4960d1411a5.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Check with SCTP_ALL_ASSOC instead in sctp_setsockopt_delayed_ack and
check with SCTP_FUTURE_ASSOC instead in sctp_getsockopt_delayed_ack,
it's compatible with 0.

SCTP_CURRENT_ASSOC is supported for SCTP_DELAYED_SACK in this patch.

It also adds sctp_apply_asoc_delayed_ack() to make code more readable.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 121 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 66 insertions(+), 55 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index bf91591..f72148d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2798,6 +2798,43 @@ static inline __u32 sctp_spp_sackdelay_disable(__u32 param_flags)
 	return (param_flags & ~SPP_SACKDELAY) | SPP_SACKDELAY_DISABLE;
 }
 
+static void sctp_apply_asoc_delayed_ack(struct sctp_sack_info *params,
+					struct sctp_association *asoc)
+{
+	struct sctp_transport *trans;
+
+	if (params->sack_delay) {
+		asoc->sackdelay = msecs_to_jiffies(params->sack_delay);
+		asoc->param_flags +			sctp_spp_sackdelay_enable(asoc->param_flags);
+	}
+	if (params->sack_freq = 1) {
+		asoc->param_flags +			sctp_spp_sackdelay_disable(asoc->param_flags);
+	} else if (params->sack_freq > 1) {
+		asoc->sackfreq = params->sack_freq;
+		asoc->param_flags +			sctp_spp_sackdelay_enable(asoc->param_flags);
+	}
+
+	list_for_each_entry(trans, &asoc->peer.transport_addr_list,
+			    transports) {
+		if (params->sack_delay) {
+			trans->sackdelay = msecs_to_jiffies(params->sack_delay);
+			trans->param_flags +				sctp_spp_sackdelay_enable(trans->param_flags);
+		}
+		if (params->sack_freq = 1) {
+			trans->param_flags +				sctp_spp_sackdelay_disable(trans->param_flags);
+		} else if (params->sack_freq > 1) {
+			trans->sackfreq = params->sack_freq;
+			trans->param_flags +				sctp_spp_sackdelay_enable(trans->param_flags);
+		}
+	}
+}
+
 /*
  * 7.1.23.  Get or set delayed ack timer (SCTP_DELAYED_SACK)
  *
@@ -2837,10 +2874,9 @@ static inline __u32 sctp_spp_sackdelay_disable(__u32 param_flags)
 static int sctp_setsockopt_delayed_ack(struct sock *sk,
 				       char __user *optval, unsigned int optlen)
 {
-	struct sctp_sack_info    params;
-	struct sctp_transport   *trans = NULL;
-	struct sctp_association *asoc = NULL;
-	struct sctp_sock        *sp = sctp_sk(sk);
+	struct sctp_sock *sp = sctp_sk(sk);
+	struct sctp_association *asoc;
+	struct sctp_sack_info params;
 
 	if (optlen = sizeof(struct sctp_sack_info)) {
 		if (copy_from_user(&params, optval, optlen))
@@ -2868,67 +2904,42 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
 	if (params.sack_delay > 500)
 		return -EINVAL;
 
-	/* Get association, if sack_assoc_id != 0 and the socket is a one
-	 * to many style socket, and an association was not found, then
-	 * the id was invalid.
+	/* Get association, if sack_assoc_id != SCTP_FUTURE_ASSOC and the
+	 * socket is a one to many style socket, and an association
+	 * was not found, then the id was invalid.
 	 */
 	asoc = sctp_id2assoc(sk, params.sack_assoc_id);
-	if (!asoc && params.sack_assoc_id && sctp_style(sk, UDP))
+	if (!asoc && params.sack_assoc_id > SCTP_ALL_ASSOC &&
+	    sctp_style(sk, UDP))
 		return -EINVAL;
 
-	if (params.sack_delay) {
-		if (asoc) {
-			asoc->sackdelay -				msecs_to_jiffies(params.sack_delay);
-			asoc->param_flags -				sctp_spp_sackdelay_enable(asoc->param_flags);
-		} else {
+	if (asoc) {
+		sctp_apply_asoc_delayed_ack(&params, asoc);
+
+		return 0;
+	}
+
+	if (params.sack_assoc_id = SCTP_FUTURE_ASSOC ||
+	    params.sack_assoc_id = SCTP_ALL_ASSOC) {
+		if (params.sack_delay) {
 			sp->sackdelay = params.sack_delay;
 			sp->param_flags  				sctp_spp_sackdelay_enable(sp->param_flags);
 		}
-	}
-
-	if (params.sack_freq = 1) {
-		if (asoc) {
-			asoc->param_flags -				sctp_spp_sackdelay_disable(asoc->param_flags);
-		} else {
+		if (params.sack_freq = 1) {
 			sp->param_flags  				sctp_spp_sackdelay_disable(sp->param_flags);
-		}
-	} else if (params.sack_freq > 1) {
-		if (asoc) {
-			asoc->sackfreq = params.sack_freq;
-			asoc->param_flags -				sctp_spp_sackdelay_enable(asoc->param_flags);
-		} else {
+		} else if (params.sack_freq > 1) {
 			sp->sackfreq = params.sack_freq;
 			sp->param_flags  				sctp_spp_sackdelay_enable(sp->param_flags);
 		}
 	}
 
-	/* If change is for association, also apply to each transport. */
-	if (asoc) {
-		list_for_each_entry(trans, &asoc->peer.transport_addr_list,
-				transports) {
-			if (params.sack_delay) {
-				trans->sackdelay -					msecs_to_jiffies(params.sack_delay);
-				trans->param_flags -					sctp_spp_sackdelay_enable(trans->param_flags);
-			}
-			if (params.sack_freq = 1) {
-				trans->param_flags -					sctp_spp_sackdelay_disable(trans->param_flags);
-			} else if (params.sack_freq > 1) {
-				trans->sackfreq = params.sack_freq;
-				trans->param_flags -					sctp_spp_sackdelay_enable(trans->param_flags);
-			}
-		}
-	}
+	if (params.sack_assoc_id = SCTP_CURRENT_ASSOC ||
+	    params.sack_assoc_id = SCTP_ALL_ASSOC)
+		list_for_each_entry(asoc, &sp->ep->asocs, asocs)
+			sctp_apply_asoc_delayed_ack(&params, asoc);
 
 	return 0;
 }
@@ -5847,19 +5858,19 @@ static int sctp_getsockopt_delayed_ack(struct sock *sk, int len,
 	} else
 		return -EINVAL;
 
-	/* Get association, if sack_assoc_id != 0 and the socket is a one
-	 * to many style socket, and an association was not found, then
-	 * the id was invalid.
+	/* Get association, if sack_assoc_id != SCTP_FUTURE_ASSOC and the
+	 * socket is a one to many style socket, and an association
+	 * was not found, then the id was invalid.
 	 */
 	asoc = sctp_id2assoc(sk, params.sack_assoc_id);
-	if (!asoc && params.sack_assoc_id && sctp_style(sk, UDP))
+	if (!asoc && params.sack_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
 		/* Fetch association values. */
 		if (asoc->param_flags & SPP_SACKDELAY_ENABLE) {
-			params.sack_delay = jiffies_to_msecs(
-				asoc->sackdelay);
+			params.sack_delay = jiffies_to_msecs(asoc->sackdelay);
 			params.sack_freq = asoc->sackfreq;
 
 		} else {
-- 
2.1.0
