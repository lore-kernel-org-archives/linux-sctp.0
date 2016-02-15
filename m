From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 15 Feb 2016 06:28:04 +0000
Subject: [PATCH net 2/3] sctp: remove rcu_read_lock in sctp_seq_dump_remote_addrs()
Message-Id: <4e75be65afef4ccacca08e83316a8fbe811d5b1f.1455517541.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1455517541.git.lucien.xin@gmail.com>
 <c805e4a1994f53947351e8d4dd79609fd206e807.1455517541.git.lucien.xin@gmail.com>
In-Reply-To: <c805e4a1994f53947351e8d4dd79609fd206e807.1455517541.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, davem@davemloft.net

sctp_seq_dump_remote_addrs is only called by sctp_assocs_seq_show()
and it has been protected by rcu_read_lock that is from
rhashtable_walk_start().

So we will remove this one.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/proc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index ded7d93..cfc3c71 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -161,7 +161,6 @@ static void sctp_seq_dump_remote_addrs(struct seq_file *seq, struct sctp_associa
 	struct sctp_af *af;
 
 	primary = &assoc->peer.primary_addr;
-	rcu_read_lock();
 	list_for_each_entry_rcu(transport, &assoc->peer.transport_addr_list,
 			transports) {
 		addr = &transport->ipaddr;
@@ -172,7 +171,6 @@ static void sctp_seq_dump_remote_addrs(struct seq_file *seq, struct sctp_associa
 		}
 		af->seq_dump_addr(seq, addr);
 	}
-	rcu_read_unlock();
 }
 
 static void *sctp_eps_seq_start(struct seq_file *seq, loff_t *pos)
-- 
2.1.0

