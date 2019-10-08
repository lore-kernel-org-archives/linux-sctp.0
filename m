From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 08 Oct 2019 11:27:33 +0000
Subject: [PATCH net-next 1/4] sctp: add SCTP_ADDR_ADDED event
Message-Id: <05b452daf6271ca0a37bafd28947e3b16bf49fd5.1570534014.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1570534014.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1570534014.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

A helper sctp_ulpevent_nofity_peer_addr_change() will be extracted
to make peer_addr_change event and enqueue it, and the helper will
be called in sctp_assoc_add_peer() to send SCTP_ADDR_ADDED event.

This event is described in rfc6458#section-6.1.2:

  SCTP_ADDR_ADDED:  The address is now part of the association.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/ulpevent.h |  9 ++-------
 net/sctp/associola.c        | 19 ++++++-------------
 net/sctp/ulpevent.c         | 18 +++++++++++++++++-
 3 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/include/net/sctp/ulpevent.h b/include/net/sctp/ulpevent.h
index e1a92c4..e6ead1e 100644
--- a/include/net/sctp/ulpevent.h
+++ b/include/net/sctp/ulpevent.h
@@ -80,13 +80,8 @@ struct sctp_ulpevent *sctp_ulpevent_make_assoc_change(
 	struct sctp_chunk *chunk,
 	gfp_t gfp);
 
-struct sctp_ulpevent *sctp_ulpevent_make_peer_addr_change(
-	const struct sctp_association *asoc,
-	const struct sockaddr_storage *aaddr,
-	int flags,
-	int state,
-	int error,
-	gfp_t gfp);
+void sctp_ulpevent_nofity_peer_addr_change(struct sctp_transport *transport,
+					   int state, int error);
 
 struct sctp_ulpevent *sctp_ulpevent_make_remote_error(
 	const struct sctp_association *asoc,
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index d2ffc9a..55aad70 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -707,6 +707,8 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 	list_add_tail_rcu(&peer->transports, &asoc->peer.transport_addr_list);
 	asoc->peer.transport_count++;
 
+	sctp_ulpevent_nofity_peer_addr_change(peer, SCTP_ADDR_ADDED, 0);
+
 	/* If we do not yet have a primary path, set one.  */
 	if (!asoc->peer.primary_path) {
 		sctp_assoc_set_primary(asoc, peer);
@@ -781,10 +783,8 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 				  enum sctp_transport_cmd command,
 				  sctp_sn_error_t error)
 {
-	struct sctp_ulpevent *event;
-	struct sockaddr_storage addr;
-	int spc_state = 0;
 	bool ulp_notify = true;
+	int spc_state = 0;
 
 	/* Record the transition on the transport.  */
 	switch (command) {
@@ -836,16 +836,9 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 	/* Generate and send a SCTP_PEER_ADDR_CHANGE notification
 	 * to the user.
 	 */
-	if (ulp_notify) {
-		memset(&addr, 0, sizeof(struct sockaddr_storage));
-		memcpy(&addr, &transport->ipaddr,
-		       transport->af_specific->sockaddr_len);
-
-		event = sctp_ulpevent_make_peer_addr_change(asoc, &addr,
-					0, spc_state, error, GFP_ATOMIC);
-		if (event)
-			asoc->stream.si->enqueue_event(&asoc->ulpq, event);
-	}
+	if (ulp_notify)
+		sctp_ulpevent_nofity_peer_addr_change(transport,
+						      spc_state, error);
 
 	/* Select new active and retran paths. */
 	sctp_select_active_and_retran_path(asoc);
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index e0cc1ed..f07b986 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -238,7 +238,7 @@ struct sctp_ulpevent  *sctp_ulpevent_make_assoc_change(
  * When a destination address on a multi-homed peer encounters a change
  * an interface details event is sent.
  */
-struct sctp_ulpevent *sctp_ulpevent_make_peer_addr_change(
+static struct sctp_ulpevent *sctp_ulpevent_make_peer_addr_change(
 	const struct sctp_association *asoc,
 	const struct sockaddr_storage *aaddr,
 	int flags, int state, int error, gfp_t gfp)
@@ -336,6 +336,22 @@ struct sctp_ulpevent *sctp_ulpevent_make_peer_addr_change(
 	return NULL;
 }
 
+void sctp_ulpevent_nofity_peer_addr_change(struct sctp_transport *transport,
+					   int state, int error)
+{
+	struct sctp_association *asoc = transport->asoc;
+	struct sockaddr_storage addr;
+	struct sctp_ulpevent *event;
+
+	memset(&addr, 0, sizeof(struct sockaddr_storage));
+	memcpy(&addr, &transport->ipaddr, transport->af_specific->sockaddr_len);
+
+	event = sctp_ulpevent_make_peer_addr_change(asoc, &addr, 0, state,
+						    error, GFP_ATOMIC);
+	if (event)
+		asoc->stream.si->enqueue_event(&asoc->ulpq, event);
+}
+
 /* Create and initialize an SCTP_REMOTE_ERROR notification.
  *
  * Note: This assumes that the chunk->skb->data already points to the
-- 
2.1.0
