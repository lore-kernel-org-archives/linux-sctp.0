From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 12 Jan 2010 08:19:08 +0000
Subject: [PATCH] sctp: send SHUTDOWN-ACK chunk back to where the SHUTDOWN
Message-Id: <4B4C307C.5070901@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

SHUTDOWN-ACK is alaways sent to the primary path at the first time,
but should better transmit SHUTDOWN-ACK chunk to the same destination
transport address from which it received the SHUTDOWN chunk.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/structs.h |    3 ++-
 net/sctp/associola.c       |   12 ++++++++----
 net/sctp/sm_sideeffect.c   |    7 ++++---
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index ff30177..565a291 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1948,7 +1948,8 @@ void sctp_association_put(struct sctp_association *);
 void sctp_association_hold(struct sctp_association *);
 
 struct sctp_transport *sctp_assoc_choose_alter_transport(
-	struct sctp_association *, struct sctp_transport *);
+	struct sctp_association *, struct sctp_transport *,
+	struct sctp_chunk *);
 void sctp_assoc_update_retran_path(struct sctp_association *);
 struct sctp_transport *sctp_assoc_lookup_paddr(const struct sctp_association *,
 					  const union sctp_addr *);
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index df5abbf..45bb311 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1335,15 +1335,19 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
 
 /* Choose the transport for sending retransmit packet.  */
 struct sctp_transport *sctp_assoc_choose_alter_transport(
-	struct sctp_association *asoc, struct sctp_transport *last_sent_to)
+	struct sctp_association *asoc, struct sctp_transport *last_sent_to,
+	struct sctp_chunk *chunk)
 {
 	/* If this is the first time packet is sent, use the active path,
 	 * else use the retran path. If the last packet was sent over the
 	 * retran path, update the retran path and use it.
 	 */
-	if (!last_sent_to)
-		return asoc->peer.active_path;
-	else {
+	if (!last_sent_to) {
+		if (chunk && chunk->transport)
+			return chunk->transport;
+		else
+			return asoc->peer.active_path;
+	} else {
 		if (last_sent_to = asoc->peer.retran_path)
 			sctp_assoc_update_retran_path(asoc);
 		return asoc->peer.retran_path;
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 4e4ca65..e61d5bf 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -697,7 +697,8 @@ static void sctp_cmd_setup_t2(sctp_cmd_seq_t *cmds,
 	struct sctp_transport *t;
 
 	t = sctp_assoc_choose_alter_transport(asoc,
-					      asoc->shutdown_last_sent_to);
+					      asoc->shutdown_last_sent_to,
+					      chunk);
 	asoc->shutdown_last_sent_to = t;
 	asoc->timeouts[SCTP_EVENT_TIMEOUT_T2_SHUTDOWN] = t->rto;
 	chunk->transport = t;
@@ -788,7 +789,7 @@ static void sctp_cmd_setup_t4(sctp_cmd_seq_t *cmds,
 {
 	struct sctp_transport *t;
 
-	t = sctp_assoc_choose_alter_transport(asoc, chunk->transport);
+	t = sctp_assoc_choose_alter_transport(asoc, chunk->transport, NULL);
 	asoc->timeouts[SCTP_EVENT_TIMEOUT_T4_RTO] = t->rto;
 	chunk->transport = t;
 }
@@ -1412,7 +1413,7 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
 		case SCTP_CMD_INIT_CHOOSE_TRANSPORT:
 			chunk = cmd->obj.ptr;
 			t = sctp_assoc_choose_alter_transport(asoc,
-						asoc->init_last_sent_to);
+						asoc->init_last_sent_to, NULL);
 			asoc->init_last_sent_to = t;
 			chunk->transport = t;
 			t->init_sent_count++;
-- 
1.6.2.2


