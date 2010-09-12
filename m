From: Yaogong Wang <ywang15@ncsu.edu>
Date: Sun, 12 Sep 2010 01:12:50 +0000
Subject: [PATCHv2 2/5] sctp: implement pluggable multistream scheduling
Message-Id: <AANLkTinaO5Fqn+QJxxkXSCsW0XWvhBc16jK6HGB_0YG0@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-kernel@vger.kernel.org

Implement the pluggable multistream scheduling framework.
Provide the default first-come-first-serve (FCFS) algorithm.

Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
---
 include/net/sctp/structs.h |    6 +-
 net/sctp/Makefile          |    2 +-
 net/sctp/associola.c       |    4 +-
 net/sctp/outqueue.c        |   56 +++++---------
 net/sctp/protocol.c        |   11 +++
 net/sctp/sched.c           |  177 ++++++++++++++++++++++++++++++++++++++++++++
 net/sctp/socket.c          |    3 +
 7 files changed, 218 insertions(+), 41 deletions(-)
 create mode 100644 net/sctp/sched.c

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 6b08876..52af764 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -577,6 +577,8 @@ extern void sctp_unregister_sched(struct
sctp_sched_ops *type);
 extern void sctp_cleanup_sched(struct sock *sk);
 extern int sctp_set_sched(struct sock *sk, const char *name);

+extern struct sctp_sched_ops sctp_fcfs;
+
 /*
  * Pointers to address related SCTP functions.
  * (i.e. things that depend on the address family.)
@@ -1167,7 +1169,7 @@ struct sctp_outq {
 	struct sctp_association *asoc;

 	/* Data pending that has never been transmitted.  */
-	struct list_head out_chunk_list;
+	struct list_head *out_chunk_list;

 	/* Multistream scheduling */
 	const struct sctp_sched_ops *sched_ops;
@@ -1211,7 +1213,7 @@ struct sctp_outq {
 	char malloced;
 };

-void sctp_outq_init(struct sctp_association *, struct sctp_outq *);
+int sctp_outq_init(struct sctp_association *, struct sctp_outq *, gfp_t gfp);
 void sctp_outq_teardown(struct sctp_outq *);
 void sctp_outq_free(struct sctp_outq*);
 int sctp_outq_tail(struct sctp_outq *, struct sctp_chunk *chunk);
diff --git a/net/sctp/Makefile b/net/sctp/Makefile
index 5c30b7a..4e8b65d 100644
--- a/net/sctp/Makefile
+++ b/net/sctp/Makefile
@@ -10,7 +10,7 @@ sctp-y := sm_statetable.o sm_statefuns.o sm_sideeffect.o \
 	  transport.o chunk.o sm_make_chunk.o ulpevent.o \
 	  inqueue.o outqueue.o ulpqueue.o command.o \
 	  tsnmap.o bind_addr.o socket.o primitive.o \
-	  output.o input.o debug.o ssnmap.o auth.o
+	  output.o input.o debug.o ssnmap.o auth.o sched.o

 sctp_probe-y := probe.o

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 0b85e52..4a6f29d 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -283,7 +283,9 @@ static struct sctp_association
*sctp_association_init(struct sctp_association *a
 	sctp_inq_set_th_handler(&asoc->base.inqueue, sctp_assoc_bh_rcv);

 	/* Create an output queue.  */
-	sctp_outq_init(asoc, &asoc->outqueue);
+	err = sctp_outq_init(asoc, &asoc->outqueue, gfp);
+	if (err)
+		goto fail_init;

 	if (!sctp_ulpq_init(&asoc->ulpq, asoc))
 		goto fail_init;
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index c04b2eb..37ffa21 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -74,36 +74,6 @@ static void sctp_generate_fwdtsn(struct sctp_outq
*q, __u32 sack_ctsn);

 static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout);

-/* Add data to the front of the queue. */
-static inline void sctp_outq_head_data(struct sctp_outq *q,
-					struct sctp_chunk *ch)
-{
-	list_add(&ch->list, &q->out_chunk_list);
-	q->out_qlen += ch->skb->len;
-}
-
-/* Take data from the front of the queue. */
-static inline struct sctp_chunk *sctp_outq_dequeue_data(struct sctp_outq *q)
-{
-	struct sctp_chunk *ch = NULL;
-
-	if (!list_empty(&q->out_chunk_list)) {
-		struct list_head *entry = q->out_chunk_list.next;
-
-		ch = list_entry(entry, struct sctp_chunk, list);
-		list_del_init(entry);
-		q->out_qlen -= ch->skb->len;
-	}
-	return ch;
-}
-/* Add data chunk to the end of the queue. */
-static inline void sctp_outq_tail_data(struct sctp_outq *q,
-				       struct sctp_chunk *ch)
-{
-	list_add_tail(&ch->list, &q->out_chunk_list);
-	q->out_qlen += ch->skb->len;
-}
-
 /*
  * SFR-CACC algorithm:
  * D) If count_of_newacks is greater than or equal to 2
@@ -200,10 +170,18 @@ static inline int sctp_cacc_skip(struct
sctp_transport *primary,
  * You still need to define handlers if you really want to DO
  * something with this structure...
  */
-void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
+int sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q,
+			gfp_t gfp)
 {
+	int err = 0;
 	q->asoc = asoc;
-	INIT_LIST_HEAD(&q->out_chunk_list);
+
+	/* initialize to the default FCFS at this stage */
+	q->sched_ops = sctp_default_sched_ops;
+	err = q->sched_ops->init(q, gfp);
+	if (err)
+		return err;
+
 	INIT_LIST_HEAD(&q->control_chunk_list);
 	INIT_LIST_HEAD(&q->retransmit);
 	INIT_LIST_HEAD(&q->sacked);
@@ -216,6 +194,8 @@ void sctp_outq_init(struct sctp_association *asoc,
struct sctp_outq *q)

 	q->malloced = 0;
 	q->out_qlen = 0;
+
+	return 0;
 }

 /* Free the outqueue structure and any related pending chunks.
@@ -266,7 +246,7 @@ void sctp_outq_teardown(struct sctp_outq *q)
 	}

 	/* Throw away any leftover data chunks. */
-	while ((chunk = sctp_outq_dequeue_data(q)) != NULL) {
+	while ((chunk = q->sched_ops->dequeue_data(q)) != NULL) {

 		/* Mark as send failure. */
 		sctp_chunk_fail(chunk, q->error);
@@ -288,6 +268,8 @@ void sctp_outq_free(struct sctp_outq *q)
 	/* Throw away leftover chunks. */
 	sctp_outq_teardown(q);

+	q->sched_ops->release(q);
+
 	/* If we were kmalloc()'d, free the memory.  */
 	if (q->malloced)
 		kfree(q);
@@ -333,7 +315,7 @@ int sctp_outq_tail(struct sctp_outq *q, struct
sctp_chunk *chunk)
 			  sctp_cname(SCTP_ST_CHUNK(chunk->chunk_hdr->type))
 			  : "Illegal Chunk");

-			sctp_outq_tail_data(q, chunk);
+			q->sched_ops->enqueue_tail_data(q, chunk);
 			if (chunk->chunk_hdr->flags & SCTP_DATA_UNORDERED)
 				SCTP_INC_STATS(SCTP_MIB_OUTUNORDERCHUNKS);
 			else
@@ -938,7 +920,7 @@ static int sctp_outq_flush(struct sctp_outq *q,
int rtx_timeout)
 			sctp_transport_burst_limited(transport);

 		/* Finally, transmit new packets.  */
-		while ((chunk = sctp_outq_dequeue_data(q)) != NULL) {
+		while ((chunk = q->sched_ops->dequeue_data(q)) != NULL) {
 			/* RFC 2960 6.5 Every DATA chunk MUST carry a valid
 			 * stream identifier.
 			 */
@@ -1016,7 +998,7 @@ static int sctp_outq_flush(struct sctp_outq *q,
int rtx_timeout)
 					"not transmit TSN: 0x%x, status: %d\n",
 					ntohl(chunk->subh.data_hdr->tsn),
 					status);
-				sctp_outq_head_data(q, chunk);
+				q->sched_ops->enqueue_head_data(q, chunk);
 				goto sctp_flush_out;
 				break;

@@ -1260,7 +1242,7 @@ int sctp_outq_sack(struct sctp_outq *q, struct
sctp_sackhdr *sack)
 	/* See if all chunks are acked.
 	 * Make sure the empty queue handler will get run later.
 	 */
-	q->empty = (list_empty(&q->out_chunk_list) &&
+	q->empty = (q->sched_ops->is_empty(q) &&
 		    list_empty(&q->retransmit));
 	if (!q->empty)
 		goto finish;
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 5027b83..d40c5cc 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1157,6 +1157,9 @@ SCTP_STATIC __init int sctp_init(void)
 	sctp_max_instreams    		= SCTP_DEFAULT_INSTREAMS;
 	sctp_max_outstreams   		= SCTP_DEFAULT_OUTSTREAMS;

+	/* Initialize default multistream scheduling algorithm to FCFS */
+	sctp_default_sched_ops		= &sctp_fcfs;
+
 	/* Initialize handle used for association ids. */
 	idr_init(&sctp_assocs_id);

@@ -1304,6 +1307,11 @@ SCTP_STATIC __init int sctp_init(void)
 	if (status)
 		goto err_v6_add_protocol;

+	/* Add FCFS to sctp_sched_list */
+	status = sctp_register_sched(&sctp_fcfs);
+	if (status)
+		goto err_v6_add_protocol;
+
 	status = 0;
 out:
 	return status;
@@ -1348,6 +1356,9 @@ SCTP_STATIC __exit void sctp_exit(void)
 	 * up all the remaining associations and all that memory.
 	 */

+	/* Unregister FCFS from sctp_sched_list */
+	sctp_unregister_sched(&sctp_fcfs);
+
 	/* Unregister with inet6/inet layers. */
 	sctp_v6_del_protocol();
 	sctp_v4_del_protocol();
diff --git a/net/sctp/sched.c b/net/sctp/sched.c
new file mode 100644
index 0000000..3820e3f
--- /dev/null
+++ b/net/sctp/sched.c
@@ -0,0 +1,177 @@
+/*
+ * Plugable SCTP multistream scheduling support and
+ * the default first-come-first-serve (FCFS) algorithm
+ *
+ * Based on ideas from pluggable TCP congestion control
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <net/sctp/sctp.h>
+
+static DEFINE_SPINLOCK(sctp_sched_list_lock);
+static LIST_HEAD(sctp_sched_list);
+
+/* Simple linear search, don't expect many entries! */
+static struct sctp_sched_ops *sctp_sched_find(const char *name)
+{
+	struct sctp_sched_ops *e;
+
+	list_for_each_entry_rcu(e, &sctp_sched_list, list) {
+		if (strcmp(e->name, name) = 0)
+			return e;
+	}
+
+	return NULL;
+}
+
+/*
+ * Attach new scheduling algorithm to the list
+ * of available options.
+ */
+int sctp_register_sched(struct sctp_sched_ops *sched)
+{
+	int ret = 0;
+
+	/* algorithm must implement required ops */
+	if (!sched->init || !sched->release || !sched->is_empty
+		|| !sched->enqueue_head_data || !sched->enqueue_tail_data
+		|| !sched->dequeue_data) {
+		printk(KERN_ERR "SCTP %s does not implement required ops\n",
+		       sched->name);
+		return -EINVAL;
+	}
+
+	spin_lock(&sctp_sched_list_lock);
+	if (sctp_sched_find(sched->name)) {
+		printk(KERN_NOTICE "SCTP %s already registered\n", sched->name);
+		ret = -EEXIST;
+	} else {
+		list_add_tail_rcu(&sched->list, &sctp_sched_list);
+		printk(KERN_INFO "SCTP %s registered\n", sched->name);
+	}
+	spin_unlock(&sctp_sched_list_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sctp_register_sched);
+
+/*
+ * Remove scheduling algorithm, called from
+ * the module's remove function.  Module ref counts are used
+ * to ensure that this can't be done till all sockets using
+ * that method are closed.
+ */
+void sctp_unregister_sched(struct sctp_sched_ops *sched)
+{
+	spin_lock(&sctp_sched_list_lock);
+	list_del_rcu(&sched->list);
+	spin_unlock(&sctp_sched_list_lock);
+}
+EXPORT_SYMBOL_GPL(sctp_unregister_sched);
+
+/* Manage refcounts on socket close. */
+void sctp_cleanup_sched(struct sock *sk)
+{
+	module_put(sctp_sk(sk)->sched_ops->owner);
+}
+
+/* Change scheduling algorithm for socket */
+int sctp_set_sched(struct sock *sk, const char *name)
+{
+	struct sctp_sock *sp = sctp_sk(sk);
+	struct sctp_sched_ops *sched;
+	int err = 0;
+
+	rcu_read_lock();
+	sched = sctp_sched_find(name);
+
+	/* no change asking for existing value */
+	if (sched = sp->sched_ops)
+		goto out;
+
+#ifdef CONFIG_MODULES
+	/* not found attempt to autoload module */
+	if (!sched && capable(CAP_NET_ADMIN)) {
+		rcu_read_unlock();
+		request_module("sctp_%s", name);
+		rcu_read_lock();
+		sched = sctp_sched_find(name);
+	}
+#endif
+	if (!sched)
+		err = -ENOENT;
+
+	else if (!try_module_get(sched->owner))
+		err = -EBUSY;
+
+	else {
+		sctp_cleanup_sched(sk);
+		sp->sched_ops = sched;
+	}
+out:
+	rcu_read_unlock();
+	return err;
+}
+
+static int fcfs_init(struct sctp_outq *q, gfp_t gfp)
+{
+	q->out_chunk_list = kmalloc(sizeof(struct list_head), gfp);
+	if (!q->out_chunk_list)
+		return -ENOMEM;
+	INIT_LIST_HEAD(q->out_chunk_list);
+
+	return 0;
+}
+
+static void fcfs_release(struct sctp_outq *q)
+{
+	kfree(q->out_chunk_list);
+}
+
+static void fcfs_enqueue_head_data(struct sctp_outq *q,
+					struct sctp_chunk *ch)
+{
+	list_add(&ch->list, q->out_chunk_list);
+	q->out_qlen += ch->skb->len;
+	return;
+}
+
+static void fcfs_enqueue_tail_data(struct sctp_outq *q, struct sctp_chunk *ch)
+{
+	list_add_tail(&ch->list, q->out_chunk_list);
+	q->out_qlen += ch->skb->len;
+	return;
+}
+
+static struct sctp_chunk *fcfs_dequeue_data(struct sctp_outq *q)
+{
+	struct sctp_chunk *ch = NULL;
+
+	if (!list_empty(q->out_chunk_list)) {
+		struct list_head *entry = q->out_chunk_list->next;
+
+		ch = list_entry(entry, struct sctp_chunk, list);
+		list_del_init(entry);
+		q->out_qlen -= ch->skb->len;
+	}
+	return ch;
+}
+
+static inline int fcfs_is_empty(struct sctp_outq *q)
+{
+	return list_empty(q->out_chunk_list);
+}
+
+struct sctp_sched_ops sctp_fcfs = {
+	.name			= "fcfs",
+	.owner			= THIS_MODULE,
+	.init			= fcfs_init,
+	.release		= fcfs_release,
+	.enqueue_head_data	= fcfs_enqueue_head_data,
+	.enqueue_tail_data	= fcfs_enqueue_tail_data,
+	.dequeue_data		= fcfs_dequeue_data,
+	.is_empty		= fcfs_is_empty,
+};
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ca44917..7d461be 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3644,6 +3644,9 @@ SCTP_STATIC int sctp_init_sock(struct sock *sk)
 	sp->initmsg.sinit_max_attempts   = sctp_max_retrans_init;
 	sp->initmsg.sinit_max_init_timeo = sctp_rto_max;

+	/* Initialize default multistream scheduling algorithm */
+	sp->sched_ops = sctp_default_sched_ops;
+
 	/* Initialize default RTO related parameters.  These parameters can
 	 * be modified for with the SCTP_RTOINFO socket option.
 	 */
-- 
1.7.0.4
