From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 18 Nov 2018 08:08:54 +0000
Subject: [PATCHv3 net-next 4/4] sctp: add sockopt SCTP_EVENT
Message-Id: <839715c531d817888bbacdf7d4570c9b55a40d0f.1542528309.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1542528309.git.lucien.xin@gmail.com>
 <dcc896a5655922d754c5da3b215d2d5ee338ca69.1542528309.git.lucien.xin@gmail.com>
 <55fc02263caa543564279aa33023cfaba9f2413a.1542528309.git.lucien.xin@gmail.com>
 <e729d53856fbbd755f6a90229a2976deb2ccb319.1542528309.git.lucien.xin@gmail.com>
In-Reply-To: <e729d53856fbbd755f6a90229a2976deb2ccb319.1542528309.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch adds sockopt SCTP_EVENT described in rfc6525#section-6.2.
With this sockopt users can subscribe to an event from a specified
asoc.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  7 ++++
 net/sctp/socket.c         | 88 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 66afa5b..d584073 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -129,6 +129,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_STREAM_SCHEDULER_VALUE	124
 #define SCTP_INTERLEAVING_SUPPORTED	125
 #define SCTP_SENDMSG_CONNECT	126
+#define SCTP_EVENT	127
 
 /* PR-SCTP policies */
 #define SCTP_PR_SCTP_NONE	0x0000
@@ -1154,6 +1155,12 @@ struct sctp_add_streams {
 	uint16_t sas_outstrms;
 };
 
+struct sctp_event {
+	sctp_assoc_t se_assoc_id;
+	uint16_t se_type;
+	uint8_t se_on;
+};
+
 /* SCTP Stream schedulers */
 enum sctp_sched_type {
 	SCTP_SS_FCFS,
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c771827..e16c090 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4288,6 +4288,57 @@ static int sctp_setsockopt_reuse_port(struct sock *sk, char __user *optval,
 	return 0;
 }
 
+static int sctp_setsockopt_event(struct sock *sk, char __user *optval,
+				 unsigned int optlen)
+{
+	struct sctp_association *asoc;
+	struct sctp_ulpevent *event;
+	struct sctp_event param;
+	int retval = 0;
+
+	if (optlen < sizeof(param)) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	optlen = sizeof(param);
+	if (copy_from_user(&param, optval, optlen)) {
+		retval = -EFAULT;
+		goto out;
+	}
+
+	if (param.se_type < SCTP_SN_TYPE_BASE ||
+	    param.se_type > SCTP_SN_TYPE_MAX) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	asoc = sctp_id2assoc(sk, param.se_assoc_id);
+	if (!asoc) {
+		sctp_ulpevent_type_set(&sctp_sk(sk)->subscribe,
+				       param.se_type, param.se_on);
+		goto out;
+	}
+
+	sctp_ulpevent_type_set(&asoc->subscribe, param.se_type, param.se_on);
+
+	if (param.se_type = SCTP_SENDER_DRY_EVENT && param.se_on) {
+		if (sctp_outq_is_empty(&asoc->outqueue)) {
+			event = sctp_ulpevent_make_sender_dry_event(asoc,
+					GFP_USER | __GFP_NOWARN);
+			if (!event) {
+				retval = -ENOMEM;
+				goto out;
+			}
+
+			asoc->stream.si->enqueue_event(&asoc->ulpq, event);
+		}
+	}
+
+out:
+	return retval;
+}
+
 /* API 6.2 setsockopt(), getsockopt()
  *
  * Applications use setsockopt() and getsockopt() to set or retrieve
@@ -4485,6 +4536,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_REUSE_PORT:
 		retval = sctp_setsockopt_reuse_port(sk, optval, optlen);
 		break;
+	case SCTP_EVENT:
+		retval = sctp_setsockopt_event(sk, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -7430,6 +7484,37 @@ static int sctp_getsockopt_reuse_port(struct sock *sk, int len,
 	return 0;
 }
 
+static int sctp_getsockopt_event(struct sock *sk, int len, char __user *optval,
+				 int __user *optlen)
+{
+	struct sctp_association *asoc;
+	struct sctp_event param;
+	__u16 subscribe;
+
+	if (len < sizeof(param))
+		return -EINVAL;
+
+	len = sizeof(param);
+	if (copy_from_user(&param, optval, len))
+		return -EFAULT;
+
+	if (param.se_type < SCTP_SN_TYPE_BASE ||
+	    param.se_type > SCTP_SN_TYPE_MAX)
+		return -EINVAL;
+
+	asoc = sctp_id2assoc(sk, param.se_assoc_id);
+	subscribe = asoc ? asoc->subscribe : sctp_sk(sk)->subscribe;
+	param.se_on = sctp_ulpevent_type_enabled(subscribe, param.se_type);
+
+	if (put_user(len, optlen))
+		return -EFAULT;
+
+	if (copy_to_user(optval, &param, len))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int sctp_getsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, int __user *optlen)
 {
@@ -7628,6 +7713,9 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 	case SCTP_REUSE_PORT:
 		retval = sctp_getsockopt_reuse_port(sk, len, optval, optlen);
 		break;
+	case SCTP_EVENT:
+		retval = sctp_getsockopt_event(sk, len, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
-- 
2.1.0
