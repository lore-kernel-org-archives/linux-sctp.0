From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:21:57 +0000
Subject: [PATCH 20/51] sctp: pass a kernel pointer to sctp_setsockopt_adaptation_layer
Message-Id: <20200719072228.112645-21-hch@lst.de>
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
 net/sctp/socket.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index cc7d5430ad8858..b29452f58ff988 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3336,17 +3336,14 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk,
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
@@ -4700,7 +4697,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_maxseg(sk, kopt, optlen);
 		break;
 	case SCTP_ADAPTATION_LAYER:
-		retval = sctp_setsockopt_adaptation_layer(sk, optval, optlen);
+		retval = sctp_setsockopt_adaptation_layer(sk, kopt, optlen);
 		break;
 	case SCTP_CONTEXT:
 		retval = sctp_setsockopt_context(sk, optval, optlen);
-- 
2.27.0
