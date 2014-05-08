From: Wang Weidong <wangweidong1@huawei.com>
Date: Thu, 08 May 2014 07:55:05 +0000
Subject: [PATCH net-next] sctp: add a checking for sctp_sysctl_net_register
Message-Id: <536B3859.2050908@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>
Cc: Daniel Borkmann <dborkman@redhat.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

When register_net_sysctl failed, we should free the
sysctl_table while the net_namespace is not init_net.

Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/sctp/sysctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 844d2b0..4c17694 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -450,6 +450,11 @@ int sctp_sysctl_net_register(struct net *net)
 	}
 
 	net->sctp.sysctl_header = register_net_sysctl(net, "net/sctp", table);
+	if (net->sctp.sysctl_header = NULL) {
+		if (!net_eq(net, &init_net))
+			kfree(table);
+		return -ENOMEM;
+	}
 	return 0;
 }
 
-- 
1.7.12


