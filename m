From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:21:42 +0000
Subject: [PATCH 05/51] sctp: pass a kernel pointer to sctp_setsockopt_events
Message-Id: <20200719072228.112645-6-hch@lst.de>
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
 net/sctp/socket.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b259ea94aeddef..bc37174bd71af0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2193,11 +2193,9 @@ static int sctp_setsockopt_disable_fragments(struct sock *sk, int *val,
 	return 0;
 }
 
-static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_events(struct sock *sk, __u8 *sn_type,
 				  unsigned int optlen)
 {
-	struct sctp_event_subscribe subscribe;
-	__u8 *sn_type = (__u8 *)&subscribe;
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 	int i;
@@ -2205,9 +2203,6 @@ static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
 	if (optlen > sizeof(struct sctp_event_subscribe))
 		return -EINVAL;
 
-	if (copy_from_user(&subscribe, optval, optlen))
-		return -EFAULT;
-
 	for (i = 0; i < optlen; i++)
 		sctp_ulpevent_type_set(&sp->subscribe, SCTP_SN_TYPE_BASE + i,
 				       sn_type[i]);
@@ -4697,7 +4692,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SCTP_EVENTS:
-		retval = sctp_setsockopt_events(sk, optval, optlen);
+		retval = sctp_setsockopt_events(sk, kopt, optlen);
 		break;
 
 	case SCTP_AUTOCLOSE:
-- 
2.27.0
