From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 25 Aug 2020 14:52:59 +0000
Subject: [PATCH 05/13] lib/generic-radix-tree: Optimise __genradix_ptr_alloc()
Message-Id: <3313cca9b8a64ef0a192fc1a5562fb1c@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, 'Catalin Marinas' <catalin.marinas@arm.com>, "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 'Neil Horman' <nhorman@tuxdriver.com>

Take the code that allocates an new page and inserts it in the tree
out of line. It is uncommon (and already expensive).

Optimise for the common case where the entire tree fits in one page.

Signed-off-by: David Laight <david.laight@aculab.com>
---
 lib/generic-radix-tree.c | 111 ++++++++++++++++++++++++++-------------
 1 file changed, 74 insertions(+), 37 deletions(-)

diff --git a/lib/generic-radix-tree.c b/lib/generic-radix-tree.c
index 212e04cf171a..b378e10c8fa4 100644
--- a/lib/generic-radix-tree.c
+++ b/lib/generic-radix-tree.c
@@ -108,6 +108,35 @@ static inline void genradix_free_node(struct genradix_node *node)
 	free_page((unsigned long)node);
 }
 
+static noinline struct genradix_node *
+alloc_node(struct genradix_node **tgt, struct genradix_node *old,
+	    struct genradix_node *child, unsigned int level, gfp_t gfp_mask)
+{
+	struct genradix_node *n = genradix_alloc_node(gfp_mask);
+	struct genradix_node *new_node, *check;
+
+	if (!n)
+		return NULL;
+	n->children[0] = child;
+
+	/* The 'root' address is 'overpunched' with the level */
+	new_node = (void *)((unsigned long)n + level);
+
+	check = cmpxchg_release(tgt, old, new_node);
+	if (check = old)
+		return new_node;
+
+	genradix_free_node(n);
+	return check;
+}
+
+static struct genradix_root *
+alloc_root(struct genradix_root **tgt, struct genradix_root *old,
+	    struct genradix_node *child, unsigned int level, gfp_t gfp_mask)
+{
+	return (void *)alloc_node((void *)tgt, (void *)old, child, level, gfp_mask);
+}
+
 /*
  * Returns pointer to the specified byte @offset within @radix, allocating it if
  * necessary - newly allocated slots are always zeroed out:
@@ -115,55 +144,63 @@ static inline void genradix_free_node(struct genradix_node *node)
 void *__genradix_ptr_alloc(struct __genradix *radix, size_t offset,
 			   gfp_t gfp_mask)
 {
-	struct genradix_root *v = READ_ONCE(radix->root);
-	struct genradix_node *n, *new_node;
-	unsigned level;
+	struct genradix_node *n, *n1;
+	struct genradix_root *r;
+	unsigned int level, shift;
+	unsigned int idx;
 
-	/* Increase tree depth if necessary: */
-	while (1) {
-		struct genradix_root *r = v, *new_root;
+	r = READ_ONCE(radix->root);
+	level = genradix_root_to_depth(r);
+
+	/* Optimise non-tree structures */
+	if (likely(!level) && likely(offset < PAGE_SIZE)) {
+		n = genradix_root_to_node(r);
+		if (likely(n))
+			return n->data + offset;
+		r = alloc_root(&radix->root, NULL, NULL, 0, gfp_mask);
+		if (!r)
+			return NULL;
+		level = genradix_root_to_depth(r);
+		if (!level) {
+			n = genradix_root_to_node(r);
+			return n->data + offset;
+		}
+	}
 
-		n	= genradix_root_to_node(r);
-		level	= genradix_root_to_depth(r);
+	/* Ensure tree is deep enough */
+	for (;;) {
+		n = genradix_root_to_node(r);
+		shift = genradix_depth_shift(level) - GENRADIX_ARY_SHIFT;
+		idx = offset >> shift;
 
-		if (n && !(offset >> genradix_depth_shift(level)))
+		if (likely(idx < GENRADIX_ARY))
 			break;
 
-		new_node = genradix_alloc_node(gfp_mask);
-		if (!new_node)
+		/* Tree depth needs increasing */
+		r = alloc_root(&radix->root, r, n, level + 1, gfp_mask);
+		if (!r)
 			return NULL;
 
-		new_node->children[0] = n;
-		new_root = ((struct genradix_root *)
-			    ((unsigned long) new_node | (n ? level + 1 : 0)));
-
-		v = cmpxchg_release(&radix->root, r, new_root);
-		if (v = r)
-			v = new_root;
-		else
-			genradix_free_node(new_node);
+		/* Multiple levels could have been added by someone else. */
+		level = genradix_root_to_depth(r);
 	}
 
-	while (level--) {
-		struct genradix_node **p -			&n->children[offset >> genradix_depth_shift(level)];
-		offset &= genradix_depth_size(level) - 1;
-
-		n = READ_ONCE(*p);
-		if (!n) {
-			new_node = genradix_alloc_node(gfp_mask);
-			if (!new_node)
+	/* Descend the tree */
+	for (;;) {
+		n1 = READ_ONCE(n->children[idx]);
+		if (unlikely(!n1)) {
+			n1 = alloc_node(n->children + idx, NULL, NULL, 0, gfp_mask);
+			if (!n1)
 				return NULL;
-
-			n = cmpxchg_release(p, NULL, new_node);
-			if (!n)
-				n = new_node;
-			else
-				genradix_free_node(new_node);
 		}
-	}
 
-	return &n->data[offset];
+		n = n1;
+		if (shift = PAGE_SHIFT)
+			return n->data + (offset % PAGE_SIZE);
+
+		shift -= GENRADIX_ARY_SHIFT;
+		idx = (offset >> shift) % GENRADIX_ARY;
+	}
 }
 EXPORT_SYMBOL(__genradix_ptr_alloc);
 
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
