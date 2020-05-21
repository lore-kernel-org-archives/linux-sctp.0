From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:47:09 +0000
Subject: [PATCH 34/49] sctp: pass a kernel pointer to sctp_setsockopt_pr_supported
Message-Id: <20200521174724.2635475-35-hch@lst.de>
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
 net/sctp/socket.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index fe8d1ea7d9c35..fb7ed11382af1 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3921,24 +3921,20 @@ static int sctp_setsockopt_recvnxtinfo(struct sock *sk, int *val,
 }
 
 static int sctp_setsockopt_pr_supported(struct sock *sk,
-					char __user *optval,
+					struct sctp_assoc_value *params,
 					unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 
-	if (optlen != sizeof(params))
+	if (optlen != sizeof(*params))
 		return -EINVAL;
 
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
-
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
-	sctp_sk(sk)->ep->prsctp_enable = !!params.assoc_value;
+	sctp_sk(sk)->ep->prsctp_enable = !!params->assoc_value;
 
 	return 0;
 }
@@ -4687,7 +4683,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_recvnxtinfo(sk, kopt, optlen);
 		break;
 	case SCTP_PR_SUPPORTED:
-		retval = sctp_setsockopt_pr_supported(sk, optval, optlen);
+		retval = sctp_setsockopt_pr_supported(sk, kopt, optlen);
 		break;
 	case SCTP_DEFAULT_PRINFO:
 		retval = sctp_setsockopt_default_prinfo(sk, optval, optlen);
-- 
2.26.2
