From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Tue, 01 Jun 2010 12:03:57 +0000
Subject: [PATCH] sctp: handle ootb packet in chunk order as defined
Message-Id: <4C04F72D.4080800@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


Changed the order of processing SHUTDOWN ACK and COOKIE ACK 
refer to section 8.4:Handle "Out of the Blue" Packets. 

SHUTDOWN ACK chunk should be processed before processing 
"Stale Cookie" ERROR or a COOKIE ACK.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 net/sctp/input.c        |   15 ---------------
 net/sctp/sm_statefuns.c |   21 +++++++++++++++++++++
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index ad3466a..b2fbe6f 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -655,7 +655,6 @@ static int sctp_rcv_ootb(struct sk_buff *skb)
 {
 	sctp_chunkhdr_t *ch;
 	__u8 *ch_end;
-	sctp_errhdr_t *err;
 
 	ch = (sctp_chunkhdr_t *) skb->data;
 
@@ -691,20 +690,6 @@ static int sctp_rcv_ootb(struct sk_buff *skb)
 		if (SCTP_CID_INIT = ch->type && (void *)ch != skb->data)
 			goto discard;
 
-		/* RFC 8.4, 7) If the packet contains a "Stale cookie" ERROR
-		 * or a COOKIE ACK the SCTP Packet should be silently
-		 * discarded.
-		 */
-		if (SCTP_CID_COOKIE_ACK = ch->type)
-			goto discard;
-
-		if (SCTP_CID_ERROR = ch->type) {
-			sctp_walk_errors(err, ch) {
-				if (SCTP_ERROR_STALE_COOKIE = err->cause)
-					goto discard;
-			}
-		}
-
 		ch = (sctp_chunkhdr_t *) ch_end;
 	} while (ch_end < skb_tail_pointer(skb));
 
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index dbf98a2..b440c0b 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3320,8 +3320,10 @@ sctp_disposition_t sctp_sf_ootb(const struct sctp_endpoint *ep,
 	struct sctp_chunk *chunk = arg;
 	struct sk_buff *skb = chunk->skb;
 	sctp_chunkhdr_t *ch;
+	sctp_errhdr_t *err;
 	__u8 *ch_end;
 	int ootb_shut_ack = 0;
+	int ootb_cookie_ack = 0;
 
 	SCTP_INC_STATS(SCTP_MIB_OUTOFBLUES);
 
@@ -3346,6 +3348,23 @@ sctp_disposition_t sctp_sf_ootb(const struct sctp_endpoint *ep,
 		if (SCTP_CID_ABORT = ch->type)
 			return sctp_sf_pdiscard(ep, asoc, type, arg, commands);
 
+		/* RFC 8.4, 7) If the packet contains a "Stale cookie" ERROR
+		 * or a COOKIE ACK the SCTP Packet should be silently
+		 * discarded.
+		 */
+
+		if (SCTP_CID_COOKIE_ACK = ch->type)
+			ootb_cookie_ack = 1;
+
+		if (SCTP_CID_ERROR = ch->type) {
+			sctp_walk_errors(err, ch) {
+				if (SCTP_ERROR_STALE_COOKIE = err->cause) {
+					ootb_cookie_ack = 1;
+					break;
+				}
+			}
+		}
+
 		/* Report violation if chunk len overflows */
 		ch_end = ((__u8 *)ch) + WORD_ROUND(ntohs(ch->length));
 		if (ch_end > skb_tail_pointer(skb))
@@ -3357,6 +3376,8 @@ sctp_disposition_t sctp_sf_ootb(const struct sctp_endpoint *ep,
 
 	if (ootb_shut_ack)
 		return sctp_sf_shut_8_4_5(ep, asoc, type, arg, commands);
+	else if (ootb_cookie_ack)
+		return sctp_sf_pdiscard(ep, asoc, type, arg, commands);
 	else
 		return sctp_sf_tabort_8_4_8(ep, asoc, type, arg, commands);
 }
-- 1.7.0 
