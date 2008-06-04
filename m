From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 04 Jun 2008 18:25:47 +0000
Subject: [PATCH 2/6] SCTP: Move sctp_v4_dst_saddr out of loop
Message-Id: <1212603951-24932-3-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1212603951-24932-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1212603951-24932-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, davem@davemloft.net, Gui Jianfeng <guijianfeng@cn.fujitsu.com>, Vlad Yasevich <vladislav.yasevich@hp.com>

From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

There's no need to execute sctp_v4_dst_saddr() for each
iteration, just move it out of loop.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/protocol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 0ec234b..040e489 100644
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
1.5.3.5

