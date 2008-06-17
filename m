From: David Miller <davem@davemloft.net>
Date: Tue, 17 Jun 2008 07:43:24 +0000
Subject: [PATCH] Kill unused macros...
Message-Id: <20080617.004324.162289618.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org


I noticed this while working on something unrelated in the
net-next-2.6 tree, applied and pushed to kernel.org

sctp: Kill SCTP_SOCK_SLEEP_{PRE,POST}, unused.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/net/sctp/sctp.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 5672d48..17b932b 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -220,8 +220,6 @@ extern struct kmem_cache *sctp_bucket_cachep __read_mostly;
 #define sctp_release_sock(sk)    release_sock(sk)
 #define sctp_bh_lock_sock(sk)    bh_lock_sock(sk)
 #define sctp_bh_unlock_sock(sk)  bh_unlock_sock(sk)
-#define SCTP_SOCK_SLEEP_PRE(sk)  SOCK_SLEEP_PRE(sk)
-#define SCTP_SOCK_SLEEP_POST(sk) SOCK_SLEEP_POST(sk)
 
 /* SCTP SNMP MIB stats handlers */
 DECLARE_SNMP_STAT(struct sctp_mib, sctp_statistics);
