From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 25 Aug 2020 14:53:07 +0000
Subject: [PATCH 02/13] lib/generic-radix-tree: Optimise out ilog2(variable).
Message-Id: <5a4d1a42f61d4fd28e7ef177efd958af@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, 'Catalin Marinas' <catalin.marinas@arm.com>, "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 'Neil Horman' <nhorman@tuxdriver.com>

ilog2() is relatively expensive (especially without bit-scan instructions).
Replace the comparisons 'ilog2(x) >= y' with '(x >> y) != 0'.

Signed-off-by: David Laight <david.laight@aculab.com>
---
 lib/generic-radix-tree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/generic-radix-tree.c b/lib/generic-radix-tree.c
index 5695fe547f9d..d5e97b51308d 100644
--- a/lib/generic-radix-tree.c
+++ b/lib/generic-radix-tree.c
@@ -57,7 +57,7 @@ void *__genradix_ptr(struct __genradix *radix, size_t offset)
 	struct genradix_node *n = genradix_root_to_node(r);
 	unsigned level		= genradix_root_to_depth(r);
 
-	if (ilog2(offset) >= genradix_depth_shift(level))
+	if (offset >> genradix_depth_shift(level))
 		return NULL;
 
 	while (1) {
@@ -115,7 +115,7 @@ void *__genradix_ptr_alloc(struct __genradix *radix, size_t offset,
 		n	= genradix_root_to_node(r);
 		level	= genradix_root_to_depth(r);
 
-		if (n && ilog2(offset) < genradix_depth_shift(level))
+		if (n && !(offset >> genradix_depth_shift(level)))
 			break;
 
 		new_node = genradix_alloc_node(gfp_mask);
@@ -171,7 +171,7 @@ void *__genradix_iter_peek(struct genradix_iter *iter,
 	n	= genradix_root_to_node(r);
 	level	= genradix_root_to_depth(r);
 
-	if (ilog2(iter->offset) >= genradix_depth_shift(level))
+	if (iter->offset >> genradix_depth_shift(level))
 		return NULL;
 
 	while (level) {
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
