From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 22 Jul 2016 09:38:51 +0000
Subject: [PATCH net-next] sctp: support ipv6 nonlocal bind
Message-Id: <b3a6fd04f36bcfc5557d70ba79cddfc9c5d33b3c.1469180331.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, davem@davemloft.net

This patch makes sctp support ipv6 nonlocal bind by adding
sp->inet.freebind and net->ipv6.sysctl.ip_nonlocal_bind
check in sctp_v6_available as what sctp did to support
ipv4 nonlocal bind (commit cdac4e077489).

Reported-by: Shijoe George <spanjikk@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/ipv6.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index ae6f1a2..660c4a4 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -560,6 +560,7 @@ static int sctp_v6_is_any(const union sctp_addr *addr)
 static int sctp_v6_available(union sctp_addr *addr, struct sctp_sock *sp)
 {
 	int type;
+	struct net *net = sock_net(&sp->inet.sk);
 	const struct in6_addr *in6 = (const struct in6_addr *)&addr->v6.sin6_addr;
 
 	type = ipv6_addr_type(in6);
@@ -574,7 +575,8 @@ static int sctp_v6_available(union sctp_addr *addr, struct sctp_sock *sp)
 	if (!(type & IPV6_ADDR_UNICAST))
 		return 0;
 
-	return ipv6_chk_addr(sock_net(&sp->inet.sk), in6, NULL, 0);
+	return sp->inet.freebind || net->ipv6.sysctl.ip_nonlocal_bind ||
+		ipv6_chk_addr(net, in6, NULL, 0);
 }
 
 /* This function checks if the address is a valid address to be used for
-- 
2.1.0

