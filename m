From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 25 Aug 2020 14:52:47 +0000
Subject: [PATCH 10/13] lib/generic-radix-tree: Simplify offset calculation:
Message-Id: <bc04c6adae56428c9e247b0506da5f25@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, 'Catalin Marinas' <catalin.marinas@arm.com>, "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 'Neil Horman' <nhorman@tuxdriver.com>

Since these are equivalent:
    (idx / objs_per_page) * PAGE_SIZE + (idx % objs_per_page) * obj_size;
    idx * obj_size + (idx / objs_per_page) * (PAGE_SIZE % obj_size);
Use the latter since it is slightly faster.
It also deosn't need an extra check for obj_size being a power of 2.

Signed-off-by: David Laight <david.laight@aculab.com>
---
 include/linux/generic-radix-tree.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/linux/generic-radix-tree.h b/include/linux/generic-radix-tree.h
index 53149bc1b92a..5fe1c4c5588d 100644
--- a/include/linux/generic-radix-tree.h
+++ b/include/linux/generic-radix-tree.h
@@ -100,14 +100,9 @@ void __genradix_free(struct __genradix *);
 
 static inline size_t __idx_to_offset(size_t idx, size_t obj_size)
 {
-	if (!is_power_of_2(obj_size)) {
-		size_t objs_per_page = PAGE_SIZE / obj_size;
+	size_t objs_per_page = PAGE_SIZE / obj_size;
 
-		return (idx / objs_per_page) * PAGE_SIZE +
-			(idx % objs_per_page) * obj_size;
-	} else {
-		return idx * obj_size;
-	}
+	return idx * obj_size + (idx / objs_per_page) * (PAGE_SIZE % obj_size);
 }
 
 #define __genradix_cast(_radix)		(typeof((_radix)->type[0]) *)
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
