From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:22 +0000
Subject: [PATCH 45/51] sctp: pass a kernel pointer to sctp_setsockopt_reuse_port
Message-Id: <20200719072228.112645-46-hch@lst.de>
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
index 6232e46c4cdebd..a5b95e68cc129f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4214,11 +4214,9 @@ static int sctp_setsockopt_interleaving_supported(struct sock *sk,
 	return 0;
 }
 
-static int sctp_setsockopt_reuse_port(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_reuse_port(struct sock *sk, int *val,
 				      unsigned int optlen)
 {
-	int val;
-
 	if (!sctp_style(sk, TCP))
 		return -EOPNOTSUPP;
 
@@ -4228,10 +4226,7 @@ static int sctp_setsockopt_reuse_port(struct sock *sk, char __user *optval,
 	if (optlen < sizeof(int))
 		return -EINVAL;
 
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-
-	sctp_sk(sk)->reuse = !!val;
+	sctp_sk(sk)->reuse = !!*val;
 
 	return 0;
 }
@@ -4645,7 +4640,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 								optlen);
 		break;
 	case SCTP_REUSE_PORT:
-		retval = sctp_setsockopt_reuse_port(sk, optval, optlen);
+		retval = sctp_setsockopt_reuse_port(sk, kopt, optlen);
 		break;
 	case SCTP_EVENT:
 		retval = sctp_setsockopt_event(sk, optval, optlen);
-- 
2.27.0
