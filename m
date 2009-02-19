From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 19 Feb 2009 17:11:27 +0000
Subject: [PATCH] sctp: Fix broken RTO-doubling for data retransmits
Message-Id: <1235063487-9470-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Commit faee47cdbfe8d74a1573c2f81ea6dbb08d735be6
(sctp: Fix the RTO-doubling on idle-link heartbeats)
broke the RTO doubling for data retransmits.  If the
heartbeat was sent before the data T3-rtx time, the
the RTO will not double upon the T3-rtx expiration.
Distingish between the operations by passing an argument
to the function.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/sm_sideeffect.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 0146cfb..4ac6163 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -434,7 +434,8 @@ sctp_timer_event_t *sctp_timer_events[SCTP_NUM_TIMEOUT_TYPES] = {
  *
  */
 static void sctp_do_8_2_transport_strike(struct sctp_association *asoc,
-					 struct sctp_transport *transport)
+					 struct sctp_transport *transport,
+					 int is_hb)
 {
 	/* The check for association's overall error counter exceeding the
 	 * threshold is done in the state function.
@@ -466,7 +467,7 @@ static void sctp_do_8_2_transport_strike(struct sctp_association *asoc,
 	 * The first unacknowleged HB triggers it.  We do this with a flag
 	 * that indicates that we have an outstanding HB.
 	 */
-	if (transport->hb_sent) {
+	if (!is_hb || transport->hb_sent) {
 		transport->last_rto = transport->rto;
 		transport->rto = min((transport->rto * 2), transport->asoc->rto_max);
 	}
@@ -667,7 +668,7 @@ static void sctp_cmd_transport_reset(sctp_cmd_seq_t *cmds,
 	sctp_transport_lower_cwnd(t, SCTP_LOWER_CWND_INACTIVE);
 
 	/* Mark one strike against a transport.  */
-	sctp_do_8_2_transport_strike(asoc, t);
+	sctp_do_8_2_transport_strike(asoc, t, 1);
 
 	t->hb_sent = 1;
 }
@@ -1459,7 +1460,8 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
 
 		case SCTP_CMD_STRIKE:
 			/* Mark one strike against a transport.  */
-			sctp_do_8_2_transport_strike(asoc, cmd->obj.transport);
+			sctp_do_8_2_transport_strike(asoc, cmd->obj.transport,
+						    0);
 			break;
 
 		case SCTP_CMD_TRANSPORT_RESET:
-- 
1.5.4.3

