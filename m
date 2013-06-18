From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 18 Jun 2013 08:55:16 +0000
Subject: [PATCH net-next 1/5] net: sctp: remove TEST_FRAME ifdef
Message-Id: <1371545720-22950-2-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1371545720-22950-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1371545720-22950-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

We do neither ship a test_frame.h, nor will this be compatible with
the 2.5 out-of-tree lksctp kernel test suite anyway. So remove this
artefact.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 include/net/sctp/sctp.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 6321c08..15214a8 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -188,11 +188,6 @@ extern struct kmem_cache *sctp_bucket_cachep __read_mostly;
  *  Section:  Macros, externs, and inlines
  */
 
-
-#ifdef TEST_FRAME
-#include <test_frame.h>
-#else
-
 /* spin lock wrappers. */
 #define sctp_spin_lock_irqsave(lock, flags) spin_lock_irqsave(lock, flags)
 #define sctp_spin_unlock_irqrestore(lock, flags)  \
@@ -218,8 +213,6 @@ extern struct kmem_cache *sctp_bucket_cachep __read_mostly;
 #define SCTP_INC_STATS_USER(net, field) SNMP_INC_STATS_USER((net)->sctp.sctp_statistics, field)
 #define SCTP_DEC_STATS(net, field)      SNMP_DEC_STATS((net)->sctp.sctp_statistics, field)
 
-#endif /* !TEST_FRAME */
-
 /* sctp mib definitions */
 enum {
 	SCTP_MIB_NUM = 0,
-- 
1.7.11.7

