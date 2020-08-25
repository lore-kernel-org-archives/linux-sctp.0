From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 25 Aug 2020 14:52:53 +0000
Subject: [PATCH 08/13] lib/generic-radix-tree: Save number of bits to shift instead of tree level.
Message-Id: <815c1debffb64f7c8af3fc06dd50f5cb@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, 'Catalin Marinas' <catalin.marinas@arm.com>, "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 'Neil Horman' <nhorman@tuxdriver.com>

Saving the 'number of bits to shift' to get the array index rather
than the 'level' saves the shift = level * 9 + 3 calculations.
In addition a shift of zero only happens for an NULL pointer,
so the 'indirect into a single page' check can be optimised for.

Signed-off-by: David Laight <david.laight@aculab.com>
---
 lib/generic-radix-tree.c | 116 ++++++++++++++++++++-------------------
 1 file changed, 59 insertions(+), 57 deletions(-)

diff --git a/lib/generic-radix-tree.c b/lib/generic-radix-tree.c
index 0df99ee428d8..363bcefae8aa 100644
--- a/lib/generic-radix-tree.c
+++ b/lib/generic-radix-tree.c
@@ -6,6 +6,7 @@
 
 #define GENRADIX_ARY		(PAGE_SIZE / sizeof(struct genradix_node *))
 #define GENRADIX_ARY_SHIFT	ilog2(GENRADIX_ARY)
+#define GENRADIX_ROOT_SHIFT	ilog2(sizeof(struct genradix_node *))
 
 struct genradix_node {
 	union {
@@ -17,11 +18,6 @@ struct genradix_node {
 	};
 };
 
-static inline int genradix_depth_shift(unsigned depth)
-{
-	return PAGE_SHIFT + GENRADIX_ARY_SHIFT * depth;
-}
-
 /*
  * The 'depth' of the tree is held in the low bits of the 'root'.
  * Since all the buffers are allocated as pages lots of low bits are zero.
@@ -29,17 +25,21 @@ static inline int genradix_depth_shift(unsigned depth)
  * maximum depth/shift we can possibly need is 64.
  * However using the low 8 bits for the depth may give better code
  * on some archectures (eg x86).
+ *
+ * The 'depth' is saved as the shift to get the index into children[].
+ * With 4k pages on a 64bit system the values are 3, 12, 21 etc.
+ * A 0 shift only ever happens when the pointer is NULL.
  */
-#define GENRADIX_DEPTH_MASK 0xff
+#define GENRADIX_SHIFT_MASK 0xff
 
-static inline unsigned genradix_root_to_depth(struct genradix_root *r)
+static inline unsigned genradix_root_to_shift(struct genradix_root *r)
 {
-	return (unsigned long) r & GENRADIX_DEPTH_MASK;
+	return (unsigned long)r & GENRADIX_SHIFT_MASK;
 }
 
 static inline struct genradix_node *genradix_root_to_node(struct genradix_root *r)
 {
-	return (void *) ((unsigned long) r & ~GENRADIX_DEPTH_MASK);
+	return (void *)((unsigned long) r & ~GENRADIX_SHIFT_MASK);
 }
 
 /*
@@ -50,16 +50,14 @@ void *__genradix_ptr(struct __genradix *radix, size_t offset)
 {
 	struct genradix_root *r = READ_ONCE(radix->root);
 	struct genradix_node *n = genradix_root_to_node(r);
-	unsigned int shift = genradix_root_to_depth(r);
+	unsigned int shift = genradix_root_to_shift(r);
 	unsigned int idx;
 
-	if (unlikely(!n))
-		return NULL;
-
-	if (!shift)
+	if (likely(shift = GENRADIX_ROOT_SHIFT))
 		return offset < PAGE_SIZE ? n->data + offset : NULL;
 
-	shift = genradix_depth_shift(shift) - GENRADIX_ARY_SHIFT;
+	if (unlikely(!shift))
+		return NULL;
 
 	idx = offset >> shift;
 	if (unlikely(idx >= GENRADIX_ARY))
@@ -102,7 +100,7 @@ static inline void genradix_free_node(struct genradix_node *node)
 
 static noinline struct genradix_node *
 alloc_node(struct genradix_node **tgt, struct genradix_node *old,
-	    struct genradix_node *child, unsigned int level, gfp_t gfp)
+	    struct genradix_node *child, unsigned int shift, gfp_t gfp)
 {
 	struct genradix_node *n = genradix_alloc_node(gfp);
 	struct genradix_node *new_node, *check;
@@ -111,8 +109,8 @@ alloc_node(struct genradix_node **tgt, struct genradix_node *old,
 		return NULL;
 	n->children[0] = child;
 
-	/* The 'root' address is 'overpunched' with the level */
-	new_node = (void *)((unsigned long)n + level);
+	/* The 'root' address is 'overpunched' with the shift */
+	new_node = (void *)((unsigned long)n + shift);
 
 	check = cmpxchg_release(tgt, old, new_node);
 	if (check = old)
@@ -124,9 +122,9 @@ alloc_node(struct genradix_node **tgt, struct genradix_node *old,
 
 static struct genradix_root *
 alloc_root(struct genradix_root **tgt, struct genradix_root *old,
-	    struct genradix_node *child, unsigned int level, gfp_t gfp)
+	    struct genradix_node *child, unsigned int shift, gfp_t gfp)
 {
-	return (void *)alloc_node((void *)tgt, (void *)old, child, level, gfp);
+	return (void *)alloc_node((void *)tgt, (void *)old, child, shift, gfp);
 }
 
 /*
@@ -137,43 +135,48 @@ void *__genradix_ptr_alloc(struct __genradix *radix, size_t offset, gfp_t gfp)
 {
 	struct genradix_node *n, *n1;
 	struct genradix_root *r;
-	unsigned int level, shift;
+	unsigned int shift;
 	unsigned int idx;
 
 	r = READ_ONCE(radix->root);
-	level = genradix_root_to_depth(r);
+	shift = genradix_root_to_shift(r);
+	n = genradix_root_to_node(r);
 
 	/* Optimise non-tree structures */
-	if (likely(!level) && likely(offset < PAGE_SIZE)) {
-		n = genradix_root_to_node(r);
-		if (likely(n))
+	if (likely(offset < PAGE_SIZE)) {
+		if (likely(shift = GENRADIX_ROOT_SHIFT))
 			return n->data + offset;
-		r = alloc_root(&radix->root, NULL, NULL, 0, gfp);
-		if (!r)
-			return NULL;
-		level = genradix_root_to_depth(r);
-		if (!level) {
+
+		if (!shift) {
+			r = alloc_root(&radix->root, NULL, NULL, GENRADIX_ROOT_SHIFT, gfp);
+			if (!r)
+				return NULL;
+			shift = genradix_root_to_shift(r);
 			n = genradix_root_to_node(r);
-			return n->data + offset;
+			if (shift = GENRADIX_ROOT_SHIFT)
+				return n->data + offset;
+			/* Someone else added multiple root levels */
 		}
-	}
-
-	/* Ensure tree is deep enough */
-	for (;;) {
-		n = genradix_root_to_node(r);
-		shift = genradix_depth_shift(level) - GENRADIX_ARY_SHIFT;
-		idx = offset >> shift;
-
-		if (likely(idx < GENRADIX_ARY))
-			break;
-
-		/* Tree depth needs increasing */
-		r = alloc_root(&radix->root, r, n, level + 1, gfp);
-		if (!r)
-			return NULL;
+	} else {
+		/* Ensure tree is deep enough */
+		for (;;) {
+			idx = offset >> shift;
+
+			if (likely(idx < GENRADIX_ARY))
+				break;
+
+			/* Tree depth needs increasing */
+			if (!shift)
+				shift = GENRADIX_ROOT_SHIFT;
+			shift += GENRADIX_ARY_SHIFT;
+			r = alloc_root(&radix->root, r, n, shift, gfp);
+			if (!r)
+				return NULL;
 
-		/* Multiple levels could have been added by someone else. */
-		level = genradix_root_to_depth(r);
+			/* Many levels could have been added by someone else. */
+			shift = genradix_root_to_shift(r);
+			n = genradix_root_to_node(r);
+		}
 	}
 
 	/* Descend the tree */
@@ -201,15 +204,14 @@ void *__genradix_iter_peek(struct genradix_iter *iter,
 {
 	struct genradix_root *r;
 	struct genradix_node *n;
-	unsigned int shift, level, i;
+	unsigned int shift, i;
 restart:
 	r = READ_ONCE(radix->root);
 	if (!r)
 		return NULL;
 
 	n	= genradix_root_to_node(r);
-	level	= genradix_root_to_depth(r);
-	shift = genradix_depth_shift(level);
+	shift	= genradix_root_to_shift(r);
 
 	if (iter->offset >> shift)
 		return NULL;
@@ -221,8 +223,7 @@ void *__genradix_iter_peek(struct genradix_iter *iter,
 
 		while (!n->children[i]) {
 			i++;
-			iter->offset = round_down(iter->offset +
-					   (1u << shift),
+			iter->offset = round_down(iter->offset + (1u << shift),
 					   1u << shift);
 			iter->pos = (iter->offset >> PAGE_SHIFT) *
 				objs_per_page;
@@ -237,14 +238,15 @@ void *__genradix_iter_peek(struct genradix_iter *iter,
 }
 EXPORT_SYMBOL(__genradix_iter_peek);
 
-static void genradix_free_recurse(struct genradix_node *n, unsigned level)
+static void genradix_free_recurse(struct genradix_node *n, unsigned shift)
 {
-	if (level) {
+	if (shift > GENRADIX_ARY_SHIFT) {
 		unsigned i;
+		shift -= GENRADIX_ARY_SHIFT;
 
 		for (i = 0; i < GENRADIX_ARY; i++)
 			if (n->children[i])
-				genradix_free_recurse(n->children[i], level - 1);
+				genradix_free_recurse(n->children[i], shift);
 	}
 
 	genradix_free_node(n);
@@ -267,6 +269,6 @@ void __genradix_free(struct __genradix *radix)
 	struct genradix_root *r = xchg(&radix->root, NULL);
 
 	genradix_free_recurse(genradix_root_to_node(r),
-			      genradix_root_to_depth(r));
+			      genradix_root_to_shift(r));
 }
 EXPORT_SYMBOL(__genradix_free);
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
