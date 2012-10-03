From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Wed, 03 Oct 2012 15:43:21 +0000
Subject: [RFC PATCH 1/2] sctp: fix a typo in prototype of __sctp_rcv_lookup()
Message-Id: <1349279002-4008-1-git-send-email-nicolas.dichtel@6wind.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, vyasevich@gmail.com
Cc: netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>

Just to avoid confusion when people only reads this prototype.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/sctp/input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 25dfe73..8bd3c27 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -68,8 +68,8 @@
 static int sctp_rcv_ootb(struct sk_buff *);
 static struct sctp_association *__sctp_rcv_lookup(struct net *net,
 				      struct sk_buff *skb,
-				      const union sctp_addr *laddr,
 				      const union sctp_addr *paddr,
+				      const union sctp_addr *laddr,
 				      struct sctp_transport **transportp);
 static struct sctp_endpoint *__sctp_rcv_lookup_endpoint(struct net *net,
 						const union sctp_addr *laddr);
-- 
1.7.12

