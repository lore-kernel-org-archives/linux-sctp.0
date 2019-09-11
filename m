From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Wed, 11 Sep 2019 16:02:39 +0000
Subject: [PATCH] sctp: Fix the link time qualifier of 'sctp_ctrlsock_exit()'
Message-Id: <20190911160239.10734-1-christophe.jaillet@wanadoo.fr>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net, vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>

The '.exit' functions from 'pernet_operations' structure should be marked
as __net_exit, not __net_init.

Fixes: 8e2d61e0aed2 ("sctp: fix race on protocol/netns initialization")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/sctp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 2d47adcb4cbe..53746ffeeca3 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1336,7 +1336,7 @@ static int __net_init sctp_ctrlsock_init(struct net *net)
 	return status;
 }
 
-static void __net_init sctp_ctrlsock_exit(struct net *net)
+static void __net_exit sctp_ctrlsock_exit(struct net *net)
 {
 	/* Free the control endpoint.  */
 	inet_ctl_sock_destroy(net->sctp.ctl_sock);
-- 
2.20.1
