From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 24 Dec 2013 13:19:43 +0000
Subject: [RFC PATCH 3/3] net: sctp: use sk_copy_sanitize for accept sockets
Message-Id: <1387891183-21169-4-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wang reported an issue that lksctp's test_getname_v6 seems to fail.

The issue is that we do not copy sk_v6_rcv_saddr over to the new
socket, although the comment above says so regarding rcv_saddr.

Commit 914e1c8b6980 ("sctp: Inherit all socket options from parent
correctly.") originally moved that over to sctp_copy_sock(), but
after commit efe4208f47f9 ("ipv6: make lookups simpler and faster")
this no longer holds and the actual value of sk_v6_rcv_saddr was
no longer being migrated.

The issue seems to be deeper than that though. We always used to
do a partial copy of socket members in accept/peeloff case. This
means that also newly added members to the kernel's socket
representation weren't inherited to spawned sockets, for example,
Eric points out that settings of SO_MAX_PACING_RATE would be broken
on SCTP as well.

So lets get rid of this restriction by using sk_copy_sanitize().
With this patch, the lksctp test suite also passes again for IPv6.

Fixes: efe4208f47f9 ("ipv6: make lookups simpler and faster")
Reported-by: Wang Weidong <wangweidong1@huawei.com>
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Not-yet-signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 include/net/sctp/sctp.h |   4 +-
 net/sctp/ipv6.c         |  11 +++---
 net/sctp/protocol.c     |  13 +++---
 net/sctp/socket.c       | 102 +++++++++++++++++++++++++++++-------------------
 4 files changed, 75 insertions(+), 55 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 610a8c8..8422bb5 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -105,8 +105,8 @@ void sctp_data_ready(struct sock *sk, int len);
 unsigned int sctp_poll(struct file *file, struct socket *sock,
 		poll_table *wait);
 void sctp_sock_rfree(struct sk_buff *skb);
-void sctp_copy_sock(struct sock *newsk, struct sock *sk,
-		    struct sctp_association *asoc);
+struct sock *sctp_clone_lock(const struct sock *sk, const gfp_t priority,
+			     struct sctp_association *asoc);
 extern struct percpu_counter sctp_sockets_allocated;
 int sctp_asconf_mgmt(struct sctp_sock *, struct sctp_sockaddr_entry *);
 
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 14191ab..27879c5 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -639,13 +639,10 @@ static struct sock *sctp_v6_create_accept_sk(struct sock *sk,
 	struct ipv6_pinfo *newnp, *np = inet6_sk(sk);
 	struct sctp6_sock *newsctp6sk;
 
-	newsk = sk_alloc(sock_net(sk), PF_INET6, GFP_KERNEL, sk->sk_prot);
+	newsk = sctp_clone_lock(sk, GFP_KERNEL, asoc);
 	if (!newsk)
 		goto out;
 
-	sock_init_data(NULL, newsk);
-
-	sctp_copy_sock(newsk, sk, asoc);
 	sock_reset_flag(sk, SOCK_ZAPPED);
 
 	newsctp6sk = (struct sctp6_sock *)newsk;
@@ -654,7 +651,6 @@ static struct sock *sctp_v6_create_accept_sk(struct sock *sk,
 	sctp_sk(newsk)->v4mapped = sctp_sk(sk)->v4mapped;
 
 	newnp = inet6_sk(newsk);
-
 	memcpy(newnp, np, sizeof(struct ipv6_pinfo));
 
 	/* Initialize sk's sport, dport, rcv_saddr and daddr for getsockname()
@@ -668,8 +664,11 @@ static struct sock *sctp_v6_create_accept_sk(struct sock *sk,
 		sk_common_release(newsk);
 		newsk = NULL;
 	}
-
 out:
+	if (newsk) {
+		bh_unlock_sock(newsk);
+		sock_put(newsk);
+	}
 	return newsk;
 }
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 19bd4c5..1058a77 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -544,20 +544,16 @@ static int sctp_v4_is_ce(const struct sk_buff *skb)
 static struct sock *sctp_v4_create_accept_sk(struct sock *sk,
 					     struct sctp_association *asoc)
 {
-	struct sock *newsk = sk_alloc(sock_net(sk), PF_INET, GFP_KERNEL,
-			sk->sk_prot);
+	struct sock *newsk;
 	struct inet_sock *newinet;
 
+	newsk = sctp_clone_lock(sk, GFP_KERNEL, asoc);
 	if (!newsk)
 		goto out;
 
-	sock_init_data(NULL, newsk);
-
-	sctp_copy_sock(newsk, sk, asoc);
 	sock_reset_flag(newsk, SOCK_ZAPPED);
 
 	newinet = inet_sk(newsk);
-
 	newinet->inet_daddr = asoc->peer.primary_addr.v4.sin_addr.s_addr;
 
 	sk_refcnt_debug_inc(newsk);
@@ -566,8 +562,11 @@ static struct sock *sctp_v4_create_accept_sk(struct sock *sk,
 		sk_common_release(newsk);
 		newsk = NULL;
 	}
-
 out:
+	if (newsk) {
+		bh_unlock_sock(newsk);
+		sock_put(newsk);
+	}
 	return newsk;
 }
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index d39fd0c..3a6eb04 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4269,17 +4269,17 @@ static int sctp_getsockopt_autoclose(struct sock *sk, int len, char __user *optv
 int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
 {
 	struct sctp_association *asoc = sctp_id2assoc(sk, id);
+	struct inet_sock *inet = inet_sk(sk);
 	struct socket *sock;
+	struct sock *newsk;
+	struct inet_sock *newinet;
 	struct sctp_af *af;
 	int err = 0;
 
-	if (!asoc)
-		return -EINVAL;
-
 	/* An association cannot be branched off from an already peeled-off
 	 * socket, nor is this supported for tcp style sockets.
 	 */
-	if (!sctp_style(sk, UDP))
+	if (!asoc || !sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Create a new socket.  */
@@ -4287,7 +4287,44 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
 	if (err < 0)
 		return err;
 
-	sctp_copy_sock(sock->sk, sk, asoc);
+	newsk = sock->sk;
+
+	newsk->sk_type = sk->sk_type;
+	newsk->sk_bound_dev_if = sk->sk_bound_dev_if;
+	newsk->sk_flags = sk->sk_flags;
+	newsk->sk_no_check = sk->sk_no_check;
+	newsk->sk_reuse = sk->sk_reuse;
+
+	newsk->sk_shutdown = sk->sk_shutdown;
+	newsk->sk_destruct = sctp_destruct_sock;
+	newsk->sk_family = sk->sk_family;
+	newsk->sk_protocol = IPPROTO_SCTP;
+	newsk->sk_backlog_rcv = sk->sk_prot->backlog_rcv;
+	newsk->sk_sndbuf = sk->sk_sndbuf;
+	newsk->sk_rcvbuf = sk->sk_rcvbuf;
+	newsk->sk_lingertime = sk->sk_lingertime;
+	newsk->sk_rcvtimeo = sk->sk_rcvtimeo;
+	newsk->sk_sndtimeo = sk->sk_sndtimeo;
+
+	newinet = inet_sk(newsk);
+
+	/* Initialize sk's sport, dport, rcv_saddr and daddr for
+	 * getsockname() and getpeername()
+	 */
+	newinet->inet_sport = inet->inet_sport;
+	newinet->inet_saddr = inet->inet_saddr;
+	newinet->inet_rcv_saddr = inet->inet_rcv_saddr;
+	newinet->inet_dport = htons(asoc->peer.port);
+	newinet->pmtudisc = inet->pmtudisc;
+	newinet->inet_id = asoc->next_tsn ^ jiffies;
+
+	newinet->uc_ttl = inet->uc_ttl;
+	newinet->mc_loop = 1;
+	newinet->mc_ttl = 1;
+	newinet->mc_index = 0;
+	newinet->mc_list = NULL;
+
+//XXX	sctp_copy_sock(sock->sk, sk, asoc);
 
 	/* Make peeled-off sockets more like 1-1 accepted sockets.
 	 * Set the daddr and initialize id to something more random
@@ -6850,46 +6887,31 @@ done:
 	sctp_skb_set_owner_r(skb, sk);
 }
 
-void sctp_copy_sock(struct sock *newsk, struct sock *sk,
-		    struct sctp_association *asoc)
+struct sock *sctp_clone_lock(const struct sock *sk, const gfp_t priority,
+			     struct sctp_association *asoc)
 {
-	struct inet_sock *inet = inet_sk(sk);
-	struct inet_sock *newinet;
+	struct sock *newsk;
 
-	newsk->sk_type = sk->sk_type;
-	newsk->sk_bound_dev_if = sk->sk_bound_dev_if;
-	newsk->sk_flags = sk->sk_flags;
-	newsk->sk_no_check = sk->sk_no_check;
-	newsk->sk_reuse = sk->sk_reuse;
-
-	newsk->sk_shutdown = sk->sk_shutdown;
-	newsk->sk_destruct = sctp_destruct_sock;
-	newsk->sk_family = sk->sk_family;
-	newsk->sk_protocol = IPPROTO_SCTP;
-	newsk->sk_backlog_rcv = sk->sk_prot->backlog_rcv;
-	newsk->sk_sndbuf = sk->sk_sndbuf;
-	newsk->sk_rcvbuf = sk->sk_rcvbuf;
-	newsk->sk_lingertime = sk->sk_lingertime;
-	newsk->sk_rcvtimeo = sk->sk_rcvtimeo;
-	newsk->sk_sndtimeo = sk->sk_sndtimeo;
+	newsk = sk_clone_lock(sk, priority);
+	if (newsk != NULL) {
+		struct inet_sock *newinet = inet_sk(newsk);
+		struct inet_sock *inet = inet_sk(sk);
 
-	newinet = inet_sk(newsk);
+		newinet->inet_sport = inet->inet_sport;
+		newinet->inet_saddr = inet->inet_saddr;
+		newinet->inet_rcv_saddr = inet->inet_rcv_saddr;
+		newinet->inet_dport = htons(asoc->peer.port);
+		newinet->pmtudisc = inet->pmtudisc;
+		newinet->inet_id = asoc->next_tsn ^ jiffies;
 
-	/* Initialize sk's sport, dport, rcv_saddr and daddr for
-	 * getsockname() and getpeername()
-	 */
-	newinet->inet_sport = inet->inet_sport;
-	newinet->inet_saddr = inet->inet_saddr;
-	newinet->inet_rcv_saddr = inet->inet_rcv_saddr;
-	newinet->inet_dport = htons(asoc->peer.port);
-	newinet->pmtudisc = inet->pmtudisc;
-	newinet->inet_id = asoc->next_tsn ^ jiffies;
+		newinet->uc_ttl = inet->uc_ttl;
+		newinet->mc_loop = 1;
+		newinet->mc_ttl = 1;
+		newinet->mc_index = 0;
+		newinet->mc_list = NULL;
+	}
 
-	newinet->uc_ttl = inet->uc_ttl;
-	newinet->mc_loop = 1;
-	newinet->mc_ttl = 1;
-	newinet->mc_index = 0;
-	newinet->mc_list = NULL;
+	return newsk;
 }
 
 /* Populate the fields of the newsk from the oldsk and migrate the assoc
-- 
1.8.3.1

