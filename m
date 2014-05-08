From: Wang Weidong <wangweidong1@huawei.com>
Date: Thu, 08 May 2014 12:55:02 +0000
Subject: [net-next 2/2] sctp: add a checking for sctp_sysctl_net_register
Message-Id: <1399553702-7960-3-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1399553702-7960-1-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1399553702-7960-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net, vyasevich@gmail.com, nhorman@tuxdriver.com, dborkman@redhat.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

When register_net_sysctl failed, we should free the
sysctl_table.

Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/sctp/sysctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index ee80eb4..7e5eb75 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -447,6 +447,10 @@ int sctp_sysctl_net_register(struct net *net)
 		table[i].data += (char *)(&net->sctp) - (char *)&init_net.sctp;
 
 	net->sctp.sysctl_header = register_net_sysctl(net, "net/sctp", table);
+	if (net->sctp.sysctl_header = NULL) {
+		kfree(table);
+		return -ENOMEM;
+	}
 	return 0;
 }
 
-- 
1.7.12


