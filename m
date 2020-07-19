From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:21:54 +0000
Subject: [PATCH 17/51] sctp: pass a kernel pointer to sctp_setsockopt_associnfo
Message-Id: <20200719072228.112645-18-hch@lst.de>
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
 net/sctp/socket.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6339a08b62dd2b..2a655c65e2943d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3105,26 +3105,25 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk,
  * See [SCTP] for more information.
  *
  */
-static int sctp_setsockopt_associnfo(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_associnfo(struct sock *sk,
+				     struct sctp_assocparams *assocparams,
+				     unsigned int optlen)
 {
 
-	struct sctp_assocparams assocparams;
 	struct sctp_association *asoc;
 
 	if (optlen != sizeof(struct sctp_assocparams))
 		return -EINVAL;
-	if (copy_from_user(&assocparams, optval, optlen))
-		return -EFAULT;
 
-	asoc = sctp_id2assoc(sk, assocparams.sasoc_assoc_id);
+	asoc = sctp_id2assoc(sk, assocparams->sasoc_assoc_id);
 
-	if (!asoc && assocparams.sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && assocparams->sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Set the values to the specific association */
 	if (asoc) {
-		if (assocparams.sasoc_asocmaxrxt != 0) {
+		if (assocparams->sasoc_asocmaxrxt != 0) {
 			__u32 path_sum = 0;
 			int   paths = 0;
 			struct sctp_transport *peer_addr;
@@ -3141,24 +3140,25 @@ static int sctp_setsockopt_associnfo(struct sock *sk, char __user *optval, unsig
 			 * then one path.
 			 */
 			if (paths > 1 &&
-			    assocparams.sasoc_asocmaxrxt > path_sum)
+			    assocparams->sasoc_asocmaxrxt > path_sum)
 				return -EINVAL;
 
-			asoc->max_retrans = assocparams.sasoc_asocmaxrxt;
+			asoc->max_retrans = assocparams->sasoc_asocmaxrxt;
 		}
 
-		if (assocparams.sasoc_cookie_life != 0)
-			asoc->cookie_life = ms_to_ktime(assocparams.sasoc_cookie_life);
+		if (assocparams->sasoc_cookie_life != 0)
+			asoc->cookie_life +				ms_to_ktime(assocparams->sasoc_cookie_life);
 	} else {
 		/* Set the values to the endpoint */
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		if (assocparams.sasoc_asocmaxrxt != 0)
+		if (assocparams->sasoc_asocmaxrxt != 0)
 			sp->assocparams.sasoc_asocmaxrxt -						assocparams.sasoc_asocmaxrxt;
-		if (assocparams.sasoc_cookie_life != 0)
+						assocparams->sasoc_asocmaxrxt;
+		if (assocparams->sasoc_cookie_life != 0)
 			sp->assocparams.sasoc_cookie_life -						assocparams.sasoc_cookie_life;
+						assocparams->sasoc_cookie_life;
 	}
 	return 0;
 }
@@ -4693,7 +4693,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_rtoinfo(sk, kopt, optlen);
 		break;
 	case SCTP_ASSOCINFO:
-		retval = sctp_setsockopt_associnfo(sk, optval, optlen);
+		retval = sctp_setsockopt_associnfo(sk, kopt, optlen);
 		break;
 	case SCTP_I_WANT_MAPPED_V4_ADDR:
 		retval = sctp_setsockopt_mappedv4(sk, optval, optlen);
-- 
2.27.0
