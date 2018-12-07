From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 07 Dec 2018 06:30:34 +0000
Subject: [PATCHv2 net 2/3] flex_array: support flex_array_resize
Message-Id: <9122685dd16d04613de02594325acf79b2d04a3d.1544163962.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1544163962.git.lucien.xin@gmail.com>
 <a4474a5886807d13146dc67e2d214b7ba3029d32.1544163962.git.lucien.xin@gmail.com>
In-Reply-To: <a4474a5886807d13146dc67e2d214b7ba3029d32.1544163962.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Dave Hansen <dave.hansen@linux.intel.com>, David Rientjes <rientjes@google.com>, Eric Paris <eparis@redhat.com>, Konstantin Khorenko <khorenko@virtuozzo.com>

This function can dynamically change total_nr_elements of a flex_array,
and keep the old elements of the same memory. Returns 0 if it succeeds.

Note that it won't do any memory allocation or shrinking for elements,
which should be only done by flex_array_prealloc and flex_array_shrink.

Suggested-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 include/linux/flex_array.h | 11 +++++++++
 lib/flex_array.c           | 58 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/include/linux/flex_array.h b/include/linux/flex_array.h
index 29ad65f..19ff58d 100644
--- a/include/linux/flex_array.h
+++ b/include/linux/flex_array.h
@@ -130,6 +130,17 @@ void *flex_array_get(struct flex_array *fa, unsigned int element_nr);
  */
 int flex_array_shrink(struct flex_array *fa);
 
+/**
+ * flex_array_resize() - Resize without the old elements memory changed
+ * @fa:		array to resize
+ * @total:	total number of elements that this would change to
+ * @flags:	page allocation flags to use for base array
+ *
+ * Return:	Returns 0 if it succeeds.
+ *
+ */
+int flex_array_resize(struct flex_array *fa, unsigned int total, gfp_t flags);
+
 #define flex_array_put_ptr(fa, nr, src, gfp) \
 	flex_array_put(fa, nr, (void *)&(src), gfp)
 
diff --git a/lib/flex_array.c b/lib/flex_array.c
index 8c0b9b6..2f913e7 100644
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -405,3 +405,61 @@ int flex_array_shrink(struct flex_array *fa)
 	return ret;
 }
 EXPORT_SYMBOL(flex_array_shrink);
+
+/**
+ * flex_array_resize - resize without the old elements memory changed
+ * @fa:		the flex array to resize
+ * @total:	total number of elements that this would change to
+ * @flags:	page allocation flags to use for base array
+ *
+ * This function can dynamically change total_nr_elements of a flex_array,
+ * and keep the old elements of the same memory. Returns 0 if it succeeds.
+ * Note that it won't do any memory allocation or shrinking for elements,
+ * which should be only done by flex_array_prealloc and flex_array_shrink.
+ *
+ * Locking must be provided by the caller.
+ */
+int flex_array_resize(struct flex_array *fa, unsigned int total, gfp_t flags)
+{
+	int nr;
+
+	if (total > FLEX_ARRAY_NR_BASE_PTRS * fa->elems_per_part)
+		return -EINVAL;
+
+	if (elements_fit_in_base(fa)) {
+		struct flex_array_part_p *part_p;
+
+		nr = fa->total_nr_elements;
+		fa->total_nr_elements = total;
+		if (elements_fit_in_base(fa))
+			return 0;
+
+		part_p = kzalloc(sizeof(*part_p), flags);
+		if (!part_p) {
+			fa->total_nr_elements = nr;
+			return -ENOMEM;
+		}
+
+		part_p->p_part[0] = (struct flex_array_part *)&fa->parts[0];
+		fa->part_p = part_p;
+	} else {
+		struct flex_array_part *part;
+
+		fa->total_nr_elements = total;
+		if (!elements_fit_in_base(fa))
+			return 0;
+
+		for (nr = 1; nr < FLEX_ARRAY_NR_BASE_PTRS; nr++) {
+			part = fa->parts[nr];
+			if (part) {
+				fa->parts[nr] = NULL;
+				kfree(part);
+			}
+		}
+
+		fa->part_p = (struct flex_array_part_p *)fa->parts[0];
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(flex_array_resize);
-- 
2.1.0
