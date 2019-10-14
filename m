From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 14 Oct 2019 06:14:46 +0000
Subject: [PATCHv3 net-next 3/5] sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Message-Id: <eedcaeabec9253902de381b75ffc00c007fcd2b6.1571033544.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
 <f4c99c3d918c0d82f5d5c60abd6abcf381292f1f.1571033544.git.lucien.xin@gmail.com>
In-Reply-To: <f4c99c3d918c0d82f5d5c60abd6abcf381292f1f.1571033544.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net, David Laight <david.laight@aculab.com>

This is a sockopt defined in section 7.3 of rfc7829: "Exposing
the Potentially Failed Path State", by which users can change
pf_expose per sock and asoc.

v1->v2:
  - no change.
v2->v3:
  - return -EINVAL if params.assoc_value > SCTP_PF_EXPOSE_MAX.
  - define SCTP_EXPOSE_PF_STATE SCTP_EXPOSE_POTENTIALLY_FAILED_STATE.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  2 ++
 net/sctp/socket.c         | 79 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index d99b428..a190e4a 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -137,6 +137,8 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_ASCONF_SUPPORTED	128
 #define SCTP_AUTH_SUPPORTED	129
 #define SCTP_ECN_SUPPORTED	130
+#define SCTP_EXPOSE_POTENTIALLY_FAILED_STATE	131
+#define SCTP_EXPOSE_PF_STATE	SCTP_EXPOSE_POTENTIALLY_FAILED_STATE
 
 /* PR-SCTP policies */
 #define SCTP_PR_SCTP_NONE	0x0000
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 669e02e..eccd689 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4589,6 +4589,40 @@ static int sctp_setsockopt_ecn_supported(struct sock *sk,
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
+	if (params.assoc_value > SCTP_PF_EXPOSE_MAX)
+		goto out;
+
+	asoc = sctp_id2assoc(sk, params.assoc_id);
+	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		goto out;
+
+	if (asoc)
+		asoc->pf_expose = params.assoc_value;
+	else
+		sctp_sk(sk)->pf_expose = params.assoc_value;
+	retval = 0;
+
+out:
+	return retval;
+}
+
 /* API 6.2 setsockopt(), getsockopt()
  *
  * Applications use setsockopt() and getsockopt() to set or retrieve
@@ -4798,6 +4832,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_ECN_SUPPORTED:
 		retval = sctp_setsockopt_ecn_supported(sk, optval, optlen);
 		break;
+	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
+		retval = sctp_setsockopt_pf_expose(sk, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -7909,6 +7946,45 @@ static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
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
@@ -8121,6 +8197,9 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
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
