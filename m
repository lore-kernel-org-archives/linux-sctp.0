From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:46:44 +0000
Subject: [PATCH 09/49] sctp: pass a kernel pointer to sctp_setsockopt_partial_delivery_point
Message-Id: <20200521174724.2635475-10-hch@lst.de>
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
 net/sctp/socket.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 3763f124f9fea..6dd6b0cfcfe03 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3484,24 +3484,19 @@ static int sctp_setsockopt_fragment_interleave(struct sock *sk,
  * call as long as the user provided buffer is large enough to hold the
  * message.
  */
-static int sctp_setsockopt_partial_delivery_point(struct sock *sk,
-						  char __user *optval,
+static int sctp_setsockopt_partial_delivery_point(struct sock *sk, u32 *val,
 						  unsigned int optlen)
 {
-	u32 val;
-
 	if (optlen != sizeof(u32))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
 
 	/* Note: We double the receive buffer from what the user sets
 	 * it to be, also initial rwnd is based on rcvbuf/2.
 	 */
-	if (val > (sk->sk_rcvbuf >> 1))
+	if (*val > (sk->sk_rcvbuf >> 1))
 		return -EINVAL;
 
-	sctp_sk(sk)->pd_point = val;
+	sctp_sk(sk)->pd_point = *val;
 
 	return 0; /* is this the right error code? */
 }
@@ -4692,7 +4687,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_delayed_ack(sk, kopt, optlen);
 		break;
 	case SCTP_PARTIAL_DELIVERY_POINT:
-		retval = sctp_setsockopt_partial_delivery_point(sk, optval, optlen);
+		retval = sctp_setsockopt_partial_delivery_point(sk, kopt, optlen);
 		break;
 
 	case SCTP_INITMSG:
-- 
2.26.2
