From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 15 Apr 2017 13:56:57 +0000
Subject: [PATCH net-next] sctp: get list_of_streams of strreset outreq earlier
Message-Id: <3537c3429653a9b83da508e61210dd4b2fdde60a.1492264617.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Now when processing strreset out responses, it gets outreq->list_of_streams
only when result is performed. But if result is not performed, str_p will
be NULL. It will cause panic in sctp_ulpevent_make_stream_reset_event if
nums is not 0.

This patch is to fix it by getting outreq->list_of_streams earlier, and
also to improve some codes for the strreset inreq process.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index eff6008..4ec3679 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -732,14 +732,14 @@ struct sctp_chunk *sctp_process_strreset_resp(
 
 	if (req->type = SCTP_PARAM_RESET_OUT_REQUEST) {
 		struct sctp_strreset_outreq *outreq;
-		__u16 *str_p = NULL;
+		__u16 *str_p;
 
 		outreq = (struct sctp_strreset_outreq *)req;
+		str_p = outreq->list_of_streams;
 		nums = (ntohs(outreq->param_hdr.length) - sizeof(*outreq)) / 2;
 
 		if (result = SCTP_STRRESET_PERFORMED) {
 			if (nums) {
-				str_p = outreq->list_of_streams;
 				for (i = 0; i < nums; i++)
 					stream->out[ntohs(str_p[i])].ssn = 0;
 			} else {
@@ -757,16 +757,16 @@ struct sctp_chunk *sctp_process_strreset_resp(
 			nums, str_p, GFP_ATOMIC);
 	} else if (req->type = SCTP_PARAM_RESET_IN_REQUEST) {
 		struct sctp_strreset_inreq *inreq;
-		__u16 *str_p = NULL;
+		__u16 *str_p;
 
 		/* if the result is performed, it's impossible for inreq */
 		if (result = SCTP_STRRESET_PERFORMED)
 			return NULL;
 
 		inreq = (struct sctp_strreset_inreq *)req;
+		str_p = inreq->list_of_streams;
 		nums = (ntohs(inreq->param_hdr.length) - sizeof(*inreq)) / 2;
 
-		str_p = inreq->list_of_streams;
 		*evp = sctp_ulpevent_make_stream_reset_event(asoc, flags,
 			nums, str_p, GFP_ATOMIC);
 	} else if (req->type = SCTP_PARAM_RESET_TSN_REQUEST) {
-- 
2.1.0

