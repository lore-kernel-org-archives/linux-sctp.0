From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 25 Aug 2020 14:52:38 +0000
Subject: [PATCH 13/13] lib/generic-radix-tree: Simplify __genradix_ptr()
Message-Id: <35b7ab36369249d8bf17a04f58a0f337@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, 'Catalin Marinas' <catalin.marinas@arm.com>, "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 'Neil Horman' <nhorman@tuxdriver.com>

Now that requests for small trees are inlined there is no need
to aggressively optimise for them in __genradix_ptr().

Signed-off-by: David Laight <david.laight@aculab.com>
---
 lib/generic-radix-tree.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/lib/generic-radix-tree.c b/lib/generic-radix-tree.c
index 7029a14eed97..497ac5effda0 100644
--- a/lib/generic-radix-tree.c
+++ b/lib/generic-radix-tree.c
@@ -45,9 +45,6 @@ void *__genradix_ptr(struct genradix_root *r, size_t offset)
 	unsigned int shift = __genradix_root_to_shift(r);
 	unsigned int idx;
 
-	if (likely(shift = GENRADIX_ROOT_SHIFT))
-		return offset < PAGE_SIZE ? n->data + offset : NULL;
-
 	if (unlikely(!shift))
 		return NULL;
 
@@ -56,13 +53,13 @@ void *__genradix_ptr(struct genradix_root *r, size_t offset)
 		return NULL;
 
 	for (;;) {
+		if (likely(shift = GENRADIX_ROOT_SHIFT))
+			return n->data + (offset % PAGE_SIZE);
+
 		n = READ_ONCE(n->children[idx]);
 		if (unlikely(!n))
 			return NULL;
 
-		if (shift = PAGE_SHIFT)
-			return n->data + (offset % PAGE_SIZE);
-
 		shift -= GENRADIX_ARY_SHIFT;
 		idx = (offset >> shift) % GENRADIX_ARY;
 	}
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
