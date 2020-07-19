From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:20 +0000
Subject: [PATCH 43/51] sctp: pass a kernel pointer to sctp_setsockopt_scheduler_value
Message-Id: <20200719072228.112645-44-hch@lst.de>
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
 net/sctp/socket.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a7d6a66fbe2113..4b660e6bf3bb54 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4158,38 +4158,32 @@ static int sctp_setsockopt_scheduler(struct sock *sk,
 }
 
 static int sctp_setsockopt_scheduler_value(struct sock *sk,
-					   char __user *optval,
+					   struct sctp_stream_value *params,
 					   unsigned int optlen)
 {
-	struct sctp_stream_value params;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen < sizeof(params))
-		goto out;
-
-	optlen = sizeof(params);
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
+	if (optlen < sizeof(*params))
 		goto out;
-	}
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_CURRENT_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_CURRENT_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	if (asoc) {
-		retval = sctp_sched_set_value(asoc, params.stream_id,
-					      params.stream_value, GFP_KERNEL);
+		retval = sctp_sched_set_value(asoc, params->stream_id,
+					      params->stream_value, GFP_KERNEL);
 		goto out;
 	}
 
 	retval = 0;
 
 	list_for_each_entry(asoc, &sctp_sk(sk)->ep->asocs, asocs) {
-		int ret = sctp_sched_set_value(asoc, params.stream_id,
-					       params.stream_value, GFP_KERNEL);
+		int ret = sctp_sched_set_value(asoc, params->stream_id,
+					       params->stream_value,
+					       GFP_KERNEL);
 		if (ret && !retval) /* try to return the 1st error. */
 			retval = ret;
 	}
@@ -4658,7 +4652,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_scheduler(sk, kopt, optlen);
 		break;
 	case SCTP_STREAM_SCHEDULER_VALUE:
-		retval = sctp_setsockopt_scheduler_value(sk, optval, optlen);
+		retval = sctp_setsockopt_scheduler_value(sk, kopt, optlen);
 		break;
 	case SCTP_INTERLEAVING_SUPPORTED:
 		retval = sctp_setsockopt_interleaving_supported(sk, optval,
-- 
2.27.0
