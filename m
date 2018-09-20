From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 20 Sep 2018 09:27:28 +0000
Subject: [PATCH net] sctp: update dst pmtu with the correct daddr
Message-Id: <dbed84b3964b13a0c15b3a5c8e825940819a2918.1537435648.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

When processing pmtu update from an icmp packet, it calls .update_pmtu
with sk instead of skb in sctp_transport_update_pmtu.

However for sctp, the daddr in the transport might be different from
inet_sock->inet_daddr or sk->sk_v6_daddr, which is used to update or
create the route cache. The incorrect daddr will cause a different
route cache created for the path.

So before calling .update_pmtu, inet_sock->inet_daddr/sk->sk_v6_daddr
should be updated with the daddr in the transport, and update it back
after it's done.

The issue has existed since route exceptions introduction.

Fixes: 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions.")
Reported-by: ian.periam@dialogic.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/transport.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 12cac85..033696e 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -260,6 +260,7 @@ void sctp_transport_pmtu(struct sctp_transport *transport, struct sock *sk)
 bool sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu)
 {
 	struct dst_entry *dst = sctp_transport_dst_check(t);
+	struct sock *sk = t->asoc->base.sk;
 	bool change = true;
 
 	if (unlikely(pmtu < SCTP_DEFAULT_MINSEGMENT)) {
@@ -271,12 +272,19 @@ bool sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu)
 	pmtu = SCTP_TRUNC4(pmtu);
 
 	if (dst) {
-		dst->ops->update_pmtu(dst, t->asoc->base.sk, NULL, pmtu);
+		struct sctp_pf *pf = sctp_get_pf_specific(dst->ops->family);
+		union sctp_addr addr;
+
+		pf->af->from_sk(&addr, sk);
+		pf->to_sk_daddr(&t->ipaddr, sk);
+		dst->ops->update_pmtu(dst, sk, NULL, pmtu);
+		pf->to_sk_daddr(&addr, sk);
+
 		dst = sctp_transport_dst_check(t);
 	}
 
 	if (!dst) {
-		t->af_specific->get_dst(t, &t->saddr, &t->fl, t->asoc->base.sk);
+		t->af_specific->get_dst(t, &t->saddr, &t->fl, sk);
 		dst = t->dst;
 	}
 
-- 
2.1.0
