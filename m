From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 02 Jun 2010 06:51:26 +0000
Subject: sctp: implement event notification SCTP_SENDER_DRY_EVENT
Message-Id: <4C05FF6E.1090507@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patch implement event notification SCTP_SENDER_DRY_EVENT.
SCTP Socket API Extensions:

  6.3.10. SCTP_SENDER_DRY_EVENT

  When the SCTP implementation has no user data anymore to send or
  retransmit this notification is given to the user.  If the user
  subscribes to this event and the SCTP has at this point of time no
  user data to send or retransmit this notification is also given to
  the user.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/sm.h       |    1 +
 include/net/sctp/ulpevent.h |    3 +++
 include/net/sctp/user.h     |   18 ++++++++++++++++++
 net/sctp/sm_statefuns.c     |   25 +++++++++++++++++++++++++
 net/sctp/sm_statetable.c    |    2 +-
 net/sctp/ulpevent.c         |   28 ++++++++++++++++++++++++++++
 6 files changed, 76 insertions(+), 1 deletions(-)

diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index 4088c89..b22ede7 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -165,6 +165,7 @@ sctp_state_fn_t sctp_sf_do_prm_requestheartbeat;
 sctp_state_fn_t sctp_sf_do_prm_asconf;
 
 /* Prototypes for other event state functions.  */
+sctp_state_fn_t sctp_sf_do_no_pending_tsn;
 sctp_state_fn_t sctp_sf_do_9_2_start_shutdown;
 sctp_state_fn_t sctp_sf_do_9_2_shutdown_ack;
 sctp_state_fn_t sctp_sf_ignore_other;
diff --git a/include/net/sctp/ulpevent.h b/include/net/sctp/ulpevent.h
index 7ea12e8..99b027b 100644
--- a/include/net/sctp/ulpevent.h
+++ b/include/net/sctp/ulpevent.h
@@ -132,6 +132,9 @@ struct sctp_ulpevent *sctp_ulpevent_make_authkey(
 	const struct sctp_association *asoc, __u16 key_id,
 	__u32 indication, gfp_t gfp);
 
+struct sctp_ulpevent *sctp_ulpevent_make_sender_dry_event(
+	const struct sctp_association *asoc, gfp_t gfp);
+
 void sctp_ulpevent_read_sndrcvinfo(const struct sctp_ulpevent *event,
 	struct msghdr *);
 __u16 sctp_ulpevent_get_notification_type(const struct sctp_ulpevent *event);
diff --git a/include/net/sctp/user.h b/include/net/sctp/user.h
index fd60e29..1311601 100644
--- a/include/net/sctp/user.h
+++ b/include/net/sctp/user.h
@@ -353,6 +353,21 @@ struct sctp_authkey_event {
 
 enum { SCTP_AUTH_NEWKEY = 0, };
 
+/*
+ * 6.3.10. SCTP_SENDER_DRY_EVENT
+ *
+ * When the SCTP implementation has no user data anymore to send or
+ * retransmit this notification is given to the user.  If the user
+ * subscribes to this event and the SCTP has at this point of time no
+ * user data to send or retransmit this notification is also given to
+ * the user.
+ */
+struct sctp_sender_dry_event {
+	__u16 sender_dry_type;
+	__u16 sender_dry_flags;
+	__u32 sender_dry_length;
+	sctp_assoc_t sender_dry_assoc_id;
+};
 
 /*
  * Described in Section 7.3
@@ -368,6 +383,7 @@ struct sctp_event_subscribe {
 	__u8 sctp_partial_delivery_event;
 	__u8 sctp_adaptation_layer_event;
 	__u8 sctp_authentication_event;
+	__u8 sctp_sender_dry_event;
 };
 
 /*
@@ -391,6 +407,7 @@ union sctp_notification {
 	struct sctp_adaptation_event sn_adaptation_event;
 	struct sctp_pdapi_event sn_pdapi_event;
 	struct sctp_authkey_event sn_authkey_event;
+	struct sctp_sender_dry_event sn_sender_dry_event;
 };
 
 /* Section 5.3.1
@@ -409,6 +426,7 @@ enum sctp_sn_type {
 	SCTP_ADAPTATION_INDICATION,
 	SCTP_AUTHENTICATION_EVENT,
 #define SCTP_AUTHENTICATION_INDICATION	SCTP_AUTHENTICATION_EVENT
+	SCTP_SENDER_DRY_EVENT,
 };
 
 /* Notification error codes used to fill up the error fields in some
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 24b2cd5..1634a89 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -5056,6 +5056,31 @@ sctp_disposition_t sctp_sf_ignore_primitive(
  ***************************************************************************/
 
 /*
+ * When the SCTP implementation has no user data anymore to send or
+ * retransmit this notification is given to the user.  If the user
+ * subscribes to this event and the SCTP has at this point of time no
+ * user data to send or retransmit this notification is also given to
+ * the user.
+ */
+sctp_disposition_t sctp_sf_do_no_pending_tsn(
+	const struct sctp_endpoint *ep,
+	const struct sctp_association *asoc,
+	const sctp_subtype_t type,
+	void *arg,
+	sctp_cmd_seq_t *commands)
+{
+	struct sctp_ulpevent *event;
+
+	event = sctp_ulpevent_make_sender_dry_event(asoc, GFP_ATOMIC);
+	if (!event)
+		return SCTP_DISPOSITION_NOMEM;
+
+	sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(event));
+
+	return SCTP_DISPOSITION_CONSUME;
+}
+
+/*
  * Start the shutdown negotiation.
  *
  * From Section 9.2:
diff --git a/net/sctp/sm_statetable.c b/net/sctp/sm_statetable.c
index 6d9b3aa..79d9d53 100644
--- a/net/sctp/sm_statetable.c
+++ b/net/sctp/sm_statetable.c
@@ -722,7 +722,7 @@ static const sctp_sm_table_entry_t primitive_event_table[SCTP_NUM_PRIMITIVE_TYPE
 	/* SCTP_STATE_COOKIE_ECHOED */ \
 	TYPE_SCTP_FUNC(sctp_sf_ignore_other), \
 	/* SCTP_STATE_ESTABLISHED */ \
-	TYPE_SCTP_FUNC(sctp_sf_ignore_other), \
+	TYPE_SCTP_FUNC(sctp_sf_do_no_pending_tsn), \
 	/* SCTP_STATE_SHUTDOWN_PENDING */ \
 	TYPE_SCTP_FUNC(sctp_sf_do_9_2_start_shutdown), \
 	/* SCTP_STATE_SHUTDOWN_SENT */ \
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index 674a249..7750317 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -862,6 +862,34 @@ fail:
 	return NULL;
 }
 
+/*
+ * Socket Extensions for SCTP
+ * 6.3.10. SCTP_SENDER_DRY_EVENT
+ */
+struct sctp_ulpevent *sctp_ulpevent_make_sender_dry_event(
+	const struct sctp_association *asoc, gfp_t gfp)
+{
+	struct sctp_ulpevent *event;
+	struct sctp_sender_dry_event *sdry;
+	struct sk_buff *skb;
+
+	event = sctp_ulpevent_new(sizeof(struct sctp_sender_dry_event),
+				  MSG_NOTIFICATION, gfp);
+	if (!event)
+		return NULL;
+
+	skb = sctp_event2skb(event);
+	sdry = (struct sctp_sender_dry_event *)
+		skb_put(skb, sizeof(struct sctp_sender_dry_event));
+
+	sdry->sender_dry_type = SCTP_SENDER_DRY_EVENT;
+	sdry->sender_dry_flags = 0;
+	sdry->sender_dry_length = sizeof(struct sctp_sender_dry_event);
+	sctp_ulpevent_set_owner(event, asoc);
+	sdry->sender_dry_assoc_id = sctp_assoc2id(asoc);
+
+	return event;
+}
 
 /* Return the notification type, assuming this is a notification
  * event.
-- 
1.6.5.2


