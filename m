From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:23 +0000
Subject: [PATCH 46/51] sctp: pass a kernel pointer to sctp_setsockopt_event
Message-Id: <20200719072228.112645-47-hch@lst.de>
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
 net/sctp/socket.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a5b95e68cc129f..12a33fc42eeeb2 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4252,45 +4252,40 @@ static int sctp_assoc_ulpevent_type_set(struct sctp_event *param,
 	return 0;
 }
 
-static int sctp_setsockopt_event(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_event(struct sock *sk, struct sctp_event *param,
 				 unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
-	struct sctp_event param;
 	int retval = 0;
 
-	if (optlen < sizeof(param))
+	if (optlen < sizeof(*param))
 		return -EINVAL;
 
-	optlen = sizeof(param);
-	if (copy_from_user(&param, optval, optlen))
-		return -EFAULT;
-
-	if (param.se_type < SCTP_SN_TYPE_BASE ||
-	    param.se_type > SCTP_SN_TYPE_MAX)
+	if (param->se_type < SCTP_SN_TYPE_BASE ||
+	    param->se_type > SCTP_SN_TYPE_MAX)
 		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, param.se_assoc_id);
-	if (!asoc && param.se_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, param->se_assoc_id);
+	if (!asoc && param->se_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc)
-		return sctp_assoc_ulpevent_type_set(&param, asoc);
+		return sctp_assoc_ulpevent_type_set(param, asoc);
 
 	if (sctp_style(sk, TCP))
-		param.se_assoc_id = SCTP_FUTURE_ASSOC;
+		param->se_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (param.se_assoc_id = SCTP_FUTURE_ASSOC ||
-	    param.se_assoc_id = SCTP_ALL_ASSOC)
+	if (param->se_assoc_id = SCTP_FUTURE_ASSOC ||
+	    param->se_assoc_id = SCTP_ALL_ASSOC)
 		sctp_ulpevent_type_set(&sp->subscribe,
-				       param.se_type, param.se_on);
+				       param->se_type, param->se_on);
 
-	if (param.se_assoc_id = SCTP_CURRENT_ASSOC ||
-	    param.se_assoc_id = SCTP_ALL_ASSOC) {
+	if (param->se_assoc_id = SCTP_CURRENT_ASSOC ||
+	    param->se_assoc_id = SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
-			int ret = sctp_assoc_ulpevent_type_set(&param, asoc);
+			int ret = sctp_assoc_ulpevent_type_set(param, asoc);
 
 			if (ret && !retval)
 				retval = ret;
@@ -4643,7 +4638,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_reuse_port(sk, kopt, optlen);
 		break;
 	case SCTP_EVENT:
-		retval = sctp_setsockopt_event(sk, optval, optlen);
+		retval = sctp_setsockopt_event(sk, kopt, optlen);
 		break;
 	case SCTP_ASCONF_SUPPORTED:
 		retval = sctp_setsockopt_asconf_supported(sk, optval, optlen);
-- 
2.27.0
