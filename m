From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 02 May 2018 16:12:25 +0000
Subject: [PATCHv2 lksctp-tools 1/3] lib: add the core functions for sctp_sendv and sctp_recvv
Message-Id: <87be890523e90cb351b5a3e0a53589a4a2cc6c30.1525277218.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patch is to implement sctp_sendv and sctp_recvv defined in
rfc6458#section-9.12 and 9.13. They provide an extensible way
for users to send or receive messages from a SCTP socket.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 src/include/netinet/sctp.h |  43 +++++++++++++++
 src/lib/Versions.map       |   2 +
 src/lib/recvmsg.c          |  88 ++++++++++++++++++++++++++++++
 src/lib/sendmsg.c          | 130 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 263 insertions(+)

diff --git a/src/include/netinet/sctp.h b/src/include/netinet/sctp.h
index a0cd14c..701f091 100644
--- a/src/include/netinet/sctp.h
+++ b/src/include/netinet/sctp.h
@@ -122,6 +122,49 @@ int sctp_recvmsg(int s, void *msg, size_t len, struct sockaddr *from,
 /* Return the address length for an address family. */
 int sctp_getaddrlen(sa_family_t family);
 
+
+/* sendv infotype */
+enum {
+	SCTP_SENDV_NOINFO,
+	SCTP_SENDV_SNDINFO,
+	SCTP_SENDV_PRINFO,
+	SCTP_SENDV_AUTHINFO,
+	SCTP_SENDV_SPA
+};
+
+/* sendv_flags */
+#define SCTP_SEND_SNDINFO_VALID		0x1
+#define SCTP_SEND_PRINFO_VALID		0x2
+#define SCTP_SEND_AUTHINFO_VALID	0x4
+
+struct sctp_sendv_spa {
+	uint32_t sendv_flags;
+	struct sctp_sndinfo sendv_sndinfo;
+	struct sctp_prinfo sendv_prinfo;
+	struct sctp_authinfo sendv_authinfo;
+};
+
+int sctp_sendv(int s, const struct iovec *iov, int iovcnt,
+	       struct sockaddr *addrs, int addrcnt, void *info,
+	       socklen_t infolen, unsigned int infotype, int flags);
+
+/* recvv infotype */
+enum {
+	SCTP_RECVV_NOINFO,
+	SCTP_RECVV_RCVINFO,
+	SCTP_RECVV_NXTINFO,
+	SCTP_RECVV_RN
+};
+
+struct sctp_recvv_rn {
+	struct sctp_rcvinfo recvv_rcvinfo;
+	struct sctp_nxtinfo recvv_nxtinfo;
+};
+
+int sctp_recvv(int s, const struct iovec *iov, int iovlen,
+	       struct sockaddr *from, socklen_t *fromlen, void *info,
+	       socklen_t *infolen, unsigned int *infotype, int *flags);
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/src/lib/Versions.map b/src/lib/Versions.map
index a3c5561..7faad5d 100644
--- a/src/lib/Versions.map
+++ b/src/lib/Versions.map
@@ -10,7 +10,9 @@ VERS_1 {
 		sctp_opt_info;
 		sctp_peeloff;
 		sctp_recvmsg;
+		sctp_recvv;
 		sctp_sendmsg;
+		sctp_sendv;
 		sctp_send;
 
 	local:
diff --git a/src/lib/recvmsg.c b/src/lib/recvmsg.c
index 4575788..7c1dcad 100644
--- a/src/lib/recvmsg.c
+++ b/src/lib/recvmsg.c
@@ -99,3 +99,91 @@ int sctp_recvmsg(int s, void *msg, size_t len, struct sockaddr *from,
 
 	return (error);
 }
+
+int sctp_recvv(int s, const struct iovec *iov, int iovlen,
+	       struct sockaddr *from, socklen_t *fromlen, void *info,
+	       socklen_t *infolen, unsigned int *infotype, int *flags)
+{
+	char incmsg[CMSG_SPACE(sizeof(struct sctp_rcvinfo) +
+			       sizeof(struct sctp_nxtinfo))];
+	int error, len, _infolen;
+	struct cmsghdr *cmsg;
+	struct msghdr inmsg;
+
+	memset(&inmsg, 0, sizeof(inmsg));
+
+	/* set from and iov */
+	inmsg.msg_name = from;
+	inmsg.msg_namelen = fromlen ? *fromlen : 0;
+	inmsg.msg_iov = (struct iovec *)iov;
+	inmsg.msg_iovlen = iovlen;
+	inmsg.msg_control = incmsg;
+	inmsg.msg_controllen = sizeof(incmsg);
+
+	error = recvmsg(s, &inmsg, flags ? *flags : 0);
+	if (error < 0)
+		return error;
+
+	/* set fromlen, frags */
+	if (fromlen)
+		*fromlen = inmsg.msg_namelen;
+
+	if (flags)
+		*flags = inmsg.msg_flags;
+
+	if (!info || !infotype || !infolen)
+		return error;
+
+	*infotype = SCTP_RECVV_NOINFO;
+	_infolen = *infolen;
+
+	/* set info and infotype */
+	for (cmsg = CMSG_FIRSTHDR(&inmsg); cmsg != NULL;
+				cmsg = CMSG_NXTHDR(&inmsg, cmsg)) {
+		if (cmsg->cmsg_level != IPPROTO_SCTP)
+			continue;
+
+		if (cmsg->cmsg_type = SCTP_RCVINFO) {
+			len = sizeof(struct sctp_rcvinfo);
+			if (*infotype = SCTP_RECVV_NOINFO) {
+				if (_infolen < len)
+					break;
+				memcpy(info, CMSG_DATA(cmsg), len);
+				*infotype = SCTP_RECVV_RCVINFO;
+				*infolen = len;
+			} else if (*infotype = SCTP_RECVV_NXTINFO) {
+				if (_infolen < len +
+					       sizeof(struct sctp_nxtinfo))
+					break;
+				memcpy(info + len, info,
+				       sizeof(struct sctp_nxtinfo));
+				memcpy(info, CMSG_DATA(cmsg), len);
+				*infotype = SCTP_RECVV_RN;
+				*infolen = len + sizeof(struct sctp_nxtinfo);
+			} else {
+				break;
+			}
+		} else if (cmsg->cmsg_type = SCTP_NXTINFO) {
+			len = sizeof(struct sctp_nxtinfo);
+			if (*infotype = SCTP_RECVV_NOINFO) {
+				if (_infolen < len)
+					break;
+				memcpy(info, CMSG_DATA(cmsg), len);
+				*infotype = SCTP_RECVV_NXTINFO;
+				*infolen = len;
+			} else if (*infotype = SCTP_RECVV_RCVINFO) {
+				if (_infolen < len +
+					       sizeof(struct sctp_rcvinfo))
+					break;
+				memcpy(info + sizeof(struct sctp_rcvinfo),
+				       CMSG_DATA(cmsg), len);
+				*infotype = SCTP_RECVV_RN;
+				*infolen = len + sizeof(struct sctp_rcvinfo);
+			} else {
+				break;
+			}
+		}
+	}
+
+	return error;
+}
diff --git a/src/lib/sendmsg.c b/src/lib/sendmsg.c
index 9046174..a67c1c8 100644
--- a/src/lib/sendmsg.c
+++ b/src/lib/sendmsg.c
@@ -19,7 +19,10 @@
  *  Ardelle Fan     <ardelle.fan@intel.com>
  */
 
+#include <errno.h>
 #include <string.h>
+#include <stdlib.h>
+#include <netinet/in.h>
 #include <sys/socket.h>   /* struct sockaddr_storage, setsockopt() */
 #include <netinet/sctp.h>
 
@@ -104,3 +107,130 @@ sctp_send(int s, const void *msg, size_t len,
 
 	return sendmsg(s, &outmsg, flags);
 }
+
+static struct cmsghdr *sctp_sendv_store_cmsg(struct cmsghdr *cmsg, int *cmsglen,
+					     int type, int len, void *data)
+{
+	cmsg->cmsg_level = IPPROTO_SCTP;
+	cmsg->cmsg_type = type;
+	cmsg->cmsg_len = CMSG_LEN(len);
+	memcpy(CMSG_DATA(cmsg), data, len);
+
+	*cmsglen += CMSG_SPACE(len);
+
+	return (struct cmsghdr *)((char *)cmsg + CMSG_SPACE(len));
+}
+
+int sctp_sendv(int s, const struct iovec *iov, int iovcnt,
+	       struct sockaddr *addrs, int addrcnt, void *info,
+	       socklen_t infolen, unsigned int infotype, int flags)
+{
+	char _cmsg[CMSG_SPACE(sizeof(struct sctp_sendv_spa))];
+	struct cmsghdr *cmsg = (struct cmsghdr *)_cmsg;
+	struct sockaddr *addr;
+	struct msghdr outmsg;
+	int len, cmsglen = 0;
+	int err, type, i;
+	char *addrbuf;
+
+	/* set msg_iov, msg_iovlen, msg_flags */
+	memset(&outmsg, 0x00, sizeof(outmsg));
+	outmsg.msg_iov = (struct iovec *)iov;
+	outmsg.msg_iovlen = iovcnt;
+	outmsg.msg_flags = flags;
+
+	/* set msg_name and msg_namelen */
+	if (addrs && addrcnt) {
+		outmsg.msg_name = addrs;
+		if (addrs->sa_family = AF_INET)
+			outmsg.msg_namelen = sizeof(struct sockaddr_in);
+		else if (addrs->sa_family = AF_INET6)
+			outmsg.msg_namelen = sizeof(struct sockaddr_in6);
+		else
+			return -EINVAL;
+		addrcnt -= 1;
+		addrbuf = (char *)addrs;
+		addrs = (struct sockaddr *)(addrbuf + outmsg.msg_namelen);
+	}
+
+	/* alloc memory only when it's multi-address */
+	if (addrcnt) {
+		len = CMSG_SPACE(sizeof(struct sockaddr_in6)) * addrcnt;
+		cmsg = malloc(sizeof(_cmsg) + len);
+		if (!cmsg)
+			return -ENOMEM;
+	}
+
+	outmsg.msg_control = cmsg;
+
+	/* add cmsg info for addr info */
+	for (i = 0, addrbuf = (char *)addrs; i < addrcnt; i++) {
+		void *ainfo;
+
+		addr = (struct sockaddr *)addrbuf;
+		if (addr->sa_family = AF_INET) {
+			struct sockaddr_in *a = (struct sockaddr_in *)addrbuf;
+
+			len = sizeof(struct in_addr);
+			type = SCTP_DSTADDRV4;
+			ainfo = &a->sin_addr;
+			addrbuf += sizeof(*a);
+		} else if (addr->sa_family = AF_INET6) {
+			struct sockaddr_in6 *a = (struct sockaddr_in6 *)addrbuf;
+
+			len = sizeof(struct in6_addr);
+			type = SCTP_DSTADDRV6;
+			ainfo = &a->sin6_addr;
+			addrbuf += sizeof(*a);
+		} else {
+			free(outmsg.msg_control);
+			return -EINVAL;
+		}
+
+		cmsg = sctp_sendv_store_cmsg(cmsg, &cmsglen, type, len, ainfo);
+	}
+	/* add cmsg info for addr info for snd/pr/auth info */
+	if (infotype = SCTP_SENDV_SPA) {
+		struct sctp_sendv_spa *spa = info;
+
+		if (spa->sendv_flags & SCTP_SEND_SNDINFO_VALID) {
+			type = SCTP_SNDINFO;
+			len = sizeof(struct sctp_sndinfo);
+			cmsg = sctp_sendv_store_cmsg(cmsg, &cmsglen, type, len,
+						     &spa->sendv_sndinfo);
+		}
+		if (spa->sendv_flags & SCTP_SEND_PRINFO_VALID) {
+			type = SCTP_PRINFO;
+			len = sizeof(struct sctp_prinfo);
+			cmsg = sctp_sendv_store_cmsg(cmsg, &cmsglen, type, len,
+						     &spa->sendv_prinfo);
+		}
+		if (spa->sendv_flags & SCTP_SEND_AUTHINFO_VALID) {
+			type = SCTP_AUTHINFO;
+			len = sizeof(struct sctp_authinfo);
+			sctp_sendv_store_cmsg(cmsg, &cmsglen, type, len,
+					      &spa->sendv_authinfo);
+		}
+	} else if (infotype = SCTP_SENDV_SNDINFO) {
+		type = SCTP_SNDINFO;
+		len = sizeof(struct sctp_sndinfo);
+		sctp_sendv_store_cmsg(cmsg, &cmsglen, type, len, info);
+	} else if (infotype = SCTP_SENDV_PRINFO) {
+		type = SCTP_PRINFO;
+		len = sizeof(struct sctp_prinfo);
+		sctp_sendv_store_cmsg(cmsg, &cmsglen, type, len, info);
+	} else if (infotype = SCTP_SENDV_AUTHINFO) {
+		type = SCTP_AUTHINFO;
+		len = sizeof(struct sctp_authinfo);
+		sctp_sendv_store_cmsg(cmsg, &cmsglen, type, len, info);
+	}
+
+	outmsg.msg_controllen = cmsglen;
+
+	err = sendmsg(s, &outmsg, 0);
+
+	if (outmsg.msg_control != _cmsg)
+		free(outmsg.msg_control);
+
+	return err;
+}
-- 
2.1.0

