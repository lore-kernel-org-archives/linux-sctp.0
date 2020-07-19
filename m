From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:21:43 +0000
Subject: [PATCH 06/51] sctp: pass a kernel pointer to sctp_setsockopt_autoclose
Message-Id: <20200719072228.112645-7-hch@lst.de>
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
 net/sctp/socket.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index bc37174bd71af0..d7ed8c6ea3754f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2242,7 +2242,7 @@ static int sctp_setsockopt_events(struct sock *sk, __u8 *sn_type,
  * integer defining the number of seconds of idle time before an
  * association is closed.
  */
-static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_autoclose(struct sock *sk, u32 *optval,
 				     unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
@@ -2253,9 +2253,8 @@ static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
 		return -EOPNOTSUPP;
 	if (optlen != sizeof(int))
 		return -EINVAL;
-	if (copy_from_user(&sp->autoclose, optval, optlen))
-		return -EFAULT;
 
+	sp->autoclose = *optval;
 	if (sp->autoclose > net->sctp.max_autoclose)
 		sp->autoclose = net->sctp.max_autoclose;
 
@@ -4696,7 +4695,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_AUTOCLOSE:
-		retval = sctp_setsockopt_autoclose(sk, optval, optlen);
+		retval = sctp_setsockopt_autoclose(sk, kopt, optlen);
 		break;
 
 	case SCTP_PEER_ADDR_PARAMS:
-- 
2.27.0
