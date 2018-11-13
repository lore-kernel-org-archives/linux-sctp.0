From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 13 Nov 2018 06:24:54 +0000
Subject: [PATCHv2 net-next 2/4] sctp: add subscribe per asoc
Message-Id: <c4bd8385e895a6b8fa91d1119ec695c941b63f62.1542089666.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1542089666.git.lucien.xin@gmail.com>
 <82150b4fab9e70377db3db9c62fd10323be3f294.1542089666.git.lucien.xin@gmail.com>
In-Reply-To: <82150b4fab9e70377db3db9c62fd10323be3f294.1542089666.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

The member subscribe should be per asoc, so that sockopt SCTP_EVENT
in the next patch can subscribe a event from one asoc only.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h   | 2 ++
 net/sctp/associola.c         | 2 ++
 net/sctp/chunk.c             | 6 ++----
 net/sctp/socket.c            | 6 +++++-
 net/sctp/stream_interleave.c | 7 ++++---
 net/sctp/ulpqueue.c          | 4 ++--
 6 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index bc7808a..7eaa294 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -2077,6 +2077,8 @@ struct sctp_association {
 
 	int sent_cnt_removable;
 
+	__u16 subscribe;
+
 	__u64 abandoned_unsent[SCTP_PR_INDEX(MAX) + 1];
 	__u64 abandoned_sent[SCTP_PR_INDEX(MAX) + 1];
 };
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 6a28b96..685c7ef 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -135,6 +135,8 @@ static struct sctp_association *sctp_association_init(
 	 */
 	asoc->max_burst = sp->max_burst;
 
+	asoc->subscribe = sp->subscribe;
+
 	/* initialize association timers */
 	asoc->timeouts[SCTP_EVENT_TIMEOUT_T1_COOKIE] = asoc->rto_initial;
 	asoc->timeouts[SCTP_EVENT_TIMEOUT_T1_INIT] = asoc->rto_initial;
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index 6c761af..0b203b8 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -86,11 +86,10 @@ void sctp_datamsg_free(struct sctp_datamsg *msg)
 /* Final destructruction of datamsg memory. */
 static void sctp_datamsg_destroy(struct sctp_datamsg *msg)
 {
+	struct sctp_association *asoc = NULL;
 	struct list_head *pos, *temp;
 	struct sctp_chunk *chunk;
-	struct sctp_sock *sp;
 	struct sctp_ulpevent *ev;
-	struct sctp_association *asoc = NULL;
 	int error = 0, notify;
 
 	/* If we failed, we may need to notify. */
@@ -108,8 +107,7 @@ static void sctp_datamsg_destroy(struct sctp_datamsg *msg)
 			else
 				error = asoc->outqueue.error;
 
-			sp = sctp_sk(asoc->base.sk);
-			notify = sctp_ulpevent_type_enabled(sp->subscribe,
+			notify = sctp_ulpevent_type_enabled(asoc->subscribe,
 							    SCTP_SEND_FAILED);
 		}
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 48e0b45..789008d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2307,6 +2307,7 @@ static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
 	struct sctp_event_subscribe subscribe;
 	__u8 *sn_type = (__u8 *)&subscribe;
 	struct sctp_sock *sp = sctp_sk(sk);
+	struct sctp_association *asoc;
 	int i;
 
 	if (optlen > sizeof(struct sctp_event_subscribe))
@@ -2319,14 +2320,17 @@ static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
 		sctp_ulpevent_type_set(&sp->subscribe, SCTP_SN_TYPE_BASE + i,
 				       sn_type[i]);
 
+	list_for_each_entry(asoc, &sp->ep->asocs, asocs)
+		asoc->subscribe = sctp_sk(sk)->subscribe;
+
 	/* At the time when a user app subscribes to SCTP_SENDER_DRY_EVENT,
 	 * if there is no data to be sent or retransmit, the stack will
 	 * immediately send up this notification.
 	 */
 	if (sctp_ulpevent_type_enabled(sp->subscribe, SCTP_SENDER_DRY_EVENT)) {
-		struct sctp_association *asoc = sctp_id2assoc(sk, 0);
 		struct sctp_ulpevent *event;
 
+		asoc = sctp_id2assoc(sk, 0);
 		if (asoc && sctp_outq_is_empty(&asoc->outqueue)) {
 			event = sctp_ulpevent_make_sender_dry_event(asoc,
 					GFP_USER | __GFP_NOWARN);
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index ceef5a3..a6bf215 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -503,7 +503,7 @@ static int sctp_enqueue_event(struct sctp_ulpq *ulpq,
 		sk_incoming_cpu_update(sk);
 	}
 
-	if (!sctp_ulpevent_is_enabled(event, sp->subscribe))
+	if (!sctp_ulpevent_is_enabled(event, ulpq->asoc->subscribe))
 		goto out_free;
 
 	if (skb_list)
@@ -992,16 +992,17 @@ static void sctp_intl_stream_abort_pd(struct sctp_ulpq *ulpq, __u16 sid,
 				      __u32 mid, __u16 flags, gfp_t gfp)
 {
 	struct sock *sk = ulpq->asoc->base.sk;
-	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_ulpevent *ev = NULL;
 
-	if (!sctp_ulpevent_type_enabled(sp->subscribe,
+	if (!sctp_ulpevent_type_enabled(ulpq->asoc->subscribe,
 					SCTP_PARTIAL_DELIVERY_EVENT))
 		return;
 
 	ev = sctp_ulpevent_make_pdapi(ulpq->asoc, SCTP_PARTIAL_DELIVERY_ABORTED,
 				      sid, mid, flags, gfp);
 	if (ev) {
+		struct sctp_sock *sp = sctp_sk(sk);
+
 		__skb_queue_tail(&sk->sk_receive_queue, sctp_event2skb(ev));
 
 		if (!sp->data_ready_signalled) {
diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index b36dd90..5dde921 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -219,7 +219,7 @@ int sctp_ulpq_tail_event(struct sctp_ulpq *ulpq, struct sctp_ulpevent *event)
 		sk_incoming_cpu_update(sk);
 	}
 	/* Check if the user wishes to receive this event.  */
-	if (!sctp_ulpevent_is_enabled(event, sp->subscribe))
+	if (!sctp_ulpevent_is_enabled(event, ulpq->asoc->subscribe))
 		goto out_free;
 
 	/* If we are in partial delivery mode, post to the lobby until
@@ -1137,7 +1137,7 @@ void sctp_ulpq_abort_pd(struct sctp_ulpq *ulpq, gfp_t gfp)
 
 	sk = ulpq->asoc->base.sk;
 	sp = sctp_sk(sk);
-	if (sctp_ulpevent_type_enabled(sp->subscribe,
+	if (sctp_ulpevent_type_enabled(ulpq->asoc->subscribe,
 				       SCTP_PARTIAL_DELIVERY_EVENT))
 		ev = sctp_ulpevent_make_pdapi(ulpq->asoc,
 					      SCTP_PARTIAL_DELIVERY_ABORTED,
-- 
2.1.0
