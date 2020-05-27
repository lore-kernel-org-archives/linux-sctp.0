From: Jonas Falkevik <jonas.falkevik@gmail.com>
Date: Wed, 27 May 2020 09:59:43 +0000
Subject: [PATCH] sctp: fix typo sctp_ulpevent_nofity_peer_addr_change
Message-Id: <20200527095943.271140-1-jonas.falkevik@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com, lucien.xin@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com, davem@davemloft.net, kuba@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jonas Falkevik <jonas.falkevik@gmail.com>

change typo in function name "nofity" to "notify"
sctp_ulpevent_nofity_peer_addr_change ->
sctp_ulpevent_notify_peer_addr_change

Signed-off-by: Jonas Falkevik <jonas.falkevik@gmail.com>
---
 include/net/sctp/ulpevent.h | 2 +-
 net/sctp/associola.c        | 8 ++++----
 net/sctp/ulpevent.c         | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/sctp/ulpevent.h b/include/net/sctp/ulpevent.h
index 0b032b92da0b..994e984eef32 100644
--- a/include/net/sctp/ulpevent.h
+++ b/include/net/sctp/ulpevent.h
@@ -80,7 +80,7 @@ struct sctp_ulpevent *sctp_ulpevent_make_assoc_change(
 	struct sctp_chunk *chunk,
 	gfp_t gfp);
 
-void sctp_ulpevent_nofity_peer_addr_change(struct sctp_transport *transport,
+void sctp_ulpevent_notify_peer_addr_change(struct sctp_transport *transport,
 					   int state, int error);
 
 struct sctp_ulpevent *sctp_ulpevent_make_remote_error(
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 437079a4883d..72315137d7e7 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -432,7 +432,7 @@ void sctp_assoc_set_primary(struct sctp_association *asoc,
 		changeover = 1 ;
 
 	asoc->peer.primary_path = transport;
-	sctp_ulpevent_nofity_peer_addr_change(transport,
+	sctp_ulpevent_notify_peer_addr_change(transport,
 					      SCTP_ADDR_MADE_PRIM, 0);
 
 	/* Set a default msg_name for events. */
@@ -574,7 +574,7 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
 
 	asoc->peer.transport_count--;
 
-	sctp_ulpevent_nofity_peer_addr_change(peer, SCTP_ADDR_REMOVED, 0);
+	sctp_ulpevent_notify_peer_addr_change(peer, SCTP_ADDR_REMOVED, 0);
 	sctp_transport_free(peer);
 }
 
@@ -714,7 +714,7 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 	list_add_tail_rcu(&peer->transports, &asoc->peer.transport_addr_list);
 	asoc->peer.transport_count++;
 
-	sctp_ulpevent_nofity_peer_addr_change(peer, SCTP_ADDR_ADDED, 0);
+	sctp_ulpevent_notify_peer_addr_change(peer, SCTP_ADDR_ADDED, 0);
 
 	/* If we do not yet have a primary path, set one.  */
 	if (!asoc->peer.primary_path) {
@@ -840,7 +840,7 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 	 * to the user.
 	 */
 	if (ulp_notify)
-		sctp_ulpevent_nofity_peer_addr_change(transport,
+		sctp_ulpevent_notify_peer_addr_change(transport,
 						      spc_state, error);
 
 	/* Select new active and retran paths. */
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index 77d5c36a8991..0c3d2b4d7321 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -336,7 +336,7 @@ static struct sctp_ulpevent *sctp_ulpevent_make_peer_addr_change(
 	return NULL;
 }
 
-void sctp_ulpevent_nofity_peer_addr_change(struct sctp_transport *transport,
+void sctp_ulpevent_notify_peer_addr_change(struct sctp_transport *transport,
 					   int state, int error)
 {
 	struct sctp_association *asoc = transport->asoc;
-- 
2.25.4
