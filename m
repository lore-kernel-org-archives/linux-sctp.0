From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:46:39 +0000
Subject: [PATCH 04/49] sctp: pass a kernel pointer to sctp_setsockopt_disable_fragments
Message-Id: <20200521174724.2635475-5-hch@lst.de>
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
 net/sctp/socket.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index f7621ea99340e..0ca8001acfd50 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2180,20 +2180,12 @@ static int sctp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
  * exceeds the current PMTU size, the message will NOT be sent and
  * instead a error will be indicated to the user.
  */
-static int sctp_setsockopt_disable_fragments(struct sock *sk,
-					     char __user *optval,
+static int sctp_setsockopt_disable_fragments(struct sock *sk, int *val,
 					     unsigned int optlen)
 {
-	int val;
-
 	if (optlen < sizeof(int))
 		return -EINVAL;
-
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-
-	sctp_sk(sk)->disable_fragments = (val = 0) ? 0 : 1;
-
+	sctp_sk(sk)->disable_fragments = (*val = 0) ? 0 : 1;
 	return 0;
 }
 
@@ -4697,7 +4689,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_DISABLE_FRAGMENTS:
-		retval = sctp_setsockopt_disable_fragments(sk, optval, optlen);
+		retval = sctp_setsockopt_disable_fragments(sk, kopt, optlen);
 		break;
 
 	case SCTP_EVENTS:
-- 
2.26.2
