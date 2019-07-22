From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 22 Jul 2019 17:37:59 +0000
Subject: [PATCH net-next 3/4] sctp: factor out sctp_connect_new_asoc
Message-Id: <1b46966a4b2013dd3bb3c19b61b38e2d39d53118.1563817029.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1563817029.git.lucien.xin@gmail.com>
 <c875aa0a5b2965636dc3da83398856627310b280.1563817029.git.lucien.xin@gmail.com>
 <0a87c3c2c48b10a930205d413a160854032eaa4a.1563817029.git.lucien.xin@gmail.com>
In-Reply-To: <0a87c3c2c48b10a930205d413a160854032eaa4a.1563817029.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

In this function factored out from sctp_sendmsg_new_asoc() and
__sctp_connect(), it creates the asoc and adds a peer with the
1st addr.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 160 ++++++++++++++++++++++++++----------------------------
 1 file changed, 76 insertions(+), 84 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 49837e9..420abdb 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1044,6 +1044,73 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 	return err;
 }
 
+static int sctp_connect_new_asoc(struct sctp_endpoint *ep,
+				 const union sctp_addr *daddr,
+				 const struct sctp_initmsg *init,
+				 struct sctp_transport **tp)
+{
+	struct sctp_association *asoc;
+	struct sock *sk = ep->base.sk;
+	struct net *net = sock_net(sk);
+	enum sctp_scope scope;
+	int err;
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
+	asoc = sctp_association_new(ep, sk, scope, GFP_KERNEL);
+	if (!asoc)
+		return -ENOMEM;
+
+	err = sctp_assoc_set_bind_addr_from_ep(asoc, scope, GFP_KERNEL);
+	if (err < 0)
+		goto free;
+
+	*tp = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL, SCTP_UNKNOWN);
+	if (!*tp) {
+		err = -ENOMEM;
+		goto free;
+	}
+
+	if (!init)
+		return 0;
+
+	if (init->sinit_num_ostreams) {
+		__u16 outcnt = init->sinit_num_ostreams;
+
+		asoc->c.sinit_num_ostreams = outcnt;
+		/* outcnt has been changed, need to re-init stream */
+		err = sctp_stream_init(&asoc->stream, outcnt, 0, GFP_KERNEL);
+		if (err)
+			goto free;
+	}
+
+	if (init->sinit_max_instreams)
+		asoc->c.sinit_max_instreams = init->sinit_max_instreams;
+
+	if (init->sinit_max_attempts)
+		asoc->max_init_attempts = init->sinit_max_attempts;
+
+	if (init->sinit_max_init_timeo)
+		asoc->max_init_timeo +			msecs_to_jiffies(init->sinit_max_init_timeo);
+
+	return 0;
+free:
+	sctp_association_free(asoc);
+	return err;
+}
+
 /* __sctp_connect(struct sock* sk, struct sockaddr *kaddrs, int addrs_size)
  *
  * Common routine for handling connect() and sctp_connectx().
@@ -1056,11 +1123,9 @@ static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_endpoint *ep = sp->ep;
 	struct sctp_transport *transport;
-	struct net *net = sock_net(sk);
 	int addrcnt, walk_size, err;
 	void *addr_buf = kaddrs;
 	union sctp_addr *daddr;
-	enum sctp_scope scope;
 	struct sctp_af *af;
 	long timeo;
 
@@ -1082,32 +1147,10 @@ static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
 		return asoc->state >= SCTP_STATE_ESTABLISHED ? -EISCONN
 							     : -EALREADY;
 
-	if (sctp_endpoint_is_peeled_off(ep, daddr))
-		return -EADDRNOTAVAIL;
-
-	if (!ep->base.bind_addr.port) {
-		if (sctp_autobind(sk))
-			return -EAGAIN;
-	} else {
-		if (ep->base.bind_addr.port < inet_prot_sock(net) &&
-		    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
-			return -EACCES;
-	}
-
-	scope = sctp_scope(daddr);
-	asoc = sctp_association_new(ep, sk, scope, GFP_KERNEL);
-	if (!asoc)
-		return -ENOMEM;
-
-	err = sctp_assoc_set_bind_addr_from_ep(asoc, scope, GFP_KERNEL);
-	if (err < 0)
-		goto out_free;
-
-	transport = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL, SCTP_UNKNOWN);
-	if (!transport) {
-		err = -ENOMEM;
-		goto out_free;
-	}
+	err = sctp_connect_new_asoc(ep, daddr, NULL, &transport);
+	if (err)
+		return err;
+	asoc = transport->asoc;
 
 	addr_buf += af->sockaddr_len;
 	walk_size = af->sockaddr_len;
@@ -1162,7 +1205,7 @@ static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
 			goto out_free;
 	}
 
-	err = sctp_primitive_ASSOCIATE(net, asoc, NULL);
+	err = sctp_primitive_ASSOCIATE(sock_net(sk), asoc, NULL);
 	if (err < 0)
 		goto out_free;
 
@@ -1598,9 +1641,7 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 				 struct sctp_transport **tp)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct net *net = sock_net(sk);
 	struct sctp_association *asoc;
-	enum sctp_scope scope;
 	struct cmsghdr *cmsg;
 	__be32 flowinfo = 0;
 	struct sctp_af *af;
@@ -1615,20 +1656,6 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 				    sctp_sstate(sk, CLOSING)))
 		return -EADDRNOTAVAIL;
 
-	if (sctp_endpoint_is_peeled_off(ep, daddr))
-		return -EADDRNOTAVAIL;
-
-	if (!ep->base.bind_addr.port) {
-		if (sctp_autobind(sk))
-			return -EAGAIN;
-	} else {
-		if (ep->base.bind_addr.port < inet_prot_sock(net) &&
-		    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
-			return -EACCES;
-	}
-
-	scope = sctp_scope(daddr);
-
 	/* Label connection socket for first association 1-to-many
 	 * style for client sequence socket()->sendmsg(). This
 	 * needs to be done before sctp_assoc_add_peer() as that will
@@ -1644,45 +1671,10 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 	if (err < 0)
 		return err;
 
-	asoc = sctp_association_new(ep, sk, scope, GFP_KERNEL);
-	if (!asoc)
-		return -ENOMEM;
-
-	if (sctp_assoc_set_bind_addr_from_ep(asoc, scope, GFP_KERNEL) < 0) {
-		err = -ENOMEM;
-		goto free;
-	}
-
-	if (cmsgs->init) {
-		struct sctp_initmsg *init = cmsgs->init;
-
-		if (init->sinit_num_ostreams) {
-			__u16 outcnt = init->sinit_num_ostreams;
-
-			asoc->c.sinit_num_ostreams = outcnt;
-			/* outcnt has been changed, need to re-init stream */
-			err = sctp_stream_init(&asoc->stream, outcnt, 0,
-					       GFP_KERNEL);
-			if (err)
-				goto free;
-		}
-
-		if (init->sinit_max_instreams)
-			asoc->c.sinit_max_instreams = init->sinit_max_instreams;
-
-		if (init->sinit_max_attempts)
-			asoc->max_init_attempts = init->sinit_max_attempts;
-
-		if (init->sinit_max_init_timeo)
-			asoc->max_init_timeo -				msecs_to_jiffies(init->sinit_max_init_timeo);
-	}
-
-	*tp = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL, SCTP_UNKNOWN);
-	if (!*tp) {
-		err = -ENOMEM;
-		goto free;
-	}
+	err = sctp_connect_new_asoc(ep, daddr, cmsgs->init, tp);
+	if (err)
+		return err;
+	asoc = (*tp)->asoc;
 
 	if (!cmsgs->addrs_msg)
 		return 0;
-- 
2.1.0
