From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 28 Feb 2016 02:03:51 +0000
Subject: [PATCH net] sctp: lack the check for ports in sctp_v6_cmp_addr
Message-Id: <415cb449b7811635a13245e5ec99a5679516524a.1456625031.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, davem@davemloft.net

As the member .cmp_addr of sctp_af_inet6, sctp_v6_cmp_addr should also check
the port of addresses, just like sctp_v4_cmp_addr, cause it's invoked by
sctp_cmp_addr_exact().

Now sctp_v6_cmp_addr just check the port when two addresses have different
family, and lack the port check for two ipv6 addresses. that will make
sctp_hash_cmp() cannot work well.

so fix it by adding ports comparison in sctp_v6_cmp_addr().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/ipv6.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index ec52912..ce46f1c 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -526,6 +526,8 @@ static int sctp_v6_cmp_addr(const union sctp_addr *addr1,
 		}
 		return 0;
 	}
+	if (addr1->v6.sin6_port != addr2->v6.sin6_port)
+		return 0;
 	if (!ipv6_addr_equal(&addr1->v6.sin6_addr, &addr2->v6.sin6_addr))
 		return 0;
 	/* If this is a linklocal address, compare the scope_id. */
-- 
2.1.0

