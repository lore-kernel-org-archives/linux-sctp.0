From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 09 Mar 2009 03:15:56 +0000
Subject: [PATCH 2/6] sctp: implement sysctl to enable/disable STREAM-RESET
Message-Id: <49B489EC.7070702@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patch provides a way to enable/disable STREAM-RESET extension.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/structs.h |    4 ++++
 net/sctp/protocol.c        |    3 +++
 net/sctp/sysctl.c          |    9 +++++++++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 23f08fe..b92226b 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -222,6 +222,9 @@ extern struct sctp_globals {
 	/* Flag to indicate whether computing and verifying checksum
 	 * is disabled. */
         int checksum_disable;
+
+	/* Flag to idicate if STREAM-RESET is enabled */
+	int strrst_enable;
 } sctp_globals;
 
 #define sctp_rto_initial		(sctp_globals.rto_initial)
@@ -257,6 +260,7 @@ extern struct sctp_globals {
 #define sctp_prsctp_enable		(sctp_globals.prsctp_enable)
 #define sctp_auth_enable		(sctp_globals.auth_enable)
 #define sctp_checksum_disable		(sctp_globals.checksum_disable)
+#define sctp_strrst_enable		(sctp_globals.strrst_enable)
 
 /* SCTP Socket type: UDP or TCP style. */
 typedef enum {
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index cb198af..30a1410 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1262,6 +1262,9 @@ SCTP_STATIC __init int sctp_init(void)
 	/* Disable AUTH by default. */
 	sctp_auth_enable = 0;
 
+	/* Disable STREAM-RESET by default. */
+	sctp_strrst_enable = 0;
+
 	sctp_sysctl_register();
 
 	INIT_LIST_HEAD(&sctp_address_families);
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index f58e994..f176812 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -272,6 +272,15 @@ static ctl_table sctp_table[] = {
 		.proc_handler	= proc_dointvec,
 		.strategy	= sysctl_intvec
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "strrst_enable",
+		.data		= &sctp_strrst_enable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.strategy	= sysctl_intvec
+	},
 	{ .ctl_name = 0 }
 };
 
-- 
1.5.3.8




