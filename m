From: Wang Weidong <wangweidong1@huawei.com>
Date: Thu, 12 Dec 2013 12:32:36 +0000
Subject: [PATCH] sctp: loading sctp when load sctp_probe
Message-Id: <52A9ACE4.3080506@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, David Miller <davem@davemloft.net>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

when I modprobe sctp_probe, it failed with "FATAL: ". I found that 
sctp should load before sctp_probe register jprobe. So I add a
sctp_setup_jprobe for loading 'sctp' when first failed to register
jprobe, just do this similar to dccp_probe.

Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/sctp/probe.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/sctp/probe.c b/net/sctp/probe.c
index 53c452e..cd9565a 100644
--- a/net/sctp/probe.c
+++ b/net/sctp/probe.c
@@ -182,6 +182,17 @@ static struct jprobe sctp_recv_probe = {
 	.entry	= jsctp_sf_eat_sack,
 };
 
+static __init int sctp_setup_jprobe(void)
+{
+	int ret = register_jprobe(&sctp_recv_probe);
+
+	if (ret) {
+		request_module("sctp");
+		ret = register_jprobe(&sctp_recv_probe);
+	}
+	return ret;
+}
+
 static __init int sctpprobe_init(void)
 {
 	int ret = -ENOMEM;
@@ -202,7 +213,7 @@ static __init int sctpprobe_init(void)
 			 &sctpprobe_fops))
 		goto free_kfifo;
 
-	ret = register_jprobe(&sctp_recv_probe);
+	ret = sctp_setup_jprobe();
 	if (ret)
 		goto remove_proc;
 
-- 
1.7.12


