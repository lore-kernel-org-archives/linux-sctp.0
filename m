From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 04 Jul 2014 21:05:05 +0000
Subject: [PATCH net-next 2/5] net: sctp: implement rfc6458, 5.3.4. SCTP_SNDINFO cmsg support
Message-Id: <1404507908-6949-3-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Geir Ola Vaagland <geirola@gmail.com>

This patch implements section 5.3.4. of RFC6458, that is, support
for 'SCTP Send Information Structure' (SCTP_SNDINFO) which can be
placed into ancillary data cmsghdr structure for sendmsg() calls.

The sctp_sndinfo structure is defined as per RFC as below ...

  struct sctp_sndinfo {
    uint16_t snd_sid;
    uint16_t snd_flags;
    uint32_t snd_ppid;
    uint32_t snd_context;
    sctp_assoc_t snd_assoc_id;
  };

... and supplied under cmsg_level IPPROTO_SCTP, cmsg_type
SCTP_SNDINFO, while cmsg_data[] contains struct sctp_sndinfo.
An sctp_sndinfo item always corresponds to the data in msg_iov.

Joint work with Daniel Borkmann.

Signed-off-by: Geir Ola Vaagland <geirola@gmail.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 include/net/sctp/structs.h |  3 +-
 include/uapi/linux/sctp.h  | 22 +++++++++++--
 net/sctp/socket.c          | 77 ++++++++++++++++++++++++++++++++++------------
 3 files changed, 79 insertions(+), 23 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index f38588b..7af9a0f 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1919,7 +1919,8 @@ struct sctp_chunk *sctp_get_ecne_prepend(struct sctp_association *asoc);
 /* A convenience structure to parse out SCTP specific CMSGs. */
 typedef struct sctp_cmsgs {
 	struct sctp_initmsg *init;
-	struct sctp_sndrcvinfo *info;
+	struct sctp_sndrcvinfo *srinfo;
+	struct sctp_sndinfo *sinfo;
 } sctp_cmsgs_t;
 
 /* Structure for tracking memory objects */
diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 266022a..a387761 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -154,6 +154,22 @@ struct sctp_sndrcvinfo {
 	sctp_assoc_t sinfo_assoc_id;
 };
 
+/* 5.3.4 SCTP Send Information Structure (SCTP_SNDINFO)
+ *
+ *   This cmsghdr structure specifies SCTP options for sendmsg().
+ *
+ *   cmsg_level    cmsg_type      cmsg_data[]
+ *   ------------  ------------   -------------------
+ *   IPPROTO_SCTP  SCTP_SNDINFO   struct sctp_sndinfo
+ */
+struct sctp_sndinfo {
+	__u16 snd_sid;
+	__u16 snd_flags;
+	__u32 snd_ppid;
+	__u32 snd_context;
+	sctp_assoc_t snd_assoc_id;
+};
+
 /*
  *  sinfo_flags: 16 bits (unsigned integer)
  *
@@ -177,10 +193,12 @@ typedef union {
 
 /* These are cmsg_types.  */
 typedef enum sctp_cmsg_type {
-	SCTP_INIT,              /* 5.2.1 SCTP Initiation Structure */
+	SCTP_INIT,		/* 5.2.1 SCTP Initiation Structure */
 #define SCTP_INIT	SCTP_INIT
-	SCTP_SNDRCV,            /* 5.2.2 SCTP Header Information Structure */
+	SCTP_SNDRCV,		/* 5.2.2 SCTP Header Information Structure */
 #define SCTP_SNDRCV	SCTP_SNDRCV
+	SCTP_SNDINFO,		/* 5.3.4 SCTP Send Information Structure */
+#define SCTP_SNDINFO	SCTP_SNDINFO
 } sctp_cmsg_t;
 
 /*
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4298996..d61729e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1602,12 +1602,13 @@ static int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
 	struct sctp_initmsg *sinit;
 	sctp_assoc_t associd = 0;
 	sctp_cmsgs_t cmsgs = { NULL };
-	int err;
 	sctp_scope_t scope;
-	long timeo;
-	__u16 sinfo_flags = 0;
+	bool fill_sinfo_ttl = false;
 	struct sctp_datamsg *datamsg;
 	int msg_flags = msg->msg_flags;
+	__u16 sinfo_flags = 0;
+	long timeo;
+	int err;
 
 	err = 0;
 	sp = sctp_sk(sk);
@@ -1648,10 +1649,21 @@ static int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
 		msg_name = msg->msg_name;
 	}
 
-	sinfo = cmsgs.info;
 	sinit = cmsgs.init;
+	if (cmsgs.sinfo != NULL) {
+		memset(&default_sinfo, 0, sizeof(default_sinfo));
+		default_sinfo.sinfo_stream = cmsgs.sinfo->snd_sid;
+		default_sinfo.sinfo_flags = cmsgs.sinfo->snd_flags;
+		default_sinfo.sinfo_ppid = cmsgs.sinfo->snd_ppid;
+		default_sinfo.sinfo_context = cmsgs.sinfo->snd_context;
+		default_sinfo.sinfo_assoc_id = cmsgs.sinfo->snd_assoc_id;
 
-	/* Did the user specify SNDRCVINFO?  */
+		sinfo = &default_sinfo;
+		fill_sinfo_ttl = true;
+	} else {
+		sinfo = cmsgs.srinfo;
+	}
+	/* Did the user specify SNDINFO/SNDRCVINFO? */
 	if (sinfo) {
 		sinfo_flags = sinfo->sinfo_flags;
 		associd = sinfo->sinfo_assoc_id;
@@ -1858,8 +1870,8 @@ static int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
 	pr_debug("%s: we have a valid association\n", __func__);
 
 	if (!sinfo) {
-		/* If the user didn't specify SNDRCVINFO, make up one with
-		 * some defaults.
+		/* If the user didn't specify SNDINFO/SNDRCVINFO, make up
+		 * one with some defaults.
 		 */
 		memset(&default_sinfo, 0, sizeof(default_sinfo));
 		default_sinfo.sinfo_stream = asoc->default_stream;
@@ -1868,7 +1880,13 @@ static int sctp_sendmsg(struct kiocb *iocb, struct sock *sk,
 		default_sinfo.sinfo_context = asoc->default_context;
 		default_sinfo.sinfo_timetolive = asoc->default_timetolive;
 		default_sinfo.sinfo_assoc_id = sctp_assoc2id(asoc);
+
 		sinfo = &default_sinfo;
+	} else if (fill_sinfo_ttl) {
+		/* In case SNDINFO was specified, we still need to fill
+		 * it with a default ttl from the assoc here.
+		 */
+		sinfo->sinfo_timetolive = asoc->default_timetolive;
 	}
 
 	/* API 7.1.7, the sndbuf size per association bounds the
@@ -6390,8 +6408,7 @@ static int sctp_msghdr_parse(const struct msghdr *msg, sctp_cmsgs_t *cmsgs)
 	struct cmsghdr *cmsg;
 	struct msghdr *my_msg = (struct msghdr *)msg;
 
-	for (cmsg = CMSG_FIRSTHDR(msg);
-	     cmsg != NULL;
+	for (cmsg = CMSG_FIRSTHDR(msg); cmsg != NULL;
 	     cmsg = CMSG_NXTHDR(my_msg, cmsg)) {
 		if (!CMSG_OK(my_msg, cmsg))
 			return -EINVAL;
@@ -6404,7 +6421,7 @@ static int sctp_msghdr_parse(const struct msghdr *msg, sctp_cmsgs_t *cmsgs)
 		switch (cmsg->cmsg_type) {
 		case SCTP_INIT:
 			/* SCTP Socket API Extension
-			 * 5.2.1 SCTP Initiation Structure (SCTP_INIT)
+			 * 5.3.1 SCTP Initiation Structure (SCTP_INIT)
 			 *
 			 * This cmsghdr structure provides information for
 			 * initializing new SCTP associations with sendmsg().
@@ -6416,15 +6433,15 @@ static int sctp_msghdr_parse(const struct msghdr *msg, sctp_cmsgs_t *cmsgs)
 			 * ------------  ------------   ----------------------
 			 * IPPROTO_SCTP  SCTP_INIT      struct sctp_initmsg
 			 */
-			if (cmsg->cmsg_len !-			    CMSG_LEN(sizeof(struct sctp_initmsg)))
+			if (cmsg->cmsg_len != CMSG_LEN(sizeof(struct sctp_initmsg)))
 				return -EINVAL;
-			cmsgs->init = (struct sctp_initmsg *)CMSG_DATA(cmsg);
+
+			cmsgs->init = CMSG_DATA(cmsg);
 			break;
 
 		case SCTP_SNDRCV:
 			/* SCTP Socket API Extension
-			 * 5.2.2 SCTP Header Information Structure(SCTP_SNDRCV)
+			 * 5.3.2 SCTP Header Information Structure(SCTP_SNDRCV)
 			 *
 			 * This cmsghdr structure specifies SCTP options for
 			 * sendmsg() and describes SCTP header information
@@ -6434,24 +6451,44 @@ static int sctp_msghdr_parse(const struct msghdr *msg, sctp_cmsgs_t *cmsgs)
 			 * ------------  ------------   ----------------------
 			 * IPPROTO_SCTP  SCTP_SNDRCV    struct sctp_sndrcvinfo
 			 */
-			if (cmsg->cmsg_len !-			    CMSG_LEN(sizeof(struct sctp_sndrcvinfo)))
+			if (cmsg->cmsg_len != CMSG_LEN(sizeof(struct sctp_sndrcvinfo)))
 				return -EINVAL;
 
-			cmsgs->info -				(struct sctp_sndrcvinfo *)CMSG_DATA(cmsg);
+			cmsgs->srinfo = CMSG_DATA(cmsg);
 
-			/* Minimally, validate the sinfo_flags. */
-			if (cmsgs->info->sinfo_flags &
+			if (cmsgs->srinfo->sinfo_flags &
 			    ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
 			      SCTP_ABORT | SCTP_EOF))
 				return -EINVAL;
 			break;
 
+		case SCTP_SNDINFO:
+			/* SCTP Socket API Extension
+			 * 5.3.4 SCTP Send Information Structure (SCTP_SNDINFO)
+			 *
+			 * This cmsghdr structure specifies SCTP options for
+			 * sendmsg(). This structure and SCTP_RCVINFO replaces
+			 * SCTP_SNDRCV which has been deprecated.
+			 *
+			 * cmsg_level    cmsg_type      cmsg_data[]
+			 * ------------  ------------   ---------------------
+			 * IPPROTO_SCTP  SCTP_SNDINFO    struct sctp_sndinfo
+			 */
+			if (cmsg->cmsg_len != CMSG_LEN(sizeof(struct sctp_sndinfo)))
+				return -EINVAL;
+
+			cmsgs->sinfo = CMSG_DATA(cmsg);
+
+			if (cmsgs->sinfo->snd_flags &
+			    ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
+			      SCTP_ABORT | SCTP_EOF))
+				return -EINVAL;
+			break;
 		default:
 			return -EINVAL;
 		}
 	}
+
 	return 0;
 }
 
-- 
1.7.11.7

