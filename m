From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Fri, 10 Aug 2018 17:11:43 +0000
Subject: [PATCH v3 2/2] net/sctp: Replace in/out stream arrays with flex_array
Message-Id: <20180810171143.21592-3-khorenko@virtuozzo.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <deb7cbdc-55b9-3ff5-8f13-cfa61e08eebe@virtuozzo.com>
 <20180810171143.21592-1-khorenko@virtuozzo.com>
In-Reply-To: <20180810171143.21592-1-khorenko@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: oleg.babin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>

This path replaces physically contiguous memory arrays
allocated using kmalloc_array() with flexible arrays.
This enables to avoid memory allocation failures on the
systems under a memory stress.

Signed-off-by: Oleg Babin <obabin@virtuozzo.com>
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>

---
 include/net/sctp/structs.h |  9 ++---
 net/sctp/stream.c          | 88 ++++++++++++++++++++++++++++++++++------------
 2 files changed, 71 insertions(+), 26 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index ce4bf844f573..f922db8029e6 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -57,6 +57,7 @@
 #include <linux/atomic.h>		/* This gets us atomic counters.  */
 #include <linux/skbuff.h>	/* We need sk_buff_head. */
 #include <linux/workqueue.h>	/* We need tq_struct.	 */
+#include <linux/flex_array.h>	/* We need flex_array.   */
 #include <linux/sctp.h>		/* We need sctp* header structs.  */
 #include <net/sctp/auth.h>	/* We need auth specific structs */
 #include <net/ip.h>		/* For inet_skb_parm */
@@ -1431,8 +1432,8 @@ struct sctp_stream_in {
 };
 
 struct sctp_stream {
-	struct sctp_stream_out *out;
-	struct sctp_stream_in *in;
+	struct flex_array *out;
+	struct flex_array *in;
 	__u16 outcnt;
 	__u16 incnt;
 	/* Current stream being sent, if any */
@@ -1458,14 +1459,14 @@ static inline struct sctp_stream_out *sctp_stream_out(
 	const struct sctp_stream *stream,
 	__u16 sid)
 {
-	return ((struct sctp_stream_out *)(stream->out)) + sid;
+	return flex_array_get(stream->out, sid);
 }
 
 static inline struct sctp_stream_in *sctp_stream_in(
 	const struct sctp_stream *stream,
 	__u16 sid)
 {
-	return ((struct sctp_stream_in *)(stream->in)) + sid;
+	return flex_array_get(stream->in, sid);
 }
 
 #define SCTP_SO(s, i) sctp_stream_out((s), (i))
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 7ca6fe4e7882..ffb940d3b57c 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -37,6 +37,53 @@
 #include <net/sctp/sm.h>
 #include <net/sctp/stream_sched.h>
 
+static struct flex_array *fa_alloc(size_t elem_size, size_t elem_count,
+				   gfp_t gfp)
+{
+	struct flex_array *result;
+	int err;
+
+	result = flex_array_alloc(elem_size, elem_count, gfp);
+	if (result) {
+		err = flex_array_prealloc(result, 0, elem_count, gfp);
+		if (err) {
+			flex_array_free(result);
+			result = NULL;
+		}
+	}
+
+	return result;
+}
+
+static void fa_free(struct flex_array *fa)
+{
+	if (fa)
+		flex_array_free(fa);
+}
+
+static void fa_copy(struct flex_array *fa, struct flex_array *from,
+		    size_t index, size_t count)
+{
+	void *elem;
+
+	while (count--) {
+		elem = flex_array_get(from, index);
+		flex_array_put(fa, index, elem, 0);
+		index++;
+	}
+}
+
+static void fa_zero(struct flex_array *fa, size_t index, size_t count)
+{
+	void *elem;
+
+	while (count--) {
+		elem = flex_array_get(fa, index);
+		memset(elem, 0, fa->element_size);
+		index++;
+	}
+}
+
 /* Migrates chunks from stream queues to new stream queues if needed,
  * but not across associations. Also, removes those chunks to streams
  * higher than the new max.
@@ -78,34 +125,33 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
 		 * sctp_stream_update will swap ->out pointers.
 		 */
 		for (i = 0; i < outcnt; i++) {
-			kfree(new->out[i].ext);
-			new->out[i].ext = stream->out[i].ext;
-			stream->out[i].ext = NULL;
+			kfree(SCTP_SO(new, i)->ext);
+			SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
+			SCTP_SO(stream, i)->ext = NULL;
 		}
 	}
 
 	for (i = outcnt; i < stream->outcnt; i++)
-		kfree(stream->out[i].ext);
+		kfree(SCTP_SO(stream, i)->ext);
 }
 
 static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
 				 gfp_t gfp)
 {
-	struct sctp_stream_out *out;
+	struct flex_array *out;
+	size_t elem_size = sizeof(struct sctp_stream_out);
 
-	out = kmalloc_array(outcnt, sizeof(*out), gfp);
+	out = fa_alloc(elem_size, outcnt, gfp);
 	if (!out)
 		return -ENOMEM;
 
 	if (stream->out) {
-		memcpy(out, stream->out, min(outcnt, stream->outcnt) *
-					 sizeof(*out));
-		kfree(stream->out);
+		fa_copy(out, stream->out, 0, min(outcnt, stream->outcnt));
+		fa_free(stream->out);
 	}
 
 	if (outcnt > stream->outcnt)
-		memset(out + stream->outcnt, 0,
-		       (outcnt - stream->outcnt) * sizeof(*out));
+		fa_zero(out, stream->outcnt, (outcnt - stream->outcnt));
 
 	stream->out = out;
 
@@ -115,22 +161,20 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
 static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
 				gfp_t gfp)
 {
-	struct sctp_stream_in *in;
-
-	in = kmalloc_array(incnt, sizeof(*stream->in), gfp);
+	struct flex_array *in;
+	size_t elem_size = sizeof(struct sctp_stream_in);
 
+	in = fa_alloc(elem_size, incnt, gfp);
 	if (!in)
 		return -ENOMEM;
 
 	if (stream->in) {
-		memcpy(in, stream->in, min(incnt, stream->incnt) *
-				       sizeof(*in));
-		kfree(stream->in);
+		fa_copy(in, stream->in, 0, min(incnt, stream->incnt));
+		fa_free(stream->in);
 	}
 
 	if (incnt > stream->incnt)
-		memset(in + stream->incnt, 0,
-		       (incnt - stream->incnt) * sizeof(*in));
+		fa_zero(in, stream->incnt, (incnt - stream->incnt));
 
 	stream->in = in;
 
@@ -174,7 +218,7 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 	ret = sctp_stream_alloc_in(stream, incnt, gfp);
 	if (ret) {
 		sched->free(stream);
-		kfree(stream->out);
+		fa_free(stream->out);
 		stream->out = NULL;
 		stream->outcnt = 0;
 		goto out;
@@ -206,8 +250,8 @@ void sctp_stream_free(struct sctp_stream *stream)
 	sched->free(stream);
 	for (i = 0; i < stream->outcnt; i++)
 		kfree(SCTP_SO(stream, i)->ext);
-	kfree(stream->out);
-	kfree(stream->in);
+	fa_free(stream->out);
+	fa_free(stream->in);
 }
 
 void sctp_stream_clear(struct sctp_stream *stream)
-- 
2.15.1
