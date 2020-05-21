From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:47:23 +0000
Subject: [PATCH 48/49] sctp: pass a kernel pointer to sctp_setsockopt_ecn_supported
Message-Id: <20200521174724.2635475-49-hch@lst.de>
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
 net/sctp/socket.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 755bb23ffa3c9..f9f4776b0bbfd 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4356,27 +4356,21 @@ static int sctp_setsockopt_auth_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_ecn_supported(struct sock *sk,
-					 char __user *optval,
+					 struct sctp_assoc_value *params,
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
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
-	sctp_sk(sk)->ep->ecn_enable = !!params.assoc_value;
+	sctp_sk(sk)->ep->ecn_enable = !!params->assoc_value;
 	retval = 0;
 
 out:
@@ -4631,7 +4625,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_auth_supported(sk, kopt, optlen);
 		break;
 	case SCTP_ECN_SUPPORTED:
-		retval = sctp_setsockopt_ecn_supported(sk, optval, optlen);
+		retval = sctp_setsockopt_ecn_supported(sk, kopt, optlen);
 		break;
 	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
 		retval = sctp_setsockopt_pf_expose(sk, optval, optlen);
-- 
2.26.2
