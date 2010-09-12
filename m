From: Yaogong Wang <ywang15@ncsu.edu>
Date: Sun, 12 Sep 2010 01:12:41 +0000
Subject: [PATCHv2 1/5] sctp: declare multistream scheduling handler
Message-Id: <AANLkTik20Vt_V3jj_k7si5cb2Uw-XuxKpXGzTLCP5Qvv@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-kernel@vger.kernel.org

Declare sctp_sched_ops structure and related helper functions.

Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
---
 include/net/sctp/structs.h |   41 +++++++++++++++++++++++++++++++++++++++++
 include/net/sctp/user.h    |    2 ++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index f9e7473..6b08876 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -84,6 +84,7 @@ struct sctp_packet;
 struct sctp_chunk;
 struct sctp_inq;
 struct sctp_outq;
+struct sctp_sched_ops;
 struct sctp_bind_addr;
 struct sctp_ulpq;
 struct sctp_ep_common;
@@ -181,6 +182,9 @@ extern struct sctp_globals {
 	__u16 max_instreams;
 	__u16 max_outstreams;

+	/* Default multistream scheduling algorithm  */
+	struct sctp_sched_ops *sched_ops;
+
 	/* This is a list of groups of functions for each address
 	 * family that we support.
 	 */
@@ -255,6 +259,7 @@ extern struct sctp_globals {
 #define sctp_hb_interval		(sctp_globals.hb_interval)
 #define sctp_max_instreams		(sctp_globals.max_instreams)
 #define sctp_max_outstreams		(sctp_globals.max_outstreams)
+#define sctp_default_sched_ops		(sctp_globals.sched_ops)
 #define sctp_address_families		(sctp_globals.address_families)
 #define sctp_ep_hashsize		(sctp_globals.ep_hashsize)
 #define sctp_ep_hashtable		(sctp_globals.ep_hashtable)
@@ -326,6 +331,9 @@ struct sctp_sock {
 	/* Flags controlling Heartbeat, SACK delay, and Path MTU Discovery. */
 	__u32 param_flags;

+	/* Multistream scheduling */
+	const struct sctp_sched_ops *sched_ops;
+
 	struct sctp_initmsg initmsg;
 	struct sctp_rtoinfo rtoinfo;
 	struct sctp_paddrparams paddrparam;
@@ -540,6 +548,36 @@ static inline void sctp_ssn_skip(struct
sctp_stream *stream, __u16 id,
 }

 /*
+ * Interface for adding new multistream scheduling handlers
+ * This is similar to pluggable TCP congestion control
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
+	char		name[SCTP_SCHED_NAME_MAX];
+	struct module	*owner;
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
@@ -1131,6 +1169,9 @@ struct sctp_outq {
 	/* Data pending that has never been transmitted.  */
 	struct list_head out_chunk_list;

+	/* Multistream scheduling */
+	const struct sctp_sched_ops *sched_ops;
+
 	unsigned out_qlen;	/* Total length of queued data chunks. */

 	/* Error of send failed, may used in SCTP_SEND_FAILED event. */
diff --git a/include/net/sctp/user.h b/include/net/sctp/user.h
index 2b2769c..1e084f9 100644
--- a/include/net/sctp/user.h
+++ b/include/net/sctp/user.h
@@ -708,4 +708,6 @@ typedef struct {
 	int sd;
 } sctp_peeloff_arg_t;

+#define SCTP_SCHED_NAME_MAX	16
+
 #endif /* __net_sctp_user_h__ */
-- 
1.7.0.4
