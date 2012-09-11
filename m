From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Tue, 11 Sep 2012 08:09:45 +0000
Subject: [PATCH net-next v3 2/4] xfrm: invalidate dst on policy insertion/deletion
Message-Id: <1347350987-8054-3-git-send-email-nicolas.dichtel@6wind.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <504DFF90.3010802@6wind.com>
 <1347350987-8054-1-git-send-email-nicolas.dichtel@6wind.com>
In-Reply-To: <1347350987-8054-1-git-send-email-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, davem@davemloft.net, eric.dumazet@gmail.com, sds@tycho.nsa.gov, james.l.morris@oracle.com, eparis@parisplace.org
Cc: sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>

When a policy is inserted or deleted, all dst should be recalculated.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/xfrm/xfrm_policy.c          | 1 +
 security/selinux/include/xfrm.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 741a32a..67f456d 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -602,6 +602,7 @@ int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
 	xfrm_pol_hold(policy);
 	net->xfrm.policy_count[dir]++;
 	atomic_inc(&flow_cache_genid);
+	rt_genid_bump(net);
 	if (delpol)
 		__xfrm_policy_unlink(delpol, dir);
 	policy->index = delpol ? delpol->index : xfrm_gen_index(net, dir);
diff --git a/security/selinux/include/xfrm.h b/security/selinux/include/xfrm.h
index c220f31..65f67cb 100644
--- a/security/selinux/include/xfrm.h
+++ b/security/selinux/include/xfrm.h
@@ -51,6 +51,7 @@ int selinux_xfrm_decode_session(struct sk_buff *skb, u32 *sid, int ckall);
 static inline void selinux_xfrm_notify_policyload(void)
 {
 	atomic_inc(&flow_cache_genid);
+	rt_genid_bump(&init_net);
 }
 #else
 static inline int selinux_xfrm_enabled(void)
-- 
1.7.12

