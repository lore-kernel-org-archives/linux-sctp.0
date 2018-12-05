From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 05 Dec 2018 06:49:40 +0000
Subject: [PATCH net 1/3] flex_array: make FLEX_ARRAY_BASE_SIZE the same value of FLEX_ARRAY_PART_SIZE
Message-Id: <afecf0734c4f583e9179d2b2e069b969647f29bb.1543992464.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1543992464.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1543992464.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Dave Hansen <dave@linux.vnet.ibm.com>, Konstantin Khorenko <khorenko@virtuozzo.com>

This patch is to separate the base data memory from struct flex_array and
save it into a page. With this change, total_nr_elements of a flex_array
can grow or shrink without having the old element's memory changed when
the new size of the flex_arry crosses FLEX_ARRAY_BASE_SIZE, which will
be added in the next patch.

Suggested-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/flex_array.h | 29 +++++++++--------------------
 lib/flex_array.c           | 15 ++++++++++++---
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/include/linux/flex_array.h b/include/linux/flex_array.h
index b94fa61..29ad65f 100644
--- a/include/linux/flex_array.h
+++ b/include/linux/flex_array.h
@@ -7,9 +7,10 @@
 #include <asm/page.h>
 
 #define FLEX_ARRAY_PART_SIZE PAGE_SIZE
-#define FLEX_ARRAY_BASE_SIZE PAGE_SIZE
+#define FLEX_ARRAY_BASE_SIZE FLEX_ARRAY_PART_SIZE
 
 struct flex_array_part;
+struct flex_array_part_p;
 
 /*
  * This is meant to replace cases where an array-like
@@ -19,29 +20,17 @@ struct flex_array_part;
  */
 
 struct flex_array {
-	union {
-		struct {
-			int element_size;
-			int total_nr_elements;
-			int elems_per_part;
-			struct reciprocal_value reciprocal_elems;
-			struct flex_array_part *parts[];
-		};
-		/*
-		 * This little trick makes sure that
-		 * sizeof(flex_array) = PAGE_SIZE
-		 */
-		char padding[FLEX_ARRAY_BASE_SIZE];
-	};
+	int element_size;
+	int total_nr_elements;
+	int elems_per_part;
+	struct reciprocal_value reciprocal_elems;
+	struct flex_array_part_p *part_p;
+#define parts part_p->p_part
 };
 
-/* Number of bytes left in base struct flex_array, excluding metadata */
-#define FLEX_ARRAY_BASE_BYTES_LEFT					\
-	(FLEX_ARRAY_BASE_SIZE - offsetof(struct flex_array, parts))
-
 /* Number of pointers in base to struct flex_array_part pages */
 #define FLEX_ARRAY_NR_BASE_PTRS						\
-	(FLEX_ARRAY_BASE_BYTES_LEFT / sizeof(struct flex_array_part *))
+	(FLEX_ARRAY_BASE_SIZE / sizeof(struct flex_array_part *))
 
 /* Number of elements of size that fit in struct flex_array_part */
 #define FLEX_ARRAY_ELEMENTS_PER_PART(size)				\
diff --git a/lib/flex_array.c b/lib/flex_array.c
index 2eed22f..8c0b9b6 100644
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -30,6 +30,10 @@ struct flex_array_part {
 	char elements[FLEX_ARRAY_PART_SIZE];
 };
 
+struct flex_array_part_p {
+	struct flex_array_part *p_part[FLEX_ARRAY_NR_BASE_PTRS];
+};
+
 /*
  * If a user requests an allocation which is small
  * enough, we may simply use the space in the
@@ -39,7 +43,7 @@ struct flex_array_part {
 static inline int elements_fit_in_base(struct flex_array *fa)
 {
 	int data_size = fa->element_size * fa->total_nr_elements;
-	if (data_size <= FLEX_ARRAY_BASE_BYTES_LEFT)
+	if (data_size <= FLEX_ARRAY_BASE_SIZE)
 		return 1;
 	return 0;
 }
@@ -105,13 +109,17 @@ struct flex_array *flex_array_alloc(int element_size, unsigned int total,
 	ret = kzalloc(sizeof(struct flex_array), flags);
 	if (!ret)
 		return NULL;
+	ret->part_p = kzalloc(sizeof(struct flex_array_part_p), flags);
+	if (!ret->part_p) {
+		kfree(ret);
+		return NULL;
+	}
 	ret->element_size = element_size;
 	ret->total_nr_elements = total;
 	ret->elems_per_part = elems_per_part;
 	ret->reciprocal_elems = reciprocal_elems;
 	if (elements_fit_in_base(ret) && !(flags & __GFP_ZERO))
-		memset(&ret->parts[0], FLEX_ARRAY_FREE,
-						FLEX_ARRAY_BASE_BYTES_LEFT);
+		memset(&ret->parts[0], FLEX_ARRAY_FREE, FLEX_ARRAY_BASE_SIZE);
 	return ret;
 }
 EXPORT_SYMBOL(flex_array_alloc);
@@ -148,6 +156,7 @@ EXPORT_SYMBOL(flex_array_free_parts);
 void flex_array_free(struct flex_array *fa)
 {
 	flex_array_free_parts(fa);
+	kfree(fa->part_p);
 	kfree(fa);
 }
 EXPORT_SYMBOL(flex_array_free);
-- 
2.1.0
