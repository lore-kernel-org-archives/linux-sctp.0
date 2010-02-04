From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 04 Feb 2010 09:07:41 +0000
Subject: [PATCH] sctp: missing set src and dest port while lookup output route
Message-Id: <4B6A8E5D.9080804@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

While lookup the output route, we do not set the src and dest
port. This will cause we got a wrong route if we had set the
outbund transport to IPsec with src or dst port.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/protocol.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index a3c8988..87b5eea 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -474,13 +474,17 @@ static struct dst_entry *sctp_v4_get_dst(struct sctp_association *asoc,
 
 	memset(&fl, 0x0, sizeof(struct flowi));
 	fl.fl4_dst  = daddr->v4.sin_addr.s_addr;
+	fl.fl_ip_dport = daddr->v4.sin_port;
 	fl.proto = IPPROTO_SCTP;
 	if (asoc) {
 		fl.fl4_tos = RT_CONN_FLAGS(asoc->base.sk);
 		fl.oif = asoc->base.sk->sk_bound_dev_if;
+		fl.fl_ip_sport = htons(asoc->base.bind_addr.port);
 	}
-	if (saddr)
+	if (saddr) {
 		fl.fl4_src = saddr->v4.sin_addr.s_addr;
+		fl.fl_ip_sport = saddr->v4.sin_port;
+	}
 
 	SCTP_DEBUG_PRINTK("%s: DST:%pI4, SRC:%pI4 - ",
 			  __func__, &fl.fl4_dst, &fl.fl4_src);
@@ -528,6 +532,7 @@ static struct dst_entry *sctp_v4_get_dst(struct sctp_association *asoc,
 		if ((laddr->state = SCTP_ADDR_SRC) &&
 		    (AF_INET = laddr->a.sa.sa_family)) {
 			fl.fl4_src = laddr->a.v4.sin_addr.s_addr;
+			fl.fl_ip_sport = laddr->a.v4.sin_port;
 			if (!ip_route_output_key(&init_net, &rt, &fl)) {
 				dst = &rt->u.dst;
 				goto out_unlock;
-- 
1.6.5.2


