From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 19 Aug 2019 14:02:46 +0000
Subject: [PATCH net-next 4/8] sctp: add SCTP_ASCONF_SUPPORTED sockopt
Message-Id: <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1566223325.git.lucien.xin@gmail.com>
 <4c4682aab70fc11be7a505b11939dd998b9b21f5.1566223325.git.lucien.xin@gmail.com>
 <04b2de14df6de243e9faacc3a3de091adff45d52.1566223325.git.lucien.xin@gmail.com>
 <b868cd2896190a99a8553d0cfd372e72f3dbb1b7.1566223325.git.lucien.xin@gmail.com>
In-Reply-To: <b868cd2896190a99a8553d0cfd372e72f3dbb1b7.1566223325.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

SCTP_ASCONF_SUPPORTED sockopt is used to set enpoint's asconf
flag. With this feature, each endpoint will have its own flag
for its future asoc's asconf_capable, instead of netns asconf
flag.

Note that when both ep's asconf_enable and auth_enable are
enabled, SCTP_CID_ASCONF and SCTP_CID_ASCONF_ACK should be
added into auth_chunk_list.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  1 +
 net/sctp/socket.c         | 82 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index b8f2c4d..9b9b82d 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -134,6 +134,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_INTERLEAVING_SUPPORTED	125
 #define SCTP_SENDMSG_CONNECT	126
 #define SCTP_EVENT	127
+#define SCTP_ASCONF_SUPPORTED	128
 
 /* PR-SCTP policies */
 #define SCTP_PR_SCTP_NONE	0x0000
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 559793f..b21a707 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4496,6 +4496,42 @@ static int sctp_setsockopt_event(struct sock *sk, char __user *optval,
 	return retval;
 }
 
+static int sctp_setsockopt_asconf_supported(struct sock *sk,
+					    char __user *optval,
+					    unsigned int optlen)
+{
+	struct sctp_assoc_value params;
+	struct sctp_association *asoc;
+	struct sctp_endpoint *ep;
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
+	ep = sctp_sk(sk)->ep;
+	ep->asconf_enable = !!params.assoc_value;
+
+	if (ep->asconf_enable && ep->auth_enable) {
+		sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF);
+		sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF_ACK);
+	}
+
+	retval = 0;
+
+out:
+	return retval;
+}
+
 /* API 6.2 setsockopt(), getsockopt()
  *
  * Applications use setsockopt() and getsockopt() to set or retrieve
@@ -4696,6 +4732,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_EVENT:
 		retval = sctp_setsockopt_event(sk, optval, optlen);
 		break;
+	case SCTP_ASCONF_SUPPORTED:
+		retval = sctp_setsockopt_asconf_supported(sk, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -7675,6 +7714,45 @@ static int sctp_getsockopt_event(struct sock *sk, int len, char __user *optval,
 	return 0;
 }
 
+static int sctp_getsockopt_asconf_supported(struct sock *sk, int len,
+					    char __user *optval,
+					    int __user *optlen)
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
+	params.assoc_value = asoc ? asoc->peer.asconf_capable
+				  : sctp_sk(sk)->ep->asconf_enable;
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
@@ -7876,6 +7954,10 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 	case SCTP_EVENT:
 		retval = sctp_getsockopt_event(sk, len, optval, optlen);
 		break;
+	case SCTP_ASCONF_SUPPORTED:
+		retval = sctp_getsockopt_asconf_supported(sk, len, optval,
+							  optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
-- 
2.1.0
