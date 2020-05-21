From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:47:18 +0000
Subject: [PATCH 43/49] sctp: pass a kernel pointer to sctp_setsockopt_interleaving_supported
Message-Id: <20200521174724.2635475-44-hch@lst.de>
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
 net/sctp/socket.c | 34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4d61c2885f8f2..48229ffabbaee 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4189,39 +4189,25 @@ static int sctp_setsockopt_scheduler_value(struct sock *sk,
 }
 
 static int sctp_setsockopt_interleaving_supported(struct sock *sk,
-						  char __user *optval,
+						  struct sctp_assoc_value *p,
 						  unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
-	int retval = -EINVAL;
 
-	if (optlen < sizeof(params))
-		goto out;
-
-	optlen = sizeof(params);
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	if (optlen < sizeof(*p))
+		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
-	    sctp_style(sk, UDP))
-		goto out;
+	asoc = sctp_id2assoc(sk, p->assoc_id);
+	if (!asoc && p->assoc_id != SCTP_FUTURE_ASSOC && sctp_style(sk, UDP))
+		return -EINVAL;
 
 	if (!sock_net(sk)->sctp.intl_enable || !sp->frag_interleave) {
-		retval = -EPERM;
-		goto out;
+		return -EPERM;
 	}
 
-	sp->ep->intl_enable = !!params.assoc_value;
-
-	retval = 0;
-
-out:
-	return retval;
+	sp->ep->intl_enable = !!p->assoc_value;
+	return 0;
 }
 
 static int sctp_setsockopt_reuse_port(struct sock *sk, char __user *optval,
@@ -4651,7 +4637,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_scheduler_value(sk, kopt, optlen);
 		break;
 	case SCTP_INTERLEAVING_SUPPORTED:
-		retval = sctp_setsockopt_interleaving_supported(sk, optval,
+		retval = sctp_setsockopt_interleaving_supported(sk, kopt,
 								optlen);
 		break;
 	case SCTP_REUSE_PORT:
-- 
2.26.2
