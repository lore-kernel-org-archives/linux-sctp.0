From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:46:41 +0000
Subject: [PATCH 06/49] sctp: pass a kernel pointer to sctp_setsockopt_autoclose
Message-Id: <20200521174724.2635475-7-hch@lst.de>
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
 net/sctp/socket.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 34bd2ce2ddf66..2fb3a5590a12e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2238,7 +2238,7 @@ static int sctp_setsockopt_events(struct sock *sk, __u8 *sn_type,
  * integer defining the number of seconds of idle time before an
  * association is closed.
  */
-static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_autoclose(struct sock *sk, u32 *autoclose,
 				     unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
@@ -2249,11 +2249,11 @@ static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
 		return -EOPNOTSUPP;
 	if (optlen != sizeof(int))
 		return -EINVAL;
-	if (copy_from_user(&sp->autoclose, optval, optlen))
-		return -EFAULT;
-
-	if (sp->autoclose > net->sctp.max_autoclose)
+	
+	if (*autoclose > net->sctp.max_autoclose)
 		sp->autoclose = net->sctp.max_autoclose;
+	else
+		sp->autoclose = *autoclose;
 
 	return 0;
 }
@@ -4692,7 +4692,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_AUTOCLOSE:
-		retval = sctp_setsockopt_autoclose(sk, optval, optlen);
+		retval = sctp_setsockopt_autoclose(sk, kopt, optlen);
 		break;
 
 	case SCTP_PEER_ADDR_PARAMS:
-- 
2.26.2
