From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 19 Oct 2020 12:25:30 +0000
Subject: [PATCHv4 net-next 13/16] sctp: support for sending packet over udp6 sock
Message-Id: <15f6150aa59acd248129723df647d55ea1169d85.1603110316.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
 <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
 <5f06ac649f4b63fc5a254812a963cada3183f136.1603110316.git.lucien.xin@gmail.com>
 <e99845af51be8fdaa53a2575e8967b8c3c8d423a.1603110316.git.lucien.xin@gmail.com>
 <7a2f5792c1a428c16962fff08b7bcfedc21bd5e2.1603110316.git.lucien.xin@gmail.com>
 <7cfd72e42b8b1cde268ad4062c96c08a56c4b14f.1603110316.git.lucien.xin@gmail.com>
 <d55a0eaefa4b8a671e54535a1899ea4c00bc2de8.1603110316.git.lucien.xin@gmail.com>
 <25013493737f5b488ce48c38667a077ca6573dd5.1603110316.git.lucien.xin@gmail.com>
 <fe0630fd48830058df1bfdd53a9e6b9fbf83b498.1603110316.git.lucien.xin@gmail.com>
 <8547ef8c7056072bdeca8f5e9eb0d7fec5cdb210.1603110316.git.lucien.xin@gmail.com>
 <e8d627d45c604460c57959a124b21aaeddfb3808.1603110316.git.lucien.xin@gmail.com>
 <2cac0eaff47574dbc07a4a074500f5e0300cff3e.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <2cac0eaff47574dbc07a4a074500f5e0300cff3e.1603110316.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net, gnault@redhat.com, pabeni@redhat.com, willemdebruijn.kernel@gmail.com

This one basically does the similar things in sctp_v6_xmit as does for
udp4 sock in the last patch, just note that:

  1. label needs to be calculated, as it's the param of
     udp_tunnel6_xmit_skb().

  2. The 'nocheck' param of udp_tunnel6_xmit_skb() is false, as
     required by RFC.

v1->v2:
  - Use sp->udp_port instead in sctp_v6_xmit(), which is more safe.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/ipv6.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index a064bf2..814754d 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -55,6 +55,7 @@
 #include <net/inet_common.h>
 #include <net/inet_ecn.h>
 #include <net/sctp/sctp.h>
+#include <net/udp_tunnel.h>
 
 #include <linux/uaccess.h>
 
@@ -191,33 +192,53 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	return ret;
 }
 
-static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *transport)
+static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *t)
 {
+	struct dst_entry *dst = dst_clone(t->dst);
+	struct flowi6 *fl6 = &t->fl.u.ip6;
 	struct sock *sk = skb->sk;
 	struct ipv6_pinfo *np = inet6_sk(sk);
-	struct flowi6 *fl6 = &transport->fl.u.ip6;
 	__u8 tclass = np->tclass;
-	int res;
+	__be32 label;
 
 	pr_debug("%s: skb:%p, len:%d, src:%pI6 dst:%pI6\n", __func__, skb,
 		 skb->len, &fl6->saddr, &fl6->daddr);
 
-	if (transport->dscp & SCTP_DSCP_SET_MASK)
-		tclass = transport->dscp & SCTP_DSCP_VAL_MASK;
+	if (t->dscp & SCTP_DSCP_SET_MASK)
+		tclass = t->dscp & SCTP_DSCP_VAL_MASK;
 
 	if (INET_ECN_is_capable(tclass))
 		IP6_ECN_flow_xmit(sk, fl6->flowlabel);
 
-	if (!(transport->param_flags & SPP_PMTUD_ENABLE))
+	if (!(t->param_flags & SPP_PMTUD_ENABLE))
 		skb->ignore_df = 1;
 
 	SCTP_INC_STATS(sock_net(sk), SCTP_MIB_OUTSCTPPACKS);
 
-	rcu_read_lock();
-	res = ip6_xmit(sk, skb, fl6, sk->sk_mark, rcu_dereference(np->opt),
-		       tclass, sk->sk_priority);
-	rcu_read_unlock();
-	return res;
+	if (!t->encap_port || !sctp_sk(sk)->udp_port) {
+		int res;
+
+		skb_dst_set(skb, dst);
+		rcu_read_lock();
+		res = ip6_xmit(sk, skb, fl6, sk->sk_mark,
+			       rcu_dereference(np->opt),
+			       tclass, sk->sk_priority);
+		rcu_read_unlock();
+		return res;
+	}
+
+	if (skb_is_gso(skb))
+		skb_shinfo(skb)->gso_type |= SKB_GSO_UDP_TUNNEL_CSUM;
+
+	skb->encapsulation = 1;
+	skb_reset_inner_mac_header(skb);
+	skb_reset_inner_transport_header(skb);
+	skb_set_inner_ipproto(skb, IPPROTO_SCTP);
+	label = ip6_make_flowlabel(sock_net(sk), skb, fl6->flowlabel, true, fl6);
+
+	return udp_tunnel6_xmit_skb(dst, sk, skb, NULL, &fl6->saddr,
+				    &fl6->daddr, tclass, ip6_dst_hoplimit(dst),
+				    label, sctp_sk(sk)->udp_port, t->encap_port, false);
 }
 
 /* Returns the dst cache entry for the given source and destination ip
-- 
2.1.0
