From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 05 Dec 2017 15:15:58 +0000
Subject: [PATCH net-next 01/12] sctp: add stream interleave enable members and sockopt
Message-Id: <b830faf5987dbed8b1e724f039348e960b8537e3.1512486606.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512486606.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1512486606.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch adds intl_enable in asoc and netns, and strm_interleave in
sctp_sock to indicate if stream interleave is enabled and supported.

netns intl_enable would be set via procfs, but that is not added yet
until all stream interleave codes are completely implemented; asoc
intl_enable will be set when doing 4-shakehands.

sp strm_interleave can be set by sockopt SCTP_INTERLEAVING_SUPPORTED
which is also added in this patch. This socket option is defined in
section 4.3.1 of RFC8260.

Note that strm_interleave can only be set by sockopt when both netns
intl_enable and sp frag_interleave are set.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netns/sctp.h   |  5 ++-
 include/net/sctp/structs.h |  2 ++
 include/uapi/linux/sctp.h  |  1 +
 net/sctp/socket.c          | 88 +++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index ebc8132..0db7fb3 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -122,9 +122,12 @@ struct netns_sctp {
 	/* Flag to indicate if PR-CONFIG is enabled. */
 	int reconf_enable;
 
-	/* Flag to idicate if SCTP-AUTH is enabled */
+	/* Flag to indicate if SCTP-AUTH is enabled */
 	int auth_enable;
 
+	/* Flag to indicate if stream interleave is enabled */
+	int intl_enable;
+
 	/*
 	 * Policy to control SCTP IPv4 address scoping
 	 * 0   - Disable IPv4 address scoping
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 16f949e..dd2bb62 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -217,6 +217,7 @@ struct sctp_sock {
 		disable_fragments:1,
 		v4mapped:1,
 		frag_interleave:1,
+		strm_interleave:1,
 		recvrcvinfo:1,
 		recvnxtinfo:1,
 		data_ready_signalled:1;
@@ -1939,6 +1940,7 @@ struct sctp_association {
 	__u8 need_ecne:1,	/* Need to send an ECNE Chunk? */
 	     temp:1,		/* Is it a temporary association? */
 	     force_delay:1,
+	     intl_enable:1,
 	     prsctp_enable:1,
 	     reconf_enable:1;
 
diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index d9adab3..6ed934c 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -125,6 +125,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_SOCKOPT_PEELOFF_FLAGS 122
 #define SCTP_STREAM_SCHEDULER	123
 #define SCTP_STREAM_SCHEDULER_VALUE	124
+#define SCTP_INTERLEAVING_SUPPORTED	125
 
 /* PR-SCTP policies */
 #define SCTP_PR_SCTP_NONE	0x0000
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 014847e..8c33463 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3350,7 +3350,10 @@ static int sctp_setsockopt_fragment_interleave(struct sock *sk,
 	if (get_user(val, (int __user *)optval))
 		return -EFAULT;
 
-	sctp_sk(sk)->frag_interleave = (val = 0) ? 0 : 1;
+	sctp_sk(sk)->frag_interleave = !!val;
+
+	if (!sctp_sk(sk)->frag_interleave)
+		sctp_sk(sk)->strm_interleave = 0;
 
 	return 0;
 }
@@ -4019,6 +4022,40 @@ static int sctp_setsockopt_scheduler_value(struct sock *sk,
 	return retval;
 }
 
+static int sctp_setsockopt_interleaving_supported(struct sock *sk,
+						  char __user *optval,
+						  unsigned int optlen)
+{
+	struct sctp_sock *sp = sctp_sk(sk);
+	struct net *net = sock_net(sk);
+	struct sctp_assoc_value params;
+	int retval = -EINVAL;
+
+	if (optlen < sizeof(params))
+		goto out;
+
+	optlen = sizeof(params);
+	if (copy_from_user(&params, optval, optlen)) {
+		retval = -EFAULT;
+		goto out;
+	}
+
+	if (params.assoc_id)
+		goto out;
+
+	if (!net->sctp.intl_enable || !sp->frag_interleave) {
+		retval = -EPERM;
+		goto out;
+	}
+
+	sp->strm_interleave = !!params.assoc_value;
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
@@ -4206,6 +4243,10 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_STREAM_SCHEDULER_VALUE:
 		retval = sctp_setsockopt_scheduler_value(sk, optval, optlen);
 		break;
+	case SCTP_INTERLEAVING_SUPPORTED:
+		retval = sctp_setsockopt_interleaving_supported(sk, optval,
+								optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -6981,6 +7022,47 @@ static int sctp_getsockopt_scheduler_value(struct sock *sk, int len,
 	return retval;
 }
 
+static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
+						  char __user *optval,
+						  int __user *optlen)
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
+	if (asoc) {
+		params.assoc_value = asoc->intl_enable;
+	} else if (!params.assoc_id) {
+		struct sctp_sock *sp = sctp_sk(sk);
+
+		params.assoc_value = sp->strm_interleave;
+	} else {
+		retval = -EINVAL;
+		goto out;
+	}
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
@@ -7171,6 +7253,10 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_getsockopt_scheduler_value(sk, len, optval,
 							 optlen);
 		break;
+	case SCTP_INTERLEAVING_SUPPORTED:
+		retval = sctp_getsockopt_interleaving_supported(sk, len, optval,
+								optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
-- 
2.1.0

