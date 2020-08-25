From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 25 Aug 2020 14:53:04 +0000
Subject: [PATCH 03/13] lib/generic-radix-tree: Always use low 8 bits of 'root' for depth.
Message-Id: <c91557f439854e4997e807a5215d4763@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, 'Catalin Marinas' <catalin.marinas@arm.com>, "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 'Neil Horman' <nhorman@tuxdriver.com>

There is no need to calculate the minimum number of bits needed for the
depth (stored in the low bits of the pointer to the root).
Since the root is PAGE_SIZE aligned and we can't need more than 64bits
just use the low 8 bits for the depth.
This (probably) generates better code on x86 then using (say) 6 bits.

Signed-off-by: David Laight <david.laight@aculab.com>
---
 lib/generic-radix-tree.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/lib/generic-radix-tree.c b/lib/generic-radix-tree.c
index d5e97b51308d..12dcaf891af9 100644
--- a/lib/generic-radix-tree.c
+++ b/lib/generic-radix-tree.c
@@ -30,12 +30,15 @@ static inline size_t genradix_depth_size(unsigned depth)
 	return 1UL << genradix_depth_shift(depth);
 }
 
-/* depth that's needed for a genradix that can address up to ULONG_MAX: */
-#define GENRADIX_MAX_DEPTH	\
-	DIV_ROUND_UP(BITS_PER_LONG - PAGE_SHIFT, GENRADIX_ARY_SHIFT)
-
-#define GENRADIX_DEPTH_MASK				\
-	((unsigned long) (roundup_pow_of_two(GENRADIX_MAX_DEPTH + 1) - 1))
+/*
+ * The 'depth' of the tree is held in the low bits of the 'root'.
+ * Since all the buffers are allocated as pages lots of low bits are zero.
+ * To support a genradix that can address up to ULONG_MAX items the
+ * maximum depth/shift we can possibly need is 64.
+ * However using the low 8 bits for the depth may give better code
+ * on some archectures (eg x86).
+ */
+#define GENRADIX_DEPTH_MASK 0xff
 
 static inline unsigned genradix_root_to_depth(struct genradix_root *r)
 {
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
