From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:21:59 +0000
Subject: [PATCH 22/51] sctp: pass a kernel pointer to sctp_setsockopt_fragment_interleave
Message-Id: <20200719072228.112645-23-hch@lst.de>
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
index 2862047054d55a..874cec73153052 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3422,18 +3422,13 @@ static int sctp_setsockopt_context(struct sock *sk,
  * application using the one to many model may become confused and act
  * incorrectly.
  */
-static int sctp_setsockopt_fragment_interleave(struct sock *sk,
-					       char __user *optval,
+static int sctp_setsockopt_fragment_interleave(struct sock *sk, int *val,
 					       unsigned int optlen)
 {
-	int val;
-
 	if (optlen != sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
 
-	sctp_sk(sk)->frag_interleave = !!val;
+	sctp_sk(sk)->frag_interleave = !!*val;
 
 	if (!sctp_sk(sk)->frag_interleave)
 		sctp_sk(sk)->ep->intl_enable = 0;
@@ -4701,7 +4696,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_context(sk, kopt, optlen);
 		break;
 	case SCTP_FRAGMENT_INTERLEAVE:
-		retval = sctp_setsockopt_fragment_interleave(sk, optval, optlen);
+		retval = sctp_setsockopt_fragment_interleave(sk, kopt, optlen);
 		break;
 	case SCTP_MAX_BURST:
 		retval = sctp_setsockopt_maxburst(sk, optval, optlen);
-- 
2.27.0
