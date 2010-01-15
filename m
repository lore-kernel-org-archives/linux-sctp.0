From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 15 Jan 2010 03:49:37 +0000
Subject: sctp: fix to retranmit at least one DATA chunk
Message-Id: <4B4FE5D1.2040103@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

While doing retranmit, if control chunk is exists, such as
FORWARD TSN chunk, and the DATA chunk can not be bundled with
the control chunk because the limit of PMTU, none DATA chunk
will be retranmitted in the current implementation. This
patch fix to retranmit at least one DATA chunk in this case.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/outqueue.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 8092032..61cd7f1 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -609,13 +609,20 @@ static int sctp_outq_flush_rtx(struct sctp_outq *q, struct sctp_packet *pkt,
 		if (fast_rtx && !chunk->fast_retransmit)
 			continue;
 
+redo:
 		/* Attempt to append this chunk to the packet. */
 		status = sctp_packet_append_chunk(pkt, chunk);
 
 		switch (status) {
 		case SCTP_XMIT_PMTU_FULL:
-			/* Send this packet.  */
-			error = sctp_packet_transmit(pkt);
+			if (!pkt->has_data && !pkt->has_cookie_echo) {
+				/* Send a control chunk. */
+				error = sctp_packet_transmit(pkt);
+				goto redo;
+			} else {
+				/* Send this packet.  */
+				error = sctp_packet_transmit(pkt);
+			}
 
 			/* If we are retransmitting, we should only
 			 * send a single packet.
-- 
1.6.2.2


