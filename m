From: Richard Haines <richard_c_haines@btinternet.com>
Date: Tue, 13 Feb 2018 20:54:44 +0000
Subject: [PATCH V6 2/4] sctp: Add ip option support
Message-Id: <20180213205444.4559-1-richard_c_haines@btinternet.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-security-module@vger.kernel.org

Add ip option support to allow LSM security modules to utilise CIPSO/IPv4
and CALIPSO/IPv6 services.

Signed-off-by: Richard Haines <richard_c_haines@btinternet.com>
---
 include/net/sctp/sctp.h    |  4 +++-
 include/net/sctp/structs.h |  2 ++
 net/sctp/chunk.c           | 12 +++++++-----
 net/sctp/ipv6.c            | 42 +++++++++++++++++++++++++++++++++++-------
 net/sctp/output.c          |  5 ++++-
 net/sctp/protocol.c        | 36 ++++++++++++++++++++++++++++++++++++
 net/sctp/socket.c          | 14 ++++++++++----
 7 files changed, 97 insertions(+), 18 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index f7ae6b0..25c5c87 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -441,9 +441,11 @@ static inline int sctp_list_single_entry(struct list_head *head)
 static inline int sctp_frag_point(const struct sctp_association *asoc, int pmtu)
 {
 	struct sctp_sock *sp = sctp_sk(asoc->base.sk);
+	struct sctp_af *af = sp->pf->af;
 	int frag = pmtu;
 
-	frag -= sp->pf->af->net_header_len;
+	frag -= af->ip_options_len(asoc->base.sk);
+	frag -= af->net_header_len;
 	frag -= sizeof(struct sctphdr) + sctp_datachk_len(&asoc->stream);
 
 	if (asoc->user_frag)
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 03e92dd..ead5fce 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -491,6 +491,7 @@ struct sctp_af {
 	void		(*ecn_capable)(struct sock *sk);
 	__u16		net_header_len;
 	int		sockaddr_len;
+	int		(*ip_options_len)(struct sock *sk);
 	sa_family_t	sa_family;
 	struct list_head list;
 };
@@ -515,6 +516,7 @@ struct sctp_pf {
 	int (*addr_to_user)(struct sctp_sock *sk, union sctp_addr *addr);
 	void (*to_sk_saddr)(union sctp_addr *, struct sock *sk);
 	void (*to_sk_daddr)(union sctp_addr *, struct sock *sk);
+	void (*copy_ip_options)(struct sock *sk, struct sock *newsk);
 	struct sctp_af *af;
 };
 
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index 991a530..d5c0ef7 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -154,7 +154,6 @@ static void sctp_datamsg_assign(struct sctp_datamsg *msg, struct sctp_chunk *chu
 	chunk->msg = msg;
 }
 
-
 /* A data chunk can have a maximum payload of (2^16 - 20).  Break
  * down any such message into smaller chunks.  Opportunistically, fragment
  * the chunks down to the current MTU constraints.  We may get refragmented
@@ -171,6 +170,8 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 	struct list_head *pos, *temp;
 	struct sctp_chunk *chunk;
 	struct sctp_datamsg *msg;
+	struct sctp_sock *sp;
+	struct sctp_af *af;
 	int err;
 
 	msg = sctp_datamsg_new(GFP_KERNEL);
@@ -189,9 +190,11 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 	/* This is the biggest possible DATA chunk that can fit into
 	 * the packet
 	 */
-	max_data = asoc->pathmtu -
-		   sctp_sk(asoc->base.sk)->pf->af->net_header_len -
-		   sizeof(struct sctphdr) - sctp_datachk_len(&asoc->stream);
+	sp = sctp_sk(asoc->base.sk);
+	af = sp->pf->af;
+	max_data = asoc->pathmtu - af->net_header_len -
+		   sizeof(struct sctphdr) - sctp_datachk_len(&asoc->stream) -
+		   af->ip_options_len(asoc->base.sk);
 	max_data = SCTP_TRUNC4(max_data);
 
 	/* If the the peer requested that we authenticate DATA chunks
@@ -211,7 +214,6 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 
 	/* Set first_len and then account for possible bundles on first frag */
 	first_len = max_data;
-
 	/* Check to see if we have a pending SACK and try to let it be bundled
 	 * with this message.  Do this if we don't have any data queued already.
 	 * To check that, look at out_qlen and retransmit list.
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index e35d4f7..0b0f895 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -427,6 +427,38 @@ static void sctp_v6_copy_addrlist(struct list_head *addrlist,
 	rcu_read_unlock();
 }
 
+/* Copy over any ip options */
+static void sctp_v6_copy_ip_options(struct sock *sk, struct sock *newsk)
+{
+	struct ipv6_pinfo *newnp, *np = inet6_sk(sk);
+	struct ipv6_txoptions *opt;
+
+	newnp = inet6_sk(newsk);
+
+	rcu_read_lock();
+	opt = rcu_dereference(np->opt);
+	if (opt)
+		opt = ipv6_dup_options(newsk, opt);
+	RCU_INIT_POINTER(newnp->opt, opt);
+	rcu_read_unlock();
+}
+
+/* Account for the IP options */
+static int sctp_v6_ip_options_len(struct sock *sk)
+{
+	struct ipv6_pinfo *np = inet6_sk(sk);
+	struct ipv6_txoptions *opt;
+	int len = 0;
+
+	rcu_read_lock();
+	opt = rcu_dereference(np->opt);
+	if (opt)
+		len = opt->opt_flen + opt->opt_nflen;
+
+	rcu_read_unlock();
+	return len;
+}
+
 /* Initialize a sockaddr_storage from in incoming skb. */
 static void sctp_v6_from_skb(union sctp_addr *addr, struct sk_buff *skb,
 			     int is_saddr)
@@ -666,7 +698,6 @@ static struct sock *sctp_v6_create_accept_sk(struct sock *sk,
 	struct sock *newsk;
 	struct ipv6_pinfo *newnp, *np = inet6_sk(sk);
 	struct sctp6_sock *newsctp6sk;
-	struct ipv6_txoptions *opt;
 
 	newsk = sk_alloc(sock_net(sk), PF_INET6, GFP_KERNEL, sk->sk_prot, kern);
 	if (!newsk)
@@ -689,12 +720,7 @@ static struct sock *sctp_v6_create_accept_sk(struct sock *sk,
 	newnp->ipv6_ac_list = NULL;
 	newnp->ipv6_fl_list = NULL;
 
-	rcu_read_lock();
-	opt = rcu_dereference(np->opt);
-	if (opt)
-		opt = ipv6_dup_options(newsk, opt);
-	RCU_INIT_POINTER(newnp->opt, opt);
-	rcu_read_unlock();
+	sctp_v6_copy_ip_options(sk, newsk);
 
 	/* Initialize sk's sport, dport, rcv_saddr and daddr for getsockname()
 	 * and getpeername().
@@ -1041,6 +1067,7 @@ static struct sctp_af sctp_af_inet6 = {
 	.ecn_capable	   = sctp_v6_ecn_capable,
 	.net_header_len	   = sizeof(struct ipv6hdr),
 	.sockaddr_len	   = sizeof(struct sockaddr_in6),
+	.ip_options_len	   = sctp_v6_ip_options_len,
 #ifdef CONFIG_COMPAT
 	.compat_setsockopt = compat_ipv6_setsockopt,
 	.compat_getsockopt = compat_ipv6_getsockopt,
@@ -1059,6 +1086,7 @@ static struct sctp_pf sctp_pf_inet6 = {
 	.addr_to_user  = sctp_v6_addr_to_user,
 	.to_sk_saddr   = sctp_v6_to_sk_saddr,
 	.to_sk_daddr   = sctp_v6_to_sk_daddr,
+	.copy_ip_options = sctp_v6_copy_ip_options,
 	.af            = &sctp_af_inet6,
 };
 
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 01a26ee..668e2fa 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -151,7 +151,10 @@ void sctp_packet_init(struct sctp_packet *packet,
 	INIT_LIST_HEAD(&packet->chunk_list);
 	if (asoc) {
 		struct sctp_sock *sp = sctp_sk(asoc->base.sk);
-		overhead = sp->pf->af->net_header_len;
+		struct sctp_af *af = sp->pf->af;
+
+		overhead = af->net_header_len +
+			   af->ip_options_len(asoc->base.sk);
 	} else {
 		overhead = sizeof(struct ipv6hdr);
 	}
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 91813e6..8e786f0 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -237,6 +237,38 @@ int sctp_copy_local_addr_list(struct net *net, struct sctp_bind_addr *bp,
 	return error;
 }
 
+/* Copy over any ip options */
+static void sctp_v4_copy_ip_options(struct sock *sk, struct sock *newsk)
+{
+	struct inet_sock *newinet, *inet = inet_sk(sk);
+	struct ip_options_rcu *inet_opt, *newopt = NULL;
+
+	newinet = inet_sk(newsk);
+
+	rcu_read_lock();
+	inet_opt = rcu_dereference(inet->inet_opt);
+	if (inet_opt) {
+		newopt = sock_kmalloc(newsk, sizeof(*inet_opt) +
+				      inet_opt->opt.optlen, GFP_ATOMIC);
+		if (newopt)
+			memcpy(newopt, inet_opt, sizeof(*inet_opt) +
+			       inet_opt->opt.optlen);
+	}
+	RCU_INIT_POINTER(newinet->inet_opt, newopt);
+	rcu_read_unlock();
+}
+
+/* Account for the IP options */
+static int sctp_v4_ip_options_len(struct sock *sk)
+{
+	struct inet_sock *inet = inet_sk(sk);
+
+	if (inet->inet_opt)
+		return inet->inet_opt->opt.optlen;
+	else
+		return 0;
+}
+
 /* Initialize a sctp_addr from in incoming skb.  */
 static void sctp_v4_from_skb(union sctp_addr *addr, struct sk_buff *skb,
 			     int is_saddr)
@@ -588,6 +620,8 @@ static struct sock *sctp_v4_create_accept_sk(struct sock *sk,
 	sctp_copy_sock(newsk, sk, asoc);
 	sock_reset_flag(newsk, SOCK_ZAPPED);
 
+	sctp_v4_copy_ip_options(sk, newsk);
+
 	newinet = inet_sk(newsk);
 
 	newinet->inet_daddr = asoc->peer.primary_addr.v4.sin_addr.s_addr;
@@ -1006,6 +1040,7 @@ static struct sctp_pf sctp_pf_inet = {
 	.addr_to_user  = sctp_v4_addr_to_user,
 	.to_sk_saddr   = sctp_v4_to_sk_saddr,
 	.to_sk_daddr   = sctp_v4_to_sk_daddr,
+	.copy_ip_options = sctp_v4_copy_ip_options,
 	.af            = &sctp_af_inet
 };
 
@@ -1090,6 +1125,7 @@ static struct sctp_af sctp_af_inet = {
 	.ecn_capable	   = sctp_v4_ecn_capable,
 	.net_header_len	   = sizeof(struct iphdr),
 	.sockaddr_len	   = sizeof(struct sockaddr_in),
+	.ip_options_len	   = sctp_v4_ip_options_len,
 #ifdef CONFIG_COMPAT
 	.compat_setsockopt = compat_ip_setsockopt,
 	.compat_getsockopt = compat_ip_getsockopt,
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index bf271f8..8307968 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3138,6 +3138,7 @@ static int sctp_setsockopt_mappedv4(struct sock *sk, char __user *optval, unsign
 static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned int optlen)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
+	struct sctp_af *af = sp->pf->af;
 	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	int val;
@@ -3159,10 +3160,13 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 		return -EINVAL;
 	}
 
+	asoc = sctp_id2assoc(sk, params.assoc_id);
+
 	if (val) {
 		int min_len, max_len;
 
-		min_len = SCTP_DEFAULT_MINSEGMENT - sp->pf->af->net_header_len;
+		min_len = SCTP_DEFAULT_MINSEGMENT - af->net_header_len;
+		min_len -= af->ip_options_len(asoc->base.sk);
 		min_len -= sizeof(struct sctphdr) +
 			   sizeof(struct sctp_data_chunk);
 
@@ -3172,10 +3176,10 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
 			return -EINVAL;
 	}
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
 	if (asoc) {
 		if (val = 0) {
-			val = asoc->pathmtu - sp->pf->af->net_header_len;
+			val = asoc->pathmtu - af->net_header_len;
+			val -= af->ip_options_len(asoc->base.sk);
 			val -= sizeof(struct sctphdr) +
 			       sctp_datachk_len(&asoc->stream);
 		}
@@ -5087,9 +5091,11 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
 	sctp_copy_sock(sock->sk, sk, asoc);
 
 	/* Make peeled-off sockets more like 1-1 accepted sockets.
-	 * Set the daddr and initialize id to something more random
+	 * Set the daddr and initialize id to something more random and also
+	 * copy over any ip options.
 	 */
 	sp->pf->to_sk_daddr(&asoc->peer.primary_addr, sk);
+	sp->pf->copy_ip_options(sk, sock->sk);
 
 	/* Populate the fields of the newsk from the oldsk and migrate the
 	 * asoc to the newsk.
-- 
2.14.3

