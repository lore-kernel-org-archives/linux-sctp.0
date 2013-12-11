From: Wang Weidong <wangweidong1@huawei.com>
Date: Wed, 11 Dec 2013 01:50:40 +0000
Subject: [PATCH v7 3/3] sctp: fix up a spacing
Message-Id: <1386726640-9584-4-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1386726640-9584-1-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1386726640-9584-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net
Cc: dborkman@redhat.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

fix up spacing of proc_sctp_do_hmac_alg for according to the
proc_sctp_do_rto_min[max] in sysctl.c

Suggested-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/sctp/sysctl.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 43b5e32..b0565af 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -56,10 +56,8 @@ extern long sysctl_sctp_mem[3];
 extern int sysctl_sctp_rmem[3];
 extern int sysctl_sctp_wmem[3];
 
-static int proc_sctp_do_hmac_alg(struct ctl_table *ctl,
-				int write,
+static int proc_sctp_do_hmac_alg(struct ctl_table *ctl, int write,
 				void __user *buffer, size_t *lenp,
-
 				loff_t *ppos);
 static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
 				void __user *buffer, size_t *lenp,
@@ -301,8 +299,7 @@ static struct ctl_table sctp_net_table[] = {
 	{ /* sentinel */ }
 };
 
-static int proc_sctp_do_hmac_alg(struct ctl_table *ctl,
-				int write,
+static int proc_sctp_do_hmac_alg(struct ctl_table *ctl, int write,
 				void __user *buffer, size_t *lenp,
 				loff_t *ppos)
 {
-- 
1.7.12


