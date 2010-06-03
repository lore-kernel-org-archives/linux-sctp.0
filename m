From: Yaogong Wang <ywang15@ncsu.edu>
Date: Thu, 03 Jun 2010 05:42:31 +0000
Subject: [PATCH 3/6] sctp multistream scheduling: provide the default FCFS
Message-Id: <AANLkTimiSeJ9L8iECSn0DQZ-OWdEIfLVC22S2ILHbhr3@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>, Sridhar Samudrala <sri@us.ibm.com>
Cc: linux-kernel@vger.kernel.org

Provide the default FCFS scheduling.

Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
---
diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
p2/include/net/sctp/structs.h p3/include/net/sctp/structs.h
--- p2/include/net/sctp/structs.h	2010-06-02 13:02:14.000000000 -0700
+++ p3/include/net/sctp/structs.h	2010-06-02 12:57:24.000000000 -0700
@@ -181,6 +181,9 @@ extern struct sctp_globals {
 	__u16 max_instreams;
 	__u16 max_outstreams;

+	/* Default scheduling algorithm  */
+	struct sctp_sched_ops *sched_ops;
+
 	/* This is a list of groups of functions for each address
 	 * family that we support.
 	 */
@@ -250,6 +253,7 @@ extern struct sctp_globals {
 #define sctp_hb_interval		(sctp_globals.hb_interval)
 #define sctp_max_instreams		(sctp_globals.max_instreams)
 #define sctp_max_outstreams		(sctp_globals.max_outstreams)
+#define sctp_default_sched_ops		(sctp_globals.sched_ops)
 #define sctp_address_families		(sctp_globals.address_families)
 #define sctp_ep_hashsize		(sctp_globals.ep_hashsize)
 #define sctp_ep_hashtable		(sctp_globals.ep_hashtable)
@@ -566,6 +570,8 @@ extern void sctp_unregister_sched(struct
 extern void sctp_cleanup_sched(struct sock *sk);
 extern int sctp_set_sched(struct sock *sk, const char *name);

+extern struct sctp_sched_ops sctp_fcfs;
+
 /*
  * Pointers to address related SCTP functions.
  * (i.e. things that depend on the address family.)
diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
p2/net/sctp/protocol.c p3/net/sctp/protocol.c
--- p2/net/sctp/protocol.c	2010-06-02 13:03:58.000000000 -0700
+++ p3/net/sctp/protocol.c	2010-05-28 11:18:13.000000000 -0700
@@ -1152,6 +1152,9 @@ SCTP_STATIC __init int sctp_init(void)
 	sctp_max_instreams    		= SCTP_DEFAULT_INSTREAMS;
 	sctp_max_outstreams   		= SCTP_DEFAULT_OUTSTREAMS;

+	/* Initialize default scheduling algorithm to FCFS */
+	sctp_default_sched_ops		= &sctp_fcfs;
+
 	/* Initialize handle used for association ids. */
 	idr_init(&sctp_assocs_id);

@@ -1296,6 +1299,11 @@ SCTP_STATIC __init int sctp_init(void)
 	if (status)
 		goto err_v6_add_protocol;

+	/* Add FCFS to sctp_sched_list  */
+	status = sctp_register_sched(&sctp_fcfs);
+	if (status)
+		goto err_v6_add_protocol;
+
 	status = 0;
 out:
 	return status;
diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
p2/net/sctp/sched.c p3/net/sctp/sched.c
--- p2/net/sctp/sched.c	2010-06-02 12:59:40.000000000 -0700
+++ p3/net/sctp/sched.c	2010-05-28 11:25:05.000000000 -0700
@@ -114,3 +114,62 @@ out:
 	return err;
 }

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
diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
p2/net/sctp/socket.c p3/net/sctp/socket.c
--- p2/net/sctp/socket.c	2010-06-02 13:00:21.000000000 -0700
+++ p3/net/sctp/socket.c	2010-05-28 12:38:09.000000000 -0700
@@ -3642,6 +3642,8 @@ SCTP_STATIC int sctp_init_sock(struct so
 	sp->initmsg.sinit_max_attempts   = sctp_max_retrans_init;
 	sp->initmsg.sinit_max_init_timeo = sctp_rto_max;

+	sp->sched_ops = sctp_default_sched_ops;
+
 	/* Initialize default RTO related parameters.  These parameters can
 	 * be modified for with the SCTP_RTOINFO socket option.
 	 */
