From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 26 May 2020 16:40:11 +0000
Subject: [PATCH v3 net-next 4/8] sctp: getsockopt, rename some locals.
Message-Id: <72071d4c0a854a099821df3b5e0d81ef@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Vlad Yasevich' <vyasevich@gmail.com>, 'Neil Horman' <nhorman@tuxdriver.com>, "'David S. Miller'" <davem@davemloft.net>, 'Jakub Kicinski' <kuba@kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>, 'Christoph Hellwig' <hch@lst.de>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>

Rename locals to avoid clash with structure fields in the next patch.

Signed-off-by: David Laight <david.laight@aculab.com>

---
 net/sctp/socket.c | 52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b8068da..ae916ad 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -6434,7 +6434,7 @@ static int sctp_getsockopt_nodelay(struct sock *sk, int len,
 static int sctp_getsockopt_rtoinfo(struct sock *sk, int len,
 				char __user *optval,
 				int __user *optlen) {
-	struct sctp_rtoinfo rtoinfo;
+	struct sctp_rtoinfo params;
 	struct sctp_association *asoc;
 
 	if (len < sizeof (struct sctp_rtoinfo))
@@ -6442,33 +6442,33 @@ static int sctp_getsockopt_rtoinfo(struct sock *sk, int len,
 
 	len = sizeof(struct sctp_rtoinfo);
 
-	if (copy_from_user(&rtoinfo, optval, len))
+	if (copy_from_user(&params, optval, len))
 		return -EFAULT;
 
-	asoc = sctp_id2assoc(sk, rtoinfo.srto_assoc_id);
+	asoc = sctp_id2assoc(sk, params.srto_assoc_id);
 
-	if (!asoc && rtoinfo.srto_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && params.srto_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Values corresponding to the specific association. */
 	if (asoc) {
-		rtoinfo.srto_initial = jiffies_to_msecs(asoc->rto_initial);
-		rtoinfo.srto_max = jiffies_to_msecs(asoc->rto_max);
-		rtoinfo.srto_min = jiffies_to_msecs(asoc->rto_min);
+		params.srto_initial = jiffies_to_msecs(asoc->rto_initial);
+		params.srto_max = jiffies_to_msecs(asoc->rto_max);
+		params.srto_min = jiffies_to_msecs(asoc->rto_min);
 	} else {
 		/* Values corresponding to the endpoint. */
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		rtoinfo.srto_initial = sp->rtoinfo.srto_initial;
-		rtoinfo.srto_max = sp->rtoinfo.srto_max;
-		rtoinfo.srto_min = sp->rtoinfo.srto_min;
+		params.srto_initial = sp->rtoinfo.srto_initial;
+		params.srto_max = sp->rtoinfo.srto_max;
+		params.srto_min = sp->rtoinfo.srto_min;
 	}
 
 	if (put_user(len, optlen))
 		return -EFAULT;
 
-	if (copy_to_user(optval, &rtoinfo, len))
+	if (copy_to_user(optval, &params, len))
 		return -EFAULT;
 
 	return 0;
@@ -6490,7 +6490,7 @@ static int sctp_getsockopt_associnfo(struct sock *sk, int len,
 				     int __user *optlen)
 {
 
-	struct sctp_assocparams assocparams;
+	struct sctp_assocparams params;
 	struct sctp_association *asoc;
 	struct list_head *pos;
 	int cnt = 0;
@@ -6500,37 +6500,37 @@ static int sctp_getsockopt_associnfo(struct sock *sk, int len,
 
 	len = sizeof(struct sctp_assocparams);
 
-	if (copy_from_user(&assocparams, optval, len))
+	if (copy_from_user(&params, optval, len))
 		return -EFAULT;
 
-	asoc = sctp_id2assoc(sk, assocparams.sasoc_assoc_id);
+	asoc = sctp_id2assoc(sk, params.sasoc_assoc_id);
 
-	if (!asoc && assocparams.sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && params.sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Values correspoinding to the specific association */
 	if (asoc) {
-		assocparams.sasoc_asocmaxrxt = asoc->max_retrans;
-		assocparams.sasoc_peer_rwnd = asoc->peer.rwnd;
-		assocparams.sasoc_local_rwnd = asoc->a_rwnd;
-		assocparams.sasoc_cookie_life = ktime_to_ms(asoc->cookie_life);
+		params.sasoc_asocmaxrxt = asoc->max_retrans;
+		params.sasoc_peer_rwnd = asoc->peer.rwnd;
+		params.sasoc_local_rwnd = asoc->a_rwnd;
+		params.sasoc_cookie_life = ktime_to_ms(asoc->cookie_life);
 
 		list_for_each(pos, &asoc->peer.transport_addr_list) {
 			cnt++;
 		}
 
-		assocparams.sasoc_number_peer_destinations = cnt;
+		params.sasoc_number_peer_destinations = cnt;
 	} else {
 		/* Values corresponding to the endpoint */
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		assocparams.sasoc_asocmaxrxt = sp->assocparams.sasoc_asocmaxrxt;
-		assocparams.sasoc_peer_rwnd = sp->assocparams.sasoc_peer_rwnd;
-		assocparams.sasoc_local_rwnd = sp->assocparams.sasoc_local_rwnd;
-		assocparams.sasoc_cookie_life +		params.sasoc_asocmaxrxt = sp->assocparams.sasoc_asocmaxrxt;
+		params.sasoc_peer_rwnd = sp->assocparams.sasoc_peer_rwnd;
+		params.sasoc_local_rwnd = sp->assocparams.sasoc_local_rwnd;
+		params.sasoc_cookie_life  					sp->assocparams.sasoc_cookie_life;
-		assocparams.sasoc_number_peer_destinations +		params.sasoc_number_peer_destinations  					sp->assocparams.
 					sasoc_number_peer_destinations;
 	}
@@ -6538,7 +6538,7 @@ static int sctp_getsockopt_associnfo(struct sock *sk, int len,
 	if (put_user(len, optlen))
 		return -EFAULT;
 
-	if (copy_to_user(optval, &assocparams, len))
+	if (copy_to_user(optval, &params, len))
 		return -EFAULT;
 
 	return 0;
-- 
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
