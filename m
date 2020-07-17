From: Christoph Hellwig <hch@lst.de>
Date: Fri, 17 Jul 2020 06:23:22 +0000
Subject: [PATCH 13/22] netfilter: split nf_sockopt
Message-Id: <20200717062331.691152-14-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200717062331.691152-1-hch@lst.de>
In-Reply-To: <20200717062331.691152-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Chas Williams <3chas3@gmail.com>, Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org, linux-arch@vger.kernel.org, linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org, linux-can@vger.kernel.org, dccp@vger.kernel.org, linux-wpan@vger.kernel.org, mptcp@lists.01.org

Split nf_sockopt into a getsockopt and setsockopt side as they share
very little code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/netfilter/nf_sockopt.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_sockopt.c b/net/netfilter/nf_sockopt.c
index 02870993d335c9..90469b1f628a8e 100644
--- a/net/netfilter/nf_sockopt.c
+++ b/net/netfilter/nf_sockopt.c
@@ -89,36 +89,32 @@ static struct nf_sockopt_ops *nf_sockopt_find(struct sock *sk, u_int8_t pf,
 	return ops;
 }
 
-/* Call get/setsockopt() */
-static int nf_sockopt(struct sock *sk, u_int8_t pf, int val,
-		      char __user *opt, int *len, int get)
+int nf_setsockopt(struct sock *sk, u_int8_t pf, int val, char __user *opt,
+		  unsigned int len)
 {
 	struct nf_sockopt_ops *ops;
 	int ret;
 
-	ops = nf_sockopt_find(sk, pf, val, get);
+	ops = nf_sockopt_find(sk, pf, val, 0);
 	if (IS_ERR(ops))
 		return PTR_ERR(ops);
-
-	if (get)
-		ret = ops->get(sk, val, opt, len);
-	else
-		ret = ops->set(sk, val, opt, *len);
-
+	ret = ops->set(sk, val, opt, len);
 	module_put(ops->owner);
 	return ret;
 }
-
-int nf_setsockopt(struct sock *sk, u_int8_t pf, int val, char __user *opt,
-		  unsigned int len)
-{
-	return nf_sockopt(sk, pf, val, opt, &len, 0);
-}
 EXPORT_SYMBOL(nf_setsockopt);
 
 int nf_getsockopt(struct sock *sk, u_int8_t pf, int val, char __user *opt,
 		  int *len)
 {
-	return nf_sockopt(sk, pf, val, opt, len, 1);
+	struct nf_sockopt_ops *ops;
+	int ret;
+
+	ops = nf_sockopt_find(sk, pf, val, 1);
+	if (IS_ERR(ops))
+		return PTR_ERR(ops);
+	ret = ops->get(sk, val, opt, len);
+	module_put(ops->owner);
+	return ret;
 }
 EXPORT_SYMBOL(nf_getsockopt);
-- 
2.27.0
