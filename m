From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:19 +0000
Subject: [PATCH 42/51] sctp: pass a kernel pointer to sctp_setsockopt_scheduler
Message-Id: <20200719072228.112645-43-hch@lst.de>
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
 net/sctp/socket.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4dedb94bca7714..a7d6a66fbe2113 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4115,44 +4115,39 @@ static int sctp_setsockopt_add_streams(struct sock *sk,
 }
 
 static int sctp_setsockopt_scheduler(struct sock *sk,
-				     char __user *optval,
+				     struct sctp_assoc_value *params,
 				     unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_assoc_value params;
 	int retval = 0;
 
-	if (optlen < sizeof(params))
+	if (optlen < sizeof(*params))
 		return -EINVAL;
 
-	optlen = sizeof(params);
-	if (copy_from_user(&params, optval, optlen))
-		return -EFAULT;
-
-	if (params.assoc_value > SCTP_SS_MAX)
+	if (params->assoc_value > SCTP_SS_MAX)
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc)
-		return sctp_sched_set_sched(asoc, params.assoc_value);
+		return sctp_sched_set_sched(asoc, params->assoc_value);
 
 	if (sctp_style(sk, TCP))
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (params.assoc_id = SCTP_FUTURE_ASSOC ||
-	    params.assoc_id = SCTP_ALL_ASSOC)
-		sp->default_ss = params.assoc_value;
+	if (params->assoc_id = SCTP_FUTURE_ASSOC ||
+	    params->assoc_id = SCTP_ALL_ASSOC)
+		sp->default_ss = params->assoc_value;
 
-	if (params.assoc_id = SCTP_CURRENT_ASSOC ||
-	    params.assoc_id = SCTP_ALL_ASSOC) {
+	if (params->assoc_id = SCTP_CURRENT_ASSOC ||
+	    params->assoc_id = SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
 			int ret = sctp_sched_set_sched(asoc,
-						       params.assoc_value);
+						       params->assoc_value);
 
 			if (ret && !retval)
 				retval = ret;
@@ -4660,7 +4655,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_add_streams(sk, kopt, optlen);
 		break;
 	case SCTP_STREAM_SCHEDULER:
-		retval = sctp_setsockopt_scheduler(sk, optval, optlen);
+		retval = sctp_setsockopt_scheduler(sk, kopt, optlen);
 		break;
 	case SCTP_STREAM_SCHEDULER_VALUE:
 		retval = sctp_setsockopt_scheduler_value(sk, optval, optlen);
-- 
2.27.0
