From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:10 +0000
Subject: [PATCH 33/51] sctp: pass a kernel pointer to sctp_setsockopt_recvrcvinfo
Message-Id: <20200719072228.112645-34-hch@lst.de>
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
 net/sctp/socket.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ea027ea74ba557..ac56fb7eb394f9 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3902,18 +3902,13 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 	return 0;
 }
 
-static int sctp_setsockopt_recvrcvinfo(struct sock *sk,
-				       char __user *optval,
+static int sctp_setsockopt_recvrcvinfo(struct sock *sk, int *val,
 				       unsigned int optlen)
 {
-	int val;
-
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *) optval))
-		return -EFAULT;
 
-	sctp_sk(sk)->recvrcvinfo = (val = 0) ? 0 : 1;
+	sctp_sk(sk)->recvrcvinfo = (*val = 0) ? 0 : 1;
 
 	return 0;
 }
@@ -4695,7 +4690,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 							  true);
 		break;
 	case SCTP_RECVRCVINFO:
-		retval = sctp_setsockopt_recvrcvinfo(sk, optval, optlen);
+		retval = sctp_setsockopt_recvrcvinfo(sk, kopt, optlen);
 		break;
 	case SCTP_RECVNXTINFO:
 		retval = sctp_setsockopt_recvnxtinfo(sk, optval, optlen);
-- 
2.27.0
