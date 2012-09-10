From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Mon, 10 Sep 2012 13:22:18 +0000
Subject: [PATCH net-next v2 4/4] ipv6: use DST_* macro to set obselete field
Message-Id: <1347283338-4249-5-git-send-email-nicolas.dichtel@6wind.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20120907.144828.97793990734588625.davem@davemloft.net>
 <1347283338-4249-1-git-send-email-nicolas.dichtel@6wind.com>
In-Reply-To: <1347283338-4249-1-git-send-email-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, davem@davemloft.net, eric.dumazet@gmail.com
Cc: sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/ipv6/route.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index db7b78f..99b41cc 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -226,7 +226,7 @@ static struct rt6_info ip6_null_entry_template = {
 	.dst = {
 		.__refcnt	= ATOMIC_INIT(1),
 		.__use		= 1,
-		.obsolete	= -1,
+		.obsolete	= DST_OBSOLETE_FORCE_CHK,
 		.error		= -ENETUNREACH,
 		.input		= ip6_pkt_discard,
 		.output		= ip6_pkt_discard_out,
@@ -246,7 +246,7 @@ static struct rt6_info ip6_prohibit_entry_template = {
 	.dst = {
 		.__refcnt	= ATOMIC_INIT(1),
 		.__use		= 1,
-		.obsolete	= -1,
+		.obsolete	= DST_OBSOLETE_FORCE_CHK,
 		.error		= -EACCES,
 		.input		= ip6_pkt_prohibit,
 		.output		= ip6_pkt_prohibit_out,
@@ -261,7 +261,7 @@ static struct rt6_info ip6_blk_hole_entry_template = {
 	.dst = {
 		.__refcnt	= ATOMIC_INIT(1),
 		.__use		= 1,
-		.obsolete	= -1,
+		.obsolete	= DST_OBSOLETE_FORCE_CHK,
 		.error		= -EINVAL,
 		.input		= dst_discard,
 		.output		= dst_discard,
-- 
1.7.12

