From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 02 Jun 2010 06:47:29 +0000
Subject: sctp: implement socket option SCTP_GET_ASSOC_ID_LIST
Message-Id: <4C05FE81.8070101@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patch Implement socket option SCTP_GET_ASSOC_ID_LIST.
SCTP Socket API Extension:

  8.2.6. Get the Current Identifiers of Associations
         (SCTP_GET_ASSOC_ID_LIST)

  This option gets the current list of SCTP association identifiers of
  the SCTP associations handled by a one-to-many style socket.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/user.h |   13 +++++++++++
 net/sctp/socket.c       |   52 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/include/net/sctp/user.h b/include/net/sctp/user.h
index 2b2769c..f05f99b 100644
--- a/include/net/sctp/user.h
+++ b/include/net/sctp/user.h
@@ -90,6 +90,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_PEER_AUTH_CHUNKS	26	/* Read only */
 #define SCTP_LOCAL_AUTH_CHUNKS	27	/* Read only */
 #define SCTP_GET_ASSOC_NUMBER	28	/* Read only */
+#define SCTP_GET_ASSOC_ID_LIST	29	/* Read only */
 
 /* Internal Socket Options. Some of the sctp library functions are
  * implemented using these socket options.
@@ -668,6 +669,18 @@ struct sctp_authchunks {
 };
 
 /*
+ * 8.2.6. Get the Current Identifiers of Associations
+ *        (SCTP_GET_ASSOC_ID_LIST)
+ *
+ * This option gets the current list of SCTP association identifiers of
+ * the SCTP associations handled by a one-to-many style socket.
+ */
+struct sctp_assoc_ids {
+	__u32		gaids_number_of_ids;
+	sctp_assoc_t	gaids_assoc_id[];
+};
+
+/*
  * 8.3, 8.5 get all peer/local addresses in an association.
  * This parameter struct is used by SCTP_GET_PEER_ADDRS and 
  * SCTP_GET_LOCAL_ADDRS socket options used internally to implement
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ca44917..857347b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5241,6 +5241,55 @@ static int sctp_getsockopt_assoc_number(struct sock *sk, int len,
 	return 0;
 }
 
+/*
+ * 8.2.6. Get the Current Identifiers of Associations
+ *        (SCTP_GET_ASSOC_ID_LIST)
+ *
+ * This option gets the current list of SCTP association identifiers of
+ * the SCTP associations handled by a one-to-many style socket.
+ */
+static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
+				    char __user *optval, int __user *optlen)
+{
+	struct sctp_sock *sp = sctp_sk(sk);
+	struct sctp_association *asoc;
+	struct sctp_assoc_ids *ids;
+	u32 num = 0;
+
+	if (sctp_style(sk, TCP))
+		return -EOPNOTSUPP;
+
+	if (len < sizeof(struct sctp_assoc_ids))
+		return -EINVAL;
+
+	list_for_each_entry(asoc, &(sp->ep->asocs), asocs) {
+		num++;
+	}
+
+	if (len < sizeof(struct sctp_assoc_ids) + sizeof(sctp_assoc_t) * num)
+		return -EINVAL;
+
+	len = sizeof(struct sctp_assoc_ids) + sizeof(sctp_assoc_t) * num;
+
+	ids = kmalloc(len, GFP_KERNEL);
+	if (unlikely(!ids))
+		return -ENOMEM;
+
+	ids->gaids_number_of_ids = num;
+	num = 0;
+	list_for_each_entry(asoc, &(sp->ep->asocs), asocs) {
+		ids->gaids_assoc_id[num++] = asoc->assoc_id;
+	}
+
+	if (put_user(len, optlen) || copy_to_user(optval, ids, len)) {
+		kfree(ids);
+		return -EFAULT;
+	}
+
+	kfree(ids);
+	return 0;
+}
+
 SCTP_STATIC int sctp_getsockopt(struct sock *sk, int level, int optname,
 				char __user *optval, int __user *optlen)
 {
@@ -5373,6 +5422,9 @@ SCTP_STATIC int sctp_getsockopt(struct sock *sk, int level, int optname,
 	case SCTP_GET_ASSOC_NUMBER:
 		retval = sctp_getsockopt_assoc_number(sk, len, optval, optlen);
 		break;
+	case SCTP_GET_ASSOC_ID_LIST:
+		retval = sctp_getsockopt_assoc_ids(sk, len, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
-- 
1.6.5.2


