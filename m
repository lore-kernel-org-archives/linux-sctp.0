From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Sat, 22 Aug 2009 03:24:00 +0000
Subject: [PATCH] sctp: drop SHUTDOWN chunk if the TSN is less than the CTSN
Message-Id: <4A8F64D0.8000408@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

If Cumulative TSN Ack field of SHUTDOWN chunk is less than the
Cumulative TSN Ack Point then drop the SHUTDOWN chunk.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_statefuns.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 7288192..071c668 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2561,6 +2561,12 @@ sctp_disposition_t sctp_sf_do_9_2_shutdown(const struct sctp_endpoint *ep,
 	chunk->subh.shutdown_hdr = sdh;
 	ctsn = ntohl(sdh->cum_tsn_ack);
 
+	if (TSN_lt(ctsn, asoc->ctsn_ack_point)) {
+		SCTP_DEBUG_PRINTK("ctsn %x\n", ctsn);
+		SCTP_DEBUG_PRINTK("ctsn_ack_point %x\n", asoc->ctsn_ack_point);
+		return SCTP_DISPOSITION_DISCARD;
+	}
+
 	/* If Cumulative TSN Ack beyond the max tsn currently
 	 * send, terminating the association and respond to the
 	 * sender with an ABORT.
@@ -2624,6 +2630,7 @@ sctp_disposition_t sctp_sf_do_9_2_shut_ctsn(const struct sctp_endpoint *ep,
 {
 	struct sctp_chunk *chunk = arg;
 	sctp_shutdownhdr_t *sdh;
+	__u32 ctsn;
 
 	if (!sctp_vtag_verify(chunk, asoc))
 		return sctp_sf_pdiscard(ep, asoc, type, arg, commands);
@@ -2635,12 +2642,19 @@ sctp_disposition_t sctp_sf_do_9_2_shut_ctsn(const struct sctp_endpoint *ep,
 						  commands);
 
 	sdh = (sctp_shutdownhdr_t *)chunk->skb->data;
+	ctsn = ntohl(sdh->cum_tsn_ack);
+
+	if (TSN_lt(ctsn, asoc->ctsn_ack_point)) {
+		SCTP_DEBUG_PRINTK("ctsn %x\n", ctsn);
+		SCTP_DEBUG_PRINTK("ctsn_ack_point %x\n", asoc->ctsn_ack_point);
+		return SCTP_DISPOSITION_DISCARD;
+	}
 
 	/* If Cumulative TSN Ack beyond the max tsn currently
 	 * send, terminating the association and respond to the
 	 * sender with an ABORT.
 	 */
-	if (!TSN_lt(ntohl(sdh->cum_tsn_ack), asoc->next_tsn))
+	if (!TSN_lt(ctsn, asoc->next_tsn))
 		return sctp_sf_violation_ctsn(ep, asoc, type, arg, commands);
 
 	/* verify, by checking the Cumulative TSN Ack field of the
-- 
1.6.2.2




