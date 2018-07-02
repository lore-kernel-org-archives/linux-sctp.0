From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 02 Jul 2018 10:21:11 +0000
Subject: [PATCHv2 net-next 1/5] ipv4: add __ip_queue_xmit() that supports tos param
Message-Id: <6504d3609be85e1574b6f44051d2523342f9e955.1530526661.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1530526661.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1530526661.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net, hideaki.yoshifuji@miraclelinux.com

This patch introduces __ip_queue_xmit(), through which the callers
can pass tos param into it without having to set inet->tos. For
ipv6, ip6_xmit() already allows passing tclass parameter.

It's needed when some transport protocol doesn't use inet->tos,
like sctp's per transport dscp, which will be added in next patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/ip.h     | 9 ++++++++-
 net/ipv4/ip_output.c | 9 +++++----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 0d2281b..09da79d 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -148,7 +148,8 @@ void ip_send_check(struct iphdr *ip);
 int __ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb);
 int ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb);
 
-int ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl);
+int __ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl,
+		    __u8 tos);
 void ip_init(void);
 int ip_append_data(struct sock *sk, struct flowi4 *fl4,
 		   int getfrag(void *from, char *to, int offset, int len,
@@ -174,6 +175,12 @@ struct sk_buff *ip_make_skb(struct sock *sk, struct flowi4 *fl4,
 			    struct ipcm_cookie *ipc, struct rtable **rtp,
 			    struct inet_cork *cork, unsigned int flags);
 
+static inline int ip_queue_xmit(struct sock *sk, struct sk_buff *skb,
+				struct flowi *fl)
+{
+	return __ip_queue_xmit(sk, skb, fl, inet_sk(sk)->tos);
+}
+
 static inline struct sk_buff *ip_finish_skb(struct sock *sk, struct flowi4 *fl4)
 {
 	return __ip_make_skb(sk, fl4, &sk->sk_write_queue, &inet_sk(sk)->cork.base);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index b3308e9..188cc58 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -423,7 +423,8 @@ static void ip_copy_addrs(struct iphdr *iph, const struct flowi4 *fl4)
 }
 
 /* Note: skb->sk can be different from sk, in case of tunnels */
-int ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl)
+int __ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl,
+		    __u8 tos)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct net *net = sock_net(sk);
@@ -462,7 +463,7 @@ int ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl)
 					   inet->inet_dport,
 					   inet->inet_sport,
 					   sk->sk_protocol,
-					   RT_CONN_FLAGS(sk),
+					   RT_CONN_FLAGS_TOS(sk, tos),
 					   sk->sk_bound_dev_if);
 		if (IS_ERR(rt))
 			goto no_route;
@@ -478,7 +479,7 @@ int ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl)
 	skb_push(skb, sizeof(struct iphdr) + (inet_opt ? inet_opt->opt.optlen : 0));
 	skb_reset_network_header(skb);
 	iph = ip_hdr(skb);
-	*((__be16 *)iph) = htons((4 << 12) | (5 << 8) | (inet->tos & 0xff));
+	*((__be16 *)iph) = htons((4 << 12) | (5 << 8) | (tos & 0xff));
 	if (ip_dont_fragment(sk, &rt->dst) && !skb->ignore_df)
 		iph->frag_off = htons(IP_DF);
 	else
@@ -511,7 +512,7 @@ int ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl)
 	kfree_skb(skb);
 	return -EHOSTUNREACH;
 }
-EXPORT_SYMBOL(ip_queue_xmit);
+EXPORT_SYMBOL(__ip_queue_xmit);
 
 static void ip_copy_metadata(struct sk_buff *to, struct sk_buff *from)
 {
-- 
2.1.0

