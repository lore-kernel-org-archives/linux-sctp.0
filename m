From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 03 Feb 2019 19:27:58 +0000
Subject: [PATCHv3 net] sctp: check and update stream->out_curr when allocating stream_out
Message-Id: <91ab89c95836cfcacbe823f4bc0ecd2568bad113.1549222078.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Now when using stream reconfig to add out streams, stream->out
will get re-allocated, and all old streams' information will
be copied to the new ones and the old ones will be freed.

So without stream->out_curr updated, next time when trying to
send from stream->out_curr stream, a panic would be caused.

This patch is to check and update stream->out_curr when
allocating stream_out.

v1->v2:
  - define fa_index() to get elem index from stream->out_curr.
v2->v3:
  - repost with no change.

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Reported-by: Ying Xu <yinxu@redhat.com>
Reported-by: syzbot+e33a3a138267ca119c7d@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 80e0ae5..f246331 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -84,6 +84,19 @@ static void fa_zero(struct flex_array *fa, size_t index, size_t count)
 	}
 }
 
+static size_t fa_index(struct flex_array *fa, void *elem, size_t count)
+{
+	size_t index = 0;
+
+	while (count--) {
+		if (elem = flex_array_get(fa, index))
+			break;
+		index++;
+	}
+
+	return index;
+}
+
 /* Migrates chunks from stream queues to new stream queues if needed,
  * but not across associations. Also, removes those chunks to streams
  * higher than the new max.
@@ -147,6 +160,13 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
 
 	if (stream->out) {
 		fa_copy(out, stream->out, 0, min(outcnt, stream->outcnt));
+		if (stream->out_curr) {
+			size_t index = fa_index(stream->out, stream->out_curr,
+						stream->outcnt);
+
+			BUG_ON(index = stream->outcnt);
+			stream->out_curr = flex_array_get(out, index);
+		}
 		fa_free(stream->out);
 	}
 
-- 
2.1.0
