From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 19 Aug 2016 11:30:21 +0000
Subject: [PATCH net 1/2] sctp: reduce indent level in sctp_copy_local_addr_list
Message-Id: <4d3c7b176bc8d5c48807ed60d83793c9d02e3757.1471605833.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1471605833.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1471605833.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net

This patch is to reduce indent level by using continue when the addr
is not allowed, and also drop end_copy by using break.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/protocol.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 7b523e3..da5d82b 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -205,26 +205,27 @@ int sctp_copy_local_addr_list(struct net *net, struct sctp_bind_addr *bp,
 	list_for_each_entry_rcu(addr, &net->sctp.local_addr_list, list) {
 		if (!addr->valid)
 			continue;
-		if (sctp_in_scope(net, &addr->a, scope)) {
-			/* Now that the address is in scope, check to see if
-			 * the address type is really supported by the local
-			 * sock as well as the remote peer.
-			 */
-			if ((((AF_INET = addr->a.sa.sa_family) &&
-			      (copy_flags & SCTP_ADDR4_PEERSUPP))) ||
-			    (((AF_INET6 = addr->a.sa.sa_family) &&
-			      (copy_flags & SCTP_ADDR6_ALLOWED) &&
-			      (copy_flags & SCTP_ADDR6_PEERSUPP)))) {
-				error = sctp_add_bind_addr(bp, &addr->a,
-						    sizeof(addr->a),
-						    SCTP_ADDR_SRC, GFP_ATOMIC);
-				if (error)
-					goto end_copy;
-			}
-		}
+		if (!sctp_in_scope(net, &addr->a, scope))
+			continue;
+
+		/* Now that the address is in scope, check to see if
+		 * the address type is really supported by the local
+		 * sock as well as the remote peer.
+		 */
+		if (addr->a.sa.sa_family = AF_INET &&
+		    !(copy_flags & SCTP_ADDR4_PEERSUPP))
+			continue;
+		if (addr->a.sa.sa_family = AF_INET6 &&
+		    (!(copy_flags & SCTP_ADDR6_ALLOWED) ||
+		     !(copy_flags & SCTP_ADDR6_PEERSUPP)))
+			continue;
+
+		error = sctp_add_bind_addr(bp, &addr->a, sizeof(addr->a),
+					   SCTP_ADDR_SRC, GFP_ATOMIC);
+		if (error)
+			break;
 	}
 
-end_copy:
 	rcu_read_unlock();
 	return error;
 }
-- 
2.1.0

