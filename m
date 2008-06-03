From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Date: Tue, 03 Jun 2008 05:41:39 +0000
Subject: [PATCH] SCTP: Move sctp_v4_dst_saddr out of loop
Message-Id: <4844D993.7090705@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav <vladislav.yasevich@hp.com>
Cc: netdev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, David Miller <davem@davemloft.net>

There's no need to execute sctp_v4_dst_saddr() for each
iteration, just move it out of loop.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 net/sctp/protocol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index c2dd65d..b51d980 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -470,11 +470,11 @@ static struct dst_entry *sctp_v4_get_dst(struct sctp_association *asoc,
 		/* Walk through the bind address list and look for a bind
 		 * address that matches the source address of the returned dst.
 		 */
+		sctp_v4_dst_saddr(&dst_saddr, dst, htons(bp->port));
 		rcu_read_lock();
 		list_for_each_entry_rcu(laddr, &bp->address_list, list) {
 			if (!laddr->valid || (laddr->state != SCTP_ADDR_SRC))
 				continue;
-			sctp_v4_dst_saddr(&dst_saddr, dst, htons(bp->port));
 			if (sctp_v4_cmp_addr(&dst_saddr, &laddr->a))
 				goto out_unlock;
 		}
-- 
1.5.3

