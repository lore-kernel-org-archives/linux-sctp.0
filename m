From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 13 Jun 2008 13:49:08 +0000
Subject: [PATCH 1/2] sctp: Correctly cleanup procfs entries upon failure.
Message-Id: <1213364949-9997-2-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1213364949-9997-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1213364949-9997-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net, Wei Yongjun <yjwei@cn.fujitsu.com>, Vlad Yasevich <vladislav.yasevich@hp.com>

From: Wei Yongjun <yjwei@cn.fujitsu.com>

This patch remove the proc fs entry which has been created if fail to
set up proc fs entry for the SCTP protocol.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/protocol.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index b435a19..9258dfe 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -108,14 +108,23 @@ static __init int sctp_proc_init(void)
 	}
 
 	if (sctp_snmp_proc_init())
-		goto out_nomem;
+		goto out_snmp_proc_init;
 	if (sctp_eps_proc_init())
-		goto out_nomem;
+		goto out_eps_proc_init;
 	if (sctp_assocs_proc_init())
-		goto out_nomem;
+		goto out_assocs_proc_init;
 
 	return 0;
 
+out_assocs_proc_init:
+	sctp_eps_proc_exit();
+out_eps_proc_init:
+	sctp_snmp_proc_exit();
+out_snmp_proc_init:
+	if (proc_net_sctp) {
+		proc_net_sctp = NULL;
+		remove_proc_entry("sctp", init_net.proc_net);
+	}
 out_nomem:
 	return -ENOMEM;
 }
-- 
1.5.3.5

