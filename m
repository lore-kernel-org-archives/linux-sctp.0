From: Dan Rosenberg <drosenberg@vsecurity.com>
Date: Fri, 12 Nov 2010 01:06:55 +0000
Subject: [PATCH 1/10] Fix leaking of kernel heap addresses in net/
Message-Id: <1289524015.5167.65.camel@dan>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Oliver Hartkopp <socketcan@hartkopp.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Urs Thuermann <urs.thuermann@volkswagen.de>, Hideaki

diff --git a/net/atm/proc.c b/net/atm/proc.c
index f85da07..21ec2ba 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -191,7 +191,7 @@ static void vcc_info(struct seq_file *seq, struct atm_vcc *vcc)
 {
 	struct sock *sk = sk_atm(vcc);
 
-	seq_printf(seq, "%p ", vcc);
+	seq_printf(seq, "%lu ", sock_i_ino(sk));
 	if (!vcc->dev)
 		seq_printf(seq, "Unassigned    ");
 	else



