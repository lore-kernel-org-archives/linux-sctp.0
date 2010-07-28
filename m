From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 28 Jul 2010 03:35:20 +0000
Subject: [PATCH next] sctp: fix IPv6 source address output routing with IPsec
Message-Id: <4C4FA578.9000607@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

When do IPv6 source address output routing, the fl.proto
is missing, with IPsec different router will be return.
This patch fixed it.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/ipv6.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index d4db450..0fbc4e2 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -286,6 +286,7 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 	memset(fl, 0, sizeof(fl));
 	ipv6_addr_copy(&fl->fl6_dst, &daddr->v6.sin6_addr);
 	fl->fl_ip_dport = daddr->v6.sin6_port;
+	fl->proto = IPPROTO_SCTP;
 	if (ipv6_addr_type(&daddr->v6.sin6_addr) & IPV6_ADDR_LINKLOCAL)
 		fl->oif = daddr->v6.sin6_scope_id;
 
-- 
1.6.5.2


