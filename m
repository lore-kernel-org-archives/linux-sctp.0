From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 30 Jul 2019 12:38:23 +0000
Subject: [PATCHv2 net-next 5/5] sctp: factor out sctp_connect_add_peer
Message-Id: <9c1d65ebe29d85fc50a9bb285797a4449e6dd3a6.1564490276.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1564490276.git.lucien.xin@gmail.com>
 <bb6e9856c2db0f24b91fb326fbe3c9c013f2459b.1564490276.git.lucien.xin@gmail.com>
 <2fe592e724eee4e9b00097485a5bccf317907874.1564490276.git.lucien.xin@gmail.com>
 <9995f1c75cd5a555fc22ba2ab374890ad1cee470.1564490276.git.lucien.xin@gmail.com>
 <64a624d23fe947a7bd4fe1d66ddb8719e791c284.1564490276.git.lucien.xin@gmail.com>
In-Reply-To: <64a624d23fe947a7bd4fe1d66ddb8719e791c284.1564490276.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

In this function factored out from sctp_sendmsg_new_asoc() and
__sctp_connect(), it adds a peer with the other addr into the
asoc after this asoc is created with the 1st addr.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 76 +++++++++++++++++++++++--------------------------------
 1 file changed, 31 insertions(+), 45 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6f77853..2f7e88c 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1111,6 +1111,33 @@ static int sctp_connect_new_asoc(struct sctp_endpoint *ep,
 	return err;
 }
 
+static int sctp_connect_add_peer(struct sctp_association *asoc,
+				 union sctp_addr *daddr, int addr_len)
+{
+	struct sctp_endpoint *ep = asoc->ep;
+	struct sctp_association *old;
+	struct sctp_transport *t;
+	int err;
+
+	err = sctp_verify_addr(ep->base.sk, daddr, addr_len);
+	if (err)
+		return err;
+
+	old = sctp_endpoint_lookup_assoc(ep, daddr, &t);
+	if (old && old != asoc)
+		return old->state >= SCTP_STATE_ESTABLISHED ? -EISCONN
+							    : -EALREADY;
+
+	if (sctp_endpoint_is_peeled_off(ep, daddr))
+		return -EADDRNOTAVAIL;
+
+	t = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL, SCTP_UNKNOWN);
+	if (!t)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /* __sctp_connect(struct sock* sk, struct sockaddr *kaddrs, int addrs_size)
  *
  * Common routine for handling connect() and sctp_connectx().
@@ -1119,10 +1146,10 @@ static int sctp_connect_new_asoc(struct sctp_endpoint *ep,
 static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
 			  int addrs_size, int flags, sctp_assoc_t *assoc_id)
 {
-	struct sctp_association *old, *asoc;
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_endpoint *ep = sp->ep;
 	struct sctp_transport *transport;
+	struct sctp_association *asoc;
 	void *addr_buf = kaddrs;
 	union sctp_addr *daddr;
 	struct sctp_af *af;
@@ -1167,29 +1194,10 @@ static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
 		if (asoc->peer.port != ntohs(daddr->v4.sin_port))
 			goto out_free;
 
-		err = sctp_verify_addr(sk, daddr, af->sockaddr_len);
+		err = sctp_connect_add_peer(asoc, daddr, af->sockaddr_len);
 		if (err)
 			goto out_free;
 
-		old = sctp_endpoint_lookup_assoc(ep, daddr, &transport);
-		if (old && old != asoc) {
-			err = old->state >= SCTP_STATE_ESTABLISHED ? -EISCONN
-								   : -EALREADY;
-			goto out_free;
-		}
-
-		if (sctp_endpoint_is_peeled_off(ep, daddr)) {
-			err = -EADDRNOTAVAIL;
-			goto out_free;
-		}
-
-		transport = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL,
-						SCTP_UNKNOWN);
-		if (!transport) {
-			err = -ENOMEM;
-			goto out_free;
-		}
-
 		addr_buf  += af->sockaddr_len;
 		walk_size += af->sockaddr_len;
 	}
@@ -1683,8 +1691,6 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 
 	/* sendv addr list parse */
 	for_each_cmsghdr(cmsg, cmsgs->addrs_msg) {
-		struct sctp_transport *transport;
-		struct sctp_association *old;
 		union sctp_addr _daddr;
 		int dlen;
 
@@ -1718,30 +1724,10 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 			daddr->v6.sin6_port = htons(asoc->peer.port);
 			memcpy(&daddr->v6.sin6_addr, CMSG_DATA(cmsg), dlen);
 		}
-		err = sctp_verify_addr(sk, daddr, sizeof(*daddr));
-		if (err)
-			goto free;
-
-		old = sctp_endpoint_lookup_assoc(ep, daddr, &transport);
-		if (old && old != asoc) {
-			if (old->state >= SCTP_STATE_ESTABLISHED)
-				err = -EISCONN;
-			else
-				err = -EALREADY;
-			goto free;
-		}
 
-		if (sctp_endpoint_is_peeled_off(ep, daddr)) {
-			err = -EADDRNOTAVAIL;
-			goto free;
-		}
-
-		transport = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL,
-						SCTP_UNKNOWN);
-		if (!transport) {
-			err = -ENOMEM;
+		err = sctp_connect_add_peer(asoc, daddr, sizeof(*daddr));
+		if (err)
 			goto free;
-		}
 	}
 
 	return 0;
-- 
2.1.0
