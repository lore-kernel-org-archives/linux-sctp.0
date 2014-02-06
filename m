From: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>
Date: Thu, 06 Feb 2014 07:30:10 +0000
Subject: [PATCH] net: sctp: fix initialization of local source address on accepted ipv6 sockets
Message-Id: <52F33A02.2040902@nsn.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>

commit 	efe4208f47f907b86f528788da711e8ab9dea44d:
'ipv6: make lookups simpler and faster' broke initialization of local source
address on accepted ipv6 sockets. Before the mentioned commit receive address
was copied along with the contents of ipv6_pinfo in sctp_v6_create_accept_sk.
Now when it is moved, it has to be copied separately.

This also fixes lksctp's ipv6 regression in a sense that test_getname_v6, TC5 -
'getsockname on a connected server socket' now passes.

Signed-off-by: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>

--- net-next.orig/net/sctp/ipv6.c
+++ net-next/net/sctp/ipv6.c
@@ -662,6 +662,8 @@ static struct sock *sctp_v6_create_accep
 	 */
 	sctp_v6_to_sk_daddr(&asoc->peer.primary_addr, newsk);
 
+	newsk->sk_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
+
 	sk_refcnt_debug_inc(newsk);
 
 	if (newsk->sk_prot->init(newsk)) {
