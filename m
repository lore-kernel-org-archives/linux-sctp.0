From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 29 Nov 2018 06:49:28 +0000
Subject: [PATCHv2 net] sctp: hold transport before accessing its asoc in sctp_hash_transport
Message-Id: <92d9c2b54a60494142909f1fbb8c187aa317ab60.1543474168.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <01212b7ece946393c21023a3bde5a4c712ae0293.1543473847.git.lucien.xin@gmail.com>
In-Reply-To: <01212b7ece946393c21023a3bde5a4c712ae0293.1543473847.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

In sctp_hash_transport, it dereferences a transport's asoc only under
rcu_read_lock. Without holding the transport, its asoc could be freed
already, which leads to a use-after-free panic.

A similar fix as Commit bab1be79a516 ("sctp: hold transport before
accessing its asoc in sctp_transport_get_next") is needed to hold
the transport before accessing its asoc in sctp_hash_transport.

Note that as rhlist keeps the lists to a small size, this extra
atomic operation won't cause a noticeable latency on inserting
a transport. Yet it's not in a datapath.

v1->v2:
  - improve the changelog.

Fixes: cd2b70875058 ("sctp: check duplicate node before inserting a new transport")
Reported-by: syzbot+0b05d8aa7cb185107483@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/input.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index ce7351c..c2c0816 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -896,11 +896,16 @@ int sctp_hash_transport(struct sctp_transport *t)
 	list = rhltable_lookup(&sctp_transport_hashtable, &arg,
 			       sctp_hash_params);
 
-	rhl_for_each_entry_rcu(transport, tmp, list, node)
+	rhl_for_each_entry_rcu(transport, tmp, list, node) {
+		if (!sctp_transport_hold(transport))
+			continue;
 		if (transport->asoc->ep = t->asoc->ep) {
+			sctp_transport_put(transport);
 			rcu_read_unlock();
 			return -EEXIST;
 		}
+		sctp_transport_put(transport);
+	}
 	rcu_read_unlock();
 
 	err = rhltable_insert_key(&sctp_transport_hashtable, &arg,
-- 
2.1.0
