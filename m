From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 03 Oct 2017 22:20:09 +0000
Subject: [PATCH net-next v2 02/10] sctp: factor out stream->out allocation
Message-Id: <4c6e2ebcb18dd2953a126c6ab6a3dd50c0c93c0d.1507069005.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1507069005.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1507069005.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>, David Laight <David.Laight@ACULAB.COM>

There is 1 place allocating it and 2 other reallocating. Move such
procedures to a common function.

Tested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/stream.c | 52 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 1afa9555808390d5fc736727422d9700a3855613..6d0e997d301f89e165367106c02e82f8a6c3a877 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -35,6 +35,30 @@
 #include <net/sctp/sctp.h>
 #include <net/sctp/sm.h>
 
+static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
+				 gfp_t gfp)
+{
+	struct sctp_stream_out *out;
+
+	out = kmalloc_array(outcnt, sizeof(*out), gfp);
+	if (!out)
+		return -ENOMEM;
+
+	if (stream->out) {
+		memcpy(out, stream->out, min(outcnt, stream->outcnt) *
+					 sizeof(*out));
+		kfree(stream->out);
+	}
+
+	if (outcnt > stream->outcnt)
+		memset(out + stream->outcnt, 0,
+		       (outcnt - stream->outcnt) * sizeof(*out));
+
+	stream->out = out;
+
+	return 0;
+}
+
 int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 		     gfp_t gfp)
 {
@@ -48,11 +72,9 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
 	if (outcnt = stream->outcnt)
 		goto in;
 
-	kfree(stream->out);
-
-	stream->out = kcalloc(outcnt, sizeof(*stream->out), gfp);
-	if (!stream->out)
-		return -ENOMEM;
+	i = sctp_stream_alloc_out(stream, outcnt, gfp);
+	if (i)
+		return i;
 
 	stream->outcnt = outcnt;
 	for (i = 0; i < stream->outcnt; i++)
@@ -276,15 +298,9 @@ int sctp_send_add_streams(struct sctp_association *asoc,
 	}
 
 	if (out) {
-		struct sctp_stream_out *streamout;
-
-		streamout = krealloc(stream->out, outcnt * sizeof(*streamout),
-				     GFP_KERNEL);
-		if (!streamout)
+		retval = sctp_stream_alloc_out(stream, outcnt, GFP_KERNEL);
+		if (retval)
 			goto out;
-
-		memset(streamout + stream->outcnt, 0, out * sizeof(*streamout));
-		stream->out = streamout;
 	}
 
 	chunk = sctp_make_strreset_addstrm(asoc, out, in);
@@ -682,10 +698,10 @@ struct sctp_chunk *sctp_process_strreset_addstrm_in(
 	struct sctp_strreset_addstrm *addstrm = param.v;
 	struct sctp_stream *stream = &asoc->stream;
 	__u32 result = SCTP_STRRESET_DENIED;
-	struct sctp_stream_out *streamout;
 	struct sctp_chunk *chunk = NULL;
 	__u32 request_seq, outcnt;
 	__u16 out, i;
+	int ret;
 
 	request_seq = ntohl(addstrm->request_seq);
 	if (TSN_lt(asoc->strreset_inseq, request_seq) ||
@@ -714,14 +730,10 @@ struct sctp_chunk *sctp_process_strreset_addstrm_in(
 	if (!out || outcnt > SCTP_MAX_STREAM)
 		goto out;
 
-	streamout = krealloc(stream->out, outcnt * sizeof(*streamout),
-			     GFP_ATOMIC);
-	if (!streamout)
+	ret = sctp_stream_alloc_out(stream, outcnt, GFP_ATOMIC);
+	if (ret)
 		goto out;
 
-	memset(streamout + stream->outcnt, 0, out * sizeof(*streamout));
-	stream->out = streamout;
-
 	chunk = sctp_make_strreset_addstrm(asoc, out, 0);
 	if (!chunk)
 		goto out;
-- 
2.13.5

