From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Sun, 06 Jun 2010 18:49:12 +0000
Subject: Re: [IPTABLES][PATCH 2/2 v2] xt_sctp: support FORWARD_TSN chunk type
Message-Id: <4C0BEDA8.6090603@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4C0BE416.4070503@cn.fujitsu.com>
In-Reply-To: <4C0BE416.4070503@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Patrick McHardy <kaber@trash.net>
Cc: linux-sctp@vger.kernel.org, netfilter-devel@vger.kernel.org

The latest kernel has implemented Partial Reliability Extension
that defined in RFC3758.

This patch adds FORWARD_TSN chunk for tracing.
 
Signed-off-by: Shan Wei<shanwei@cn.fujitsu.com>
---
v1->v2:
1. Add FORWARD_TSN chunk info to sctp_help().
---
 extensions/libxt_sctp.c   |    3 ++-
 extensions/libxt_sctp.man |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 92bdb07..d321fb8 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -51,7 +51,7 @@ static void sctp_help(void)
 " --dport ...\n" 
 "[!] --chunk-types (all|any|none) (chunktype[:flags])+	match if all, any or none of\n"
 "						        chunktypes are present\n"
-"chunktypes - DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE ASCONF ASCONF_ACK ALL NONE\n");
+"chunktypes - DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE ASCONF ASCONF_ACK FORWARD_TSN ALL NONE\n");
 }
 
 static const struct option sctp_opts[] = {
@@ -114,6 +114,7 @@ static const struct sctp_chunk_names sctp_chunk_names[]
     { .name = "SHUTDOWN_COMPLETE", .chunk_type = 14,  .valid_flags = "-------T"},
     { .name = "ASCONF",		.chunk_type = 193,  .valid_flags = "--------"},
     { .name = "ASCONF_ACK",	.chunk_type = 128,  .valid_flags = "--------"},
+    { .name = "FORWARD_TSN",	.chunk_type = 192,  .valid_flags = "--------"},
 };
 
 static void
diff --git a/extensions/libxt_sctp.man b/extensions/libxt_sctp.man
index 01a2e79..eefc850 100644
--- a/extensions/libxt_sctp.man
+++ b/extensions/libxt_sctp.man
@@ -7,7 +7,7 @@
 The flag letter in upper case indicates that the flag is to match if set,
 in the lower case indicates to match if unset.
 
-Chunk types: DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE ASCONF ASCONF_ACK
+Chunk types: DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE ASCONF ASCONF_ACK FORWARD_TSN
 
 chunk type            available flags      
 .br
-- 
1.6.3.3
