From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 20 Jan 2017 18:00:35 +0000
Subject: [PATCHv4 net-next 1/5] sctp: streams should be closed when stream reset request is sent successfully
Message-Id: <162aa3d0e82a2224ea08f2adc8bf4c0eb99b5cac.1484934853.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1484934853.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1484934853.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, davem@davemloft.net

Now when sending stream reset request, it closes the streams to
block further xmit of data until this request is completed, then
calls sctp_send_reconf to send the chunk.

But if sctp_send_reconf returns err, which means the request chunk
would not be queued and sent, so the asoc will get stuck, streams
are closed and no packet was even queued.

This patch is to fix it by closing streams only when request is sent
successfully, it is also to fix a return value.

Fixes: 7f9d68ac944e ("sctp: implement sender-side procedures for SSN Reset Request Parameter")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index 13d5e07..53c67d6 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -136,8 +136,20 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
 				goto out;
 
 	chunk = sctp_make_strreset_req(asoc, str_nums, str_list, out, in);
-	if (!chunk)
+	if (!chunk) {
+		retval = -ENOMEM;
 		goto out;
+	}
+
+	asoc->strreset_chunk = chunk;
+	sctp_chunk_hold(asoc->strreset_chunk);
+
+	retval = sctp_send_reconf(asoc, chunk);
+	if (retval) {
+		sctp_chunk_put(asoc->strreset_chunk);
+		asoc->strreset_chunk = NULL;
+		goto out;
+	}
 
 	if (out) {
 		if (str_nums)
@@ -150,14 +162,6 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
 	}
 
 	asoc->strreset_outstanding = out + in;
-	asoc->strreset_chunk = chunk;
-	sctp_chunk_hold(asoc->strreset_chunk);
-
-	retval = sctp_send_reconf(asoc, chunk);
-	if (retval) {
-		sctp_chunk_put(asoc->strreset_chunk);
-		asoc->strreset_chunk = NULL;
-	}
 
 out:
 	return retval;
-- 
2.1.0

