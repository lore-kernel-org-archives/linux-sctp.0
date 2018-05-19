From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 19 May 2018 07:44:40 +0000
Subject: [PATCH net-next] sctp: add support for SCTP_REUSE_PORT sockopt
Message-Id: <be8e672439406e6c8b838321d63aa109b9620f4c.1526715880.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This feature is actually already supported by sk->sk_reuse which can be
set by SO_REUSEADDR. But it's not working exactly as RFC6458 demands in
section 8.1.27, like:

  - This option only supports one-to-one style SCTP sockets
  - This socket option must not be used after calling bind()
    or sctp_bindx().

Besides, SCTP_REUSE_PORT sockopt should be provided for user's programs.
Otherwise, the programs with SCTP_REUSE_PORT from other systems will not
work in linux.

This patch reuses sk->sk_reuse and works pretty much as SO_REUSEADDR,
just with some extra setup limitations that are neeeded when it is being
enabled.

"It should be noted that the behavior of the socket-level socket option
to reuse ports and/or addresses for SCTP sockets is unspecified", so it
leaves SO_REUSEADDR as is for the compatibility.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  1 +
 net/sctp/socket.c         | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index b64d583..c02986a 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -100,6 +100,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_RECVNXTINFO	33
 #define SCTP_DEFAULT_SNDINFO	34
 #define SCTP_AUTH_DEACTIVATE_KEY	35
+#define SCTP_REUSE_PORT		36
 
 /* Internal Socket Options. Some of the sctp library functions are
  * implemented using these socket options.
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1b4593b..8dfcc79 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4170,6 +4170,28 @@ static int sctp_setsockopt_interleaving_supported(struct sock *sk,
 	return retval;
 }
 
+static int sctp_setsockopt_reuse_port(struct sock *sk, char __user *optval,
+				      unsigned int optlen)
+{
+	int val;
+
+	if (!sctp_style(sk, TCP))
+		return -EOPNOTSUPP;
+
+	if (sctp_sk(sk)->ep->base.bind_addr.port)
+		return -EFAULT;
+
+	if (optlen < sizeof(int))
+		return -EINVAL;
+
+	if (get_user(val, (int __user *)optval))
+		return -EFAULT;
+
+	sk->sk_reuse = val ? SK_CAN_REUSE : SK_NO_REUSE;
+
+	return 0;
+}
+
 /* API 6.2 setsockopt(), getsockopt()
  *
  * Applications use setsockopt() and getsockopt() to set or retrieve
@@ -4364,6 +4386,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_interleaving_supported(sk, optval,
 								optlen);
 		break;
+	case SCTP_REUSE_PORT:
+		retval = sctp_setsockopt_reuse_port(sk, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -7175,6 +7200,26 @@ static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
 	return retval;
 }
 
+static int sctp_getsockopt_reuse_port(struct sock *sk, int len,
+				      char __user *optval,
+				      int __user *optlen)
+{
+	int val = 0;
+
+	if (len < sizeof(int))
+		return -EINVAL;
+
+	len = sizeof(int);
+	if (sk->sk_reuse != SK_NO_REUSE)
+		val = 1;
+	if (put_user(len, optlen))
+		return -EFAULT;
+	if (copy_to_user(optval, &val, len))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int sctp_getsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, int __user *optlen)
 {
@@ -7370,6 +7415,9 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_getsockopt_interleaving_supported(sk, len, optval,
 								optlen);
 		break;
+	case SCTP_REUSE_PORT:
+		retval = sctp_getsockopt_reuse_port(sk, len, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
-- 
2.1.0

