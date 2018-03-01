From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 01 Mar 2018 15:05:11 +0000
Subject: [PATCH net-next 2/9] sctp: factor out sctp_sendmsg_new_asoc from sctp_sendmsg
Message-Id: <eca6be098ff541b1e4a98b06dee76c0272590901.1519916440.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1519916440.git.lucien.xin@gmail.com>
 <1dbdb93e27d978da9fe883dbe72db78fbb58ec95.1519916440.git.lucien.xin@gmail.com>
In-Reply-To: <1dbdb93e27d978da9fe883dbe72db78fbb58ec95.1519916440.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch is to move the codes for creating a new asoc if
no asoc was found into sctp_sendmsg_new_asoc.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 201 +++++++++++++++++++++++-------------------------------
 1 file changed, 86 insertions(+), 115 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 183129e..58bb55d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1606,6 +1606,87 @@ static int sctp_error(struct sock *sk, int flags, int err)
 static int sctp_msghdr_parse(const struct msghdr *msg,
 			     struct sctp_cmsgs *cmsgs);
 
+static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
+				 struct sctp_cmsgs *cmsgs,
+				 union sctp_addr *daddr,
+				 struct sctp_transport **tp)
+{
+	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
+	struct net *net = sock_net(sk);
+	struct sctp_association *asoc;
+	enum sctp_scope scope;
+	int err = -EINVAL;
+
+	*tp = NULL;
+
+	if (sflags & (SCTP_EOF | SCTP_ABORT))
+		return -EINVAL;
+
+	if (sctp_style(sk, TCP) && (sctp_sstate(sk, ESTABLISHED) ||
+				    sctp_sstate(sk, CLOSING)))
+		return -EADDRNOTAVAIL;
+
+	if (sctp_endpoint_is_peeled_off(ep, daddr))
+		return -EADDRNOTAVAIL;
+
+	if (!ep->base.bind_addr.port) {
+		if (sctp_autobind(sk))
+			return -EAGAIN;
+	} else {
+		if (ep->base.bind_addr.port < inet_prot_sock(net) &&
+		    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
+			return -EACCES;
+	}
+
+	scope = sctp_scope(daddr);
+
+	asoc = sctp_association_new(ep, sk, scope, GFP_KERNEL);
+	if (!asoc)
+		return -ENOMEM;
+
+	if (sctp_assoc_set_bind_addr_from_ep(asoc, scope, GFP_KERNEL) < 0) {
+		err = -ENOMEM;
+		goto free;
+	}
+
+	if (cmsgs->init) {
+		struct sctp_initmsg *init = cmsgs->init;
+
+		if (init->sinit_num_ostreams) {
+			__u16 outcnt = init->sinit_num_ostreams;
+
+			asoc->c.sinit_num_ostreams = outcnt;
+			/* outcnt has been changed, need to re-init stream */
+			err = sctp_stream_init(&asoc->stream, outcnt, 0,
+					       GFP_KERNEL);
+			if (err)
+				goto free;
+		}
+
+		if (init->sinit_max_instreams)
+			asoc->c.sinit_max_instreams = init->sinit_max_instreams;
+
+		if (init->sinit_max_attempts)
+			asoc->max_init_attempts = init->sinit_max_attempts;
+
+		if (init->sinit_max_init_timeo)
+			asoc->max_init_timeo +				msecs_to_jiffies(init->sinit_max_init_timeo);
+	}
+
+	*tp = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL, SCTP_UNKNOWN);
+	if (!*tp) {
+		err = -ENOMEM;
+		goto free;
+	}
+
+	return 0;
+
+free:
+	sctp_association_free(asoc);
+	return err;
+}
+
 static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 				struct msghdr *msg, size_t msg_len,
 				struct sctp_transport *transport,
@@ -1715,7 +1796,6 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 	struct sctp_initmsg *sinit;
 	sctp_assoc_t associd = 0;
 	struct sctp_cmsgs cmsgs = { NULL };
-	enum sctp_scope scope;
 	bool fill_sinfo_ttl = false;
 	__u16 sinfo_flags = 0;
 	int err;
@@ -1817,20 +1897,6 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 	if (msg_name) {
 		/* Look for a matching association on the endpoint. */
 		asoc = sctp_endpoint_lookup_assoc(ep, &to, &transport);
-
-		/* If we could not find a matching association on the
-		 * endpoint, make sure that it is not a TCP-style
-		 * socket that already has an association or there is
-		 * no peeled-off association on another socket.
-		 */
-		if (!asoc &&
-		    ((sctp_style(sk, TCP) &&
-		      (sctp_sstate(sk, ESTABLISHED) ||
-		       sctp_sstate(sk, CLOSING))) ||
-		     sctp_endpoint_is_peeled_off(ep, &to))) {
-			err = -EADDRNOTAVAIL;
-			goto out_unlock;
-		}
 	} else {
 		asoc = sctp_id2assoc(sk, associd);
 		if (!asoc) {
@@ -1879,108 +1945,13 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 
 	/* Do we need to create the association?  */
 	if (!asoc) {
-		pr_debug("%s: there is no association yet\n", __func__);
-
-		if (sinfo_flags & (SCTP_EOF | SCTP_ABORT)) {
-			err = -EINVAL;
-			goto out_unlock;
-		}
-
-		/* Check for invalid stream against the stream counts,
-		 * either the default or the user specified stream counts.
-		 */
-		if (sinfo) {
-			if (!sinit || !sinit->sinit_num_ostreams) {
-				/* Check against the defaults. */
-				if (sinfo->sinfo_stream >-				    sp->initmsg.sinit_num_ostreams) {
-					err = -EINVAL;
-					goto out_unlock;
-				}
-			} else {
-				/* Check against the requested.  */
-				if (sinfo->sinfo_stream >-				    sinit->sinit_num_ostreams) {
-					err = -EINVAL;
-					goto out_unlock;
-				}
-			}
-		}
-
-		/*
-		 * API 3.1.2 bind() - UDP Style Syntax
-		 * If a bind() or sctp_bindx() is not called prior to a
-		 * sendmsg() call that initiates a new association, the
-		 * system picks an ephemeral port and will choose an address
-		 * set equivalent to binding with a wildcard address.
-		 */
-		if (!ep->base.bind_addr.port) {
-			if (sctp_autobind(sk)) {
-				err = -EAGAIN;
-				goto out_unlock;
-			}
-		} else {
-			/*
-			 * If an unprivileged user inherits a one-to-many
-			 * style socket with open associations on a privileged
-			 * port, it MAY be permitted to accept new associations,
-			 * but it SHOULD NOT be permitted to open new
-			 * associations.
-			 */
-			if (ep->base.bind_addr.port < inet_prot_sock(net) &&
-			    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE)) {
-				err = -EACCES;
-				goto out_unlock;
-			}
-		}
-
-		scope = sctp_scope(&to);
-		new_asoc = sctp_association_new(ep, sk, scope, GFP_KERNEL);
-		if (!new_asoc) {
-			err = -ENOMEM;
+		err = sctp_sendmsg_new_asoc(sk, sinfo_flags, &cmsgs, &to,
+					    &transport);
+		if (err)
 			goto out_unlock;
-		}
-		asoc = new_asoc;
-		err = sctp_assoc_set_bind_addr_from_ep(asoc, scope, GFP_KERNEL);
-		if (err < 0) {
-			err = -ENOMEM;
-			goto out_free;
-		}
-
-		/* If the SCTP_INIT ancillary data is specified, set all
-		 * the association init values accordingly.
-		 */
-		if (sinit) {
-			if (sinit->sinit_num_ostreams) {
-				__u16 outcnt = sinit->sinit_num_ostreams;
-
-				asoc->c.sinit_num_ostreams = outcnt;
-				/* outcnt has been changed, so re-init stream */
-				err = sctp_stream_init(&asoc->stream, outcnt, 0,
-						       GFP_KERNEL);
-				if (err)
-					goto out_free;
-			}
-			if (sinit->sinit_max_instreams) {
-				asoc->c.sinit_max_instreams -					sinit->sinit_max_instreams;
-			}
-			if (sinit->sinit_max_attempts) {
-				asoc->max_init_attempts
-					= sinit->sinit_max_attempts;
-			}
-			if (sinit->sinit_max_init_timeo) {
-				asoc->max_init_timeo -				 msecs_to_jiffies(sinit->sinit_max_init_timeo);
-			}
-		}
 
-		/* Prime the peer's transport structures.  */
-		transport = sctp_assoc_add_peer(asoc, &to, GFP_KERNEL, SCTP_UNKNOWN);
-		if (!transport) {
-			err = -ENOMEM;
-			goto out_free;
-		}
+		asoc = transport->asoc;
+		new_asoc = asoc;
 	}
 
 	/* ASSERT: we have a valid association at this point.  */
-- 
2.1.0

