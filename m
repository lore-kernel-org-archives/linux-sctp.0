From: Daniel Borkmann <dborkman@redhat.com>
Date: Sat, 12 Jul 2014 18:30:38 +0000
Subject: [PATCH net-next v2 4/6] net: sctp: implement rfc6458, 5.3.6. SCTP_NXTINFO cmsg support
Message-Id: <1405189840-31171-5-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Geir Ola Vaagland <geirola@gmail.com>

This patch implements section 5.3.6. of RFC6458, that is, support
for 'SCTP Next Receive Information Structure' (SCTP_NXTINFO) which
is placed into ancillary data cmsghdr structure for each recvmsg()
call, if this information is already available when delivering the
current message.

This option can be enabled/disabled via setsockopt(2) on SOL_SCTP
level by setting an int value with 1/0 for SCTP_RECVNXTINFO in
user space applications as per RFC6458, section 8.1.30.

The sctp_nxtinfo structure is defined as per RFC as below ...

  struct sctp_nxtinfo {
    uint16_t nxt_sid;
    uint16_t nxt_flags;
    uint32_t nxt_ppid;
    uint32_t nxt_length;
    sctp_assoc_t nxt_assoc_id;
  };

... and provided under cmsg_level IPPROTO_SCTP, cmsg_type
SCTP_NXTINFO, while cmsg_data[] contains struct sctp_nxtinfo.

Joint work with Daniel Borkmann.

Signed-off-by: Geir Ola Vaagland <geirola@gmail.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 include/net/sctp/sctp.h     |  1 +
 include/net/sctp/structs.h  |  1 +
 include/net/sctp/ulpevent.h |  9 ++------
 include/uapi/linux/sctp.h   | 47 +++++++++++++++++++++++++++++-----------
 net/sctp/socket.c           | 52 +++++++++++++++++++++++++++++++++++++++++----
 net/sctp/ulpevent.c         | 38 +++++++++++++++++++++++++++++++++
 6 files changed, 125 insertions(+), 23 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index c2035c9..90c1ccc 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -109,6 +109,7 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 		    struct sctp_association *asoc);
 extern struct percpu_counter sctp_sockets_allocated;
 int sctp_asconf_mgmt(struct sctp_sock *, struct sctp_sockaddr_entry *);
+struct sk_buff *sctp_skb_recv_datagram(struct sock *, int, int, int *);
 
 /*
  * sctp/primitive.c
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 11d5df0..7741d1b 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -218,6 +218,7 @@ struct sctp_sock {
 	__u32 adaptation_ind;
 	__u32 pd_point;
 	__u8 recvrcvinfo;
+	__u8 recvnxtinfo;
 
 	atomic_t pd_mode;
 	/* Receive to here while partial delivery is in effect. */
diff --git a/include/net/sctp/ulpevent.h b/include/net/sctp/ulpevent.h
index e8095f9..cccdcfd 100644
--- a/include/net/sctp/ulpevent.h
+++ b/include/net/sctp/ulpevent.h
@@ -132,6 +132,8 @@ void sctp_ulpevent_read_sndrcvinfo(const struct sctp_ulpevent *event,
 				   struct msghdr *);
 void sctp_ulpevent_read_rcvinfo(const struct sctp_ulpevent *event,
 				struct msghdr *);
+void sctp_ulpevent_read_nxtinfo(const struct sctp_ulpevent *event,
+				struct msghdr *, struct sock *sk);
 
 __u16 sctp_ulpevent_get_notification_type(const struct sctp_ulpevent *event);
 
@@ -158,10 +160,3 @@ static inline int sctp_ulpevent_is_enabled(const struct sctp_ulpevent *event,
 }
 
 #endif /* __sctp_ulpevent_h__ */
-
-
-
-
-
-
-
diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 29b81bb..222f82f 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -96,6 +96,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_AUTO_ASCONF       30
 #define SCTP_PEER_ADDR_THLDS	31
 #define SCTP_RECVRCVINFO	32
+#define SCTP_RECVNXTINFO	33
 
 /* Internal Socket Options. Some of the sctp library functions are
  * implemented using these socket options.
@@ -111,6 +112,13 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_SOCKOPT_CONNECTX3	111	/* CONNECTX requests (updated) */
 #define SCTP_GET_ASSOC_STATS	112	/* Read only */
 
+/* These are bit fields for msghdr->msg_flags.  See section 5.1.  */
+/* On user space Linux, these live in <bits/socket.h> as an enum.  */
+enum sctp_msg_flags {
+	MSG_NOTIFICATION = 0x8000,
+#define MSG_NOTIFICATION MSG_NOTIFICATION
+};
+
 /* 5.3.1 SCTP Initiation Structure (SCTP_INIT)
  *
  *   This cmsghdr structure provides information for initializing new
@@ -187,6 +195,25 @@ struct sctp_rcvinfo {
 	sctp_assoc_t rcv_assoc_id;
 };
 
+/* 5.3.6 SCTP Next Receive Information Structure (SCTP_NXTINFO)
+ *
+ *   This cmsghdr structure describes SCTP receive information
+ *   of the next message that will be delivered through recvmsg()
+ *   if this information is already available when delivering
+ *   the current message.
+ *
+ *   cmsg_level    cmsg_type      cmsg_data[]
+ *   ------------  ------------   -------------------
+ *   IPPROTO_SCTP  SCTP_NXTINFO   struct sctp_nxtinfo
+ */
+struct sctp_nxtinfo {
+	__u16 nxt_sid;
+	__u16 nxt_flags;
+	__u32 nxt_ppid;
+	__u32 nxt_length;
+	sctp_assoc_t nxt_assoc_id;
+};
+
 /*
  *  sinfo_flags: 16 bits (unsigned integer)
  *
@@ -194,11 +221,12 @@ struct sctp_rcvinfo {
  *   a bitwise OR of these values.
  */
 enum sctp_sinfo_flags {
-	SCTP_UNORDERED = 1,  /* Send/receive message unordered. */
-	SCTP_ADDR_OVER = 2,  /* Override the primary destination. */
-	SCTP_ABORT=4,        /* Send an ABORT message to the peer. */
-	SCTP_SACK_IMMEDIATELY = 8,	/* SACK should be sent without delay */
-	SCTP_EOF=MSG_FIN,    /* Initiate graceful shutdown process. */
+	SCTP_UNORDERED		= (1 << 0), /* Send/receive message unordered. */
+	SCTP_ADDR_OVER		= (1 << 1), /* Override the primary destination. */
+	SCTP_ABORT		= (1 << 2), /* Send an ABORT message to the peer. */
+	SCTP_SACK_IMMEDIATELY	= (1 << 3), /* SACK should be sent without delay. */
+	SCTP_NOTIFICATION	= MSG_NOTIFICATION, /* Next message is not user msg but notification. */
+	SCTP_EOF		= MSG_FIN,  /* Initiate graceful shutdown process. */
 };
 
 typedef union {
@@ -217,6 +245,8 @@ typedef enum sctp_cmsg_type {
 #define SCTP_SNDINFO	SCTP_SNDINFO
 	SCTP_RCVINFO,		/* 5.3.5 SCTP Receive Information Structure */
 #define SCTP_RCVINFO	SCTP_RCVINFO
+	SCTP_NXTINFO,		/* 5.3.6 SCTP Next Receive Information Structure */
+#define SCTP_NXTINFO	SCTP_NXTINFO
 } sctp_cmsg_t;
 
 /*
@@ -844,13 +874,6 @@ struct sctp_assoc_stats {
 	__u64		sas_ictrlchunks; /* Control chunks received */
 };
 
-/* These are bit fields for msghdr->msg_flags.  See section 5.1.  */
-/* On user space Linux, these live in <bits/socket.h> as an enum.  */
-enum sctp_msg_flags {
-	MSG_NOTIFICATION = 0x8000,
-#define MSG_NOTIFICATION MSG_NOTIFICATION
-};
-
 /*
  * 8.1 sctp_bindx()
  *
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9c19388..9bca87e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2060,8 +2060,6 @@ static int sctp_skb_pull(struct sk_buff *skb, int len)
  *  flags   - flags sent or received with the user message, see Section
  *            5 for complete description of the flags.
  */
-static struct sk_buff *sctp_skb_recv_datagram(struct sock *, int, int, int *);
-
 static int sctp_recvmsg(struct kiocb *iocb, struct sock *sk,
 			struct msghdr *msg, size_t len, int noblock,
 			int flags, int *addr_len)
@@ -2112,6 +2110,9 @@ static int sctp_recvmsg(struct kiocb *iocb, struct sock *sk,
 		sp->pf->skb_msgname(skb, msg->msg_name, addr_len);
 	}
 
+	/* Check if we allow SCTP_NXTINFO. */
+	if (sp->recvnxtinfo)
+		sctp_ulpevent_read_nxtinfo(event, msg, sk);
 	/* Check if we allow SCTP_RCVINFO. */
 	if (sp->recvrcvinfo)
 		sctp_ulpevent_read_rcvinfo(event, msg);
@@ -3611,6 +3612,22 @@ static int sctp_setsockopt_recvrcvinfo(struct sock *sk,
 	return 0;
 }
 
+static int sctp_setsockopt_recvnxtinfo(struct sock *sk,
+				       char __user *optval,
+				       unsigned int optlen)
+{
+	int val;
+
+	if (optlen < sizeof(int))
+		return -EINVAL;
+	if (get_user(val, (int __user *) optval))
+		return -EFAULT;
+
+	sctp_sk(sk)->recvnxtinfo = (val = 0) ? 0 : 1;
+
+	return 0;
+}
+
 /* API 6.2 setsockopt(), getsockopt()
  *
  * Applications use setsockopt() and getsockopt() to set or retrieve
@@ -3765,6 +3782,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_RECVRCVINFO:
 		retval = sctp_setsockopt_recvrcvinfo(sk, optval, optlen);
 		break;
+	case SCTP_RECVNXTINFO:
+		retval = sctp_setsockopt_recvnxtinfo(sk, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -4012,6 +4032,7 @@ static int sctp_init_sock(struct sock *sk)
 	sp->nodelay           = 0;
 
 	sp->recvrcvinfo = 0;
+	sp->recvnxtinfo = 0;
 
 	/* Enable by default. */
 	sp->v4mapped          = 1;
@@ -5814,6 +5835,26 @@ static int sctp_getsockopt_recvrcvinfo(struct sock *sk,	int len,
 	return 0;
 }
 
+static int sctp_getsockopt_recvnxtinfo(struct sock *sk,	int len,
+				       char __user *optval,
+				       int __user *optlen)
+{
+	int val = 0;
+
+	if (len < sizeof(int))
+		return -EINVAL;
+
+	len = sizeof(int);
+	if (sctp_sk(sk)->recvnxtinfo)
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
@@ -5960,6 +6001,9 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 	case SCTP_RECVRCVINFO:
 		retval = sctp_getsockopt_recvrcvinfo(sk, len, optval, optlen);
 		break;
+	case SCTP_RECVNXTINFO:
+		retval = sctp_getsockopt_recvnxtinfo(sk, len, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -6602,8 +6646,8 @@ out:
  * Note: This is pretty much the same routine as in core/datagram.c
  * with a few changes to make lksctp work.
  */
-static struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags,
-					      int noblock, int *err)
+struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags,
+				       int noblock, int *err)
 {
 	int error;
 	struct sk_buff *skb;
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index b31f365..e049298 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -911,6 +911,44 @@ void sctp_ulpevent_read_rcvinfo(const struct sctp_ulpevent *event,
 		 sizeof(rinfo), &rinfo);
 }
 
+/* RFC6458, Section 5.3.6. SCTP Next Receive Information Structure
+ * (SCTP_NXTINFO)
+ */
+static void __sctp_ulpevent_read_nxtinfo(const struct sctp_ulpevent *event,
+					 struct msghdr *msghdr,
+					 const struct sk_buff *skb)
+{
+	struct sctp_nxtinfo nxtinfo;
+
+	memset(&nxtinfo, 0, sizeof(nxtinfo));
+	nxtinfo.nxt_sid = event->stream;
+	nxtinfo.nxt_ppid = event->ppid;
+	nxtinfo.nxt_flags = event->flags;
+	if (sctp_ulpevent_is_notification(event))
+		nxtinfo.nxt_flags |= SCTP_NOTIFICATION;
+	nxtinfo.nxt_length = skb->len;
+	nxtinfo.nxt_assoc_id = sctp_assoc2id(event->asoc);
+
+	put_cmsg(msghdr, IPPROTO_SCTP, SCTP_NXTINFO,
+		 sizeof(nxtinfo), &nxtinfo);
+}
+
+void sctp_ulpevent_read_nxtinfo(const struct sctp_ulpevent *event,
+				struct msghdr *msghdr,
+				struct sock *sk)
+{
+	struct sk_buff *skb;
+	int err;
+
+	skb = sctp_skb_recv_datagram(sk, MSG_PEEK, 1, &err);
+	if (skb != NULL) {
+		__sctp_ulpevent_read_nxtinfo(sctp_skb2event(skb),
+					     msghdr, skb);
+		/* Just release refcount here. */
+		kfree_skb(skb);
+	}
+}
+
 /* Do accounting for bytes received and hold a reference to the association
  * for each skb.
  */
-- 
1.7.11.7

