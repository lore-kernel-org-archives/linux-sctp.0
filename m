From: Waiman Long <longman@redhat.com>
Date: Tue, 16 Jun 2020 15:43:10 +0000
Subject: [PATCH v5 1/2] mm/slab: Use memzero_explicit() in kzfree()
Message-Id: <20200616154311.12314-2-longman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200616154311.12314-1-longman@redhat.com>
In-Reply-To: <20200616154311.12314-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Linus Torvalds <torvalds@linux-foundation.org>, Joe Perches <joe@perches.com>, Matthew Wilcox <willy@infradead.org>, David Rientjes <rientjes@google.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, Michal Hocko <mhocko@suse.com>, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, linux-sctp@vger.kernel.org, target-devel@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, kasan-dev@googlegroups.com, linux-wpan@vger.kernel.org, Waiman Long <longman@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, linux-pm@vger.kernel.org, ecryptfs@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-mediatek@lists.infradead.org, linux-amlogic@lists.infradead.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-bluetooth@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, tipc-discussion@lists.sourceforge.net, linux-crypto@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, linux-integrity@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, wireguard@lists.zx2c4.com, linux-ppp@vger.kernel.org

The kzfree() function is normally used to clear some sensitive
information, like encryption keys, in the buffer before freeing it back
to the pool. Memset() is currently used for buffer clearing. However
unlikely, there is still a non-zero probability that the compiler may
choose to optimize away the memory clearing especially if LTO is being
used in the future. To make sure that this optimization will never
happen, memzero_explicit(), which is introduced in v3.18, is now used
in kzfree() to future-proof it.

Fixes: 3ef0e5ba4673 ("slab: introduce kzfree()")
Cc: stable@vger.kernel.org
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 mm/slab_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 9e72ba224175..37d48a56431d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1726,7 +1726,7 @@ void kzfree(const void *p)
 	if (unlikely(ZERO_OR_NULL_PTR(mem)))
 		return;
 	ks = ksize(mem);
-	memset(mem, 0, ks);
+	memzero_explicit(mem, ks);
 	kfree(mem);
 }
 EXPORT_SYMBOL(kzfree);
-- 
2.18.1
