From: Wang Weidong <wangweidong1@huawei.com>
Date: Mon, 02 Dec 2013 06:51:45 +0000
Subject: [PATCH] sctp: make the max_burst min value to 1
Message-Id: <529C2E01.3090005@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, nhorman@tuxdriver.com, David Miller <davem@davemloft.net>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, dingtianhong@huawei.com

From: Wang Weidong <wangweidong1@huawei.com>

when I setted the max_burst to 0, do the lksctp-tools I got hang.
I found sctp_transport_burst_limited would make the cwnd to 0.
so I make the max_burst min value to 1.
Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/sctp/sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 7637e8e..46832d3 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -135,7 +135,7 @@ static struct ctl_table sctp_net_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
+		.extra1		= &one,
 		.extra2		= &int_max
 	},
 	{
-- 
1.7.12

