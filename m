From: Kevin Kou <qdkevin.kou@gmail.com>
Date: Tue, 24 Dec 2019 10:40:40 +0000
Subject: [PATCH v2] sctp: do trace_sctp_probe after SACK validation and check
Message-Id: <20191224104040.511-1-qdkevin.kou@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net, qdkevin.kou@gmail.com

The function sctp_sf_eat_sack_6_2 now performs the Verification
Tag validation, Chunk length validation, Bogu check, and also
the detection of out-of-order SACK based on the RFC2960
Section 6.2 at the beginning, and finally performs the further
processing of SACK. The trace_sctp_probe now triggered before
the above necessary validation and check.

this patch is to do the trace_sctp_probe after the chunk sanity
tests, but keep doing trace if the SACK received is out of order,
for the out-of-order SACK is valuable to congestion control
debugging.

v1->v2:
 - keep doing SCTP trace if the SACK is out of order as Marcelo's
   suggestion.

Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
---
 net/sctp/sm_statefuns.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index b4a54df..d302a78 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3298,6 +3298,15 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
 	chunk->subh.sack_hdr = sackh;
 	ctsn = ntohl(sackh->cum_tsn_ack);
 
+	/* If Cumulative TSN Ack beyond the max tsn currently
+	 * send, terminating the association and respond to the
+	 * sender with an ABORT.
+	 */
+	if (TSN_lte(asoc->next_tsn, ctsn))
+		return sctp_sf_violation_ctsn(net, ep, asoc, type, arg, commands);
+
+	trace_sctp_probe(ep, asoc, chunk);
+
 	/* i) If Cumulative TSN Ack is less than the Cumulative TSN
 	 *     Ack Point, then drop the SACK.  Since Cumulative TSN
 	 *     Ack is monotonically increasing, a SACK whose
@@ -3311,15 +3320,6 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
 		return SCTP_DISPOSITION_DISCARD;
 	}
 
-	/* If Cumulative TSN Ack beyond the max tsn currently
-	 * send, terminating the association and respond to the
-	 * sender with an ABORT.
-	 */
-	if (!TSN_lt(ctsn, asoc->next_tsn))
-		return sctp_sf_violation_ctsn(net, ep, asoc, type, arg, commands);
-
-	trace_sctp_probe(ep, asoc, chunk);
-
 	/* Return this SACK for further processing.  */
 	sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK, SCTP_CHUNK(chunk));
 
-- 
1.8.3.1
