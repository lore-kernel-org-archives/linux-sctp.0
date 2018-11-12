From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 12 Nov 2018 10:27:15 +0000
Subject: [PATCHv2 net-next 1/3] sctp: do reuseport_select_sock in __sctp_rcv_lookup_endpoint
Message-Id: <51f701b95b1c2cecdc53f1ad518a2011b43d7621.1542018324.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1542018324.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1542018324.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This is a part of sk_reuseport support for sctp, and it selects a
sock by the hashkey of lport, paddr and dport by default. It will
work until sk_reuseport support is added in sctp_get_port_local()
in the next patch.

v1->v2:
  - define lport as __be16 instead of __be32 as Marcelo pointed in
    __sctp_rcv_lookup_endpoint().

Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/input.c | 69 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 41 insertions(+), 28 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 7ab08a5..00f995e 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -57,6 +57,7 @@
 #include <net/sctp/checksum.h>
 #include <net/net_namespace.h>
 #include <linux/rhashtable.h>
+#include <net/sock_reuseport.h>
 
 /* Forward declarations for internal helpers. */
 static int sctp_rcv_ootb(struct sk_buff *);
@@ -65,8 +66,10 @@ static struct sctp_association *__sctp_rcv_lookup(struct net *net,
 				      const union sctp_addr *paddr,
 				      const union sctp_addr *laddr,
 				      struct sctp_transport **transportp);
-static struct sctp_endpoint *__sctp_rcv_lookup_endpoint(struct net *net,
-						const union sctp_addr *laddr);
+static struct sctp_endpoint *__sctp_rcv_lookup_endpoint(
+					struct net *net, struct sk_buff *skb,
+					const union sctp_addr *laddr,
+					const union sctp_addr *daddr);
 static struct sctp_association *__sctp_lookup_association(
 					struct net *net,
 					const union sctp_addr *local,
@@ -171,7 +174,7 @@ int sctp_rcv(struct sk_buff *skb)
 	asoc = __sctp_rcv_lookup(net, skb, &src, &dest, &transport);
 
 	if (!asoc)
-		ep = __sctp_rcv_lookup_endpoint(net, &dest);
+		ep = __sctp_rcv_lookup_endpoint(net, skb, &dest, &src);
 
 	/* Retrieve the common input handling substructure. */
 	rcvr = asoc ? &asoc->base : &ep->base;
@@ -771,16 +774,35 @@ void sctp_unhash_endpoint(struct sctp_endpoint *ep)
 	local_bh_enable();
 }
 
+static inline __u32 sctp_hashfn(const struct net *net, __be16 lport,
+				const union sctp_addr *paddr, __u32 seed)
+{
+	__u32 addr;
+
+	if (paddr->sa.sa_family = AF_INET6)
+		addr = jhash(&paddr->v6.sin6_addr, 16, seed);
+	else
+		addr = (__force __u32)paddr->v4.sin_addr.s_addr;
+
+	return  jhash_3words(addr, ((__force __u32)paddr->v4.sin_port) << 16 |
+			     (__force __u32)lport, net_hash_mix(net), seed);
+}
+
 /* Look up an endpoint. */
-static struct sctp_endpoint *__sctp_rcv_lookup_endpoint(struct net *net,
-						const union sctp_addr *laddr)
+static struct sctp_endpoint *__sctp_rcv_lookup_endpoint(
+					struct net *net, struct sk_buff *skb,
+					const union sctp_addr *laddr,
+					const union sctp_addr *paddr)
 {
 	struct sctp_hashbucket *head;
 	struct sctp_ep_common *epb;
 	struct sctp_endpoint *ep;
+	struct sock *sk;
+	__be16 lport;
 	int hash;
 
-	hash = sctp_ep_hashfn(net, ntohs(laddr->v4.sin_port));
+	lport = laddr->v4.sin_port;
+	hash = sctp_ep_hashfn(net, ntohs(lport));
 	head = &sctp_ep_hashtable[hash];
 	read_lock(&head->lock);
 	sctp_for_each_hentry(epb, &head->chain) {
@@ -792,6 +814,15 @@ static struct sctp_endpoint *__sctp_rcv_lookup_endpoint(struct net *net,
 	ep = sctp_sk(net->sctp.ctl_sock)->ep;
 
 hit:
+	sk = ep->base.sk;
+	if (sk->sk_reuseport) {
+		__u32 phash = sctp_hashfn(net, lport, paddr, 0);
+
+		sk = reuseport_select_sock(sk, phash, skb,
+					   sizeof(struct sctphdr));
+		if (sk)
+			ep = sctp_sk(sk)->ep;
+	}
 	sctp_endpoint_hold(ep);
 	read_unlock(&head->lock);
 	return ep;
@@ -830,35 +861,17 @@ static inline int sctp_hash_cmp(struct rhashtable_compare_arg *arg,
 static inline __u32 sctp_hash_obj(const void *data, u32 len, u32 seed)
 {
 	const struct sctp_transport *t = data;
-	const union sctp_addr *paddr = &t->ipaddr;
-	const struct net *net = sock_net(t->asoc->base.sk);
-	__be16 lport = htons(t->asoc->base.bind_addr.port);
-	__u32 addr;
-
-	if (paddr->sa.sa_family = AF_INET6)
-		addr = jhash(&paddr->v6.sin6_addr, 16, seed);
-	else
-		addr = (__force __u32)paddr->v4.sin_addr.s_addr;
 
-	return  jhash_3words(addr, ((__force __u32)paddr->v4.sin_port) << 16 |
-			     (__force __u32)lport, net_hash_mix(net), seed);
+	return sctp_hashfn(sock_net(t->asoc->base.sk),
+			   htons(t->asoc->base.bind_addr.port),
+			   &t->ipaddr, seed);
 }
 
 static inline __u32 sctp_hash_key(const void *data, u32 len, u32 seed)
 {
 	const struct sctp_hash_cmp_arg *x = data;
-	const union sctp_addr *paddr = x->paddr;
-	const struct net *net = x->net;
-	__be16 lport = x->lport;
-	__u32 addr;
-
-	if (paddr->sa.sa_family = AF_INET6)
-		addr = jhash(&paddr->v6.sin6_addr, 16, seed);
-	else
-		addr = (__force __u32)paddr->v4.sin_addr.s_addr;
 
-	return  jhash_3words(addr, ((__force __u32)paddr->v4.sin_port) << 16 |
-			     (__force __u32)lport, net_hash_mix(net), seed);
+	return sctp_hashfn(x->net, x->lport, x->paddr, seed);
 }
 
 static const struct rhashtable_params sctp_hash_params = {
-- 
2.1.0
