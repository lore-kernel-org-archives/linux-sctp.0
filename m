From: Wang Weidong <wangweidong1@huawei.com>
Date: Wed, 11 Dec 2013 01:50:39 +0000
Subject: [PATCH v7 2/3] sctp: add check rto_min and rto_max in sysctl
Message-Id: <1386726640-9584-3-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1386726640-9584-1-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1386726640-9584-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net
Cc: dborkman@redhat.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

rto_min should be smaller than rto_max while rto_max should be larger
than rto_min. Add two proc_handler for the checking.

Suggested-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/sctp/sysctl.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 4 deletions(-)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 6b36561..43b5e32 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -61,6 +61,13 @@ static int proc_sctp_do_hmac_alg(struct ctl_table *ctl,
 				void __user *buffer, size_t *lenp,
 
 				loff_t *ppos);
+static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
+				void __user *buffer, size_t *lenp,
+				loff_t *ppos);
+static int proc_sctp_do_rto_max(struct ctl_table *ctl, int write,
+				void __user *buffer, size_t *lenp,
+				loff_t *ppos);
+
 static struct ctl_table sctp_table[] = {
 	{
 		.procname	= "sctp_mem",
@@ -102,17 +109,17 @@ static struct ctl_table sctp_net_table[] = {
 		.data		= &init_net.sctp.rto_min,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_sctp_do_rto_min,
 		.extra1         = &one,
-		.extra2         = &timer_max
+		.extra2         = &init_net.sctp.rto_max
 	},
 	{
 		.procname	= "rto_max",
 		.data		= &init_net.sctp.rto_max,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1         = &one,
+		.proc_handler	= proc_sctp_do_rto_max,
+		.extra1         = &init_net.sctp.rto_min,
 		.extra2         = &timer_max
 	},
 	{
@@ -342,6 +349,60 @@ static int proc_sctp_do_hmac_alg(struct ctl_table *ctl,
 	return ret;
 }
 
+static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
+				void __user *buffer, size_t *lenp,
+				loff_t *ppos)
+{
+	struct net *net = current->nsproxy->net_ns;
+	int new_value;
+	struct ctl_table tbl;
+	unsigned int min = *(unsigned int *) ctl->extra1;
+	unsigned int max = *(unsigned int *) ctl->extra2;
+	int ret;
+
+	memset(&tbl, 0, sizeof(struct ctl_table));
+	tbl.maxlen = sizeof(unsigned int);
+
+	if (write)
+		tbl.data = &new_value;
+	else
+		tbl.data = &net->sctp.rto_min;
+	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
+	if (write) {
+		if (ret || new_value > max || new_value < min)
+			return -EINVAL;
+		net->sctp.rto_min = new_value;
+	}
+	return ret;
+}
+
+static int proc_sctp_do_rto_max(struct ctl_table *ctl, int write,
+				void __user *buffer, size_t *lenp,
+				loff_t *ppos)
+{
+	struct net *net = current->nsproxy->net_ns;
+	int new_value;
+	struct ctl_table tbl;
+	unsigned int min = *(unsigned int *) ctl->extra1;
+	unsigned int max = *(unsigned int *) ctl->extra2;
+	int ret;
+
+	memset(&tbl, 0, sizeof(struct ctl_table));
+	tbl.maxlen = sizeof(unsigned int);
+
+	if (write)
+		tbl.data = &new_value;
+	else
+		tbl.data = &net->sctp.rto_max;
+	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
+	if (write) {
+		if (ret || new_value > max || new_value < min)
+			return -EINVAL;
+		net->sctp.rto_max = new_value;
+	}
+	return ret;
+}
+
 int sctp_sysctl_net_register(struct net *net)
 {
 	struct ctl_table *table;
-- 
1.7.12


