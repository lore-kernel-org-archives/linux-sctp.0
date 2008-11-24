From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 24 Nov 2008 04:54:36 +0000
Subject: sctp: Implement socket option SCTP_GET_ASSOC_NUMBER
Message-Id: <492A338C.6060000@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Implement socket option SCTP_GET_ASSOC_NUMBER of the latest ietf socket
extensions API draft.

  8.2.5.  Get the Current Number of Associations (SCTP_GET_ASSOC_NUMBER)

   This option gets the current number of associations that are attached
   to a one-to-many style socket.  The option value is an uint32_t.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/user.h |    2 ++
 net/sctp/socket.c       |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/include/net/sctp/user.h b/include/net/sctp/user.h
index f205b10..b259fc5 100644
--- a/include/net/sctp/user.h
+++ b/include/net/sctp/user.h
@@ -118,6 +118,8 @@ enum sctp_optname {
 #define SCTP_PEER_AUTH_CHUNKS SCTP_PEER_AUTH_CHUNKS
 	SCTP_LOCAL_AUTH_CHUNKS,		/* Read only */
 #define SCTP_LOCAL_AUTH_CHUNKS SCTP_LOCAL_AUTH_CHUNKS
+	SCTP_GET_ASSOC_NUMBER,		/* Read only */
+#define SCTP_GET_ASSOC_NUMBER SCTP_GET_ASSOC_NUMBER
 
 
 	/* Internal Socket Options. Some of the sctp library functions are 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 8d0dacc..3a71475 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5449,6 +5449,38 @@ num:
 	return 0;
 }
 
+/*
+ * 8.2.5.  Get the Current Number of Associations (SCTP_GET_ASSOC_NUMBER)
+ * This option gets the current number of associations that are attached
+ * to a one-to-many style socket.  The option value is an uint32_t.
+ */
+static int sctp_getsockopt_assoc_number(struct sock *sk, int len,
+				    char __user *optval, int __user *optlen)
+{
+	struct sctp_sock *sp = sctp_sk(sk);
+	struct sctp_association *asoc;
+	u32 val = 0;
+
+	if (sctp_style(sk, TCP))
+		return -EOPNOTSUPP;
+
+	if (len < sizeof(u32))
+		return -EINVAL;
+
+	len = sizeof(u32);
+
+	list_for_each_entry(asoc, &(sp->ep->asocs), asocs) {
+		val++;
+	}
+
+	if (put_user(len, optlen))
+		return -EFAULT;
+	if (copy_to_user(optval, &val, len))
+		return -EFAULT;
+
+	return 0;
+}
+
 SCTP_STATIC int sctp_getsockopt(struct sock *sk, int level, int optname,
 				char __user *optval, int __user *optlen)
 {
@@ -5591,6 +5623,9 @@ SCTP_STATIC int sctp_getsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_getsockopt_local_auth_chunks(sk, len, optval,
 							optlen);
 		break;
+	case SCTP_GET_ASSOC_NUMBER:
+		retval = sctp_getsockopt_assoc_number(sk, len, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
-- 
1.6.0.2.530.g67faa



