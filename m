From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 13 Nov 2018 06:24:53 +0000
Subject: [PATCHv2 net-next 1/4] sctp: define subscribe in sctp_sock as __u16
Message-Id: <82150b4fab9e70377db3db9c62fd10323be3f294.1542089666.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1542089666.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1542089666.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

The member subscribe in sctp_sock is used to indicate to which of
the events it is subscribed, more like a group of flags. So it's
better to be defined as __u16 (2 bytpes), instead of struct
sctp_event_subscribe (13 bytes).

Note that sctp_event_subscribe is an UAPI struct, used on sockopt
calls, and thus it will not be removed. This patch only changes
the internal storage of the flags.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h   |  2 +-
 include/net/sctp/ulpevent.h  | 39 ++++++++++++++++++++++++---------------
 include/uapi/linux/sctp.h    |  6 +++++-
 net/sctp/chunk.c             |  4 ++--
 net/sctp/socket.c            | 35 ++++++++++++++++++++++++++---------
 net/sctp/stream_interleave.c | 11 ++++++-----
 net/sctp/ulpqueue.c          |  8 ++++----
 7 files changed, 68 insertions(+), 37 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index af9d494..bc7808a 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -217,7 +217,7 @@ struct sctp_sock {
 	 * These two structures must be grouped together for the usercopy
 	 * whitelist region.
 	 */
-	struct sctp_event_subscribe subscribe;
+	__u16 subscribe;
 	struct sctp_initmsg initmsg;
 
 	int user_frag;
diff --git a/include/net/sctp/ulpevent.h b/include/net/sctp/ulpevent.h
index 51b4e06..bd922a0 100644
--- a/include/net/sctp/ulpevent.h
+++ b/include/net/sctp/ulpevent.h
@@ -164,30 +164,39 @@ void sctp_ulpevent_read_nxtinfo(const struct sctp_ulpevent *event,
 
 __u16 sctp_ulpevent_get_notification_type(const struct sctp_ulpevent *event);
 
+static inline void sctp_ulpevent_type_set(__u16 *subscribe,
+					  __u16 sn_type, __u8 on)
+{
+	if (sn_type > SCTP_SN_TYPE_MAX)
+		return;
+
+	if (on)
+		*subscribe |=  (1 << (sn_type - SCTP_SN_TYPE_BASE));
+	else
+		*subscribe &= ~(1 << (sn_type - SCTP_SN_TYPE_BASE));
+}
+
 /* Is this event type enabled? */
-static inline int sctp_ulpevent_type_enabled(__u16 sn_type,
-					     struct sctp_event_subscribe *mask)
+static inline bool sctp_ulpevent_type_enabled(__u16 subscribe, __u16 sn_type)
 {
-	int offset = sn_type - SCTP_SN_TYPE_BASE;
-	char *amask = (char *) mask;
+	if (sn_type > SCTP_SN_TYPE_MAX)
+		return false;
 
-	if (offset >= sizeof(struct sctp_event_subscribe))
-		return 0;
-	return amask[offset];
+	return subscribe & (1 << (sn_type - SCTP_SN_TYPE_BASE));
 }
 
 /* Given an event subscription, is this event enabled? */
-static inline int sctp_ulpevent_is_enabled(const struct sctp_ulpevent *event,
-					   struct sctp_event_subscribe *mask)
+static inline bool sctp_ulpevent_is_enabled(const struct sctp_ulpevent *event,
+					    __u16 subscribe)
 {
 	__u16 sn_type;
-	int enabled = 1;
 
-	if (sctp_ulpevent_is_notification(event)) {
-		sn_type = sctp_ulpevent_get_notification_type(event);
-		enabled = sctp_ulpevent_type_enabled(sn_type, mask);
-	}
-	return enabled;
+	if (!sctp_ulpevent_is_notification(event))
+		return true;
+
+	sn_type = sctp_ulpevent_get_notification_type(event);
+
+	return sctp_ulpevent_type_enabled(subscribe, sn_type);
 }
 
 #endif /* __sctp_ulpevent_h__ */
diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index c81feb3..66afa5b 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -632,7 +632,9 @@ union sctp_notification {
  */
 
 enum sctp_sn_type {
-	SCTP_SN_TYPE_BASE     = (1<<15),
+	SCTP_SN_TYPE_BASE	= (1<<15),
+	SCTP_DATA_IO_EVENT	= SCTP_SN_TYPE_BASE,
+#define SCTP_DATA_IO_EVENT		SCTP_DATA_IO_EVENT
 	SCTP_ASSOC_CHANGE,
 #define SCTP_ASSOC_CHANGE		SCTP_ASSOC_CHANGE
 	SCTP_PEER_ADDR_CHANGE,
@@ -657,6 +659,8 @@ enum sctp_sn_type {
 #define SCTP_ASSOC_RESET_EVENT		SCTP_ASSOC_RESET_EVENT
 	SCTP_STREAM_CHANGE_EVENT,
 #define SCTP_STREAM_CHANGE_EVENT	SCTP_STREAM_CHANGE_EVENT
+	SCTP_SN_TYPE_MAX	= SCTP_STREAM_CHANGE_EVENT,
+#define SCTP_SN_TYPE_MAX		SCTP_SN_TYPE_MAX
 };
 
 /* Notification error codes used to fill up the error fields in some
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index ce80878..6c761af 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -109,8 +109,8 @@ static void sctp_datamsg_destroy(struct sctp_datamsg *msg)
 				error = asoc->outqueue.error;
 
 			sp = sctp_sk(asoc->base.sk);
-			notify = sctp_ulpevent_type_enabled(SCTP_SEND_FAILED,
-							    &sp->subscribe);
+			notify = sctp_ulpevent_type_enabled(sp->subscribe,
+							    SCTP_SEND_FAILED);
 		}
 
 		/* Generate a SEND FAILED event only if enabled. */
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 5299add..48e0b45 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2230,7 +2230,7 @@ static int sctp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (sp->recvrcvinfo)
 		sctp_ulpevent_read_rcvinfo(event, msg);
 	/* Check if we allow SCTP_SNDRCVINFO. */
-	if (sp->subscribe.sctp_data_io_event)
+	if (sctp_ulpevent_type_enabled(sp->subscribe, SCTP_DATA_IO_EVENT))
 		sctp_ulpevent_read_sndrcvinfo(event, msg);
 
 	err = copied;
@@ -2304,21 +2304,28 @@ static int sctp_setsockopt_disable_fragments(struct sock *sk,
 static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
 				  unsigned int optlen)
 {
-	struct sctp_association *asoc;
-	struct sctp_ulpevent *event;
+	struct sctp_event_subscribe subscribe;
+	__u8 *sn_type = (__u8 *)&subscribe;
+	struct sctp_sock *sp = sctp_sk(sk);
+	int i;
 
 	if (optlen > sizeof(struct sctp_event_subscribe))
 		return -EINVAL;
-	if (copy_from_user(&sctp_sk(sk)->subscribe, optval, optlen))
+
+	if (copy_from_user(&subscribe, optval, optlen))
 		return -EFAULT;
 
+	for (i = 0; i < optlen; i++)
+		sctp_ulpevent_type_set(&sp->subscribe, SCTP_SN_TYPE_BASE + i,
+				       sn_type[i]);
+
 	/* At the time when a user app subscribes to SCTP_SENDER_DRY_EVENT,
 	 * if there is no data to be sent or retransmit, the stack will
 	 * immediately send up this notification.
 	 */
-	if (sctp_ulpevent_type_enabled(SCTP_SENDER_DRY_EVENT,
-				       &sctp_sk(sk)->subscribe)) {
-		asoc = sctp_id2assoc(sk, 0);
+	if (sctp_ulpevent_type_enabled(sp->subscribe, SCTP_SENDER_DRY_EVENT)) {
+		struct sctp_association *asoc = sctp_id2assoc(sk, 0);
+		struct sctp_ulpevent *event;
 
 		if (asoc && sctp_outq_is_empty(&asoc->outqueue)) {
 			event = sctp_ulpevent_make_sender_dry_event(asoc,
@@ -4722,7 +4729,7 @@ static int sctp_init_sock(struct sock *sk)
 	/* Initialize default event subscriptions. By default, all the
 	 * options are off.
 	 */
-	memset(&sp->subscribe, 0, sizeof(struct sctp_event_subscribe));
+	sp->subscribe = 0;
 
 	/* Default Peer Address Parameters.  These defaults can
 	 * be modified via SCTP_PEER_ADDR_PARAMS
@@ -5267,14 +5274,24 @@ static int sctp_getsockopt_disable_fragments(struct sock *sk, int len,
 static int sctp_getsockopt_events(struct sock *sk, int len, char __user *optval,
 				  int __user *optlen)
 {
+	struct sctp_event_subscribe subscribe;
+	__u8 *sn_type = (__u8 *)&subscribe;
+	int i;
+
 	if (len = 0)
 		return -EINVAL;
 	if (len > sizeof(struct sctp_event_subscribe))
 		len = sizeof(struct sctp_event_subscribe);
 	if (put_user(len, optlen))
 		return -EFAULT;
-	if (copy_to_user(optval, &sctp_sk(sk)->subscribe, len))
+
+	for (i = 0; i <= len; i++)
+		sn_type[i] = sctp_ulpevent_type_enabled(sctp_sk(sk)->subscribe,
+							SCTP_SN_TYPE_BASE + i);
+
+	if (copy_to_user(optval, &subscribe, len))
 		return -EFAULT;
+
 	return 0;
 }
 
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 2b499a8..ceef5a3 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -503,7 +503,7 @@ static int sctp_enqueue_event(struct sctp_ulpq *ulpq,
 		sk_incoming_cpu_update(sk);
 	}
 
-	if (!sctp_ulpevent_is_enabled(event, &sp->subscribe))
+	if (!sctp_ulpevent_is_enabled(event, sp->subscribe))
 		goto out_free;
 
 	if (skb_list)
@@ -992,10 +992,11 @@ static void sctp_intl_stream_abort_pd(struct sctp_ulpq *ulpq, __u16 sid,
 				      __u32 mid, __u16 flags, gfp_t gfp)
 {
 	struct sock *sk = ulpq->asoc->base.sk;
+	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_ulpevent *ev = NULL;
 
-	if (!sctp_ulpevent_type_enabled(SCTP_PARTIAL_DELIVERY_EVENT,
-					&sctp_sk(sk)->subscribe))
+	if (!sctp_ulpevent_type_enabled(sp->subscribe,
+					SCTP_PARTIAL_DELIVERY_EVENT))
 		return;
 
 	ev = sctp_ulpevent_make_pdapi(ulpq->asoc, SCTP_PARTIAL_DELIVERY_ABORTED,
@@ -1003,8 +1004,8 @@ static void sctp_intl_stream_abort_pd(struct sctp_ulpq *ulpq, __u16 sid,
 	if (ev) {
 		__skb_queue_tail(&sk->sk_receive_queue, sctp_event2skb(ev));
 
-		if (!sctp_sk(sk)->data_ready_signalled) {
-			sctp_sk(sk)->data_ready_signalled = 1;
+		if (!sp->data_ready_signalled) {
+			sp->data_ready_signalled = 1;
 			sk->sk_data_ready(sk);
 		}
 	}
diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index 331cc73..b36dd90 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -219,7 +219,7 @@ int sctp_ulpq_tail_event(struct sctp_ulpq *ulpq, struct sctp_ulpevent *event)
 		sk_incoming_cpu_update(sk);
 	}
 	/* Check if the user wishes to receive this event.  */
-	if (!sctp_ulpevent_is_enabled(event, &sp->subscribe))
+	if (!sctp_ulpevent_is_enabled(event, sp->subscribe))
 		goto out_free;
 
 	/* If we are in partial delivery mode, post to the lobby until
@@ -1129,16 +1129,16 @@ void sctp_ulpq_renege(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk,
 void sctp_ulpq_abort_pd(struct sctp_ulpq *ulpq, gfp_t gfp)
 {
 	struct sctp_ulpevent *ev = NULL;
-	struct sock *sk;
 	struct sctp_sock *sp;
+	struct sock *sk;
 
 	if (!ulpq->pd_mode)
 		return;
 
 	sk = ulpq->asoc->base.sk;
 	sp = sctp_sk(sk);
-	if (sctp_ulpevent_type_enabled(SCTP_PARTIAL_DELIVERY_EVENT,
-				       &sctp_sk(sk)->subscribe))
+	if (sctp_ulpevent_type_enabled(sp->subscribe,
+				       SCTP_PARTIAL_DELIVERY_EVENT))
 		ev = sctp_ulpevent_make_pdapi(ulpq->asoc,
 					      SCTP_PARTIAL_DELIVERY_ABORTED,
 					      0, 0, 0, gfp);
-- 
2.1.0
