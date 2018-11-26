From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 26 Nov 2018 11:22:05 +0000
Subject: [PATCH net] sctp: check and update stream->out_curr when allocating stream_out
Message-Id: <3abaeca7357361956c7c5629544aeb7704353308.1543231325.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Now when using stream reconfig to add out streams, stream->out
will get re-allocated, and all old streams' information will
be copied to the new ones and the old ones will be freed.

So without stream->out_curr updated, next time when trying to
send from stream->out_curr stream, a panic would be caused.

This patch is to define sctp_stream_out_copy used to update the
stream->out_curr pointer to the new stream when copying the old
streams' information.

While at it, rename fa_copy to sctp_stream_in_copy.

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Reported-by: Ying Xu <yinxu@redhat.com>
Reported-by: syzbot+e33a3a138267ca119c7d@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream.c | 46 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 3892e76..0687eeb 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -61,18 +61,6 @@ static void fa_free(struct flex_array *fa)
 		flex_array_free(fa);
 }
 
-static void fa_copy(struct flex_array *fa, struct flex_array *from,
-		    size_t index, size_t count)
-{
-	void *elem;
-
-	while (count--) {
-		elem = flex_array_get(from, index);
-		flex_array_put(fa, index, elem, 0);
-		index++;
-	}
-}
-
 static void fa_zero(struct flex_array *fa, size_t index, size_t count)
 {
 	void *elem;
@@ -135,6 +123,36 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
 		kfree(SCTP_SO(stream, i)->ext);
 }
 
+static void sctp_stream_in_copy(struct flex_array *fa,
+				struct sctp_stream *stream, __u16 count)
+{
+	size_t index = 0;
+	void *elem;
+
+	count = min(count, stream->incnt);
+	while (count--) {
+		elem = flex_array_get(stream->in, index);
+		flex_array_put(fa, index, elem, 0);
+		index++;
+	}
+}
+
+static void sctp_stream_out_copy(struct flex_array *fa,
+				 struct sctp_stream *stream, __u16 count)
+{
+	size_t index = 0;
+	void *elem;
+
+	count = min(count, stream->outcnt);
+	while (count--) {
+		elem = flex_array_get(stream->out, index);
+		flex_array_put(fa, index, elem, 0);
+		if (stream->out_curr = elem)
+			stream->out_curr = flex_array_get(fa, index);
+		index++;
+	}
+}
+
 static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
 				 gfp_t gfp)
 {
@@ -146,7 +164,7 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
 		return -ENOMEM;
 
 	if (stream->out) {
-		fa_copy(out, stream->out, 0, min(outcnt, stream->outcnt));
+		sctp_stream_out_copy(out, stream, outcnt);
 		fa_free(stream->out);
 	}
 
@@ -169,7 +187,7 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
 		return -ENOMEM;
 
 	if (stream->in) {
-		fa_copy(in, stream->in, 0, min(incnt, stream->incnt));
+		sctp_stream_in_copy(in, stream, incnt);
 		fa_free(stream->in);
 	}
 
-- 
2.1.0
