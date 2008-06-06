From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 06 Jun 2008 07:39:27 +0000
Subject: [PATCH] SCTP: Remove the proc fs entry if fail to set up proc fs
Message-Id: <4848E9AF.4010204@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patch remove the proc fs entry which has been created if fail to
set up proc fs entry for the SCTP protocol.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

--- a/net/sctp/protocol.c	2008-05-31 23:49:24.000000000 -0400
+++ b/net/sctp/protocol.c	2008-06-01 04:35:40.000000000 -0400
@@ -108,14 +108,23 @@ static __init int sctp_proc_init(void)
	}

	if (sctp_snmp_proc_init())
-		goto out_nomem;
+		goto err_snmp_proc_init;
	if (sctp_eps_proc_init())
-		goto out_nomem;
+		goto err_eps_proc_init;
	if (sctp_assocs_proc_init())
-		goto out_nomem;
+		goto err_assocs_proc_init;

	return 0;

+err_assocs_proc_init:
+	sctp_eps_proc_exit();
+err_eps_proc_init:
+	sctp_snmp_proc_exit();
+err_snmp_proc_init:
+	if (proc_net_sctp) {
+		proc_net_sctp = NULL;
+		remove_proc_entry("sctp", init_net.proc_net);
+	}
out_nomem:
	return -ENOMEM;
}



