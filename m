From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:13 +0000
Subject: [PATCH 36/51] sctp: pass a kernel pointer to sctp_setsockopt_default_prinfo
Message-Id: <20200719072228.112645-37-hch@lst.de>
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
 net/sctp/socket.c | 45 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 245186327896b3..0eeb6e6162ad61 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3944,55 +3944,50 @@ static int sctp_setsockopt_pr_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_default_prinfo(struct sock *sk,
-					  char __user *optval,
+					  struct sctp_default_prinfo *info,
 					  unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
-	struct sctp_default_prinfo info;
 	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(info))
-		goto out;
-
-	if (copy_from_user(&info, optval, sizeof(info))) {
-		retval = -EFAULT;
+	if (optlen != sizeof(*info))
 		goto out;
-	}
 
-	if (info.pr_policy & ~SCTP_PR_SCTP_MASK)
+	if (info->pr_policy & ~SCTP_PR_SCTP_MASK)
 		goto out;
 
-	if (info.pr_policy = SCTP_PR_SCTP_NONE)
-		info.pr_value = 0;
+	if (info->pr_policy = SCTP_PR_SCTP_NONE)
+		info->pr_value = 0;
 
-	asoc = sctp_id2assoc(sk, info.pr_assoc_id);
-	if (!asoc && info.pr_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, info->pr_assoc_id);
+	if (!asoc && info->pr_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	retval = 0;
 
 	if (asoc) {
-		SCTP_PR_SET_POLICY(asoc->default_flags, info.pr_policy);
-		asoc->default_timetolive = info.pr_value;
+		SCTP_PR_SET_POLICY(asoc->default_flags, info->pr_policy);
+		asoc->default_timetolive = info->pr_value;
 		goto out;
 	}
 
 	if (sctp_style(sk, TCP))
-		info.pr_assoc_id = SCTP_FUTURE_ASSOC;
+		info->pr_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (info.pr_assoc_id = SCTP_FUTURE_ASSOC ||
-	    info.pr_assoc_id = SCTP_ALL_ASSOC) {
-		SCTP_PR_SET_POLICY(sp->default_flags, info.pr_policy);
-		sp->default_timetolive = info.pr_value;
+	if (info->pr_assoc_id = SCTP_FUTURE_ASSOC ||
+	    info->pr_assoc_id = SCTP_ALL_ASSOC) {
+		SCTP_PR_SET_POLICY(sp->default_flags, info->pr_policy);
+		sp->default_timetolive = info->pr_value;
 	}
 
-	if (info.pr_assoc_id = SCTP_CURRENT_ASSOC ||
-	    info.pr_assoc_id = SCTP_ALL_ASSOC) {
+	if (info->pr_assoc_id = SCTP_CURRENT_ASSOC ||
+	    info->pr_assoc_id = SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &sp->ep->asocs, asocs) {
-			SCTP_PR_SET_POLICY(asoc->default_flags, info.pr_policy);
-			asoc->default_timetolive = info.pr_value;
+			SCTP_PR_SET_POLICY(asoc->default_flags,
+					   info->pr_policy);
+			asoc->default_timetolive = info->pr_value;
 		}
 	}
 
@@ -4690,7 +4685,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_pr_supported(sk, kopt, optlen);
 		break;
 	case SCTP_DEFAULT_PRINFO:
-		retval = sctp_setsockopt_default_prinfo(sk, optval, optlen);
+		retval = sctp_setsockopt_default_prinfo(sk, kopt, optlen);
 		break;
 	case SCTP_RECONFIG_SUPPORTED:
 		retval = sctp_setsockopt_reconfig_supported(sk, optval, optlen);
-- 
2.27.0
