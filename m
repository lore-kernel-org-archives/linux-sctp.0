From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:21:52 +0000
Subject: [PATCH 15/51] sctp: pass a kernel pointer to sctp_setsockopt_nodelay
Message-Id: <20200719072228.112645-16-hch@lst.de>
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
index ff3b720eab0aa2..f9fe93e865b970 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3020,17 +3020,12 @@ static int sctp_setsockopt_primary_addr(struct sock *sk, struct sctp_prim *prim,
  * introduced, at the cost of more packets in the network.  Expects an
  *  integer boolean flag.
  */
-static int sctp_setsockopt_nodelay(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_nodelay(struct sock *sk, int *val,
 				   unsigned int optlen)
 {
-	int val;
-
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-
-	sctp_sk(sk)->nodelay = (val = 0) ? 0 : 1;
+	sctp_sk(sk)->nodelay = (*val = 0) ? 0 : 1;
 	return 0;
 }
 
@@ -4694,7 +4689,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_peer_primary_addr(sk, kopt, optlen);
 		break;
 	case SCTP_NODELAY:
-		retval = sctp_setsockopt_nodelay(sk, optval, optlen);
+		retval = sctp_setsockopt_nodelay(sk, kopt, optlen);
 		break;
 	case SCTP_RTOINFO:
 		retval = sctp_setsockopt_rtoinfo(sk, optval, optlen);
-- 
2.27.0
