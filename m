From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 24 Feb 2017 07:18:46 +0000
Subject: [PATCH net] sctp: set sin_port for addr param when checking duplicate address
Message-Id: <a46d62002d14e8ff4a25d647600bb3d038c2c772.1487920726.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

Commit b8607805dd15 ("sctp: not copying duplicate addrs to the assoc's
bind address list") tried to check for duplicate address before copying
to asoc's bind_addr list from global addr list.

But all the addrs' sin_ports in global addr list are 0 while the addrs'
sin_ports are bp->port in asoc's bind_addr list. It means even if it's
a duplicate address, af->cmp_addr will still return 0 as the their
sin_ports are different.

This patch is to fix it by setting the sin_port for addr param with
bp->port before comparing the addrs.

Fixes: b8607805dd15 ("sctp: not copying duplicate addrs to the assoc's bind address list")
Reported-by: Wei Chen <weichen@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/protocol.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 8227bbb..1b6d457 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -199,6 +199,7 @@ int sctp_copy_local_addr_list(struct net *net, struct sctp_bind_addr *bp,
 			      sctp_scope_t scope, gfp_t gfp, int copy_flags)
 {
 	struct sctp_sockaddr_entry *addr;
+	union sctp_addr laddr;
 	int error = 0;
 
 	rcu_read_lock();
@@ -220,7 +221,10 @@ int sctp_copy_local_addr_list(struct net *net, struct sctp_bind_addr *bp,
 		     !(copy_flags & SCTP_ADDR6_PEERSUPP)))
 			continue;
 
-		if (sctp_bind_addr_state(bp, &addr->a) != -1)
+		laddr = addr->a;
+		/* also works for setting ipv6 address port */
+		laddr.v4.sin_port = htons(bp->port);
+		if (sctp_bind_addr_state(bp, &laddr) != -1)
 			continue;
 
 		error = sctp_add_bind_addr(bp, &addr->a, sizeof(addr->a),
-- 
2.1.0

