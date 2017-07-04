From: Elena Reshetova <elena.reshetova@intel.com>
Date: Tue, 04 Jul 2017 12:53:08 +0000
Subject: [PATCH 13/36] net, lapb: convert lapb_cb.refcnt from atomic_t to refcount_t
Message-Id: <1499172811-16271-14-git-send-email-elena.reshetova@intel.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1499172811-16271-1-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1499172811-16271-1-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-decnet-user@lists.sourceforge.net, davem@davemloft.net, jmorris@namei.org, kaber@trash.net, yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru, 3chas3@gmail.com, ralf@linux-mips.org, stephen@networkplumber.org, jchapman@katalix.com, jhs@mojatatu.com, bridge@lists.linux-foundation.org, linux-hams@vger.kernel.org, linux-x25@vger.kernel.org, peterz@infradead.org, keescook@chromium.org, linux-rdma@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, linux-nfs@vger.kernel.org, zyan@redhat.com, sage@redhat.com, bfields@fieldses.org, jlayton@poochiereds.net, steffen.klassert@secunet.com, herbert@gondor.apana.org.au, santosh.shilimkar@oracle.com, jreuter@yaina.de, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 include/net/lapb.h    | 3 ++-
 net/lapb/lapb_iface.c | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/lapb.h b/include/net/lapb.h
index 9510f87..85e7737 100644
--- a/include/net/lapb.h
+++ b/include/net/lapb.h
@@ -1,6 +1,7 @@
 #ifndef _LAPB_H
 #define _LAPB_H 
 #include <linux/lapb.h>
+#include <linux/refcount.h>
 
 #define	LAPB_HEADER_LEN	20		/* LAPB over Ethernet + a bit more */
 
@@ -101,7 +102,7 @@ struct lapb_cb {
 	struct lapb_frame	frmr_data;
 	unsigned char		frmr_type;
 
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 };
 
 /* lapb_iface.c */
diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index b50b64a..e15314e 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -54,12 +54,12 @@ static void lapb_free_cb(struct lapb_cb *lapb)
 
 static __inline__ void lapb_hold(struct lapb_cb *lapb)
 {
-	atomic_inc(&lapb->refcnt);
+	refcount_inc(&lapb->refcnt);
 }
 
 static __inline__ void lapb_put(struct lapb_cb *lapb)
 {
-	if (atomic_dec_and_test(&lapb->refcnt))
+	if (refcount_dec_and_test(&lapb->refcnt))
 		lapb_free_cb(lapb);
 }
 
@@ -136,7 +136,7 @@ static struct lapb_cb *lapb_create_cb(void)
 	lapb->mode    = LAPB_DEFAULT_MODE;
 	lapb->window  = LAPB_DEFAULT_WINDOW;
 	lapb->state   = LAPB_STATE_0;
-	atomic_set(&lapb->refcnt, 1);
+	refcount_set(&lapb->refcnt, 1);
 out:
 	return lapb;
 }
-- 
2.7.4

