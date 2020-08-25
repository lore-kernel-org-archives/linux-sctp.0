From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 25 Aug 2020 14:52:44 +0000
Subject: [PATCH 11/13] lib/generic-radix-tree: Pass the root pointer to __genradix_ptr.
Message-Id: <8edc9a8718b545e4aa2e6fd0e22288d6@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, 'Catalin Marinas' <catalin.marinas@arm.com>, "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 'Neil Horman' <nhorman@tuxdriver.com>

It can't modify it, so no point passing the address of the pointer.

Signed-off-by: David Laight <david.laight@aculab.com>
---
 include/linux/generic-radix-tree.h | 4 ++--
 lib/generic-radix-tree.c           | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/generic-radix-tree.h b/include/linux/generic-radix-tree.h
index 5fe1c4c5588d..c486fb410855 100644
--- a/include/linux/generic-radix-tree.h
+++ b/include/linux/generic-radix-tree.h
@@ -110,7 +110,7 @@ static inline size_t __idx_to_offset(size_t idx, size_t obj_size)
 #define __genradix_idx_to_offset(_radix, _idx)			\
 	__idx_to_offset(_idx, __genradix_obj_size(_radix))
 
-void *__genradix_ptr(struct __genradix *, size_t);
+void *__genradix_ptr(struct genradix_root *, size_t);
 
 /**
  * genradix_ptr - get a pointer to a genradix entry
@@ -121,7 +121,7 @@ void *__genradix_ptr(struct __genradix *, size_t);
  */
 #define genradix_ptr(_radix, _idx)				\
 	(__genradix_cast(_radix)				\
-	 __genradix_ptr(&(_radix)->tree,			\
+	 __genradix_ptr(READ_ONCE(_radix)->tree.root),			\
 			__genradix_idx_to_offset(_radix, _idx)))
 
 void *__genradix_ptr_alloc(struct __genradix *, size_t, gfp_t);
diff --git a/lib/generic-radix-tree.c b/lib/generic-radix-tree.c
index 363bcefae8aa..037a6456a17b 100644
--- a/lib/generic-radix-tree.c
+++ b/lib/generic-radix-tree.c
@@ -46,9 +46,8 @@ static inline struct genradix_node *genradix_root_to_node(struct genradix_root *
  * Returns pointer to the specified byte @offset within @radix, or NULL if not
  * allocated
  */
-void *__genradix_ptr(struct __genradix *radix, size_t offset)
+void *__genradix_ptr(struct genradix_root *r, size_t offset)
 {
-	struct genradix_root *r = READ_ONCE(radix->root);
 	struct genradix_node *n = genradix_root_to_node(r);
 	unsigned int shift = genradix_root_to_shift(r);
 	unsigned int idx;
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
