From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:27 +0000
Subject: [PATCH 50/51] sctp: pass a kernel pointer to sctp_setsockopt_pf_expose
Message-Id: <20200719072228.112645-51-hch@lst.de>
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
 net/sctp/socket.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9f7f9aa50d4bd7..f2d4f8a0c426bb 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4382,33 +4382,27 @@ static int sctp_setsockopt_ecn_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_pf_expose(struct sock *sk,
-				     char __user *optval,
+				     struct sctp_assoc_value *params,
 				     unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
-		goto out;
-
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
+	if (optlen != sizeof(*params))
 		goto out;
-	}
 
-	if (params.assoc_value > SCTP_PF_EXPOSE_MAX)
+	if (params->assoc_value > SCTP_PF_EXPOSE_MAX)
 		goto out;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	if (asoc)
-		asoc->pf_expose = params.assoc_value;
+		asoc->pf_expose = params->assoc_value;
 	else
-		sctp_sk(sk)->pf_expose = params.assoc_value;
+		sctp_sk(sk)->pf_expose = params->assoc_value;
 	retval = 0;
 
 out:
@@ -4632,7 +4626,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_ecn_supported(sk, kopt, optlen);
 		break;
 	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
-		retval = sctp_setsockopt_pf_expose(sk, optval, optlen);
+		retval = sctp_setsockopt_pf_expose(sk, kopt, optlen);
 		break;
 	default:
 		retval = -ENOPROTOOPT;
-- 
2.27.0
