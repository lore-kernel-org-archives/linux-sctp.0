From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 10 Oct 2008 06:33:52 +0000
Subject: [PATCH] sctp: Add check for the TSN field of the SHUTDOWN chunk
Message-Id: <48EEF750.40903@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

If SHUTDOWN chunk is received Cumulative TSN Ack beyond the max tsn currently
send, SHUTDOWN chunk be accepted and the association will be broken. New data
is send, but after received SACK it will be drop because TSN in SACK is less
than the Cumulative TSN, data will be retrans again and again even if correct
SACK is received.

The packet sequence is like this:

Endpoint A                       Endpoint B       ULP
(ESTABLISHED)                    (ESTABLISHED)

               <-----------      DATA (TSN=x-1)

               <-----------      DATA (TSN=x)

  SHUTDOWN     ----------->      (Now Cumulative TSN=x+1000)
  (TSN=x+1000)
               <-----------      DATA (TSN=x+1)

  SACK         ----------->      drop the SACK
  (TSN=x+1)
               <-----------      DATA (TSN=x+1)(retrans)

This patch fix this problem by terminating the association and respond to
the sender with an ABORT.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_statefuns.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 4e452dd..4e58936 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2548,6 +2548,7 @@ sctp_disposition_t sctp_sf_do_9_2_shutdown(const struct sctp_endpoint *ep,
 	sctp_shutdownhdr_t *sdh;
 	sctp_disposition_t disposition;
 	struct sctp_ulpevent *ev;
+	__u32 ctsn;
 
 	if (!sctp_vtag_verify(chunk, asoc))
 		return sctp_sf_pdiscard(ep, asoc, type, arg, commands);
@@ -2562,6 +2563,14 @@ sctp_disposition_t sctp_sf_do_9_2_shutdown(const struct sctp_endpoint *ep,
 	sdh = (sctp_shutdownhdr_t *)chunk->skb->data;
 	skb_pull(chunk->skb, sizeof(sctp_shutdownhdr_t));
 	chunk->subh.shutdown_hdr = sdh;
+	ctsn = ntohl(sdh->cum_tsn_ack);
+
+	/* If Cumulative TSN Ack beyond the max tsn currently
+	 * send, terminating the association and respond to the
+	 * sender with an ABORT.
+	 */
+	if (!TSN_lt(ctsn, asoc->next_tsn))
+		return sctp_sf_violation_ctsn(ep, asoc, type, arg, commands);
 
 	/* API 5.3.1.5 SCTP_SHUTDOWN_EVENT
 	 * When a peer sends a SHUTDOWN, SCTP delivers this notification to
-- 
1.5.3.8



