From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 05 Mar 2018 12:44:18 +0000
Subject: [PATCH net-next 1/3] sctp: add support for PR-SCTP Information for sendmsg
Message-Id: <154aa989b7a97aebaffd96ff6773b416b79398be.1520253539.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1520253539.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1520253539.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch is to add support for PR-SCTP Information for sendmsg,
as described in section 5.3.7 of RFC6458.

With this option, you can specify pr_policy and pr_value for user
data in sendmsg.

It's also a necessary send info for sctp_sendv.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h |  1 +
 include/uapi/linux/sctp.h  | 15 +++++++++++++++
 net/sctp/socket.c          | 31 ++++++++++++++++++++++++++++++-
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 03e92dd..d40a2a3 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -2112,6 +2112,7 @@ struct sctp_cmsgs {
 	struct sctp_initmsg *init;
 	struct sctp_sndrcvinfo *srinfo;
 	struct sctp_sndinfo *sinfo;
+	struct sctp_prinfo *prinfo;
 };
 
 /* Structure for tracking memory objects */
diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 4c4db14..0dd1f82 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -260,6 +260,19 @@ struct sctp_nxtinfo {
 	sctp_assoc_t nxt_assoc_id;
 };
 
+/* 5.3.7 SCTP PR-SCTP Information Structure (SCTP_PRINFO)
+ *
+ *   This cmsghdr structure specifies SCTP options for sendmsg().
+ *
+ *   cmsg_level    cmsg_type      cmsg_data[]
+ *   ------------  ------------   -------------------
+ *   IPPROTO_SCTP  SCTP_PRINFO    struct sctp_prinfo
+ */
+struct sctp_prinfo {
+	__u16 pr_policy;
+	__u32 pr_value;
+};
+
 /*
  *  sinfo_flags: 16 bits (unsigned integer)
  *
@@ -293,6 +306,8 @@ typedef enum sctp_cmsg_type {
 #define SCTP_RCVINFO	SCTP_RCVINFO
 	SCTP_NXTINFO,		/* 5.3.6 SCTP Next Receive Information Structure */
 #define SCTP_NXTINFO	SCTP_NXTINFO
+	SCTP_PRINFO,		/* 5.3.7 SCTP PR-SCTP Information Structure */
+#define SCTP_PRINFO	SCTP_PRINFO
 } sctp_cmsg_t;
 
 /*
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 7fa7603..fdde697 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1644,6 +1644,12 @@ static int sctp_sendmsg_parse(struct sock *sk, struct sctp_cmsgs *cmsgs,
 		srinfo->sinfo_assoc_id = cmsgs->sinfo->snd_assoc_id;
 	}
 
+	if (cmsgs->prinfo) {
+		srinfo->sinfo_timetolive = cmsgs->prinfo->pr_value;
+		SCTP_PR_SET_POLICY(srinfo->sinfo_flags,
+				   cmsgs->prinfo->pr_policy);
+	}
+
 	sflags = srinfo->sinfo_flags;
 	if (!sflags && msg_len)
 		return 0;
@@ -1901,9 +1907,12 @@ static void sctp_sendmsg_update_sinfo(struct sctp_association *asoc,
 		sinfo->sinfo_ppid = asoc->default_ppid;
 		sinfo->sinfo_context = asoc->default_context;
 		sinfo->sinfo_assoc_id = sctp_assoc2id(asoc);
+
+		if (!cmsgs->prinfo)
+			sinfo->sinfo_flags = asoc->default_flags;
 	}
 
-	if (!cmsgs->srinfo)
+	if (!cmsgs->srinfo && !cmsgs->prinfo)
 		sinfo->sinfo_timetolive = asoc->default_timetolive;
 }
 
@@ -7749,6 +7758,26 @@ static int sctp_msghdr_parse(const struct msghdr *msg, struct sctp_cmsgs *cmsgs)
 			      SCTP_ABORT | SCTP_EOF))
 				return -EINVAL;
 			break;
+		case SCTP_PRINFO:
+			/* SCTP Socket API Extension
+			 * 5.3.7 SCTP PR-SCTP Information Structure (SCTP_PRINFO)
+			 *
+			 * This cmsghdr structure specifies SCTP options for sendmsg().
+			 *
+			 * cmsg_level    cmsg_type      cmsg_data[]
+			 * ------------  ------------   ---------------------
+			 * IPPROTO_SCTP  SCTP_PRINFO    struct sctp_prinfo
+			 */
+			if (cmsg->cmsg_len != CMSG_LEN(sizeof(struct sctp_prinfo)))
+				return -EINVAL;
+
+			cmsgs->prinfo = CMSG_DATA(cmsg);
+			if (cmsgs->prinfo->pr_policy & ~SCTP_PR_SCTP_MASK)
+				return -EINVAL;
+
+			if (cmsgs->prinfo->pr_policy = SCTP_PR_SCTP_NONE)
+				cmsgs->prinfo->pr_value = 0;
+			break;
 		default:
 			return -EINVAL;
 		}
-- 
2.1.0

