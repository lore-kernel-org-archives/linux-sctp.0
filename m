From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:21:56 +0000
Subject: [PATCH 19/51] sctp: pass a kernel pointer to sctp_setsockopt_maxseg
Message-Id: <20200719072228.112645-20-hch@lst.de>
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
 net/sctp/socket.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 5007af318e134e..cc7d5430ad8858 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3215,11 +3215,13 @@ static int sctp_setsockopt_mappedv4(struct sock *sk, int *val,
  *    changed (effecting future associations only).
  * assoc_value:  This parameter specifies the maximum size in bytes.
  */
-static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_maxseg(struct sock *sk,
+				  struct sctp_assoc_value *params,
+				  unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
+	sctp_assoc_t assoc_id;
 	int val;
 
 	if (optlen = sizeof(int)) {
@@ -3228,19 +3230,17 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 				    "Use of int in maxseg socket option.\n"
 				    "Use struct sctp_assoc_value instead\n",
 				    current->comm, task_pid_nr(current));
-		if (copy_from_user(&val, optval, optlen))
-			return -EFAULT;
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		assoc_id = SCTP_FUTURE_ASSOC;
+		val = *(int *)params;
 	} else if (optlen = sizeof(struct sctp_assoc_value)) {
-		if (copy_from_user(&params, optval, optlen))
-			return -EFAULT;
-		val = params.assoc_value;
+		assoc_id = params->assoc_id;
+		val = params->assoc_value;
 	} else {
 		return -EINVAL;
 	}
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, assoc_id);
+	if (!asoc && assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
@@ -4697,7 +4697,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_mappedv4(sk, kopt, optlen);
 		break;
 	case SCTP_MAXSEG:
-		retval = sctp_setsockopt_maxseg(sk, optval, optlen);
+		retval = sctp_setsockopt_maxseg(sk, kopt, optlen);
 		break;
 	case SCTP_ADAPTATION_LAYER:
 		retval = sctp_setsockopt_adaptation_layer(sk, optval, optlen);
-- 
2.27.0
