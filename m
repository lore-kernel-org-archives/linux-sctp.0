From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:21:53 +0000
Subject: [PATCH 16/51] sctp: pass a kernel pointer to sctp_setsockopt_rtoinfo
Message-Id: <20200719072228.112645-17-hch@lst.de>
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
 net/sctp/socket.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f9fe93e865b970..6339a08b62dd2b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3041,9 +3041,10 @@ static int sctp_setsockopt_nodelay(struct sock *sk, int *val,
  * be changed.
  *
  */
-static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_rtoinfo(struct sock *sk,
+				   struct sctp_rtoinfo *rtoinfo,
+				   unsigned int optlen)
 {
-	struct sctp_rtoinfo rtoinfo;
 	struct sctp_association *asoc;
 	unsigned long rto_min, rto_max;
 	struct sctp_sock *sp = sctp_sk(sk);
@@ -3051,18 +3052,15 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
 	if (optlen != sizeof (struct sctp_rtoinfo))
 		return -EINVAL;
 
-	if (copy_from_user(&rtoinfo, optval, optlen))
-		return -EFAULT;
-
-	asoc = sctp_id2assoc(sk, rtoinfo.srto_assoc_id);
+	asoc = sctp_id2assoc(sk, rtoinfo->srto_assoc_id);
 
 	/* Set the values to the specific association */
-	if (!asoc && rtoinfo.srto_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && rtoinfo->srto_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
-	rto_max = rtoinfo.srto_max;
-	rto_min = rtoinfo.srto_min;
+	rto_max = rtoinfo->srto_max;
+	rto_min = rtoinfo->srto_min;
 
 	if (rto_max)
 		rto_max = asoc ? msecs_to_jiffies(rto_max) : rto_max;
@@ -3078,17 +3076,17 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
 		return -EINVAL;
 
 	if (asoc) {
-		if (rtoinfo.srto_initial != 0)
+		if (rtoinfo->srto_initial != 0)
 			asoc->rto_initial -				msecs_to_jiffies(rtoinfo.srto_initial);
+				msecs_to_jiffies(rtoinfo->srto_initial);
 		asoc->rto_max = rto_max;
 		asoc->rto_min = rto_min;
 	} else {
 		/* If there is no association or the association-id = 0
 		 * set the values to the endpoint.
 		 */
-		if (rtoinfo.srto_initial != 0)
-			sp->rtoinfo.srto_initial = rtoinfo.srto_initial;
+		if (rtoinfo->srto_initial != 0)
+			sp->rtoinfo.srto_initial = rtoinfo->srto_initial;
 		sp->rtoinfo.srto_max = rto_max;
 		sp->rtoinfo.srto_min = rto_min;
 	}
@@ -4692,7 +4690,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_nodelay(sk, kopt, optlen);
 		break;
 	case SCTP_RTOINFO:
-		retval = sctp_setsockopt_rtoinfo(sk, optval, optlen);
+		retval = sctp_setsockopt_rtoinfo(sk, kopt, optlen);
 		break;
 	case SCTP_ASSOCINFO:
 		retval = sctp_setsockopt_associnfo(sk, optval, optlen);
-- 
2.27.0
