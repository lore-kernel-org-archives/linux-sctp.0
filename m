From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 01 Mar 2018 15:05:12 +0000
Subject: [PATCH net-next 3/9] sctp: factor out sctp_sendmsg_check_sflags from sctp_sendmsg
Message-Id: <588fe081ed87c02258db4caf0377979d19a8132a.1519916440.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1519916440.git.lucien.xin@gmail.com>
 <1dbdb93e27d978da9fe883dbe72db78fbb58ec95.1519916440.git.lucien.xin@gmail.com>
 <eca6be098ff541b1e4a98b06dee76c0272590901.1519916440.git.lucien.xin@gmail.com>
In-Reply-To: <eca6be098ff541b1e4a98b06dee76c0272590901.1519916440.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch is to move the codes for checking sinfo_flags on one asoc
after this asoc has been found into sctp_sendmsg_check_sflags.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 72 +++++++++++++++++++++++++++----------------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 58bb55d..93cff99 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1687,6 +1687,39 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 	return err;
 }
 
+static int sctp_sendmsg_check_sflags(struct sctp_association *asoc,
+				     __u16 sflags, struct msghdr *msg,
+				     size_t msg_len)
+{
+	struct sock *sk = asoc->base.sk;
+	struct net *net = sock_net(sk);
+
+	if (sctp_state(asoc, CLOSED) && sctp_style(sk, TCP))
+		return -EPIPE;
+
+	if (sflags & SCTP_EOF) {
+		pr_debug("%s: shutting down association:%p\n", __func__, asoc);
+		sctp_primitive_SHUTDOWN(net, asoc, NULL);
+
+		return 0;
+	}
+
+	if (sflags & SCTP_ABORT) {
+		struct sctp_chunk *chunk;
+
+		chunk = sctp_make_abort_user(asoc, msg, msg_len);
+		if (!chunk)
+			return -ENOMEM;
+
+		pr_debug("%s: aborting association:%p\n", __func__, asoc);
+		sctp_primitive_ABORT(net, asoc, chunk);
+
+		return 0;
+	}
+
+	return 1;
+}
+
 static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 				struct msghdr *msg, size_t msg_len,
 				struct sctp_transport *transport,
@@ -1783,12 +1816,10 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 
 static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 {
-	struct net *net = sock_net(sk);
 	struct sctp_sock *sp;
 	struct sctp_endpoint *ep;
 	struct sctp_association *new_asoc = NULL, *asoc = NULL;
 	struct sctp_transport *transport, *chunk_tp;
-	struct sctp_chunk *chunk;
 	union sctp_addr to;
 	struct sockaddr *msg_name = NULL;
 	struct sctp_sndrcvinfo default_sinfo;
@@ -1906,41 +1937,10 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 	}
 
 	if (asoc) {
-		pr_debug("%s: just looked up association:%p\n", __func__, asoc);
-
-		/* We cannot send a message on a TCP-style SCTP_SS_ESTABLISHED
-		 * socket that has an association in CLOSED state. This can
-		 * happen when an accepted socket has an association that is
-		 * already CLOSED.
-		 */
-		if (sctp_state(asoc, CLOSED) && sctp_style(sk, TCP)) {
-			err = -EPIPE;
-			goto out_unlock;
-		}
-
-		if (sinfo_flags & SCTP_EOF) {
-			pr_debug("%s: shutting down association:%p\n",
-				 __func__, asoc);
-
-			sctp_primitive_SHUTDOWN(net, asoc, NULL);
-			err = 0;
+		err = sctp_sendmsg_check_sflags(asoc, sinfo_flags, msg,
+						msg_len);
+		if (err <= 0)
 			goto out_unlock;
-		}
-		if (sinfo_flags & SCTP_ABORT) {
-
-			chunk = sctp_make_abort_user(asoc, msg, msg_len);
-			if (!chunk) {
-				err = -ENOMEM;
-				goto out_unlock;
-			}
-
-			pr_debug("%s: aborting association:%p\n",
-				 __func__, asoc);
-
-			sctp_primitive_ABORT(net, asoc, chunk);
-			err = 0;
-			goto out_unlock;
-		}
 	}
 
 	/* Do we need to create the association?  */
-- 
2.1.0

