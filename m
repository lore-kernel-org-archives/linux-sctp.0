From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 23 Jan 2018 10:22:25 +0000
Subject: [PATCH net-next] sctp: reset ret in again path in sctp_for_each_transport
Message-Id: <07dcfcd8098979f6693426fd562867ffa67dd65b.1516702945.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Commit 97a6ec4ac021 ("rhashtable: Change rhashtable_walk_start to
return void") only initialized ret for the first time, when going
to again path, the next tsp could be NULL. Without resetting ret,
cb_done would be called with tsp as NULL.

A kernel crash was caused by this when running sctpdiag testcase
in sctp-tests.

Note that this issue doesn't affect net.git yet.

Fixes: 97a6ec4ac021 ("rhashtable: Change rhashtable_walk_start to return void")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 7ff444e..a40fa53 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4860,9 +4860,10 @@ int sctp_for_each_transport(int (*cb)(struct sctp_transport *, void *),
 			    struct net *net, int *pos, void *p) {
 	struct rhashtable_iter hti;
 	struct sctp_transport *tsp;
-	int ret = 0;
+	int ret;
 
 again:
+	ret = 0;
 	sctp_transport_walk_start(&hti);
 
 	tsp = sctp_transport_get_idx(net, &hti, *pos + 1);
-- 
2.1.0

