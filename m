From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 28 Oct 2017 11:43:55 +0000
Subject: [PATCH net 2/4] sctp: fix some type cast warnings introduced by transport rhashtable
Message-Id: <ddda2f5b5825a379793ac6f2ffff4c7ab9aa64e5.1509190967.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1509190967.git.lucien.xin@gmail.com>
 <d85747d7d1af0972a00b8d4594a84f2afe97aac8.1509190967.git.lucien.xin@gmail.com>
In-Reply-To: <d85747d7d1af0972a00b8d4594a84f2afe97aac8.1509190967.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Eric Dumazet <edumazet@google.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

These warnings were found by running 'make C=2 M=net/sctp/'.

They are introduced by not aware of Endian for the port when
coding transport rhashtable patches.

Fixes: 7fda702f9315 ("sctp: use new rhlist interface on sctp transport rhashtable")
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/input.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 34f10e7..621b5ca 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -794,7 +794,7 @@ static struct sctp_endpoint *__sctp_rcv_lookup_endpoint(struct net *net,
 struct sctp_hash_cmp_arg {
 	const union sctp_addr	*paddr;
 	const struct net	*net;
-	u16			lport;
+	__be16			lport;
 };
 
 static inline int sctp_hash_cmp(struct rhashtable_compare_arg *arg,
@@ -820,37 +820,37 @@ static inline int sctp_hash_cmp(struct rhashtable_compare_arg *arg,
 	return err;
 }
 
-static inline u32 sctp_hash_obj(const void *data, u32 len, u32 seed)
+static inline __u32 sctp_hash_obj(const void *data, u32 len, u32 seed)
 {
 	const struct sctp_transport *t = data;
 	const union sctp_addr *paddr = &t->ipaddr;
 	const struct net *net = sock_net(t->asoc->base.sk);
-	u16 lport = htons(t->asoc->base.bind_addr.port);
-	u32 addr;
+	__be16 lport = htons(t->asoc->base.bind_addr.port);
+	__u32 addr;
 
 	if (paddr->sa.sa_family = AF_INET6)
 		addr = jhash(&paddr->v6.sin6_addr, 16, seed);
 	else
-		addr = paddr->v4.sin_addr.s_addr;
+		addr = (__force __u32)paddr->v4.sin_addr.s_addr;
 
-	return  jhash_3words(addr, ((__u32)paddr->v4.sin_port) << 16 |
+	return  jhash_3words(addr, ((__force __u32)paddr->v4.sin_port) << 16 |
 			     (__force __u32)lport, net_hash_mix(net), seed);
 }
 
-static inline u32 sctp_hash_key(const void *data, u32 len, u32 seed)
+static inline __u32 sctp_hash_key(const void *data, u32 len, u32 seed)
 {
 	const struct sctp_hash_cmp_arg *x = data;
 	const union sctp_addr *paddr = x->paddr;
 	const struct net *net = x->net;
-	u16 lport = x->lport;
-	u32 addr;
+	__be16 lport = x->lport;
+	__u32 addr;
 
 	if (paddr->sa.sa_family = AF_INET6)
 		addr = jhash(&paddr->v6.sin6_addr, 16, seed);
 	else
-		addr = paddr->v4.sin_addr.s_addr;
+		addr = (__force __u32)paddr->v4.sin_addr.s_addr;
 
-	return  jhash_3words(addr, ((__u32)paddr->v4.sin_port) << 16 |
+	return  jhash_3words(addr, ((__force __u32)paddr->v4.sin_port) << 16 |
 			     (__force __u32)lport, net_hash_mix(net), seed);
 }
 
-- 
2.1.0

