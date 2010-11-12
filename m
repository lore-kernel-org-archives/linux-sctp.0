From: Dan Rosenberg <drosenberg@vsecurity.com>
Date: Fri, 12 Nov 2010 01:07:16 +0000
Subject: [PATCH 7/10] Fix leaking of kernel heap addresses in net/
Message-Id: <1289524036.5167.71.camel@dan>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Oliver Hartkopp <socketcan@hartkopp.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Urs Thuermann <urs.thuermann@volkswagen.de>, Hideaki

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 3616f27..3dbf2b5 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2635,17 +2635,31 @@ static int packet_seq_show(struct seq_file *seq, void *v)
 		struct sock *s = sk_entry(v);
 		const struct packet_sock *po = pkt_sk(s);
 
-		seq_printf(seq,
-			   "%p %-6d %-4d %04x   %-5d %1d %-6u %-6u %-6lu\n",
-			   s,
-			   atomic_read(&s->sk_refcnt),
-			   s->sk_type,
-			   ntohs(po->num),
-			   po->ifindex,
-			   po->running,
-			   atomic_read(&s->sk_rmem_alloc),
-			   sock_i_uid(s),
-			   sock_i_ino(s));
+		/* Only expose kernel addresses to privileged readers */
+		if (capable(CAP_NET_ADMIN))
+			seq_printf(seq,
+				   "%p %-6d %-4d %04x   %-5d %1d %-6u %-6u %-6lu\n",
+				   s,
+				   atomic_read(&s->sk_refcnt),
+				   s->sk_type,
+				   ntohs(po->num),
+				   po->ifindex,
+				   po->running,
+				   atomic_read(&s->sk_rmem_alloc),
+				   sock_i_uid(s),
+				   sock_i_ino(s));
+		else
+			seq_printf(seq,
+				   "%d %-6d %-4d %04x   %-5d %1d %-6u %-6u %-6lu\n",
+				   0,
+				   atomic_read(&s->sk_refcnt),
+				   s->sk_type,
+				   ntohs(po->num),
+				   po->ifindex,
+				   po->running,
+				   atomic_read(&s->sk_rmem_alloc),
+				   sock_i_uid(s),
+				   sock_i_ino(s));
 	}
 
 	return 0;



