From: Thomas Graf <tgraf@suug.ch>
Date: Thu, 06 Dec 2012 17:34:26 +0000
Subject: [PATCH] sctp: proc: protect bind_addr->address_list accesses with rcu_read_lock()
Message-Id: <a803093c70e857e8e01e554288ee79f66f7acda4.1354814846.git.tgraf@suug.ch>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org
Cc: netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

address_list is protected via the socket lock or RCU. Since we don't want
to take the socket lock for each assoc we dump in procfs a RCU read-side
critical section must be entered.

Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Thomas Graf <tgraf@suug.ch>
---
 net/sctp/proc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index 9966e7b..ec9b0c8 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -139,7 +139,8 @@ static void sctp_seq_dump_local_addrs(struct seq_file *seq, struct sctp_ep_commo
 	    primary = &peer->saddr;
 	}
 
-	list_for_each_entry(laddr, &epb->bind_addr.address_list, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(laddr, &epb->bind_addr.address_list, list) {
 		addr = &laddr->a;
 		af = sctp_get_af_specific(addr->sa.sa_family);
 		if (primary && af->cmp_addr(addr, primary)) {
@@ -147,6 +148,7 @@ static void sctp_seq_dump_local_addrs(struct seq_file *seq, struct sctp_ep_commo
 		}
 		af->seq_dump_addr(seq, addr);
 	}
+	rcu_read_unlock();
 }
 
 /* Dump remote addresses of an association. */
-- 
1.7.11.7

