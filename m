From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 25 Aug 2020 14:53:02 +0000
Subject: [PATCH 04/13] lib/generic-radix-tree: Optimise __genradix_ptr()
Message-Id: <d0088b5a266d4cb7bc99dd11175c77b0@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, 'Catalin Marinas' <catalin.marinas@arm.com>, "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 'Neil Horman' <nhorman@tuxdriver.com>

While gcc managed to convert the 'level' loop into one that changed the
'shift' it couldn't convert '(offset & mask) >> n' to '(offset >> n) & 511'
so avoiding body of genradix_depth_size().
Perform both optimisations in the source.

Also optimise for the common (given the only users of this code) case of
the entire radix-tree fitting in one page.

Signed-off-by: David Laight <david.laight@aculab.com>
---
 lib/generic-radix-tree.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/lib/generic-radix-tree.c b/lib/generic-radix-tree.c
index 12dcaf891af9..212e04cf171a 100644
--- a/lib/generic-radix-tree.c
+++ b/lib/generic-radix-tree.c
@@ -58,24 +58,32 @@ void *__genradix_ptr(struct __genradix *radix, size_t offset)
 {
 	struct genradix_root *r = READ_ONCE(radix->root);
 	struct genradix_node *n = genradix_root_to_node(r);
-	unsigned level		= genradix_root_to_depth(r);
+	unsigned int shift = genradix_root_to_depth(r);
+	unsigned int idx;
 
-	if (offset >> genradix_depth_shift(level))
+	if (unlikely(!n))
 		return NULL;
 
-	while (1) {
-		if (!n)
+	if (!shift)
+		return offset < PAGE_SIZE ? n->data + offset : NULL;
+
+	shift = genradix_depth_shift(shift) - GENRADIX_ARY_SHIFT;
+
+	idx = offset >> shift;
+	if (unlikely(idx >= GENRADIX_ARY))
+		return NULL;
+
+	for (;;) {
+		n = READ_ONCE(n->children[idx]);
+		if (unlikely(!n))
 			return NULL;
-		if (!level)
-			break;
 
-		level--;
+		if (shift = PAGE_SHIFT)
+			return n->data + (offset % PAGE_SIZE);
 
-		n = n->children[offset >> genradix_depth_shift(level)];
-		offset &= genradix_depth_size(level) - 1;
+		shift -= GENRADIX_ARY_SHIFT;
+		idx = (offset >> shift) % GENRADIX_ARY;
 	}
-
-	return &n->data[offset];
 }
 EXPORT_SYMBOL(__genradix_ptr);
 
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
