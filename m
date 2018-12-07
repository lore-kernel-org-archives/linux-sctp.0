From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 07 Dec 2018 06:30:35 +0000
Subject: [PATCHv2 net 3/3] sctp: fa_resize sctp stream instead of redo fa_alloc
Message-Id: <3bc7041d4157e92a36a60c4868834d0a8a439041.1544163962.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1544163962.git.lucien.xin@gmail.com>
 <a4474a5886807d13146dc67e2d214b7ba3029d32.1544163962.git.lucien.xin@gmail.com>
 <9122685dd16d04613de02594325acf79b2d04a3d.1544163962.git.lucien.xin@gmail.com>
In-Reply-To: <9122685dd16d04613de02594325acf79b2d04a3d.1544163962.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Dave Hansen <dave.hansen@linux.intel.com>, David Rientjes <rientjes@google.com>, Eric Paris <eparis@redhat.com>, Konstantin Khorenko <khorenko@virtuozzo.com>

Now when doing 4-shakehand or adding new streams, sctp has to allocate
new memory for asoc->stream and copy the old stream's information from
the old asoc->stream to the new one. It also cause the stream pointers
to change, by which a panic was even caused due to stream->out_curr's
change.

To fix this, flex_array_resize() is used in sctp_stream_alloc_out/in()
when asoc->stream has been allocated. Besides, with this asoc->stream
will only be allocated once, and grow or shrink dynamically later.

Note that flex_array_prealloc() is needed before growing as fa_alloc
does, while flex_array_clear() and flex_array_shrink() are called to
free the unused memory before shrinking.

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Reported-by: Ying Xu <yinxu@redhat.com>
Reported-by: syzbot+e33a3a138267ca119c7d@syzkaller.appspotmail.com
Suggested-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 net/sctp/stream.c | 87 +++++++++++++++++++++++++------------------------------
 1 file changed, 40 insertions(+), 47 deletions(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 3892e76..aff30b2 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -37,6 +37,17 @@
 #include <net/sctp/sm.h>
 #include <net/sctp/stream_sched.h>
 
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
 static struct flex_array *fa_alloc(size_t elem_size, size_t elem_count,
 				   gfp_t gfp)
 {
@@ -48,8 +59,9 @@ static struct flex_array *fa_alloc(size_t elem_size, size_t elem_count,
 		err = flex_array_prealloc(result, 0, elem_count, gfp);
 		if (err) {
 			flex_array_free(result);
-			result = NULL;
+			return NULL;
 		}
+		fa_zero(result, 0, elem_count);
 	}
 
 	return result;
@@ -61,27 +73,28 @@ static void fa_free(struct flex_array *fa)
 		flex_array_free(fa);
 }
 
-static void fa_copy(struct flex_array *fa, struct flex_array *from,
-		    size_t index, size_t count)
+static int fa_resize(struct flex_array *fa, size_t count, gfp_t gfp)
 {
-	void *elem;
+	int nr = fa->total_nr_elements, n;
 
-	while (count--) {
-		elem = flex_array_get(from, index);
-		flex_array_put(fa, index, elem, 0);
-		index++;
+	if (count > nr) {
+		if (flex_array_resize(fa, count, gfp))
+			return -ENOMEM;
+		if (flex_array_prealloc(fa, nr, count - nr, gfp))
+			return -ENOMEM;
+		fa_zero(fa, nr, count - nr);
+
+		return 0;
 	}
-}
 
-static void fa_zero(struct flex_array *fa, size_t index, size_t count)
-{
-	void *elem;
+	/* Shrink the unused memory,
+	 * FLEX_ARRAY_FREE check is safe for sctp stream.
+	 */
+	for (n = count; n < nr; n++)
+		flex_array_clear(fa, n);
+	flex_array_shrink(fa);
 
-	while (count--) {
-		elem = flex_array_get(fa, index);
-		memset(elem, 0, fa->element_size);
-		index++;
-	}
+	return flex_array_resize(fa, count, gfp);
 }
 
 /* Migrates chunks from stream queues to new stream queues if needed,
@@ -138,47 +151,27 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
 static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
 				 gfp_t gfp)
 {
-	struct flex_array *out;
-	size_t elem_size = sizeof(struct sctp_stream_out);
-
-	out = fa_alloc(elem_size, outcnt, gfp);
-	if (!out)
-		return -ENOMEM;
+	if (!stream->out) {
+		stream->out = fa_alloc(sizeof(struct sctp_stream_out),
+				       outcnt, gfp);
 
-	if (stream->out) {
-		fa_copy(out, stream->out, 0, min(outcnt, stream->outcnt));
-		fa_free(stream->out);
+		return stream->out ? 0 : -ENOMEM;
 	}
 
-	if (outcnt > stream->outcnt)
-		fa_zero(out, stream->outcnt, (outcnt - stream->outcnt));
-
-	stream->out = out;
-
-	return 0;
+	return fa_resize(stream->out, outcnt, gfp);
 }
 
 static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
 				gfp_t gfp)
 {
-	struct flex_array *in;
-	size_t elem_size = sizeof(struct sctp_stream_in);
+	if (!stream->in) {
+		stream->in = fa_alloc(sizeof(struct sctp_stream_in),
+				      incnt, gfp);
 
-	in = fa_alloc(elem_size, incnt, gfp);
-	if (!in)
-		return -ENOMEM;
-
-	if (stream->in) {
-		fa_copy(in, stream->in, 0, min(incnt, stream->incnt));
-		fa_free(stream->in);
+		return stream->in ? 0 : -ENOMEM;
 	}
 
-	if (incnt > stream->incnt)
-		fa_zero(in, stream->incnt, (incnt - stream->incnt));
-
-	stream->in = in;
-
-	return 0;
+	return fa_resize(stream->in, incnt, gfp);
 }
 
 int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
-- 
2.1.0
