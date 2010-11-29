From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Mon, 29 Nov 2010 10:14:58 +0000
Subject: [PATCH] sctp: kill unused macros in head file
Message-Id: <4CF37D22.8090307@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vladislav.yasevich@hp.com>, David Miller <davem@davemloft.net>, shemminger@linux-foundation.org
Cc: Network-Maillist <netdev@vger.kernel.org>, SCTP-Maillist <linux-sctp@vger.kernel.org>, Shan Wei <shanwei@cn.fujitsu.com>


1. SCTP_CMD_NUM_VERBS,SCTP_CMD_MAX
These two macros have never been used for several years since v2.6.12-rc2.

2.sctp_port_rover,sctp_port_alloc_lock
The commit 063930 abandoned global variables of port_rover and port_alloc_lock,
but still keep two macros to refer to them.
So, remove them now.

commit 06393009000779b00a558fd2f280882cc7dc2008
Author: Stephen Hemminger <shemminger@linux-foundation.org>
Date:   Wed Oct 10 17:30:18 2007 -0700

    [SCTP]: port randomization


Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 include/net/sctp/command.h |    3 ---
 include/net/sctp/structs.h |    2 --
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
index 2c55a7e..c01dc99 100644
--- a/include/net/sctp/command.h
+++ b/include/net/sctp/command.h
@@ -111,9 +111,6 @@ typedef enum {
 	SCTP_CMD_LAST
 } sctp_verb_t;
 
-#define SCTP_CMD_MAX		(SCTP_CMD_LAST - 1)
-#define SCTP_CMD_NUM_VERBS	(SCTP_CMD_MAX + 1)
-
 /* How many commands can you put in an sctp_cmd_seq_t?
  * This is a rather arbitrary number, ideally derived from a careful
  * analysis of the state functions, but in reality just taken from
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 69fef4f..cc9185c 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -261,8 +261,6 @@ extern struct sctp_globals {
 #define sctp_assoc_hashsize		(sctp_globals.assoc_hashsize)
 #define sctp_assoc_hashtable		(sctp_globals.assoc_hashtable)
 #define sctp_port_hashsize		(sctp_globals.port_hashsize)
-#define sctp_port_rover			(sctp_globals.port_rover)
-#define sctp_port_alloc_lock		(sctp_globals.port_alloc_lock)
 #define sctp_port_hashtable		(sctp_globals.port_hashtable)
 #define sctp_local_addr_list		(sctp_globals.local_addr_list)
 #define sctp_local_addr_lock		(sctp_globals.addr_list_lock)
-- 
1.6.3.3


