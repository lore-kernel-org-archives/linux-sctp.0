From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 24 Dec 2013 13:19:41 +0000
Subject: [RFC PATCH net-next 1/3] net: sock: introduce sock_sanitize
Message-Id: <1387891183-21169-2-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Refactor initialization of socket fields after sock_copy() into its
own function, so that it can be used elsewhere.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 net/core/sock.c | 194 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 102 insertions(+), 92 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 5393b4b..68a4251 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1231,6 +1231,104 @@ static void sock_copy(struct sock *nsk, const struct sock *osk)
 #endif
 }
 
+static void sk_update_clone(const struct sock *sk, struct sock *newsk)
+{
+	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
+		sock_update_memcg(newsk);
+}
+
+/* After going through a rough flat copy of socket fields through sock_copy(),
+ * make it pretty again, so that we have necessary fields properly initialized.
+ */
+static struct sock *sock_sanitize(struct sock *newsk, const struct sock *sk)
+{
+	struct sk_filter *filter;
+
+	get_net(sock_net(newsk));
+
+	sk_node_init(&newsk->sk_node);
+	sock_lock_init(newsk);
+	bh_lock_sock(newsk);
+
+	newsk->sk_backlog.head	= newsk->sk_backlog.tail = NULL;
+	newsk->sk_backlog.len = 0;
+
+	atomic_set(&newsk->sk_rmem_alloc, 0);
+	/*
+	 * sk_wmem_alloc set to one (see sk_free() and sock_wfree())
+	 */
+	atomic_set(&newsk->sk_wmem_alloc, 1);
+	atomic_set(&newsk->sk_omem_alloc, 0);
+
+	skb_queue_head_init(&newsk->sk_receive_queue);
+	skb_queue_head_init(&newsk->sk_write_queue);
+#ifdef CONFIG_NET_DMA
+	skb_queue_head_init(&newsk->sk_async_wait_queue);
+#endif
+
+	spin_lock_init(&newsk->sk_dst_lock);
+	rwlock_init(&newsk->sk_callback_lock);
+	lockdep_set_class_and_name(&newsk->sk_callback_lock,
+				   af_callback_keys + newsk->sk_family,
+				   af_family_clock_key_strings[newsk->sk_family]);
+
+	newsk->sk_dst_cache	= NULL;
+	newsk->sk_wmem_queued	= 0;
+	newsk->sk_forward_alloc = 0;
+	newsk->sk_send_head	= NULL;
+	newsk->sk_userlocks	= sk->sk_userlocks & ~SOCK_BINDPORT_LOCK;
+
+	sock_reset_flag(newsk, SOCK_DONE);
+	skb_queue_head_init(&newsk->sk_error_queue);
+
+	filter = rcu_dereference_protected(newsk->sk_filter, 1);
+	if (filter != NULL)
+		sk_filter_charge(newsk, filter);
+
+	if (unlikely(xfrm_sk_clone_policy(newsk))) {
+		/* It is still raw copy of parent, so invalidate
+		 * destructor and make plain sk_free() */
+		newsk->sk_destruct = NULL;
+		bh_unlock_sock(newsk);
+		sk_free(newsk);
+		return NULL;
+	}
+
+	newsk->sk_err	   = 0;
+	newsk->sk_priority = 0;
+	/*
+	 * Before updating sk_refcnt, we must commit prior changes to memory
+	 * (Documentation/RCU/rculist_nulls.txt for details)
+	 */
+	smp_wmb();
+	atomic_set(&newsk->sk_refcnt, 2);
+
+	/*
+	 * Increment the counter in the same struct proto as the master
+	 * sock (sk_refcnt_debug_inc uses newsk->sk_prot->socks, that
+	 * is the same as sk->sk_prot->socks, as this field was copied
+	 * with memcpy).
+	 *
+	 * This _changes_ the previous behaviour, where
+	 * tcp_create_openreq_child always was incrementing the
+	 * equivalent to tcp_prot->socks (inet_sock_nr), so this have
+	 * to be taken into account in all callers. -acme
+	 */
+	sk_refcnt_debug_inc(newsk);
+	sk_set_socket(newsk, NULL);
+	newsk->sk_wq = NULL;
+
+	sk_update_clone(sk, newsk);
+
+	if (newsk->sk_prot->sockets_allocated)
+		sk_sockets_allocated_inc(newsk);
+
+	if (newsk->sk_flags & SK_FLAGS_TIMESTAMP)
+		net_enable_timestamp();
+
+	return newsk;
+}
+
 void sk_prot_clear_portaddr_nulls(struct sock *sk, int size)
 {
 	unsigned long nulls1, nulls2;
@@ -1422,12 +1520,6 @@ void sk_release_kernel(struct sock *sk)
 }
 EXPORT_SYMBOL(sk_release_kernel);
 
-static void sk_update_clone(const struct sock *sk, struct sock *newsk)
-{
-	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
-		sock_update_memcg(newsk);
-}
-
 /**
  *	sk_clone_lock - clone a socket, and lock its clone
  *	@sk: the socket to clone
@@ -1440,94 +1532,12 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 	struct sock *newsk;
 
 	newsk = sk_prot_alloc(sk->sk_prot, priority, sk->sk_family);
-	if (newsk != NULL) {
-		struct sk_filter *filter;
-
-		sock_copy(newsk, sk);
-
-		/* SANITY */
-		get_net(sock_net(newsk));
-		sk_node_init(&newsk->sk_node);
-		sock_lock_init(newsk);
-		bh_lock_sock(newsk);
-		newsk->sk_backlog.head	= newsk->sk_backlog.tail = NULL;
-		newsk->sk_backlog.len = 0;
-
-		atomic_set(&newsk->sk_rmem_alloc, 0);
-		/*
-		 * sk_wmem_alloc set to one (see sk_free() and sock_wfree())
-		 */
-		atomic_set(&newsk->sk_wmem_alloc, 1);
-		atomic_set(&newsk->sk_omem_alloc, 0);
-		skb_queue_head_init(&newsk->sk_receive_queue);
-		skb_queue_head_init(&newsk->sk_write_queue);
-#ifdef CONFIG_NET_DMA
-		skb_queue_head_init(&newsk->sk_async_wait_queue);
-#endif
-
-		spin_lock_init(&newsk->sk_dst_lock);
-		rwlock_init(&newsk->sk_callback_lock);
-		lockdep_set_class_and_name(&newsk->sk_callback_lock,
-				af_callback_keys + newsk->sk_family,
-				af_family_clock_key_strings[newsk->sk_family]);
-
-		newsk->sk_dst_cache	= NULL;
-		newsk->sk_wmem_queued	= 0;
-		newsk->sk_forward_alloc = 0;
-		newsk->sk_send_head	= NULL;
-		newsk->sk_userlocks	= sk->sk_userlocks & ~SOCK_BINDPORT_LOCK;
-
-		sock_reset_flag(newsk, SOCK_DONE);
-		skb_queue_head_init(&newsk->sk_error_queue);
-
-		filter = rcu_dereference_protected(newsk->sk_filter, 1);
-		if (filter != NULL)
-			sk_filter_charge(newsk, filter);
-
-		if (unlikely(xfrm_sk_clone_policy(newsk))) {
-			/* It is still raw copy of parent, so invalidate
-			 * destructor and make plain sk_free() */
-			newsk->sk_destruct = NULL;
-			bh_unlock_sock(newsk);
-			sk_free(newsk);
-			newsk = NULL;
-			goto out;
-		}
-
-		newsk->sk_err	   = 0;
-		newsk->sk_priority = 0;
-		/*
-		 * Before updating sk_refcnt, we must commit prior changes to memory
-		 * (Documentation/RCU/rculist_nulls.txt for details)
-		 */
-		smp_wmb();
-		atomic_set(&newsk->sk_refcnt, 2);
-
-		/*
-		 * Increment the counter in the same struct proto as the master
-		 * sock (sk_refcnt_debug_inc uses newsk->sk_prot->socks, that
-		 * is the same as sk->sk_prot->socks, as this field was copied
-		 * with memcpy).
-		 *
-		 * This _changes_ the previous behaviour, where
-		 * tcp_create_openreq_child always was incrementing the
-		 * equivalent to tcp_prot->socks (inet_sock_nr), so this have
-		 * to be taken into account in all callers. -acme
-		 */
-		sk_refcnt_debug_inc(newsk);
-		sk_set_socket(newsk, NULL);
-		newsk->sk_wq = NULL;
-
-		sk_update_clone(sk, newsk);
+	if (newsk = NULL)
+		return NULL;
 
-		if (newsk->sk_prot->sockets_allocated)
-			sk_sockets_allocated_inc(newsk);
+	sock_copy(newsk, sk);
 
-		if (newsk->sk_flags & SK_FLAGS_TIMESTAMP)
-			net_enable_timestamp();
-	}
-out:
-	return newsk;
+	return sock_sanitize(newsk, sk);
 }
 EXPORT_SYMBOL_GPL(sk_clone_lock);
 
-- 
1.8.3.1

