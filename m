From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 22 Aug 2013 15:12:50 +0000
Subject: [PATCH net-next] net: sctp_probe: simplify code by using %pISc format specifier
Message-Id: <1377184370-13721-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

We can simply use the %pISc format specifier that was recently added
and thus remove some code that distinguishes between IPv4 and IPv6.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 net/sctp/probe.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/sctp/probe.c b/net/sctp/probe.c
index e62c225..cd72ae5 100644
--- a/net/sctp/probe.c
+++ b/net/sctp/probe.c
@@ -155,13 +155,8 @@ static sctp_disposition_t jsctp_sf_eat_sack(struct net *net,
 			if (sp = asoc->peer.primary_path)
 				printl("*");
 
-			if (sp->ipaddr.sa.sa_family = AF_INET)
-				printl("%pI4 ", &sp->ipaddr.v4.sin_addr);
-			else
-				printl("%pI6 ", &sp->ipaddr.v6.sin6_addr);
-
-			printl("%2u %8u %8u %8u %8u %8u ",
-			       sp->state, sp->cwnd, sp->ssthresh,
+			printl("%pISc %2u %8u %8u %8u %8u %8u ",
+			       &sp->ipaddr, sp->state, sp->cwnd, sp->ssthresh,
 			       sp->flight_size, sp->partial_bytes_acked,
 			       sp->pathmtu);
 		}
-- 
1.7.11.7

