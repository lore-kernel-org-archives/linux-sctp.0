From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 16 Oct 2013 02:01:29 +0000
Subject: [PATCH v4 net 1/3] net: dst: provide accessor function to dst->xfrm
Message-Id: <1381888891-31186-2-git-send-email-vyasevich@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1381888891-31186-1-git-send-email-vyasevich@gmail.com>
In-Reply-To: <1381888891-31186-1-git-send-email-vyasevich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, fan.du@windriver.com, Vlad Yasevich <vyasevich@gmail.com>

dst->xfrm is conditionally defined.  Provide accessor funtion that
is always available.

Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
---
 include/net/dst.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/net/dst.h b/include/net/dst.h
index 3bc4865..3c4c944 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -479,10 +479,22 @@ static inline struct dst_entry *xfrm_lookup(struct net *net,
 {
 	return dst_orig;
 } 
+
+static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
+{
+	return NULL;
+}
+
 #else
 extern struct dst_entry *xfrm_lookup(struct net *net, struct dst_entry *dst_orig,
 				     const struct flowi *fl, struct sock *sk,
 				     int flags);
+
+/* skb attached with this dst needs transformation if dst->xfrm is valid */
+static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
+{
+	return dst->xfrm;
+}
 #endif
 
 #endif /* _NET_DST_H */
-- 
1.8.3.1

