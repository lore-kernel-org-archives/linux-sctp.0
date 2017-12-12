From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 12 Dec 2017 09:25:58 +0000
Subject: [PATCH net-next 7/8] sctp: update mid instead of ssn when doing stream and asoc reset
Message-Id: <2ac016924b2b0f70e801297d203697fcb5deb227.1513070662.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1513070662.git.lucien.xin@gmail.com>
 <9b8315277069d021d8a6b581b7304af624a45c61.1513070662.git.lucien.xin@gmail.com>
 <dbe7bd0f6197086a6a4b4d28f0d63ee1073414e8.1513070662.git.lucien.xin@gmail.com>
 <807b1707f79b11d5883d71ea771e98e8f7af3ead.1513070662.git.lucien.xin@gmail.com>
 <5bdf9baf00c367ec91c1e06986be77835be7e451.1513070662.git.lucien.xin@gmail.com>
 <e4f468dc21292382de70c85f8e40272b37154ce0.1513070662.git.lucien.xin@gmail.com>
 <7a112fb936709ef7047548f778a895a46c31a935.1513070662.git.lucien.xin@gmail.com>
In-Reply-To: <7a112fb936709ef7047548f778a895a46c31a935.1513070662.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

When using idata and doing stream and asoc reset, setting ssn with
0 could only clear the 1st 16 bits of mid.

So to make this work for both data and idata, it sets mid with 0
instead of ssn, and also mid_uo for unordered idata also need to
be cleared, as said in section 2.3.2 of RFC8260.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index b3a9f37..06b644d 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -216,11 +216,13 @@ void sctp_stream_clear(struct sctp_stream *stream)
 {
 	int i;
 
-	for (i = 0; i < stream->outcnt; i++)
-		stream->out[i].ssn = 0;
+	for (i = 0; i < stream->outcnt; i++) {
+		stream->out[i].mid = 0;
+		stream->out[i].mid_uo = 0;
+	}
 
 	for (i = 0; i < stream->incnt; i++)
-		stream->in[i].ssn = 0;
+		stream->in[i].mid = 0;
 }
 
 void sctp_stream_update(struct sctp_stream *stream, struct sctp_stream *new)
@@ -607,10 +609,10 @@ struct sctp_chunk *sctp_process_strreset_outreq(
 		}
 
 		for (i = 0; i < nums; i++)
-			stream->in[ntohs(str_p[i])].ssn = 0;
+			stream->in[ntohs(str_p[i])].mid = 0;
 	} else {
 		for (i = 0; i < stream->incnt; i++)
-			stream->in[i].ssn = 0;
+			stream->in[i].mid = 0;
 	}
 
 	result = SCTP_STRRESET_PERFORMED;
@@ -783,10 +785,12 @@ struct sctp_chunk *sctp_process_strreset_tsnreq(
 	/* G5:  The next expected and outgoing SSNs MUST be reset to 0 for all
 	 *      incoming and outgoing streams.
 	 */
-	for (i = 0; i < stream->outcnt; i++)
-		stream->out[i].ssn = 0;
+	for (i = 0; i < stream->outcnt; i++) {
+		stream->out[i].mid = 0;
+		stream->out[i].mid_uo = 0;
+	}
 	for (i = 0; i < stream->incnt; i++)
-		stream->in[i].ssn = 0;
+		stream->in[i].mid = 0;
 
 	result = SCTP_STRRESET_PERFORMED;
 
@@ -976,11 +980,15 @@ struct sctp_chunk *sctp_process_strreset_resp(
 
 		if (result = SCTP_STRRESET_PERFORMED) {
 			if (nums) {
-				for (i = 0; i < nums; i++)
-					stream->out[ntohs(str_p[i])].ssn = 0;
+				for (i = 0; i < nums; i++) {
+					stream->out[ntohs(str_p[i])].mid = 0;
+					stream->out[ntohs(str_p[i])].mid_uo = 0;
+				}
 			} else {
-				for (i = 0; i < stream->outcnt; i++)
-					stream->out[i].ssn = 0;
+				for (i = 0; i < stream->outcnt; i++) {
+					stream->out[i].mid = 0;
+					stream->out[i].mid_uo = 0;
+				}
 			}
 
 			flags = SCTP_STREAM_RESET_OUTGOING_SSN;
@@ -1041,10 +1049,12 @@ struct sctp_chunk *sctp_process_strreset_resp(
 			asoc->ctsn_ack_point = asoc->next_tsn - 1;
 			asoc->adv_peer_ack_point = asoc->ctsn_ack_point;
 
-			for (i = 0; i < stream->outcnt; i++)
-				stream->out[i].ssn = 0;
+			for (i = 0; i < stream->outcnt; i++) {
+				stream->out[i].mid = 0;
+				stream->out[i].mid_uo = 0;
+			}
 			for (i = 0; i < stream->incnt; i++)
-				stream->in[i].ssn = 0;
+				stream->in[i].mid = 0;
 		}
 
 		for (i = 0; i < stream->outcnt; i++)
-- 
2.1.0

