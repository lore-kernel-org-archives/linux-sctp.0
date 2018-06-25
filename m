From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 25 Jun 2018 02:14:34 +0000
Subject: [PATCH net-next 2/5] sctp: add support for dscp and flowlabel per transport
Message-Id: <b63859ce9c0d5b3d69028d9aa32fd2abe9fdbbe9.1529892764.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1529892764.git.lucien.xin@gmail.com>
 <6d8aa86ce11166620c9fd4e50fdcce1baab69ab6.1529892764.git.lucien.xin@gmail.com>
In-Reply-To: <6d8aa86ce11166620c9fd4e50fdcce1baab69ab6.1529892764.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Like some other per transport params, flowlabel and dscp are added
in transport, asoc and sctp_sock. By default, transport sets its
value from asoc's, and asoc does it from sctp_sock. flowlabel
only works for ipv6 transport.

Other than that they need to be passed down in sctp_xmit, flow4/6
also needs to set them before looking up route in get_dst.

Note that it uses '& 0x100000' to check if flowlabel is set and
'& 0x1' (tos 1st bit is unused) to check if dscp is set by users,
so that they could be set to 0 by sockopt in next patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h       |  7 +++++++
 include/net/sctp/structs.h |  9 +++++++++
 net/sctp/associola.c       |  7 +++++++
 net/sctp/ipv6.c            | 11 +++++++++--
 net/sctp/protocol.c        | 16 ++++++++++++----
 5 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index b36c766..83d9434 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -801,4 +801,11 @@ struct sctp_strreset_resptsn {
 	__be32 receivers_next_tsn;
 };
 
+enum {
+	SCTP_DSCP_SET_MASK = 0x1,
+	SCTP_DSCP_VAL_MASK = 0xfc,
+	SCTP_FLOWLABEL_SET_MASK = 0x100000,
+	SCTP_FLOWLABEL_VAL_MASK = 0xfffff
+};
+
 #endif /* __LINUX_SCTP_H__ */
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 701a517..ab869e0 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -193,6 +193,9 @@ struct sctp_sock {
 	/* This is the max_retrans value for new associations. */
 	__u16 pathmaxrxt;
 
+	__u32 flowlabel;
+	__u8  dscp;
+
 	/* The initial Path MTU to use for new associations. */
 	__u32 pathmtu;
 
@@ -895,6 +898,9 @@ struct sctp_transport {
 	 */
 	__u16 pathmaxrxt;
 
+	__u32 flowlabel;
+	__u8  dscp;
+
 	/* This is the partially failed retrans value for the transport
 	 * and will be initialized from the assocs value.  This can be changed
 	 * using the SCTP_PEER_ADDR_THLDS socket option
@@ -1772,6 +1778,9 @@ struct sctp_association {
 	 */
 	__u16 pathmaxrxt;
 
+	__u32 flowlabel;
+	__u8  dscp;
+
 	/* Flag that path mtu update is pending */
 	__u8   pmtu_pending;
 
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 5d5a162..16ecfbc 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -115,6 +115,9 @@ static struct sctp_association *sctp_association_init(
 	/* Initialize path max retrans value. */
 	asoc->pathmaxrxt = sp->pathmaxrxt;
 
+	asoc->flowlabel = sp->flowlabel;
+	asoc->dscp = sp->dscp;
+
 	/* Initialize default path MTU. */
 	asoc->pathmtu = sp->pathmtu;
 
@@ -647,6 +650,10 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 	peer->sackdelay = asoc->sackdelay;
 	peer->sackfreq = asoc->sackfreq;
 
+	if (addr->sa.sa_family = AF_INET6)
+		peer->flowlabel = asoc->flowlabel;
+	peer->dscp = asoc->dscp;
+
 	/* Enable/disable heartbeat, SACK delay, and path MTU discovery
 	 * based on association setting.
 	 */
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 7339918..772513d 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -209,12 +209,17 @@ static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *transport)
 	struct sock *sk = skb->sk;
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct flowi6 *fl6 = &transport->fl.u.ip6;
+	__u8 tclass = np->tclass;
 	int res;
 
 	pr_debug("%s: skb:%p, len:%d, src:%pI6 dst:%pI6\n", __func__, skb,
 		 skb->len, &fl6->saddr, &fl6->daddr);
 
-	IP6_ECN_flow_xmit(sk, fl6->flowlabel);
+	if (transport->dscp & SCTP_DSCP_SET_MASK)
+		tclass = transport->dscp & SCTP_DSCP_VAL_MASK;
+
+	if (INET_ECN_is_capable(tclass))
+		IP6_ECN_flow_xmit(sk, fl6->flowlabel);
 
 	if (!(transport->param_flags & SPP_PMTUD_ENABLE))
 		skb->ignore_df = 1;
@@ -223,7 +228,7 @@ static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *transport)
 
 	rcu_read_lock();
 	res = ip6_xmit(sk, skb, fl6, sk->sk_mark, rcu_dereference(np->opt),
-		       np->tclass);
+		       tclass);
 	rcu_read_unlock();
 	return res;
 }
@@ -254,6 +259,8 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 		fl6->flowi6_oif = daddr->v6.sin6_scope_id;
 	else if (asoc)
 		fl6->flowi6_oif = asoc->base.sk->sk_bound_dev_if;
+	if (t->flowlabel & SCTP_FLOWLABEL_SET_MASK)
+		fl6->flowlabel = htonl(t->flowlabel & SCTP_FLOWLABEL_VAL_MASK);
 
 	pr_debug("%s: dst=%pI6 ", __func__, &fl6->daddr);
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 5dffbc4..d57fd30 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -426,13 +426,16 @@ static void sctp_v4_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 	struct dst_entry *dst = NULL;
 	union sctp_addr *daddr = &t->ipaddr;
 	union sctp_addr dst_saddr;
+	__u8 tos = inet_sk(sk)->tos;
 
+	if (t->dscp & SCTP_DSCP_SET_MASK)
+		tos = t->dscp & SCTP_DSCP_VAL_MASK;
 	memset(fl4, 0x0, sizeof(struct flowi4));
 	fl4->daddr  = daddr->v4.sin_addr.s_addr;
 	fl4->fl4_dport = daddr->v4.sin_port;
 	fl4->flowi4_proto = IPPROTO_SCTP;
 	if (asoc) {
-		fl4->flowi4_tos = RT_CONN_FLAGS(asoc->base.sk);
+		fl4->flowi4_tos = RT_CONN_FLAGS_TOS(asoc->base.sk, tos);
 		fl4->flowi4_oif = asoc->base.sk->sk_bound_dev_if;
 		fl4->fl4_sport = htons(asoc->base.bind_addr.port);
 	}
@@ -495,7 +498,7 @@ static void sctp_v4_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 		fl4->fl4_sport = laddr->a.v4.sin_port;
 		flowi4_update_output(fl4,
 				     asoc->base.sk->sk_bound_dev_if,
-				     RT_CONN_FLAGS(asoc->base.sk),
+				     RT_CONN_FLAGS_TOS(asoc->base.sk, tos),
 				     daddr->v4.sin_addr.s_addr,
 				     laddr->a.v4.sin_addr.s_addr);
 
@@ -971,16 +974,21 @@ static inline int sctp_v4_xmit(struct sk_buff *skb,
 			       struct sctp_transport *transport)
 {
 	struct inet_sock *inet = inet_sk(skb->sk);
+	__u8 dscp = inet->tos;
 
 	pr_debug("%s: skb:%p, len:%d, src:%pI4, dst:%pI4\n", __func__, skb,
-		 skb->len, &transport->fl.u.ip4.saddr, &transport->fl.u.ip4.daddr);
+		 skb->len, &transport->fl.u.ip4.saddr,
+		 &transport->fl.u.ip4.daddr);
+
+	if (transport->dscp & SCTP_DSCP_SET_MASK)
+		dscp = transport->dscp & SCTP_DSCP_VAL_MASK;
 
 	inet->pmtudisc = transport->param_flags & SPP_PMTUD_ENABLE ?
 			 IP_PMTUDISC_DO : IP_PMTUDISC_DONT;
 
 	SCTP_INC_STATS(sock_net(&inet->sk), SCTP_MIB_OUTSCTPPACKS);
 
-	return ip_queue_xmit(&inet->sk, skb, &transport->fl);
+	return __ip_queue_xmit(&inet->sk, skb, &transport->fl, dscp);
 }
 
 static struct sctp_af sctp_af_inet;
-- 
2.1.0

