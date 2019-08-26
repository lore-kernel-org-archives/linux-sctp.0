From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 26 Aug 2019 08:30:03 +0000
Subject: [PATCH net-next 2/3] sctp: allow users to set netns ecn flag with sysctl
Message-Id: <fdbf487b2e1b255b1bbf457b3112979c33b53066.1566807985.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1566807985.git.lucien.xin@gmail.com>
 <fc26e1e3bd1579a944320dc54d5cdbdec46ac61d.1566807985.git.lucien.xin@gmail.com>
In-Reply-To: <fc26e1e3bd1579a944320dc54d5cdbdec46ac61d.1566807985.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

sysctl net.sctp.ecn_enable is added in this patch. It will allow
users to change the default sctp ecn flag, net.sctp.ecn_enable.

This feature was also required on this thread:

  http://lkml.iu.edu/hypermail/linux/kernel/0812.1/01858.html

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sysctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 1250751..238cf17 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -278,6 +278,13 @@ static struct ctl_table sctp_net_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "ecn_enable",
+		.data		= &init_net.sctp.ecn_enable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
 		.procname	= "addr_scope_policy",
 		.data		= &init_net.sctp.scope_policy,
 		.maxlen		= sizeof(int),
-- 
2.1.0
