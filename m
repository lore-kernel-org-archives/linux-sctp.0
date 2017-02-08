From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 08 Feb 2017 17:18:16 +0000
Subject: [PATCHv6 net-next 2/6] sctp: streams should be recovered when it fails to send request.
Message-Id: <3d1180fcc5c72dea7d6cb7c7fafae4c4a7782cb3.1486573728.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1486573727.git.lucien.xin@gmail.com>
 <5f2d5aa54716217f68f724e4165289bd964b8755.1486573728.git.lucien.xin@gmail.com>
In-Reply-To: <5f2d5aa54716217f68f724e4165289bd964b8755.1486573728.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, davem@davemloft.net

Now when sending stream reset request, it closes the streams to
block further xmit of data until this request is completed, then
calls sctp_send_reconf to send the chunk.

But if sctp_send_reconf returns err, and it doesn't recover the
streams' states back,  which means the request chunk would not be
queued and sent, so the asoc will get stuck, streams are closed
and no packet is even queued.

This patch is to fix it by recovering the streams' states when
it fails to send the request, it is also to fix a return value.

Fixes: 7f9d68ac944e ("sctp: implement sender-side procedures for SSN Reset Request Parameter")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 13d5e07..6a686e3 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -136,8 +136,10 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
 				goto out;
 
 	chunk = sctp_make_strreset_req(asoc, str_nums, str_list, out, in);
-	if (!chunk)
+	if (!chunk) {
+		retval = -ENOMEM;
 		goto out;
+	}
 
 	if (out) {
 		if (str_nums)
@@ -149,7 +151,6 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
 				stream->out[i].state = SCTP_STREAM_CLOSED;
 	}
 
-	asoc->strreset_outstanding = out + in;
 	asoc->strreset_chunk = chunk;
 	sctp_chunk_hold(asoc->strreset_chunk);
 
@@ -157,8 +158,22 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
 	if (retval) {
 		sctp_chunk_put(asoc->strreset_chunk);
 		asoc->strreset_chunk = NULL;
+		if (!out)
+			goto out;
+
+		if (str_nums)
+			for (i = 0; i < str_nums; i++)
+				stream->out[str_list[i]].state +						       SCTP_STREAM_OPEN;
+		else
+			for (i = 0; i < stream->outcnt; i++)
+				stream->out[i].state = SCTP_STREAM_OPEN;
+
+		goto out;
 	}
 
+	asoc->strreset_outstanding = out + in;
+
 out:
 	return retval;
 }
-- 
2.1.0

