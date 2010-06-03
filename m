From: Yaogong Wang <ywang15@ncsu.edu>
Date: Thu, 03 Jun 2010 05:42:18 +0000
Subject: [PATCH 1/6] sctp multistream scheduling: declare sctp_sched_ops
Message-Id: <AANLkTilgantV3v0T1-ef6ewyinddzfOs1PZW1Re9ZAyQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>, Sridhar Samudrala <sri@us.ibm.com>
Cc: linux-kernel@vger.kernel.org

Declare sctp_sched_ops structure and related functions

Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
---
diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
linux-2.6.32.8/include/net/sctp/structs.h
p1/include/net/sctp/structs.h
--- linux-2.6.32.8/include/net/sctp/structs.h	2010-02-09
04:57:19.000000000 -0800
+++ p1/include/net/sctp/structs.h	2010-05-28 10:33:12.000000000 -0700
@@ -320,6 +320,9 @@ struct sctp_sock {
 	/* Flags controlling Heartbeat, SACK delay, and Path MTU Discovery. */
 	__u32 param_flags;

+	/* Multistream scheduling  */
+	const struct sctp_sched_ops *sched_ops;
+
 	struct sctp_initmsg initmsg;
 	struct sctp_rtoinfo rtoinfo;
 	struct sctp_paddrparams paddrparam;
@@ -534,6 +537,36 @@ static inline void sctp_ssn_skip(struct
 }

 /*
+ * Interface for adding new SCTP scheduling handlers
+ * This is similar to the pluggable TCP congestion control
+ */
+struct sctp_sched_ops {
+	struct list_head	list;
+
+	/* initialize out_chunk_list (required) */
+	int (*init)(struct sctp_outq *q, gfp_t gfp);
+	/* cleanup out_chunk_list (required) */
+	void (*release)(struct sctp_outq *q);
+	/* enqueue head function (required) */
+	void (*enqueue_head_data)(struct sctp_outq *q, struct sctp_chunk *ch);
+	/* enqueue tail function (required) */
+	void (*enqueue_tail_data)(struct sctp_outq *q, struct sctp_chunk *ch);
+	/* dequeue function (required) */
+	struct sctp_chunk* (*dequeue_data)(struct sctp_outq *q);
+	/* is out_chunk_list empty? (required) */
+	int (*is_empty)(struct sctp_outq *q);
+
+	char 		name[SCTP_SCHED_NAME_MAX];
+	struct module 	*owner;
+};
+
+extern int sctp_register_sched(struct sctp_sched_ops *type);
+extern void sctp_unregister_sched(struct sctp_sched_ops *type);
+
+extern void sctp_cleanup_sched(struct sock *sk);
+extern int sctp_set_sched(struct sock *sk, const char *name);
+
+/*
  * Pointers to address related SCTP functions.
  * (i.e. things that depend on the address family.)
  */
@@ -1650,6 +1683,9 @@ struct sctp_association {
 	/* The largest timeout or RTO value to use in attempting an INIT */
 	unsigned long max_init_timeo;

+	/* Multistream scheduling  */
+	const struct sctp_sched_ops *sched_ops;
+
 	/* Heartbeat interval: The endpoint sends out a Heartbeat chunk to
 	 * the destination address every heartbeat interval. This value
 	 * will be inherited by all new transports.
diff -uprN -X linux-2.6.32.8/Documentation/dontdiff
linux-2.6.32.8/include/net/sctp/user.h p1/include/net/sctp/user.h
--- linux-2.6.32.8/include/net/sctp/user.h	2010-02-09 04:57:19.000000000 -0800
+++ p1/include/net/sctp/user.h	2010-05-28 10:52:57.000000000 -0700
@@ -171,6 +171,8 @@ struct sctp_initmsg {
 	__u16 sinit_max_init_timeo;
 };

+#define SCTP_SCHED_NAME_MAX	16
+
 /*
  * 5.2.2 SCTP Header Information Structure (SCTP_SNDRCV)
  *
