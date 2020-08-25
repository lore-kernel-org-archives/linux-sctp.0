From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 25 Aug 2020 14:52:41 +0000
Subject: [PATCH 12/13] lib/generic-radix-tree: Inline genradix_ptr() for simple trees.
Message-Id: <a94f93ffed6749c9a7676e11f440d9b5@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, 'Catalin Marinas' <catalin.marinas@arm.com>, "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 'Neil Horman' <nhorman@tuxdriver.com>

Inline genradix_ptr() for trees that only contain 1 data page.
While this increases code size somewhat it should improve performance.

Signed-off-by: David Laight <david.laight@aculab.com>
---
 include/linux/generic-radix-tree.h | 38 ++++++++++++++++++++++++++----
 lib/generic-radix-tree.c           | 19 +++++----------
 2 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/include/linux/generic-radix-tree.h b/include/linux/generic-radix-tree.h
index c486fb410855..7575862f02d5 100644
--- a/include/linux/generic-radix-tree.h
+++ b/include/linux/generic-radix-tree.h
@@ -42,6 +42,16 @@
 #include <linux/log2.h>
 
 struct genradix_root;
+struct genradix_node;
+
+/* The depth of the tree is encoded in low bits of __genradix.root. */
+#define GENRADIX_SHIFT_MASK	0xff
+#define GENRADIX_ROOT_SHIFT	ilog2(sizeof(struct genradix_node *))
+
+static inline unsigned int __genradix_root_to_shift(struct genradix_root *root)
+{
+	return (unsigned long)root & GENRADIX_SHIFT_MASK;
+}
 
 struct __genradix {
 	struct genradix_root		*root;
@@ -98,11 +108,12 @@ void __genradix_free(struct __genradix *);
  */
 #define genradix_free(_radix)	__genradix_free(&(_radix)->tree)
 
+#define __genradix_offset_adjust(idx, obj_size) \
+	((PAGE_SIZE % obj_size) * (idx / (PAGE_SIZE / obj_size)))
+
 static inline size_t __idx_to_offset(size_t idx, size_t obj_size)
 {
-	size_t objs_per_page = PAGE_SIZE / obj_size;
-
-	return idx * obj_size + (idx / objs_per_page) * (PAGE_SIZE % obj_size);
+	return idx * obj_size + __genradix_offset_adjust(idx, obj_size);
 }
 
 #define __genradix_cast(_radix)		(typeof((_radix)->type[0]) *)
@@ -112,6 +123,23 @@ static inline size_t __idx_to_offset(size_t idx, size_t obj_size)
 
 void *__genradix_ptr(struct genradix_root *, size_t);
 
+static inline void *__genradix_ptr1(struct genradix_root *root, size_t idx,
+				    size_t sz)
+{
+	size_t offset = idx * sz;
+
+	/* Optimise accesses into small trees */
+	if (likely(offset <= PAGE_SIZE - sz)) {
+		if (likely(__genradix_root_to_shift(root) = GENRADIX_ROOT_SHIFT))
+			return (u8 *)root - GENRADIX_ROOT_SHIFT + offset;
+	} else {
+		offset += __genradix_offset_adjust(idx, sz);
+	}
+
+	return __genradix_ptr(root, offset);
+}
+
+
 /**
  * genradix_ptr - get a pointer to a genradix entry
  * @_radix:	genradix to access
@@ -121,8 +149,8 @@ void *__genradix_ptr(struct genradix_root *, size_t);
  */
 #define genradix_ptr(_radix, _idx)				\
 	(__genradix_cast(_radix)				\
-	 __genradix_ptr(READ_ONCE(_radix)->tree.root),			\
-			__genradix_idx_to_offset(_radix, _idx)))
+	 __genradix_ptr1(READ_ONCE((_radix)->tree.root), _idx,	\
+			__genradix_obj_size(_radix)))
 
 void *__genradix_ptr_alloc(struct __genradix *, size_t, gfp_t);
 
diff --git a/lib/generic-radix-tree.c b/lib/generic-radix-tree.c
index 037a6456a17b..7029a14eed97 100644
--- a/lib/generic-radix-tree.c
+++ b/lib/generic-radix-tree.c
@@ -6,7 +6,6 @@
 
 #define GENRADIX_ARY		(PAGE_SIZE / sizeof(struct genradix_node *))
 #define GENRADIX_ARY_SHIFT	ilog2(GENRADIX_ARY)
-#define GENRADIX_ROOT_SHIFT	ilog2(sizeof(struct genradix_node *))
 
 struct genradix_node {
 	union {
@@ -30,12 +29,6 @@ struct genradix_node {
  * With 4k pages on a 64bit system the values are 3, 12, 21 etc.
  * A 0 shift only ever happens when the pointer is NULL.
  */
-#define GENRADIX_SHIFT_MASK 0xff
-
-static inline unsigned genradix_root_to_shift(struct genradix_root *r)
-{
-	return (unsigned long)r & GENRADIX_SHIFT_MASK;
-}
 
 static inline struct genradix_node *genradix_root_to_node(struct genradix_root *r)
 {
@@ -49,7 +42,7 @@ static inline struct genradix_node *genradix_root_to_node(struct genradix_root *
 void *__genradix_ptr(struct genradix_root *r, size_t offset)
 {
 	struct genradix_node *n = genradix_root_to_node(r);
-	unsigned int shift = genradix_root_to_shift(r);
+	unsigned int shift = __genradix_root_to_shift(r);
 	unsigned int idx;
 
 	if (likely(shift = GENRADIX_ROOT_SHIFT))
@@ -138,7 +131,7 @@ void *__genradix_ptr_alloc(struct __genradix *radix, size_t offset, gfp_t gfp)
 	unsigned int idx;
 
 	r = READ_ONCE(radix->root);
-	shift = genradix_root_to_shift(r);
+	shift = __genradix_root_to_shift(r);
 	n = genradix_root_to_node(r);
 
 	/* Optimise non-tree structures */
@@ -150,7 +143,7 @@ void *__genradix_ptr_alloc(struct __genradix *radix, size_t offset, gfp_t gfp)
 			r = alloc_root(&radix->root, NULL, NULL, GENRADIX_ROOT_SHIFT, gfp);
 			if (!r)
 				return NULL;
-			shift = genradix_root_to_shift(r);
+			shift = __genradix_root_to_shift(r);
 			n = genradix_root_to_node(r);
 			if (shift = GENRADIX_ROOT_SHIFT)
 				return n->data + offset;
@@ -173,7 +166,7 @@ void *__genradix_ptr_alloc(struct __genradix *radix, size_t offset, gfp_t gfp)
 				return NULL;
 
 			/* Many levels could have been added by someone else. */
-			shift = genradix_root_to_shift(r);
+			shift = __genradix_root_to_shift(r);
 			n = genradix_root_to_node(r);
 		}
 	}
@@ -210,7 +203,7 @@ void *__genradix_iter_peek(struct genradix_iter *iter,
 		return NULL;
 
 	n	= genradix_root_to_node(r);
-	shift	= genradix_root_to_shift(r);
+	shift	= __genradix_root_to_shift(r);
 
 	if (iter->offset >> shift)
 		return NULL;
@@ -268,6 +261,6 @@ void __genradix_free(struct __genradix *radix)
 	struct genradix_root *r = xchg(&radix->root, NULL);
 
 	genradix_free_recurse(genradix_root_to_node(r),
-			      genradix_root_to_shift(r));
+			      __genradix_root_to_shift(r));
 }
 EXPORT_SYMBOL(__genradix_free);
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
