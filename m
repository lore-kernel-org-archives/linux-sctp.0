From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 19 Feb 2009 09:32:12 +0000
Subject: [PATCH 3/4] sctp: Fix the RTO-doubling on idle-link heartbeats
Message-Id: <499D271C.60809@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Recently committed faee47cdbfe8d74a1573c2f81ea6dbb08d735be6 broken
the RTO update of T3-rtx.

This patch reset the patch and fixed the bug about RTO-doubling on
idle-link heartbeats. The HEARTBEAT primitive only need update the
hb timer, not need to reset the transport. After this change, the
we double the RTO only if the heartbeat is unacknowledged.

This bug if found and test by SCTP Conformance Test Suite
<http://networktest.sourceforge.net/>.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/structs.h |    2 --
 net/sctp/sm_sideeffect.c   |   17 ++---------------
 net/sctp/sm_statefuns.c    |    7 +------
 net/sctp/transport.c       |    2 --
 4 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 23f08fe..9f70d54 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -910,10 +910,8 @@ struct sctp_transport {
 	 *		should be set. Every time the RTT
 	 *		calculation completes (i.e. the DATA chunk
 	 *		is SACK'd) clear this flag.
-	 * hb_sent : a flag that signals that we have a pending heartbeat.
 	 */
 	__u8 rto_pending;
-	__u8 hb_sent;
 
 	/* Flag to track the current fast recovery state */
 	__u8 fast_recovery;
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 0146cfb..e1d6076 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -461,15 +461,9 @@ static void sctp_do_8_2_transport_strike(struct sctp_association *asoc,
 	 * expires, set RTO <- RTO * 2 ("back off the timer").  The
 	 * maximum value discussed in rule C7 above (RTO.max) may be
 	 * used to provide an upper bound to this doubling operation.
-	 *
-	 * Special Case:  the first HB doesn't trigger exponential backoff.
-	 * The first unacknowleged HB triggers it.  We do this with a flag
-	 * that indicates that we have an outstanding HB.
 	 */
-	if (transport->hb_sent) {
-		transport->last_rto = transport->rto;
-		transport->rto = min((transport->rto * 2), transport->asoc->rto_max);
-	}
+	transport->last_rto = transport->rto;
+	transport->rto = min((transport->rto * 2), transport->asoc->rto_max);
 }
 
 /* Worker routine to handle INIT command failure.  */
@@ -627,11 +621,6 @@ static void sctp_cmd_transport_on(sctp_cmd_seq_t *cmds,
 	t->error_count = 0;
 	t->asoc->overall_error_count = 0;
 
-	/* Clear the hb_sent flag to signal that we had a good
-	 * acknowledgement.
-	 */
-	t->hb_sent = 0;
-
 	/* Mark the destination transport address as active if it is not so
 	 * marked.
 	 */
@@ -668,8 +657,6 @@ static void sctp_cmd_transport_reset(sctp_cmd_seq_t *cmds,
 
 	/* Mark one strike against a transport.  */
 	sctp_do_8_2_transport_strike(asoc, t);
-
-	t->hb_sent = 1;
 }
 
 /* Helper function to process the process SACK command.  */
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 3a0cd07..3e7f6d2 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4961,13 +4961,8 @@ sctp_disposition_t sctp_sf_do_prm_requestheartbeat(
 	 *
 	 *    D) Request an on-demand HEARTBEAT on a specific destination
 	 *    transport address of a given association.
-	 *
-	 *    The endpoint should increment the respective error  counter of
-	 *    the destination transport address each time a HEARTBEAT is sent
-	 *    to that address and not acknowledged within one RTO.
-	 *
 	 */
-	sctp_add_cmd_sf(commands, SCTP_CMD_TRANSPORT_RESET,
+	sctp_add_cmd_sf(commands, SCTP_CMD_HB_TIMER_UPDATE,
 			SCTP_TRANSPORT(arg));
 	return SCTP_DISPOSITION_CONSUME;
 }
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 5c29b14..e745c11 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -79,7 +79,6 @@ static struct sctp_transport *sctp_transport_init(struct sctp_transport *peer,
 	peer->rttvar = 0;
 	peer->srtt = 0;
 	peer->rto_pending = 0;
-	peer->hb_sent = 0;
 	peer->fast_recovery = 0;
 
 	peer->last_time_heard = jiffies;
@@ -609,7 +608,6 @@ void sctp_transport_reset(struct sctp_transport *t)
 	t->flight_size = 0;
 	t->error_count = 0;
 	t->rto_pending = 0;
-	t->hb_sent = 0;
 	t->fast_recovery = 0;
 
 	/* Initialize the state information for SFR-CACC */
-- 
1.5.3.8




