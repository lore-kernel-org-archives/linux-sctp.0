From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 08 Jul 2019 16:59:40 +0000
Subject: [PATCH net-next] sctp: remove rcu_read_lock from sctp_bind_addr_state
Message-Id: <30ff9e8a45fa0c64d1c71bc13e217f3374f6120e.1562605180.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

sctp_bind_addr_state() is called either in packet rcv path or
by sctp_copy_local_addr_list(), which are under rcu_read_lock.
So there's no need to call it again in sctp_bind_addr_state().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/bind_addr.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index f54333c..53bc615 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -393,24 +393,19 @@ int sctp_bind_addr_state(const struct sctp_bind_addr *bp,
 {
 	struct sctp_sockaddr_entry *laddr;
 	struct sctp_af *af;
-	int state = -1;
 
 	af = sctp_get_af_specific(addr->sa.sa_family);
 	if (unlikely(!af))
-		return state;
+		return -1;
 
-	rcu_read_lock();
 	list_for_each_entry_rcu(laddr, &bp->address_list, list) {
 		if (!laddr->valid)
 			continue;
-		if (af->cmp_addr(&laddr->a, addr)) {
-			state = laddr->state;
-			break;
-		}
+		if (af->cmp_addr(&laddr->a, addr))
+			return laddr->state;
 	}
-	rcu_read_unlock();
 
-	return state;
+	return -1;
 }
 
 /* Find the first address in the bind address list that is not present in
-- 
2.1.0
