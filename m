From: wangweidong <wangweidong1@huawei.com>
Date: Sat, 30 Nov 2013 10:23:52 +0000
Subject: [PATCH] sctp: check the rto_min and rto_max
Message-Id: <5299BCB8.6070409@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, nhorman@tuxdriver.com, davem@davemloft.net
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, dingtianhong@huawei.com

rto_min should be smaller than rto_max while rto_max should be larger
than rto_min. so just add the check.

Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/sctp/sysctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 6b36561..7637e8e 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -104,7 +104,7 @@ static struct ctl_table sctp_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1         = &one,
-		.extra2         = &timer_max
+		.extra2         = &init_net.sctp.rto_max
 	},
 	{
 		.procname	= "rto_max",
@@ -112,7 +112,7 @@ static struct ctl_table sctp_net_table[] = {
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1         = &one,
+		.extra1         = &init_net.sctp.rto_min,
 		.extra2         = &timer_max
 	},
 	{
-- 
1.7.12


