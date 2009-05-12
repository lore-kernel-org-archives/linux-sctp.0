From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 12 May 2009 13:52:51 +0000
Subject: [PATCH] sctp: fix to choose alternate destination when retransmit
Message-Id: <4A097F33.5010002@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

RFC 5061 Section 5.1 ASCONF Chunk Procedures said:

B4)  Re-transmit the ASCONF Chunk last sent and if possible choose an
     alternate destination address (please refer to [RFC4960],
     Section 6.4.1).  An endpoint MUST NOT add new parameters to this
     chunk; it MUST be the same (including its Sequence Number) as
     the last ASCONF sent.  An endpoint MAY, however, bundle an
     additional ASCONF with new ASCONF parameters with the next
     Sequence Number.  For details, see Section 5.5.

This patch fix to choose an alternate destination address when
re-transmit the ASCONF chunk, with some dup codes cleanup.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/structs.h |    6 ++----
 net/sctp/associola.c       |   42 +++++++-----------------------------------
 net/sctp/sm_sideeffect.c   |    8 +++++---
 3 files changed, 14 insertions(+), 42 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 23f08fe..edfcacf 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1939,10 +1939,8 @@ void sctp_association_free(struct sctp_association *);
 void sctp_association_put(struct sctp_association *);
 void sctp_association_hold(struct sctp_association *);
 
-struct sctp_transport *sctp_assoc_choose_init_transport(
-	struct sctp_association *);
-struct sctp_transport *sctp_assoc_choose_shutdown_transport(
-	struct sctp_association *);
+struct sctp_transport *sctp_assoc_choose_alter_transport(
+	struct sctp_association *, struct sctp_transport *);
 void sctp_assoc_update_retran_path(struct sctp_association *);
 struct sctp_transport *sctp_assoc_lookup_paddr(const struct sctp_association *,
 					  const union sctp_addr *);
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index f4b2304..09a7d15 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1268,49 +1268,21 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
 				 ntohs(t->ipaddr.v4.sin_port));
 }
 
-/* Choose the transport for sending a INIT packet.  */
-struct sctp_transport *sctp_assoc_choose_init_transport(
-	struct sctp_association *asoc)
+/* Choose the transport for sending retransmit packet.  */
+struct sctp_transport *sctp_assoc_choose_alter_transport(
+	struct sctp_association *asoc, struct sctp_transport *last_sent_to)
 {
-	struct sctp_transport *t;
-
-	/* Use the retran path. If the last INIT was sent over the
+	/* If this is the first time packet is sent, use the active path,
+	 * else use the retran path. If the last packet was sent over the
 	 * retran path, update the retran path and use it.
 	 */
-	if (!asoc->init_last_sent_to) {
-		t = asoc->peer.active_path;
-	} else {
-		if (asoc->init_last_sent_to = asoc->peer.retran_path)
-			sctp_assoc_update_retran_path(asoc);
-		t = asoc->peer.retran_path;
-	}
-
-	SCTP_DEBUG_PRINTK_IPADDR("sctp_assoc_update_retran_path:association"
-				 " %p addr: ",
-				 " port: %d\n",
-				 asoc,
-				 (&t->ipaddr),
-				 ntohs(t->ipaddr.v4.sin_port));
-
-	return t;
-}
-
-/* Choose the transport for sending a SHUTDOWN packet.  */
-struct sctp_transport *sctp_assoc_choose_shutdown_transport(
-	struct sctp_association *asoc)
-{
-	/* If this is the first time SHUTDOWN is sent, use the active path,
-	 * else use the retran path. If the last SHUTDOWN was sent over the
-	 * retran path, update the retran path and use it.
-	 */
-	if (!asoc->shutdown_last_sent_to)
+	if (!last_sent_to)
 		return asoc->peer.active_path;
 	else {
-		if (asoc->shutdown_last_sent_to = asoc->peer.retran_path)
+		if (last_sent_to = asoc->peer.retran_path)
 			sctp_assoc_update_retran_path(asoc);
 		return asoc->peer.retran_path;
 	}
-
 }
 
 /* Update the association's pmtu and frag_point by going through all the
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index e2020eb..86426aa 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -686,7 +686,8 @@ static void sctp_cmd_setup_t2(sctp_cmd_seq_t *cmds,
 {
 	struct sctp_transport *t;
 
-	t = sctp_assoc_choose_shutdown_transport(asoc);
+	t = sctp_assoc_choose_alter_transport(asoc,
+					      asoc->shutdown_last_sent_to);
 	asoc->shutdown_last_sent_to = t;
 	asoc->timeouts[SCTP_EVENT_TIMEOUT_T2_SHUTDOWN] = t->rto;
 	chunk->transport = t;
@@ -777,7 +778,7 @@ static void sctp_cmd_setup_t4(sctp_cmd_seq_t *cmds,
 {
 	struct sctp_transport *t;
 
-	t = asoc->peer.active_path;
+	t = sctp_assoc_choose_alter_transport(asoc, chunk->transport);
 	asoc->timeouts[SCTP_EVENT_TIMEOUT_T4_RTO] = t->rto;
 	chunk->transport = t;
 }
@@ -1379,7 +1380,8 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
 
 		case SCTP_CMD_INIT_CHOOSE_TRANSPORT:
 			chunk = cmd->obj.ptr;
-			t = sctp_assoc_choose_init_transport(asoc);
+			t = sctp_assoc_choose_alter_transport(asoc,
+						asoc->init_last_sent_to);
 			asoc->init_last_sent_to = t;
 			chunk->transport = t;
 			t->init_sent_count++;
-- 
1.6.0.2.530.g67faa



