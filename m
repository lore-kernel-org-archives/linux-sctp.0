From: Brian Haley <brian.haley@hp.com>
Date: Fri, 02 Apr 2010 21:38:58 +0000
Subject: [PATCH] SCTP: Change to use ipv6_addr_copy()
Message-Id: <1270244338-4190-1-git-send-email-brian.haley@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <>
In-Reply-To: <>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Change SCTP IPv6 code to use ipv6_addr_copy()

Signed-off-by: Brian Haley <brian.haley@hp.com>
---
 net/sctp/ipv6.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 216d88f..db1c767 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -364,7 +364,7 @@ static void sctp_v6_copy_addrlist(struct list_head *addrlist,
 		if (addr) {
 			addr->a.v6.sin6_family = AF_INET6;
 			addr->a.v6.sin6_port = 0;
-			addr->a.v6.sin6_addr = ifp->addr;
+			ipv6_addr_copy(&addr->a.v6.sin6_addr, &ifp->addr);
 			addr->a.v6.sin6_scope_id = dev->ifindex;
 			addr->valid = 1;
 			INIT_LIST_HEAD(&addr->list);
@@ -405,7 +405,7 @@ static void sctp_v6_from_sk(union sctp_addr *addr, struct sock *sk)
 {
 	addr->v6.sin6_family = AF_INET6;
 	addr->v6.sin6_port = 0;
-	addr->v6.sin6_addr = inet6_sk(sk)->rcv_saddr;
+	ipv6_addr_copy(&addr->v6.sin6_addr, &inet6_sk(sk)->rcv_saddr);
 }
 
 /* Initialize sk->sk_rcv_saddr from sctp_addr. */
@@ -418,7 +418,7 @@ static void sctp_v6_to_sk_saddr(union sctp_addr *addr, struct sock *sk)
 		inet6_sk(sk)->rcv_saddr.s6_addr32[3]  			addr->v4.sin_addr.s_addr;
 	} else {
-		inet6_sk(sk)->rcv_saddr = addr->v6.sin6_addr;
+		ipv6_addr_copy(&inet6_sk(sk)->rcv_saddr, &addr->v6.sin6_addr);
 	}
 }
 
@@ -431,7 +431,7 @@ static void sctp_v6_to_sk_daddr(union sctp_addr *addr, struct sock *sk)
 		inet6_sk(sk)->daddr.s6_addr32[2] = htonl(0x0000ffff);
 		inet6_sk(sk)->daddr.s6_addr32[3] = addr->v4.sin_addr.s_addr;
 	} else {
-		inet6_sk(sk)->daddr = addr->v6.sin6_addr;
+		ipv6_addr_copy(&inet6_sk(sk)->daddr, &addr->v6.sin6_addr);
 	}
 }
 
-- 
1.5.4.3

