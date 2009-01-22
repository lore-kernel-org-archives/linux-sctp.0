From: Joe Perches <joe@perches.com>
Date: Thu, 22 Jan 2009 21:08:26 +0000
Subject: [PATCH] sctp/ipv6.c: use ipv6_addr_copy
Message-Id: <1232658506.15489.63.camel@localhost>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sridhar Samudrala <sri@us.ibm.com>, Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Networking Team <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index ceaa4aa..7862275 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -97,8 +97,7 @@ static int sctp_inet6addr_event(struct notifier_block *this, unsigned long ev,
 		if (addr) {
 			addr->a.v6.sin6_family = AF_INET6;
 			addr->a.v6.sin6_port = 0;
-			memcpy(&addr->a.v6.sin6_addr, &ifa->addr,
-				 sizeof(struct in6_addr));
+			ipv6_addr_copy(&addr->a.v6.sin6_addr, &ifa->addr);
 			addr->a.v6.sin6_scope_id = ifa->idev->dev->ifindex;
 			addr->valid = 1;
 			spin_lock_bh(&sctp_local_addr_lock);


