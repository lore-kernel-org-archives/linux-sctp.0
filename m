From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 26 May 2020 16:39:50 +0000
Subject: [PATCH v3 net-next 1/8] sctp: setsockopt, rename some locals.
Message-Id: <0427477eddd345c79538a85947e73868@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Vlad Yasevich' <vyasevich@gmail.com>, 'Neil Horman' <nhorman@tuxdriver.com>, "'David S. Miller'" <davem@davemloft.net>, 'Jakub Kicinski' <kuba@kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>, 'Christoph Hellwig' <hch@lst.de>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>

Rename locals to avoid clash with structure fields in next patch.

Signed-off-by: David Laight <david.laight@aculab.com>

---
 net/sctp/socket.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1b56fc4..c1c8215 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3088,7 +3088,7 @@ static int sctp_setsockopt_nodelay(struct sock *sk, char __user *optval,
  */
 static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigned int optlen)
 {
-	struct sctp_rtoinfo rtoinfo;
+	struct sctp_rtoinfo params;
 	struct sctp_association *asoc;
 	unsigned long rto_min, rto_max;
 	struct sctp_sock *sp = sctp_sk(sk);
@@ -3096,18 +3096,18 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
 	if (optlen != sizeof (struct sctp_rtoinfo))
 		return -EINVAL;
 
-	if (copy_from_user(&rtoinfo, optval, optlen))
+	if (copy_from_user(&params, optval, optlen))
 		return -EFAULT;
 
-	asoc = sctp_id2assoc(sk, rtoinfo.srto_assoc_id);
+	asoc = sctp_id2assoc(sk, params.srto_assoc_id);
 
 	/* Set the values to the specific association */
-	if (!asoc && rtoinfo.srto_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && params.srto_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
-	rto_max = rtoinfo.srto_max;
-	rto_min = rtoinfo.srto_min;
+	rto_max = params.srto_max;
+	rto_min = params.srto_min;
 
 	if (rto_max)
 		rto_max = asoc ? msecs_to_jiffies(rto_max) : rto_max;
@@ -3123,17 +3123,17 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
 		return -EINVAL;
 
 	if (asoc) {
-		if (rtoinfo.srto_initial != 0)
+		if (params.srto_initial != 0)
 			asoc->rto_initial -				msecs_to_jiffies(rtoinfo.srto_initial);
+				msecs_to_jiffies(params.srto_initial);
 		asoc->rto_max = rto_max;
 		asoc->rto_min = rto_min;
 	} else {
 		/* If there is no association or the association-id = 0
 		 * set the values to the endpoint.
 		 */
-		if (rtoinfo.srto_initial != 0)
-			sp->rtoinfo.srto_initial = rtoinfo.srto_initial;
+		if (params.srto_initial != 0)
+			sp->rtoinfo.srto_initial = params.srto_initial;
 		sp->rtoinfo.srto_max = rto_max;
 		sp->rtoinfo.srto_min = rto_min;
 	}
@@ -3155,23 +3155,23 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
 static int sctp_setsockopt_associnfo(struct sock *sk, char __user *optval, unsigned int optlen)
 {
 
-	struct sctp_assocparams assocparams;
+	struct sctp_assocparams params;
 	struct sctp_association *asoc;
 
 	if (optlen != sizeof(struct sctp_assocparams))
 		return -EINVAL;
-	if (copy_from_user(&assocparams, optval, optlen))
+	if (copy_from_user(&params, optval, optlen))
 		return -EFAULT;
 
-	asoc = sctp_id2assoc(sk, assocparams.sasoc_assoc_id);
+	asoc = sctp_id2assoc(sk, params.sasoc_assoc_id);
 
-	if (!asoc && assocparams.sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && params.sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Set the values to the specific association */
 	if (asoc) {
-		if (assocparams.sasoc_asocmaxrxt != 0) {
+		if (params.sasoc_asocmaxrxt != 0) {
 			__u32 path_sum = 0;
 			int   paths = 0;
 			struct sctp_transport *peer_addr;
@@ -3188,24 +3188,24 @@ static int sctp_setsockopt_associnfo(struct sock *sk, char __user *optval, unsig
 			 * then one path.
 			 */
 			if (paths > 1 &&
-			    assocparams.sasoc_asocmaxrxt > path_sum)
+			    params.sasoc_asocmaxrxt > path_sum)
 				return -EINVAL;
 
-			asoc->max_retrans = assocparams.sasoc_asocmaxrxt;
+			asoc->max_retrans = params.sasoc_asocmaxrxt;
 		}
 
-		if (assocparams.sasoc_cookie_life != 0)
-			asoc->cookie_life = ms_to_ktime(assocparams.sasoc_cookie_life);
+		if (params.sasoc_cookie_life != 0)
+			asoc->cookie_life = ms_to_ktime(params.sasoc_cookie_life);
 	} else {
 		/* Set the values to the endpoint */
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		if (assocparams.sasoc_asocmaxrxt != 0)
+		if (params.sasoc_asocmaxrxt != 0)
 			sp->assocparams.sasoc_asocmaxrxt -						assocparams.sasoc_asocmaxrxt;
-		if (assocparams.sasoc_cookie_life != 0)
+						params.sasoc_asocmaxrxt;
+		if (params.sasoc_cookie_life != 0)
 			sp->assocparams.sasoc_cookie_life -						assocparams.sasoc_cookie_life;
+						params.sasoc_cookie_life;
 	}
 	return 0;
 }
-- 
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
