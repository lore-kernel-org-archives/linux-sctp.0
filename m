From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 01 Mar 2018 15:05:14 +0000
Subject: [PATCH net-next 5/9] sctp: factor out sctp_sendmsg_parse from sctp_sendmsg
Message-Id: <ee810edf89a6df987e822bda0da4bc4559a5ea97.1519916440.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1519916440.git.lucien.xin@gmail.com>
 <1dbdb93e27d978da9fe883dbe72db78fbb58ec95.1519916440.git.lucien.xin@gmail.com>
 <eca6be098ff541b1e4a98b06dee76c0272590901.1519916440.git.lucien.xin@gmail.com>
 <588fe081ed87c02258db4caf0377979d19a8132a.1519916440.git.lucien.xin@gmail.com>
 <fd4d3e9c299ccd3354d7c1af3a3eb6d732acf392.1519916440.git.lucien.xin@gmail.com>
In-Reply-To: <fd4d3e9c299ccd3354d7c1af3a3eb6d732acf392.1519916440.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch is to move the codes for parsing msghdr and checking
sk into sctp_sendmsg_parse.

Note that different from before, 'sinfo' in sctp_sendmsg won't
be NULL any more. It gets the value either from cmsgs->srinfo,
cmsgs->sinfo or asoc. With it, the 'sinfo' and 'fill_sinfo_ttl'
check can be removed from sctp_sendmsg.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 172 ++++++++++++++++++++++--------------------------------
 1 file changed, 69 insertions(+), 103 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 68691d2..bf089e5 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1606,6 +1606,61 @@ static int sctp_error(struct sock *sk, int flags, int err)
 static int sctp_msghdr_parse(const struct msghdr *msg,
 			     struct sctp_cmsgs *cmsgs);
 
+static int sctp_sendmsg_parse(struct sock *sk, struct sctp_cmsgs *cmsgs,
+			      struct sctp_sndrcvinfo *srinfo,
+			      const struct msghdr *msg, size_t msg_len)
+{
+	__u16 sflags;
+	int err;
+
+	if (sctp_sstate(sk, LISTENING) && sctp_style(sk, TCP))
+		return -EPIPE;
+
+	if (msg_len > sk->sk_sndbuf)
+		return -EMSGSIZE;
+
+	memset(cmsgs, 0, sizeof(*cmsgs));
+	err = sctp_msghdr_parse(msg, cmsgs);
+	if (err) {
+		pr_debug("%s: msghdr parse err:%x\n", __func__, err);
+		return err;
+	}
+
+	memset(srinfo, 0, sizeof(*srinfo));
+	if (cmsgs->srinfo) {
+		srinfo->sinfo_stream = cmsgs->srinfo->sinfo_stream;
+		srinfo->sinfo_flags = cmsgs->srinfo->sinfo_flags;
+		srinfo->sinfo_ppid = cmsgs->srinfo->sinfo_ppid;
+		srinfo->sinfo_context = cmsgs->srinfo->sinfo_context;
+		srinfo->sinfo_assoc_id = cmsgs->srinfo->sinfo_assoc_id;
+		srinfo->sinfo_timetolive = cmsgs->srinfo->sinfo_timetolive;
+	}
+
+	if (cmsgs->sinfo) {
+		srinfo->sinfo_stream = cmsgs->sinfo->snd_sid;
+		srinfo->sinfo_flags = cmsgs->sinfo->snd_flags;
+		srinfo->sinfo_ppid = cmsgs->sinfo->snd_ppid;
+		srinfo->sinfo_context = cmsgs->sinfo->snd_context;
+		srinfo->sinfo_assoc_id = cmsgs->sinfo->snd_assoc_id;
+	}
+
+	sflags = srinfo->sinfo_flags;
+	if (!sflags && msg_len)
+		return 0;
+
+	if (sctp_style(sk, TCP) && (sflags & (SCTP_EOF | SCTP_ABORT)))
+		return -EINVAL;
+
+	if (((sflags & SCTP_EOF) && msg_len > 0) ||
+	    (!(sflags & (SCTP_EOF | SCTP_ABORT)) && msg_len = 0))
+		return -EINVAL;
+
+	if ((sflags & SCTP_ADDR_OVER) && !msg->msg_name)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 				 struct sctp_cmsgs *cmsgs,
 				 union sctp_addr *daddr,
@@ -1839,39 +1894,23 @@ static union sctp_addr *sctp_sendmsg_get_daddr(struct sock *sk,
 
 static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 {
-	struct sctp_sock *sp;
-	struct sctp_endpoint *ep;
+	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_association *new_asoc = NULL, *asoc = NULL;
 	struct sctp_transport *transport, *chunk_tp;
-	struct sctp_sndrcvinfo default_sinfo;
-	struct sctp_sndrcvinfo *sinfo;
-	struct sctp_initmsg *sinit;
+	struct sctp_sndrcvinfo _sinfo, *sinfo;
 	sctp_assoc_t associd = 0;
 	struct sctp_cmsgs cmsgs = { NULL };
-	bool fill_sinfo_ttl = false;
 	__u16 sinfo_flags = 0;
 	union sctp_addr *daddr;
 	int err;
 
-	err = 0;
-	sp = sctp_sk(sk);
-	ep = sp->ep;
-
-	pr_debug("%s: sk:%p, msg:%p, msg_len:%zu ep:%p\n", __func__, sk,
-		 msg, msg_len, ep);
-
-	/* We cannot send a message over a TCP-style listening socket. */
-	if (sctp_style(sk, TCP) && sctp_sstate(sk, LISTENING)) {
-		err = -EPIPE;
+	/* Parse and get snd_info */
+	err = sctp_sendmsg_parse(sk, &cmsgs, &_sinfo, msg, msg_len);
+	if (err)
 		goto out_nounlock;
-	}
 
-	/* Parse out the SCTP CMSGs.  */
-	err = sctp_msghdr_parse(msg, &cmsgs);
-	if (err) {
-		pr_debug("%s: msghdr parse err:%x\n", __func__, err);
-		goto out_nounlock;
-	}
+	sinfo  = &_sinfo;
+	sinfo_flags = sinfo->sinfo_flags;
 
 	/* Get daddr from msg */
 	daddr = sctp_sendmsg_get_daddr(sk, msg, &cmsgs);
@@ -1880,58 +1919,6 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 		goto out_nounlock;
 	}
 
-	sinit = cmsgs.init;
-	if (cmsgs.sinfo != NULL) {
-		memset(&default_sinfo, 0, sizeof(default_sinfo));
-		default_sinfo.sinfo_stream = cmsgs.sinfo->snd_sid;
-		default_sinfo.sinfo_flags = cmsgs.sinfo->snd_flags;
-		default_sinfo.sinfo_ppid = cmsgs.sinfo->snd_ppid;
-		default_sinfo.sinfo_context = cmsgs.sinfo->snd_context;
-		default_sinfo.sinfo_assoc_id = cmsgs.sinfo->snd_assoc_id;
-
-		sinfo = &default_sinfo;
-		fill_sinfo_ttl = true;
-	} else {
-		sinfo = cmsgs.srinfo;
-	}
-	/* Did the user specify SNDINFO/SNDRCVINFO? */
-	if (sinfo) {
-		sinfo_flags = sinfo->sinfo_flags;
-		associd = sinfo->sinfo_assoc_id;
-	}
-
-	pr_debug("%s: msg_len:%zu, sinfo_flags:0x%x\n", __func__,
-		 msg_len, sinfo_flags);
-
-	/* SCTP_EOF or SCTP_ABORT cannot be set on a TCP-style socket. */
-	if (sctp_style(sk, TCP) && (sinfo_flags & (SCTP_EOF | SCTP_ABORT))) {
-		err = -EINVAL;
-		goto out_nounlock;
-	}
-
-	/* If SCTP_EOF is set, no data can be sent. Disallow sending zero
-	 * length messages when SCTP_EOF|SCTP_ABORT is not set.
-	 * If SCTP_ABORT is set, the message length could be non zero with
-	 * the msg_iov set to the user abort reason.
-	 */
-	if (((sinfo_flags & SCTP_EOF) && (msg_len > 0)) ||
-	    (!(sinfo_flags & (SCTP_EOF|SCTP_ABORT)) && (msg_len = 0))) {
-		err = -EINVAL;
-		goto out_nounlock;
-	}
-
-	/* If SCTP_ADDR_OVER is set, there must be an address
-	 * specified in msg_name.
-	 */
-	if ((sinfo_flags & SCTP_ADDR_OVER) && (!msg->msg_name)) {
-		err = -EINVAL;
-		goto out_nounlock;
-	}
-
-	transport = NULL;
-
-	pr_debug("%s: about to look up association\n", __func__);
-
 	lock_sock(sk);
 
 	/* If a msg_name has been specified, assume this is to be used.  */
@@ -1964,36 +1951,15 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 		new_asoc = asoc;
 	}
 
-	/* ASSERT: we have a valid association at this point.  */
-	pr_debug("%s: we have a valid association\n", __func__);
-
-	if (!sinfo) {
-		/* If the user didn't specify SNDINFO/SNDRCVINFO, make up
-		 * one with some defaults.
-		 */
-		memset(&default_sinfo, 0, sizeof(default_sinfo));
-		default_sinfo.sinfo_stream = asoc->default_stream;
-		default_sinfo.sinfo_flags = asoc->default_flags;
-		default_sinfo.sinfo_ppid = asoc->default_ppid;
-		default_sinfo.sinfo_context = asoc->default_context;
-		default_sinfo.sinfo_timetolive = asoc->default_timetolive;
-		default_sinfo.sinfo_assoc_id = sctp_assoc2id(asoc);
-
-		sinfo = &default_sinfo;
-	} else if (fill_sinfo_ttl) {
-		/* In case SNDINFO was specified, we still need to fill
-		 * it with a default ttl from the assoc here.
-		 */
-		sinfo->sinfo_timetolive = asoc->default_timetolive;
+	if (!cmsgs.srinfo && !cmsgs.sinfo) {
+		sinfo->sinfo_stream = asoc->default_stream;
+		sinfo->sinfo_ppid = asoc->default_ppid;
+		sinfo->sinfo_context = asoc->default_context;
+		sinfo->sinfo_assoc_id = sctp_assoc2id(asoc);
 	}
 
-	/* API 7.1.7, the sndbuf size per association bounds the
-	 * maximum size of data that can be sent in a single send call.
-	 */
-	if (msg_len > sk->sk_sndbuf) {
-		err = -EMSGSIZE;
-		goto out_free;
-	}
+	if (!cmsgs.srinfo)
+		sinfo->sinfo_timetolive = asoc->default_timetolive;
 
 	/* If an address is passed with the sendto/sendmsg call, it is used
 	 * to override the primary destination address in the TCP model, or
-- 
2.1.0

