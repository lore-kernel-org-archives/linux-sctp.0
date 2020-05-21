From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:46:42 +0000
Subject: [PATCH 07/49] sctp: pass a kernel pointer to sctp_setsockopt_peer_addr_params
Message-Id: <20200521174724.2635475-8-hch@lst.de>
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
 net/sctp/socket.c | 44 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 2fb3a5590a12e..0498cf21923e8 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2586,48 +2586,42 @@ static int sctp_apply_peer_addr_params(struct sctp_paddrparams *params,
 }
 
 static int sctp_setsockopt_peer_addr_params(struct sock *sk,
-					    char __user *optval,
+					    struct sctp_paddrparams *params,
 					    unsigned int optlen)
 {
-	struct sctp_paddrparams  params;
 	struct sctp_transport   *trans = NULL;
 	struct sctp_association *asoc = NULL;
 	struct sctp_sock        *sp = sctp_sk(sk);
 	int error;
 	int hb_change, pmtud_change, sackdelay_change;
 
-	if (optlen = sizeof(params)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-	} else if (optlen = ALIGN(offsetof(struct sctp_paddrparams,
+	if (optlen = ALIGN(offsetof(struct sctp_paddrparams,
 					    spp_ipv6_flowlabel), 4)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-		if (params.spp_flags & (SPP_DSCP | SPP_IPV6_FLOWLABEL))
+		if (params->spp_flags & (SPP_DSCP | SPP_IPV6_FLOWLABEL))
 			return -EINVAL;
-	} else {
+	} else if (optlen != sizeof(*params)) {
 		return -EINVAL;
 	}
 
 	/* Validate flags and value parameters. */
-	hb_change        = params.spp_flags & SPP_HB;
-	pmtud_change     = params.spp_flags & SPP_PMTUD;
-	sackdelay_change = params.spp_flags & SPP_SACKDELAY;
+	hb_change        = params->spp_flags & SPP_HB;
+	pmtud_change     = params->spp_flags & SPP_PMTUD;
+	sackdelay_change = params->spp_flags & SPP_SACKDELAY;
 
 	if (hb_change        = SPP_HB ||
 	    pmtud_change     = SPP_PMTUD ||
 	    sackdelay_change = SPP_SACKDELAY ||
-	    params.spp_sackdelay > 500 ||
-	    (params.spp_pathmtu &&
-	     params.spp_pathmtu < SCTP_DEFAULT_MINSEGMENT))
+	    params->spp_sackdelay > 500 ||
+	    (params->spp_pathmtu &&
+	     params->spp_pathmtu < SCTP_DEFAULT_MINSEGMENT))
 		return -EINVAL;
 
 	/* If an address other than INADDR_ANY is specified, and
 	 * no transport is found, then the request is invalid.
 	 */
-	if (!sctp_is_any(sk, (union sctp_addr *)&params.spp_address)) {
-		trans = sctp_addr_id2transport(sk, &params.spp_address,
-					       params.spp_assoc_id);
+	if (!sctp_is_any(sk, (union sctp_addr *)&params->spp_address)) {
+		trans = sctp_addr_id2transport(sk, &params->spp_address,
+					       params->spp_assoc_id);
 		if (!trans)
 			return -EINVAL;
 	}
@@ -2636,19 +2630,19 @@ static int sctp_setsockopt_peer_addr_params(struct sock *sk,
 	 * socket is a one to many style socket, and an association
 	 * was not found, then the id was invalid.
 	 */
-	asoc = sctp_id2assoc(sk, params.spp_assoc_id);
-	if (!asoc && params.spp_assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->spp_assoc_id);
+	if (!asoc && params->spp_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Heartbeat demand can only be sent on a transport or
 	 * association, but not a socket.
 	 */
-	if (params.spp_flags & SPP_HB_DEMAND && !trans && !asoc)
+	if (params->spp_flags & SPP_HB_DEMAND && !trans && !asoc)
 		return -EINVAL;
 
 	/* Process parameters. */
-	error = sctp_apply_peer_addr_params(&params, trans, asoc, sp,
+	error = sctp_apply_peer_addr_params(params, trans, asoc, sp,
 					    hb_change, pmtud_change,
 					    sackdelay_change);
 
@@ -2661,7 +2655,7 @@ static int sctp_setsockopt_peer_addr_params(struct sock *sk,
 	if (!trans && asoc) {
 		list_for_each_entry(trans, &asoc->peer.transport_addr_list,
 				transports) {
-			sctp_apply_peer_addr_params(&params, trans, asoc, sp,
+			sctp_apply_peer_addr_params(params, trans, asoc, sp,
 						    hb_change, pmtud_change,
 						    sackdelay_change);
 		}
@@ -4696,7 +4690,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_PEER_ADDR_PARAMS:
-		retval = sctp_setsockopt_peer_addr_params(sk, optval, optlen);
+		retval = sctp_setsockopt_peer_addr_params(sk, kopt, optlen);
 		break;
 
 	case SCTP_DELAYED_SACK:
-- 
2.26.2
