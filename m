From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 08 Oct 2019 11:25:05 +0000
Subject: [PATCHv2 net-next 3/5] sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Message-Id: <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1570533716.git.lucien.xin@gmail.com>
 <bca4cbf1bee8ad2379b2fe9536b3404fc0935579.1570533716.git.lucien.xin@gmail.com>
 <8fcf707443f7218d3fb131b827c679f423c5ecaf.1570533716.git.lucien.xin@gmail.com>
In-Reply-To: <8fcf707443f7218d3fb131b827c679f423c5ecaf.1570533716.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This is a sockopt defined in section 7.3 of rfc7829: "Exposing
the Potentially Failed Path State", by which users can change
pf_expose per sock and asoc.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  1 +
 net/sctp/socket.c         | 76 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index b6649d6..a15cc28 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -137,6 +137,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_ASCONF_SUPPORTED	128
 #define SCTP_AUTH_SUPPORTED	129
 #define SCTP_ECN_SUPPORTED	130
+#define SCTP_EXPOSE_POTENTIALLY_FAILED_STATE	131
 
 /* PR-SCTP policies */
 #define SCTP_PR_SCTP_NONE	0x0000
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 8d27434..82faf78 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4589,6 +4589,37 @@ static int sctp_setsockopt_ecn_supported(struct sock *sk,
 	return retval;
 }
 
+static int sctp_setsockopt_pf_expose(struct sock *sk,
+				     char __user *optval,
+				     unsigned int optlen)
+{
+	struct sctp_assoc_value params;
+	struct sctp_association *asoc;
+	int retval = -EINVAL;
+
+	if (optlen != sizeof(params))
+		goto out;
+
+	if (copy_from_user(&params, optval, optlen)) {
+		retval = -EFAULT;
+		goto out;
+	}
+
+	asoc = sctp_id2assoc(sk, params.assoc_id);
+	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		goto out;
+
+	if (asoc)
+		asoc->pf_expose = !!params.assoc_value;
+	else
+		sctp_sk(sk)->pf_expose = !!params.assoc_value;
+	retval = 0;
+
+out:
+	return retval;
+}
+
 /* API 6.2 setsockopt(), getsockopt()
  *
  * Applications use setsockopt() and getsockopt() to set or retrieve
@@ -4798,6 +4829,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_ECN_SUPPORTED:
 		retval = sctp_setsockopt_ecn_supported(sk, optval, optlen);
 		break;
+	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
+		retval = sctp_setsockopt_pf_expose(sk, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -7908,6 +7942,45 @@ static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
 	return retval;
 }
 
+static int sctp_getsockopt_pf_expose(struct sock *sk, int len,
+				     char __user *optval,
+				     int __user *optlen)
+{
+	struct sctp_assoc_value params;
+	struct sctp_association *asoc;
+	int retval = -EFAULT;
+
+	if (len < sizeof(params)) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	len = sizeof(params);
+	if (copy_from_user(&params, optval, len))
+		goto out;
+
+	asoc = sctp_id2assoc(sk, params.assoc_id);
+	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP)) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	params.assoc_value = asoc ? asoc->pf_expose
+				  : sctp_sk(sk)->pf_expose;
+
+	if (put_user(len, optlen))
+		goto out;
+
+	if (copy_to_user(optval, &params, len))
+		goto out;
+
+	retval = 0;
+
+out:
+	return retval;
+}
+
 static int sctp_getsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, int __user *optlen)
 {
@@ -8120,6 +8193,9 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 	case SCTP_ECN_SUPPORTED:
 		retval = sctp_getsockopt_ecn_supported(sk, len, optval, optlen);
 		break;
+	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
+		retval = sctp_getsockopt_pf_expose(sk, len, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
-- 
2.1.0
