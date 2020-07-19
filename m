From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:21:55 +0000
Subject: [PATCH 18/51] sctp: pass a kernel pointer to sctp_setsockopt_mappedv4
Message-Id: <20200719072228.112645-19-hch@lst.de>
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
 net/sctp/socket.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 2a655c65e2943d..5007af318e134e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3173,16 +3173,14 @@ static int sctp_setsockopt_associnfo(struct sock *sk,
  * addresses and a user will receive both PF_INET6 and PF_INET type
  * addresses on the socket.
  */
-static int sctp_setsockopt_mappedv4(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_mappedv4(struct sock *sk, int *val,
+				    unsigned int optlen)
 {
-	int val;
 	struct sctp_sock *sp = sctp_sk(sk);
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-	if (val)
+	if (*val)
 		sp->v4mapped = 1;
 	else
 		sp->v4mapped = 0;
@@ -4696,7 +4694,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_associnfo(sk, kopt, optlen);
 		break;
 	case SCTP_I_WANT_MAPPED_V4_ADDR:
-		retval = sctp_setsockopt_mappedv4(sk, optval, optlen);
+		retval = sctp_setsockopt_mappedv4(sk, kopt, optlen);
 		break;
 	case SCTP_MAXSEG:
 		retval = sctp_setsockopt_maxseg(sk, optval, optlen);
-- 
2.27.0
