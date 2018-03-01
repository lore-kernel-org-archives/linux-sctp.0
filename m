From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 01 Mar 2018 15:05:13 +0000
Subject: [PATCH net-next 4/9] sctp: factor out sctp_sendmsg_get_daddr from sctp_sendmsg
Message-Id: <fd4d3e9c299ccd3354d7c1af3a3eb6d732acf392.1519916440.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1519916440.git.lucien.xin@gmail.com>
 <1dbdb93e27d978da9fe883dbe72db78fbb58ec95.1519916440.git.lucien.xin@gmail.com>
 <eca6be098ff541b1e4a98b06dee76c0272590901.1519916440.git.lucien.xin@gmail.com>
 <588fe081ed87c02258db4caf0377979d19a8132a.1519916440.git.lucien.xin@gmail.com>
In-Reply-To: <588fe081ed87c02258db4caf0377979d19a8132a.1519916440.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch is to move the codes for trying to get daddr from
msg->msg_name into sctp_sendmsg_get_daddr.

Note that after adding 'daddr', 'to' and 'msg_name' can be
deleted.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 58 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 93cff99..68691d2 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1814,14 +1814,35 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 	return err;
 }
 
+static union sctp_addr *sctp_sendmsg_get_daddr(struct sock *sk,
+					       const struct msghdr *msg,
+					       struct sctp_cmsgs *cmsgs)
+{
+	union sctp_addr *daddr = NULL;
+	int err;
+
+	if (!sctp_style(sk, UDP_HIGH_BANDWIDTH) && msg->msg_name) {
+		int len = msg->msg_namelen;
+
+		if (len > sizeof(*daddr))
+			len = sizeof(*daddr);
+
+		daddr = (union sctp_addr *)msg->msg_name;
+
+		err = sctp_verify_addr(sk, daddr, len);
+		if (err)
+			return ERR_PTR(err);
+	}
+
+	return daddr;
+}
+
 static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 {
 	struct sctp_sock *sp;
 	struct sctp_endpoint *ep;
 	struct sctp_association *new_asoc = NULL, *asoc = NULL;
 	struct sctp_transport *transport, *chunk_tp;
-	union sctp_addr to;
-	struct sockaddr *msg_name = NULL;
 	struct sctp_sndrcvinfo default_sinfo;
 	struct sctp_sndrcvinfo *sinfo;
 	struct sctp_initmsg *sinit;
@@ -1829,6 +1850,7 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 	struct sctp_cmsgs cmsgs = { NULL };
 	bool fill_sinfo_ttl = false;
 	__u16 sinfo_flags = 0;
+	union sctp_addr *daddr;
 	int err;
 
 	err = 0;
@@ -1851,23 +1873,11 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 		goto out_nounlock;
 	}
 
-	/* Fetch the destination address for this packet.  This
-	 * address only selects the association--it is not necessarily
-	 * the address we will send to.
-	 * For a peeled-off socket, msg_name is ignored.
-	 */
-	if (!sctp_style(sk, UDP_HIGH_BANDWIDTH) && msg->msg_name) {
-		int msg_namelen = msg->msg_namelen;
-
-		err = sctp_verify_addr(sk, (union sctp_addr *)msg->msg_name,
-				       msg_namelen);
-		if (err)
-			return err;
-
-		if (msg_namelen > sizeof(to))
-			msg_namelen = sizeof(to);
-		memcpy(&to, msg->msg_name, msg_namelen);
-		msg_name = msg->msg_name;
+	/* Get daddr from msg */
+	daddr = sctp_sendmsg_get_daddr(sk, msg, &cmsgs);
+	if (IS_ERR(daddr)) {
+		err = PTR_ERR(daddr);
+		goto out_nounlock;
 	}
 
 	sinit = cmsgs.init;
@@ -1925,9 +1935,9 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 	lock_sock(sk);
 
 	/* If a msg_name has been specified, assume this is to be used.  */
-	if (msg_name) {
+	if (daddr) {
 		/* Look for a matching association on the endpoint. */
-		asoc = sctp_endpoint_lookup_assoc(ep, &to, &transport);
+		asoc = sctp_endpoint_lookup_assoc(ep, daddr, &transport);
 	} else {
 		asoc = sctp_id2assoc(sk, associd);
 		if (!asoc) {
@@ -1945,7 +1955,7 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 
 	/* Do we need to create the association?  */
 	if (!asoc) {
-		err = sctp_sendmsg_new_asoc(sk, sinfo_flags, &cmsgs, &to,
+		err = sctp_sendmsg_new_asoc(sk, sinfo_flags, &cmsgs, daddr,
 					    &transport);
 		if (err)
 			goto out_unlock;
@@ -1989,9 +1999,9 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 	 * to override the primary destination address in the TCP model, or
 	 * when SCTP_ADDR_OVER flag is set in the UDP model.
 	 */
-	if ((sctp_style(sk, TCP) && msg_name) ||
+	if ((sctp_style(sk, TCP) && daddr) ||
 	    (sinfo_flags & SCTP_ADDR_OVER)) {
-		chunk_tp = sctp_assoc_lookup_paddr(asoc, &to);
+		chunk_tp = sctp_assoc_lookup_paddr(asoc, daddr);
 		if (!chunk_tp) {
 			err = -EINVAL;
 			goto out_free;
-- 
2.1.0

