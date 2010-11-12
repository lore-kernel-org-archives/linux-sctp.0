From: Dan Rosenberg <drosenberg@vsecurity.com>
Date: Fri, 12 Nov 2010 01:07:12 +0000
Subject: [PATCH 6/10] Fix leaking of kernel heap addresses in net/
Message-Id: <1289524032.5167.70.camel@dan>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Oliver Hartkopp <socketcan@hartkopp.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Urs Thuermann <urs.thuermann@volkswagen.de>, Hideaki

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 478181d..88be3ab 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1990,18 +1990,35 @@ static int netlink_seq_show(struct seq_file *seq, void *v)
 		struct sock *s = v;
 		struct netlink_sock *nlk = nlk_sk(s);
 
-		seq_printf(seq, "%p %-3d %-6d %08x %-8d %-8d %p %-8d %-8d %-8lu\n",
-			   s,
-			   s->sk_protocol,
-			   nlk->pid,
-			   nlk->groups ? (u32)nlk->groups[0] : 0,
-			   sk_rmem_alloc_get(s),
-			   sk_wmem_alloc_get(s),
-			   nlk->cb,
-			   atomic_read(&s->sk_refcnt),
-			   atomic_read(&s->sk_drops),
-			   sock_i_ino(s)
-			);
+		/* Only expose kernel addresses to privileged readers */
+		if (capable(CAP_NET_ADMIN))
+			seq_printf(seq, "%p %-3d %-6d %08x %-8d "
+				   "%-8d %p %-8d %-8d %-8lu\n",
+				   s,
+				   s->sk_protocol,
+				   nlk->pid,
+				   nlk->groups ? (u32)nlk->groups[0] : 0,
+				   sk_rmem_alloc_get(s),
+				   sk_wmem_alloc_get(s),
+				   nlk->cb,
+				   atomic_read(&s->sk_refcnt),
+				   atomic_read(&s->sk_drops),
+				   sock_i_ino(s)
+				);
+		else
+			seq_printf(seq, "%d %-3d %-6d %08x %-8d "
+				   "%-8d %d %-8d %-8d %-8lu\n",
+				   0,
+				   s->sk_protocol,
+				   nlk->pid,
+				   nlk->groups ? (u32)nlk->groups[0] : 0,
+				   sk_rmem_alloc_get(s),
+				   sk_wmem_alloc_get(s),
+				   0,
+				   atomic_read(&s->sk_refcnt),
+				   atomic_read(&s->sk_drops),
+				   sock_i_ino(s)
+				);
 
 	}
 	return 0;



