From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 25 Aug 2020 14:52:50 +0000
Subject: [PATCH 09/13] lib/generic-radix-tree: Check sizeof(_type) when defining a tree.
Message-Id: <9ddf843612ea429682b68d5747bd93d8@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, 'Catalin Marinas' <catalin.marinas@arm.com>, "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 'Neil Horman' <nhorman@tuxdriver.com>

Move the check for the structure type being larger than PAGE_SIZE from every
use to the definition of a tree.

Signed-off-by: David Laight <david.laight@aculab.com>
---
 include/linux/generic-radix-tree.h | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/generic-radix-tree.h b/include/linux/generic-radix-tree.h
index bfd00320c7f3..53149bc1b92a 100644
--- a/include/linux/generic-radix-tree.h
+++ b/include/linux/generic-radix-tree.h
@@ -64,12 +64,14 @@ struct __genradix {
  * to it for casts/sizeof - we also force the alignment so that storing a type
  * with a ridiculous alignment doesn't blow up the alignment or size of the
  * genradix.
+ *
+ * Generates a compile-time error if the item is too large.
  */
 
 #define GENRADIX(_type)						\
 struct {							\
 	struct __genradix	tree;				\
-	_type			type[0] __aligned(1);		\
+	_type type[sizeof (_type) <= PAGE_SIZE ? 0 : -1] __aligned(1);	\
 }
 
 #define DEFINE_GENRADIX(_name, _type)				\
@@ -98,11 +100,6 @@ void __genradix_free(struct __genradix *);
 
 static inline size_t __idx_to_offset(size_t idx, size_t obj_size)
 {
-	if (__builtin_constant_p(obj_size))
-		BUILD_BUG_ON(obj_size > PAGE_SIZE);
-	else
-		BUG_ON(obj_size > PAGE_SIZE);
-
 	if (!is_power_of_2(obj_size)) {
 		size_t objs_per_page = PAGE_SIZE / obj_size;
 
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
