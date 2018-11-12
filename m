From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 12 Nov 2018 10:27:16 +0000
Subject: [PATCHv2 net-next 2/3] sctp: add sock_reuseport for the sock in __sctp_hash_endpoint
Message-Id: <85a05853d769b272da4a365888ff1c2f2715f8a9.1542018324.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1542018324.git.lucien.xin@gmail.com>
 <51f701b95b1c2cecdc53f1ad518a2011b43d7621.1542018324.git.lucien.xin@gmail.com>
In-Reply-To: <51f701b95b1c2cecdc53f1ad518a2011b43d7621.1542018324.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This is a part of sk_reuseport support for sctp. It defines a helper
sctp_bind_addrs_check() to check if the bind_addrs in two socks are
matched. It will add sock_reuseport if they are completely matched,
and return err if they are partly matched, and alloc sock_reuseport
if all socks are not matched at all.

It will work until sk_reuseport support is added in
sctp_get_port_local() in the next patch.

v1->v2:
  - use 'laddr->valid && laddr2->valid' check instead as Marcelo
    pointed in sctp_bind_addrs_check().

Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/sctp.h    |  2 +-
 include/net/sctp/structs.h |  2 ++
 net/core/sock_reuseport.c  |  1 +
 net/sctp/bind_addr.c       | 28 ++++++++++++++++++++++
 net/sctp/input.c           | 60 +++++++++++++++++++++++++++++++++++++++-------
 net/sctp/socket.c          |  3 +--
 6 files changed, 85 insertions(+), 11 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 9a3b48a..cdf2e80 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -152,7 +152,7 @@ int sctp_primitive_RECONF(struct net *net, struct sctp_association *asoc,
  */
 int sctp_rcv(struct sk_buff *skb);
 int sctp_v4_err(struct sk_buff *skb, u32 info);
-void sctp_hash_endpoint(struct sctp_endpoint *);
+int sctp_hash_endpoint(struct sctp_endpoint *ep);
 void sctp_unhash_endpoint(struct sctp_endpoint *);
 struct sock *sctp_err_lookup(struct net *net, int family, struct sk_buff *,
 			     struct sctphdr *, struct sctp_association **,
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index a11f937..15d017f 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1190,6 +1190,8 @@ int sctp_bind_addr_conflict(struct sctp_bind_addr *, const union sctp_addr *,
 			 struct sctp_sock *, struct sctp_sock *);
 int sctp_bind_addr_state(const struct sctp_bind_addr *bp,
 			 const union sctp_addr *addr);
+int sctp_bind_addrs_check(struct sctp_sock *sp,
+			  struct sctp_sock *sp2, int cnt2);
 union sctp_addr *sctp_find_unmatch_addr(struct sctp_bind_addr	*bp,
 					const union sctp_addr	*addrs,
 					int			addrcnt,
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index ba5cba5..d8fe3e5 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -187,6 +187,7 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
 		call_rcu(&old_reuse->rcu, reuseport_free_rcu);
 	return 0;
 }
+EXPORT_SYMBOL(reuseport_add_sock);
 
 void reuseport_detach_sock(struct sock *sk)
 {
diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index 7df3704..ebf28ad 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -337,6 +337,34 @@ int sctp_bind_addr_match(struct sctp_bind_addr *bp,
 	return match;
 }
 
+int sctp_bind_addrs_check(struct sctp_sock *sp,
+			  struct sctp_sock *sp2, int cnt2)
+{
+	struct sctp_bind_addr *bp2 = &sp2->ep->base.bind_addr;
+	struct sctp_bind_addr *bp = &sp->ep->base.bind_addr;
+	struct sctp_sockaddr_entry *laddr, *laddr2;
+	bool exist = false;
+	int cnt = 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(laddr, &bp->address_list, list) {
+		list_for_each_entry_rcu(laddr2, &bp2->address_list, list) {
+			if (sp->pf->af->cmp_addr(&laddr->a, &laddr2->a) &&
+			    laddr->valid && laddr2->valid) {
+				exist = true;
+				goto next;
+			}
+		}
+		cnt = 0;
+		break;
+next:
+		cnt++;
+	}
+	rcu_read_unlock();
+
+	return (cnt = cnt2) ? 0 : (exist ? -EEXIST : 1);
+}
+
 /* Does the address 'addr' conflict with any addresses in
  * the bp.
  */
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 00f995e..d7a649d 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -724,43 +724,87 @@ static int sctp_rcv_ootb(struct sk_buff *skb)
 }
 
 /* Insert endpoint into the hash table.  */
-static void __sctp_hash_endpoint(struct sctp_endpoint *ep)
+static int __sctp_hash_endpoint(struct sctp_endpoint *ep)
 {
-	struct net *net = sock_net(ep->base.sk);
-	struct sctp_ep_common *epb;
+	struct sock *sk = ep->base.sk;
+	struct net *net = sock_net(sk);
 	struct sctp_hashbucket *head;
+	struct sctp_ep_common *epb;
 
 	epb = &ep->base;
-
 	epb->hashent = sctp_ep_hashfn(net, epb->bind_addr.port);
 	head = &sctp_ep_hashtable[epb->hashent];
 
+	if (sk->sk_reuseport) {
+		bool any = sctp_is_ep_boundall(sk);
+		struct sctp_ep_common *epb2;
+		struct list_head *list;
+		int cnt = 0, err = 1;
+
+		list_for_each(list, &ep->base.bind_addr.address_list)
+			cnt++;
+
+		sctp_for_each_hentry(epb2, &head->chain) {
+			struct sock *sk2 = epb2->sk;
+
+			if (!net_eq(sock_net(sk2), net) || sk2 = sk ||
+			    !uid_eq(sock_i_uid(sk2), sock_i_uid(sk)) ||
+			    !sk2->sk_reuseport)
+				continue;
+
+			err = sctp_bind_addrs_check(sctp_sk(sk2),
+						    sctp_sk(sk), cnt);
+			if (!err) {
+				err = reuseport_add_sock(sk, sk2, any);
+				if (err)
+					return err;
+				break;
+			} else if (err < 0) {
+				return err;
+			}
+		}
+
+		if (err) {
+			err = reuseport_alloc(sk, any);
+			if (err)
+				return err;
+		}
+	}
+
 	write_lock(&head->lock);
 	hlist_add_head(&epb->node, &head->chain);
 	write_unlock(&head->lock);
+	return 0;
 }
 
 /* Add an endpoint to the hash. Local BH-safe. */
-void sctp_hash_endpoint(struct sctp_endpoint *ep)
+int sctp_hash_endpoint(struct sctp_endpoint *ep)
 {
+	int err;
+
 	local_bh_disable();
-	__sctp_hash_endpoint(ep);
+	err = __sctp_hash_endpoint(ep);
 	local_bh_enable();
+
+	return err;
 }
 
 /* Remove endpoint from the hash table.  */
 static void __sctp_unhash_endpoint(struct sctp_endpoint *ep)
 {
-	struct net *net = sock_net(ep->base.sk);
+	struct sock *sk = ep->base.sk;
 	struct sctp_hashbucket *head;
 	struct sctp_ep_common *epb;
 
 	epb = &ep->base;
 
-	epb->hashent = sctp_ep_hashfn(net, epb->bind_addr.port);
+	epb->hashent = sctp_ep_hashfn(sock_net(sk), epb->bind_addr.port);
 
 	head = &sctp_ep_hashtable[epb->hashent];
 
+	if (rcu_access_pointer(sk->sk_reuseport_cb))
+		reuseport_detach_sock(sk);
+
 	write_lock(&head->lock);
 	hlist_del_init(&epb->node);
 	write_unlock(&head->lock);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 739f3e5..2e955f1 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7852,8 +7852,7 @@ static int sctp_listen_start(struct sock *sk, int backlog)
 	}
 
 	sk->sk_max_ack_backlog = backlog;
-	sctp_hash_endpoint(ep);
-	return 0;
+	return sctp_hash_endpoint(ep);
 }
 
 /*
-- 
2.1.0
