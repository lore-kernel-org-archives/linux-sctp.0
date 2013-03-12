From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Date: Tue, 12 Mar 2013 05:39:47 +0000
Subject: [PATCH 18/18] net: sctp: remove cast for kmalloc/kzalloc return value
Message-Id: <513EBFA3.4070303@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <513EB23D.7020303@cn.fujitsu.com>
In-Reply-To: <513EB23D.7020303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Sridhar Samudrala <sri@us.ibm.com>, Neil Horman <nhorman@tuxdriver.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-sctp@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

remove cast for kmalloc/kzalloc return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-sctp@vger.kernel.org
---
 include/net/sctp/sctp.h |    2 +-
 net/sctp/protocol.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index df85a0c..cd89510 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -576,7 +576,7 @@ for (pos = chunk->subh.fwdtsn_hdr->skip;\
 #define WORD_ROUND(s) (((s)+3)&~3)
 
 /* Make a new instance of type.  */
-#define t_new(type, flags)	(type *)kzalloc(sizeof(type), flags)
+#define t_new(type, flags)	kzalloc(sizeof(type), flags)
 
 /* Compare two timevals.  */
 #define tv_lt(s, t) \
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 1c2e46c..eaee00c 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1403,7 +1403,7 @@ SCTP_STATIC __init int sctp_init(void)
 
 	/* Allocate and initialize the endpoint hash table.  */
 	sctp_ep_hashsize = 64;
-	sctp_ep_hashtable = (struct sctp_hashbucket *)
+	sctp_ep_hashtable  		kmalloc(64 * sizeof(struct sctp_hashbucket), GFP_KERNEL);
 	if (!sctp_ep_hashtable) {
 		pr_err("Failed endpoint_hash alloc\n");
-- 
1.7.1

