From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:46:55 +0000
Subject: [PATCH 20/49] sctp: pass a kernel pointer to sctp_setsockopt_adaptation_layer
Message-Id: <20200521174724.2635475-21-hch@lst.de>
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
 net/sctp/socket.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4374d4fff080a..b7bf09f86a5e7 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3333,17 +3333,14 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk,
 	return err;
 }
 
-static int sctp_setsockopt_adaptation_layer(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_adaptation_layer(struct sock *sk,
+					    struct sctp_setadaptation *adapt,
 					    unsigned int optlen)
 {
-	struct sctp_setadaptation adaptation;
-
 	if (optlen != sizeof(struct sctp_setadaptation))
 		return -EINVAL;
-	if (copy_from_user(&adaptation, optval, optlen))
-		return -EFAULT;
 
-	sctp_sk(sk)->adaptation_ind = adaptation.ssb_adaptation_ind;
+	sctp_sk(sk)->adaptation_ind = adapt->ssb_adaptation_ind;
 
 	return 0;
 }
@@ -4697,7 +4694,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_maxseg(sk, kopt, optlen);
 		break;
 	case SCTP_ADAPTATION_LAYER:
-		retval = sctp_setsockopt_adaptation_layer(sk, optval, optlen);
+		retval = sctp_setsockopt_adaptation_layer(sk, kopt, optlen);
 		break;
 	case SCTP_CONTEXT:
 		retval = sctp_setsockopt_context(sk, optval, optlen);
-- 
2.26.2
