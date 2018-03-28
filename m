From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 28 Mar 2018 14:14:56 +0000
Subject: [PATCH] [net-next] sctp: fix unused lable warning
Message-Id: <20180328141512.3083992-1-arnd@arndb.de>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@ZenIV.linux.org.uk>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

The proc file cleanup left a label possibly unused:

net/sctp/protocol.c: In function 'sctp_defaults_init':
net/sctp/protocol.c:1304:1: error: label 'err_init_proc' defined but not used [-Werror=unused-label]

This adds an #ifdef around it to match the respective 'goto'.

Fixes: d47d08c8ca05 ("sctp: use proc_remove_subtree()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/sctp/protocol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index c1c64b78c39d..d685f8456762 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1301,8 +1301,10 @@ static int __net_init sctp_defaults_init(struct net *net)
 
 	return 0;
 
+#ifdef CONFIG_PROC_FS
 err_init_proc:
 	cleanup_sctp_mibs(net);
+#endif
 err_init_mibs:
 	sctp_sysctl_net_unregister(net);
 err_sysctl_register:
-- 
2.9.0

