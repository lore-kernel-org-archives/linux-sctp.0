From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:21:58 +0000
Subject: [PATCH 21/51] sctp: pass a kernel pointer to sctp_setsockopt_context
Message-Id: <20200719072228.112645-22-hch@lst.de>
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
 net/sctp/socket.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b29452f58ff988..2862047054d55a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3362,40 +3362,38 @@ static int sctp_setsockopt_adaptation_layer(struct sock *sk,
  * received messages from the peer and does not effect the value that is
  * saved with outbound messages.
  */
-static int sctp_setsockopt_context(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_context(struct sock *sk,
+				   struct sctp_assoc_value *params,
 				   unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 
 	if (optlen != sizeof(struct sctp_assoc_value))
 		return -EINVAL;
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc) {
-		asoc->default_rcv_context = params.assoc_value;
+		asoc->default_rcv_context = params->assoc_value;
 
 		return 0;
 	}
 
 	if (sctp_style(sk, TCP))
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (params.assoc_id = SCTP_FUTURE_ASSOC ||
-	    params.assoc_id = SCTP_ALL_ASSOC)
-		sp->default_rcv_context = params.assoc_value;
+	if (params->assoc_id = SCTP_FUTURE_ASSOC ||
+	    params->assoc_id = SCTP_ALL_ASSOC)
+		sp->default_rcv_context = params->assoc_value;
 
-	if (params.assoc_id = SCTP_CURRENT_ASSOC ||
-	    params.assoc_id = SCTP_ALL_ASSOC)
+	if (params->assoc_id = SCTP_CURRENT_ASSOC ||
+	    params->assoc_id = SCTP_ALL_ASSOC)
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs)
-			asoc->default_rcv_context = params.assoc_value;
+			asoc->default_rcv_context = params->assoc_value;
 
 	return 0;
 }
@@ -4700,7 +4698,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_adaptation_layer(sk, kopt, optlen);
 		break;
 	case SCTP_CONTEXT:
-		retval = sctp_setsockopt_context(sk, optval, optlen);
+		retval = sctp_setsockopt_context(sk, kopt, optlen);
 		break;
 	case SCTP_FRAGMENT_INTERLEAVE:
 		retval = sctp_setsockopt_fragment_interleave(sk, optval, optlen);
-- 
2.27.0
