From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 26 Aug 2019 08:30:04 +0000
Subject: [PATCH net-next 3/3] sctp: allow users to set ep ecn flag by sockopt
Message-Id: <58415590c2640149d56ae2db35f6d6ffd126aed3.1566807985.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1566807985.git.lucien.xin@gmail.com>
 <fc26e1e3bd1579a944320dc54d5cdbdec46ac61d.1566807985.git.lucien.xin@gmail.com>
 <fdbf487b2e1b255b1bbf457b3112979c33b53066.1566807985.git.lucien.xin@gmail.com>
In-Reply-To: <fdbf487b2e1b255b1bbf457b3112979c33b53066.1566807985.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

SCTP_ECN_SUPPORTED sockopt will be added to allow users to change
ep ecn flag, and it's similar with other feature flags.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  1 +
 net/sctp/socket.c         | 73 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 62527ac..6d5b164 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -136,6 +136,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_EVENT	127
 #define SCTP_ASCONF_SUPPORTED	128
 #define SCTP_AUTH_SUPPORTED	129
+#define SCTP_ECN_SUPPORTED	130
 
 /* PR-SCTP policies */
 #define SCTP_PR_SCTP_NONE	0x0000
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 82bc252..3e50a97 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4560,6 +4560,34 @@ static int sctp_setsockopt_auth_supported(struct sock *sk,
 	return retval;
 }
 
+static int sctp_setsockopt_ecn_supported(struct sock *sk,
+					 char __user *optval,
+					 unsigned int optlen)
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
+	sctp_sk(sk)->ep->ecn_enable = !!params.assoc_value;
+	retval = 0;
+
+out:
+	return retval;
+}
+
 /* API 6.2 setsockopt(), getsockopt()
  *
  * Applications use setsockopt() and getsockopt() to set or retrieve
@@ -4766,6 +4794,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_AUTH_SUPPORTED:
 		retval = sctp_setsockopt_auth_supported(sk, optval, optlen);
 		break;
+	case SCTP_ECN_SUPPORTED:
+		retval = sctp_setsockopt_ecn_supported(sk, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -7828,6 +7859,45 @@ static int sctp_getsockopt_auth_supported(struct sock *sk, int len,
 	return retval;
 }
 
+static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
+					 char __user *optval,
+					 int __user *optlen)
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
+	params.assoc_value = asoc ? asoc->peer.ecn_capable
+				  : sctp_sk(sk)->ep->ecn_enable;
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
@@ -8037,6 +8107,9 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_getsockopt_auth_supported(sk, len, optval,
 							optlen);
 		break;
+	case SCTP_ECN_SUPPORTED:
+		retval = sctp_getsockopt_ecn_supported(sk, len, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
-- 
2.1.0
