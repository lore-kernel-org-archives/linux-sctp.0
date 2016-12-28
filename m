From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 28 Dec 2016 11:26:31 +0000
Subject: [PATCH RESEND net-next 1/5] sctp: reduce indent level at sctp_sf_tabort_8_4_8
Message-Id: <889763e8337c9ee206957270dd55cc222d64664f.1482924092.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1482924092.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1482924092.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/sm_statefuns.c | 44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 8ec20a64a3f8055a0c3576627c5ec5dad7e99ca8..32587b1f84e729221965e270607fea7ef93a7430 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3237,36 +3237,34 @@ static sctp_disposition_t sctp_sf_tabort_8_4_8(struct net *net,
 	struct sctp_chunk *abort;
 
 	packet = sctp_ootb_pkt_new(net, asoc, chunk);
+	if (!packet)
+		return SCTP_DISPOSITION_NOMEM;
 
-	if (packet) {
-		/* Make an ABORT. The T bit will be set if the asoc
-		 * is NULL.
-		 */
-		abort = sctp_make_abort(asoc, chunk, 0);
-		if (!abort) {
-			sctp_ootb_pkt_free(packet);
-			return SCTP_DISPOSITION_NOMEM;
-		}
+	/* Make an ABORT. The T bit will be set if the asoc
+	 * is NULL.
+	 */
+	abort = sctp_make_abort(asoc, chunk, 0);
+	if (!abort) {
+		sctp_ootb_pkt_free(packet);
+		return SCTP_DISPOSITION_NOMEM;
+	}
 
-		/* Reflect vtag if T-Bit is set */
-		if (sctp_test_T_bit(abort))
-			packet->vtag = ntohl(chunk->sctp_hdr->vtag);
+	/* Reflect vtag if T-Bit is set */
+	if (sctp_test_T_bit(abort))
+		packet->vtag = ntohl(chunk->sctp_hdr->vtag);
 
-		/* Set the skb to the belonging sock for accounting.  */
-		abort->skb->sk = ep->base.sk;
+	/* Set the skb to the belonging sock for accounting.  */
+	abort->skb->sk = ep->base.sk;
 
-		sctp_packet_append_chunk(packet, abort);
+	sctp_packet_append_chunk(packet, abort);
 
-		sctp_add_cmd_sf(commands, SCTP_CMD_SEND_PKT,
-				SCTP_PACKET(packet));
-
-		SCTP_INC_STATS(net, SCTP_MIB_OUTCTRLCHUNKS);
+	sctp_add_cmd_sf(commands, SCTP_CMD_SEND_PKT,
+			SCTP_PACKET(packet));
 
-		sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
-		return SCTP_DISPOSITION_CONSUME;
-	}
+	SCTP_INC_STATS(net, SCTP_MIB_OUTCTRLCHUNKS);
 
-	return SCTP_DISPOSITION_NOMEM;
+	sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+	return SCTP_DISPOSITION_CONSUME;
 }
 
 /*
-- 
2.9.3

