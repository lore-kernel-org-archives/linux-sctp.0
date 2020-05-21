From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:46:57 +0000
Subject: [PATCH 22/49] sctp: pass a kernel pointer to sctp_setsockopt_fragment_interleave
Message-Id: <20200521174724.2635475-23-hch@lst.de>
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
 net/sctp/socket.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 03577684be65f..249a87014e879 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3419,18 +3419,13 @@ static int sctp_setsockopt_context(struct sock *sk,
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
@@ -4698,7 +4693,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_context(sk, kopt, optlen);
 		break;
 	case SCTP_FRAGMENT_INTERLEAVE:
-		retval = sctp_setsockopt_fragment_interleave(sk, optval, optlen);
+		retval = sctp_setsockopt_fragment_interleave(sk, kopt, optlen);
 		break;
 	case SCTP_MAX_BURST:
 		retval = sctp_setsockopt_maxburst(sk, optval, optlen);
-- 
2.26.2
