From: Wang Weidong <wangweidong1@huawei.com>
Date: Thu, 19 Dec 2013 02:02:42 +0000
Subject: [PATCH net-next v2] sctp: remove the never used 'return' and redundant 'break'
Message-Id: <52B253C2.8070407@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52B168E0.1060108@huawei.com>
In-Reply-To: <52B168E0.1060108@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

In switch() had do return, and never use the 'return NULL'. The
'break' after return or goto has no effect. Remove it.

v2: make it more readable as suggested by Neil.

Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/sctp/input.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 042ec6c..476bc8d 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1119,19 +1119,10 @@ static struct sctp_association *__sctp_rcv_lookup_harder(struct net *net,
 		return NULL;
 
 	/* If this is INIT/INIT-ACK look inside the chunk too. */
-	switch (ch->type) {
-	case SCTP_CID_INIT:
-	case SCTP_CID_INIT_ACK:
+	if (ch->type = SCTP_CID_INIT || ch->type = SCTP_CID_INIT_ACK)
 		return __sctp_rcv_init_lookup(net, skb, laddr, transportp);
-		break;
 
-	default:
-		return __sctp_rcv_walk_lookup(net, skb, laddr, transportp);
-		break;
-	}
-
-
-	return NULL;
+	return __sctp_rcv_walk_lookup(net, skb, laddr, transportp);
 }
 
 /* Lookup an association for an inbound skb. */
-- 
1.7.12



