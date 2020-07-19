From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:21:47 +0000
Subject: [PATCH 10/51] sctp: pass a kernel pointer to sctp_setsockopt_initmsg
Message-Id: <20200719072228.112645-11-hch@lst.de>
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
 net/sctp/socket.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index deccfe54d2fc7d..d62c02d0b79346 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2832,24 +2832,22 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
  * by the change).  With TCP-style sockets, this option is inherited by
  * sockets derived from a listener socket.
  */
-static int sctp_setsockopt_initmsg(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_initmsg(struct sock *sk, struct sctp_initmsg *sinit,
+				   unsigned int optlen)
 {
-	struct sctp_initmsg sinit;
 	struct sctp_sock *sp = sctp_sk(sk);
 
 	if (optlen != sizeof(struct sctp_initmsg))
 		return -EINVAL;
-	if (copy_from_user(&sinit, optval, optlen))
-		return -EFAULT;
 
-	if (sinit.sinit_num_ostreams)
-		sp->initmsg.sinit_num_ostreams = sinit.sinit_num_ostreams;
-	if (sinit.sinit_max_instreams)
-		sp->initmsg.sinit_max_instreams = sinit.sinit_max_instreams;
-	if (sinit.sinit_max_attempts)
-		sp->initmsg.sinit_max_attempts = sinit.sinit_max_attempts;
-	if (sinit.sinit_max_init_timeo)
-		sp->initmsg.sinit_max_init_timeo = sinit.sinit_max_init_timeo;
+	if (sinit->sinit_num_ostreams)
+		sp->initmsg.sinit_num_ostreams = sinit->sinit_num_ostreams;
+	if (sinit->sinit_max_instreams)
+		sp->initmsg.sinit_max_instreams = sinit->sinit_max_instreams;
+	if (sinit->sinit_max_attempts)
+		sp->initmsg.sinit_max_attempts = sinit->sinit_max_attempts;
+	if (sinit->sinit_max_init_timeo)
+		sp->initmsg.sinit_max_init_timeo = sinit->sinit_max_init_timeo;
 
 	return 0;
 }
@@ -4694,7 +4692,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_INITMSG:
-		retval = sctp_setsockopt_initmsg(sk, optval, optlen);
+		retval = sctp_setsockopt_initmsg(sk, kopt, optlen);
 		break;
 	case SCTP_DEFAULT_SEND_PARAM:
 		retval = sctp_setsockopt_default_send_param(sk, optval,
-- 
2.27.0
