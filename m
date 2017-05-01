From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 01 May 2017 13:31:38 +0000
Subject: [PATCH 1/3] sctp: Replace six seq_printf() calls by seq_putc()
Message-Id: <a22ad66a-ffe1-b772-8151-8b389aa2c94b@users.sourceforge.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <ea9206ca-2a2f-095e-d764-3f819610d5e8@users.sourceforge.net>
In-Reply-To: <ea9206ca-2a2f-095e-d764-3f819610d5e8@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 1 May 2017 14:18:52 +0200

Six single characters should be put into a sequence.
Thus use the corresponding function "seq_putc".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 net/sctp/proc.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index a0b29d43627f..1cf4b6385418 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -149,9 +149,8 @@ static void sctp_seq_dump_local_addrs(struct seq_file *seq, struct sctp_ep_commo
 
 		addr = &laddr->a;
 		af = sctp_get_af_specific(addr->sa.sa_family);
-		if (primary && af->cmp_addr(addr, primary)) {
-			seq_printf(seq, "*");
-		}
+		if (primary && af->cmp_addr(addr, primary))
+			seq_putc(seq, '*');
 		af->seq_dump_addr(seq, addr);
 	}
 	rcu_read_unlock();
@@ -170,9 +169,8 @@ static void sctp_seq_dump_remote_addrs(struct seq_file *seq, struct sctp_associa
 		addr = &transport->ipaddr;
 
 		af = sctp_get_af_specific(addr->sa.sa_family);
-		if (af->cmp_addr(addr, primary)) {
-			seq_printf(seq, "*");
-		}
+		if (af->cmp_addr(addr, primary))
+			seq_putc(seq, '*');
 		af->seq_dump_addr(seq, addr);
 	}
 }
@@ -232,7 +230,7 @@ static int sctp_eps_seq_show(struct seq_file *seq, void *v)
 			   sock_i_ino(sk));
 
 		sctp_seq_dump_local_addrs(seq, epb);
-		seq_printf(seq, "\n");
+		seq_putc(seq, '\n');
 	}
 	read_unlock(&head->lock);
 	local_bh_enable();
@@ -355,5 +353,5 @@ static int sctp_assocs_seq_show(struct seq_file *seq, void *v)
 		   sock_i_ino(sk),
 		   epb->bind_addr.port,
 		   assoc->peer.port);
-	seq_printf(seq, " ");
+	seq_putc(seq, ' ');
 	sctp_seq_dump_local_addrs(seq, epb);
@@ -369,8 +367,7 @@ static int sctp_assocs_seq_show(struct seq_file *seq, void *v)
 		sk->sk_wmem_queued,
 		sk->sk_sndbuf,
 		sk->sk_rcvbuf);
-	seq_printf(seq, "\n");
-
+	seq_putc(seq, '\n');
 	sctp_transport_put(transport);
 
 	return 0;
@@ -438,7 +435,7 @@ static int sctp_remaddr_seq_show(struct seq_file *seq, void *v)
 		 * The remote address (ADDR)
 		 */
 		tsp->af_specific->seq_dump_addr(seq, &tsp->ipaddr);
-		seq_printf(seq, " ");
+		seq_putc(seq, ' ');
 		/*
 		 * The association ID (ASSOC_ID)
 		 */
-- 
2.12.2

