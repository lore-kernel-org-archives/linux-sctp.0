From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 26 Apr 2018 07:21:44 +0000
Subject: [PATCH net] sctp: clear the new asoc's stream outcnt in sctp_stream_update
Message-Id: <7a1180e29789ab0aa339ae8b456a100520ffcdc5.1524727304.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

When processing a duplicate cookie-echo chunk, sctp moves the new
temp asoc's stream out/in into the old asoc, and later frees this
new temp asoc.

But now after this move, the new temp asoc's stream->outcnt is not
cleared while stream->out is set to NULL, which would cause a same
crash as the one fixed in Commit 79d0895140e9 ("sctp: fix error
path in sctp_stream_init") when freeing this asoc later.

This fix is to clear this outcnt in sctp_stream_update.

Fixes: f952be79cebd ("sctp: introduce struct sctp_stream_out_ext")
Reported-by: Jianwen Ji <jiji@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index f799043..f1f1d1b 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -240,6 +240,8 @@ void sctp_stream_update(struct sctp_stream *stream, struct sctp_stream *new)
 
 	new->out = NULL;
 	new->in  = NULL;
+	new->outcnt = 0;
+	new->incnt  = 0;
 }
 
 static int sctp_send_reconf(struct sctp_association *asoc,
-- 
2.1.0

