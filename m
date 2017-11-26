From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 26 Nov 2017 12:16:08 +0000
Subject: [PATCH net 3/3] sctp: remove extern from stream sched
Message-Id: <55f27f73eb2375276f086659d6be24042160c510.1511698478.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1511698478.git.lucien.xin@gmail.com>
 <b1daca5283b99f8df5a48749a18e07c8596316d1.1511698478.git.lucien.xin@gmail.com>
 <b6a18a03feb2b815d75482e266cb5e4603bb8132.1511698478.git.lucien.xin@gmail.com>
In-Reply-To: <b6a18a03feb2b815d75482e266cb5e4603bb8132.1511698478.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

Now each stream sched ops is defined in different .c file and
added into the global ops in another .c file, it uses extern
to make this work.

However extern is not good coding style to get them in and
even make C=2 reports errors for this.

This patch adds sctp_sched_ops_xxx_init for each stream sched
ops in their .c file, then get them into the global ops by
calling them when initializing sctp module.

Fixes: 637784ade221 ("sctp: introduce priority based stream scheduler")
Fixes: ac1ed8b82cd6 ("sctp: introduce round robin stream scheduler")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/sctp.h         |  5 +++++
 include/net/sctp/stream_sched.h |  5 +++++
 net/sctp/protocol.c             |  1 +
 net/sctp/stream_sched.c         | 25 ++++++++++++++++++-------
 net/sctp/stream_sched_prio.c    |  7 ++++++-
 net/sctp/stream_sched_rr.c      |  7 ++++++-
 6 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 749a428..906a9c0 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -195,6 +195,11 @@ void sctp_remaddr_proc_exit(struct net *net);
 int sctp_offload_init(void);
 
 /*
+ * sctp/stream_sched.c
+ */
+void sctp_sched_ops_init(void);
+
+/*
  * sctp/stream.c
  */
 int sctp_send_reset_streams(struct sctp_association *asoc,
diff --git a/include/net/sctp/stream_sched.h b/include/net/sctp/stream_sched.h
index c676550..5c5da48 100644
--- a/include/net/sctp/stream_sched.h
+++ b/include/net/sctp/stream_sched.h
@@ -69,4 +69,9 @@ void sctp_sched_dequeue_common(struct sctp_outq *q, struct sctp_chunk *ch);
 int sctp_sched_init_sid(struct sctp_stream *stream, __u16 sid, gfp_t gfp);
 struct sctp_sched_ops *sctp_sched_ops_from_stream(struct sctp_stream *stream);
 
+void sctp_sched_ops_register(enum sctp_sched_type sched,
+			     struct sctp_sched_ops *sched_ops);
+void sctp_sched_ops_prio_init(void);
+void sctp_sched_ops_rr_init(void);
+
 #endif /* __sctp_stream_sched_h__ */
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index f5172c2..6a38c25 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1499,6 +1499,7 @@ static __init int sctp_init(void)
 	INIT_LIST_HEAD(&sctp_address_families);
 	sctp_v4_pf_init();
 	sctp_v6_pf_init();
+	sctp_sched_ops_init();
 
 	status = register_pernet_subsys(&sctp_defaults_ops);
 	if (status)
diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index 0b83ec5..d8c162a 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -119,16 +119,27 @@ static struct sctp_sched_ops sctp_sched_fcfs = {
 	.unsched_all = sctp_sched_fcfs_unsched_all,
 };
 
+static void sctp_sched_ops_fcfs_init(void)
+{
+	sctp_sched_ops_register(SCTP_SS_FCFS, &sctp_sched_fcfs);
+}
+
 /* API to other parts of the stack */
 
-extern struct sctp_sched_ops sctp_sched_prio;
-extern struct sctp_sched_ops sctp_sched_rr;
+static struct sctp_sched_ops *sctp_sched_ops[SCTP_SS_MAX + 1];
 
-static struct sctp_sched_ops *sctp_sched_ops[] = {
-	&sctp_sched_fcfs,
-	&sctp_sched_prio,
-	&sctp_sched_rr,
-};
+void sctp_sched_ops_register(enum sctp_sched_type sched,
+			     struct sctp_sched_ops *sched_ops)
+{
+	sctp_sched_ops[sched] = sched_ops;
+}
+
+void sctp_sched_ops_init(void)
+{
+	sctp_sched_ops_fcfs_init();
+	sctp_sched_ops_prio_init();
+	sctp_sched_ops_rr_init();
+}
 
 int sctp_sched_set_sched(struct sctp_association *asoc,
 			 enum sctp_sched_type sched)
diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
index 384dbf3..7997d35 100644
--- a/net/sctp/stream_sched_prio.c
+++ b/net/sctp/stream_sched_prio.c
@@ -333,7 +333,7 @@ static void sctp_sched_prio_unsched_all(struct sctp_stream *stream)
 			sctp_sched_prio_unsched(soute);
 }
 
-struct sctp_sched_ops sctp_sched_prio = {
+static struct sctp_sched_ops sctp_sched_prio = {
 	.set = sctp_sched_prio_set,
 	.get = sctp_sched_prio_get,
 	.init = sctp_sched_prio_init,
@@ -345,3 +345,8 @@ struct sctp_sched_ops sctp_sched_prio = {
 	.sched_all = sctp_sched_prio_sched_all,
 	.unsched_all = sctp_sched_prio_unsched_all,
 };
+
+void sctp_sched_ops_prio_init(void)
+{
+	sctp_sched_ops_register(SCTP_SS_PRIO, &sctp_sched_prio);
+}
diff --git a/net/sctp/stream_sched_rr.c b/net/sctp/stream_sched_rr.c
index 7612a43..1155692 100644
--- a/net/sctp/stream_sched_rr.c
+++ b/net/sctp/stream_sched_rr.c
@@ -187,7 +187,7 @@ static void sctp_sched_rr_unsched_all(struct sctp_stream *stream)
 		sctp_sched_rr_unsched(stream, soute);
 }
 
-struct sctp_sched_ops sctp_sched_rr = {
+static struct sctp_sched_ops sctp_sched_rr = {
 	.set = sctp_sched_rr_set,
 	.get = sctp_sched_rr_get,
 	.init = sctp_sched_rr_init,
@@ -199,3 +199,8 @@ struct sctp_sched_ops sctp_sched_rr = {
 	.sched_all = sctp_sched_rr_sched_all,
 	.unsched_all = sctp_sched_rr_unsched_all,
 };
+
+void sctp_sched_ops_rr_init(void)
+{
+	sctp_sched_ops_register(SCTP_SS_RR, &sctp_sched_rr);
+}
-- 
2.1.0

