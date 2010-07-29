From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Thu, 29 Jul 2010 02:43:18 +0000
Subject: [PATCH] sctp: fix IPSTATS_MIB_OUTNOROUTES counter for SCTP over ipv6
Message-Id: <4C50EAC6.2020007@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

When transmitting a packet, if no router can be 
found, we should increase IPSTATS_MIB_OUTNOROUTES item
according to the address family type.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 net/sctp/output.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index a646681..5c09baa 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -571,7 +571,11 @@ out:
 	return err;
 no_route:
 	kfree_skb(nskb);
-	IP_INC_STATS_BH(&init_net, IPSTATS_MIB_OUTNOROUTES);
+
+	if (tp->af_specific->sa_family = AF_INET)
+		IP_INC_STATS_BH(&init_net, IPSTATS_MIB_OUTNOROUTES);
+	else
+		IP6_INC_STATS_BH(&init_net, NULL, IPSTATS_MIB_OUTNOROUTES);
 
 	/* FIXME: Returning the 'err' will effect all the associations
 	 * associated with a socket, although only one of the paths of the
-- 
1.6.3.3


