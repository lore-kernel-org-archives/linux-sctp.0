From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 25 Aug 2020 14:52:35 +0000
Subject: [PATCH 07/13] lib/generic-radix-tree: Optimise __genradix_iter_peek()
Message-Id: <d606b3e29ec3407f98d4deb20bc29662@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, 'Catalin Marinas' <catalin.marinas@arm.com>, "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 'Neil Horman' <nhorman@tuxdriver.com>

Use the the 'shift' rather than the 'level'.
NB There are exactly zero users of this code.

Signed-off-by: David Laight <david.laight@aculab.com>
---
 lib/generic-radix-tree.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/lib/generic-radix-tree.c b/lib/generic-radix-tree.c
index 219b43250a06..0df99ee428d8 100644
--- a/lib/generic-radix-tree.c
+++ b/lib/generic-radix-tree.c
@@ -22,14 +22,6 @@ static inline int genradix_depth_shift(unsigned depth)
 	return PAGE_SHIFT + GENRADIX_ARY_SHIFT * depth;
 }
 
-/*
- * Returns size (of data, in bytes) that a tree of a given depth holds:
- */
-static inline size_t genradix_depth_size(unsigned depth)
-{
-	return 1UL << genradix_depth_shift(depth);
-}
-
 /*
  * The 'depth' of the tree is held in the low bits of the 'root'.
  * Since all the buffers are allocated as pages lots of low bits are zero.
@@ -209,7 +201,7 @@ void *__genradix_iter_peek(struct genradix_iter *iter,
 {
 	struct genradix_root *r;
 	struct genradix_node *n;
-	unsigned level, i;
+	unsigned int shift, level, i;
 restart:
 	r = READ_ONCE(radix->root);
 	if (!r)
@@ -217,21 +209,21 @@ void *__genradix_iter_peek(struct genradix_iter *iter,
 
 	n	= genradix_root_to_node(r);
 	level	= genradix_root_to_depth(r);
+	shift = genradix_depth_shift(level);
 
-	if (iter->offset >> genradix_depth_shift(level))
+	if (iter->offset >> shift)
 		return NULL;
 
-	while (level) {
-		level--;
+	while (shift > GENRADIX_ARY_SHIFT) {
+		shift -= GENRADIX_ARY_SHIFT;
 
-		i = (iter->offset >> genradix_depth_shift(level)) &
-			(GENRADIX_ARY - 1);
+		i = (iter->offset >> shift) % GENRADIX_ARY;
 
 		while (!n->children[i]) {
 			i++;
 			iter->offset = round_down(iter->offset +
-					   genradix_depth_size(level),
-					   genradix_depth_size(level));
+					   (1u << shift),
+					   1u << shift);
 			iter->pos = (iter->offset >> PAGE_SHIFT) *
 				objs_per_page;
 			if (i = GENRADIX_ARY)
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
