From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 25 Aug 2020 14:53:10 +0000
Subject: [PATCH 01/13] lib/generic-radix-tree: Fix potentially corrupt tree
Message-Id: <3184cab15fe94db58c7cf3fcf33f3875@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, 'Catalin Marinas' <catalin.marinas@arm.com>, "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 'Neil Horman' <nhorman@tuxdriver.com>

If the last cmpxchg() done when increasing the tree depth fails
(because another caller has done a concurrent update) the 'new_node'
is reused later for either a array of pointers or the user data.
However the new_node->children[0] has been set non-zero this will
either end up being treated as a pointer to another node or as user data.

Rather than just setting children[0] = NULL free back the unwanted page
in the very unusual case that the cmpxchg() fails.
This removes quite a few comparisons from the normal path.

Signed-off-by: David Laight <david.laight@aculab.com>
---

Although rather nasty not really worth a backport because neither of the
2 places this code is used can possibly hit the failing path.

 lib/generic-radix-tree.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/lib/generic-radix-tree.c b/lib/generic-radix-tree.c
index f25eb111c051..5695fe547f9d 100644
--- a/lib/generic-radix-tree.c
+++ b/lib/generic-radix-tree.c
@@ -105,7 +105,7 @@ void *__genradix_ptr_alloc(struct __genradix *radix, size_t offset,
 			   gfp_t gfp_mask)
 {
 	struct genradix_root *v = READ_ONCE(radix->root);
-	struct genradix_node *n, *new_node = NULL;
+	struct genradix_node *n, *new_node;
 	unsigned level;
 
 	/* Increase tree depth if necessary: */
@@ -118,20 +118,19 @@ void *__genradix_ptr_alloc(struct __genradix *radix, size_t offset,
 		if (n && ilog2(offset) < genradix_depth_shift(level))
 			break;
 
-		if (!new_node) {
-			new_node = genradix_alloc_node(gfp_mask);
-			if (!new_node)
-				return NULL;
-		}
+		new_node = genradix_alloc_node(gfp_mask);
+		if (!new_node)
+			return NULL;
 
 		new_node->children[0] = n;
 		new_root = ((struct genradix_root *)
 			    ((unsigned long) new_node | (n ? level + 1 : 0)));
 
-		if ((v = cmpxchg_release(&radix->root, r, new_root)) = r) {
+		v = cmpxchg_release(&radix->root, r, new_root);
+		if (v = r)
 			v = new_root;
-			new_node = NULL;
-		}
+		else
+			genradix_free_node(new_node);
 	}
 
 	while (level--) {
@@ -141,20 +140,18 @@ void *__genradix_ptr_alloc(struct __genradix *radix, size_t offset,
 
 		n = READ_ONCE(*p);
 		if (!n) {
-			if (!new_node) {
-				new_node = genradix_alloc_node(gfp_mask);
-				if (!new_node)
-					return NULL;
-			}
-
-			if (!(n = cmpxchg_release(p, NULL, new_node)))
-				swap(n, new_node);
+			new_node = genradix_alloc_node(gfp_mask);
+			if (!new_node)
+				return NULL;
+
+			n = cmpxchg_release(p, NULL, new_node);
+			if (!n)
+				n = new_node;
+			else
+				genradix_free_node(new_node);
 		}
 	}
 
-	if (new_node)
-		genradix_free_node(new_node);
-
 	return &n->data[offset];
 }
 EXPORT_SYMBOL(__genradix_ptr_alloc);
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
