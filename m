From: Yaogong Wang <ywang15@ncsu.edu>
Date: Sun, 12 Sep 2010 01:13:18 +0000
Subject: [PATCHv2 5/5] sctp: a sample module of weighted fair queue
Message-Id: <AANLkTikFdyrge-sRws+8kX=dVDpVWBxwJa+GAcjjK8mz@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-kernel@vger.kernel.org

Provide a sample kernel module that uses the pluggable multistream
scheduling framework. This modules implements weighted fair queue.

Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
---
 include/net/sctp/structs.h |    1 +
 net/sctp/Kconfig           |   12 ++++
 net/sctp/Makefile          |    1 +
 net/sctp/outqueue.c        |    1 +
 net/sctp/sctp_wfq.c        |  150 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 165 insertions(+), 0 deletions(-)
 create mode 100644 net/sctp/sctp_wfq.c

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 1a76417..06be084 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1177,6 +1177,7 @@ struct sctp_outq {
 	const struct sctp_sched_ops *sched_ops;
 	__u16 sched_config_len;
 	void *sched_config;
+	void *sched_internal;

 	unsigned out_qlen;	/* Total length of queued data chunks. */

diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
index 85c8ded..b2f9b47 100644
--- a/net/sctp/Kconfig
+++ b/net/sctp/Kconfig
@@ -49,6 +49,18 @@ config SCTP_SCHED_PRIO

 	  If in doubt, say N.

+config SCTP_SCHED_WFQ
+	tristate "SCTP Multistream Scheduling: Weighted Fair Queue"
+	default m
+	help
+	  This module provides the ability to use weighted fair queue
+	  to schedule multiple streams within an association.
+
+	  To compile this code as a module, choose M here: the
+	  module will be called sctp_wfq.
+
+	  If in doubt, say N.
+
 config NET_SCTPPROBE
 	tristate "SCTP: Association probing"
         depends on PROC_FS && KPROBES
diff --git a/net/sctp/Makefile b/net/sctp/Makefile
index 89be03a..f9b4068 100644
--- a/net/sctp/Makefile
+++ b/net/sctp/Makefile
@@ -5,6 +5,7 @@
 obj-$(CONFIG_IP_SCTP) += sctp.o
 obj-$(CONFIG_NET_SCTPPROBE) += sctp_probe.o
 obj-$(CONFIG_SCTP_SCHED_PRIO) += sctp_prio.o
+obj-$(CONFIG_SCTP_SCHED_WFQ) += sctp_wfq.o

 sctp-y := sm_statetable.o sm_statefuns.o sm_sideeffect.o \
 	  protocol.o endpointola.o associola.o \
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 1d3bd2e..1e3bc9b 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -180,6 +180,7 @@ int sctp_outq_init(struct sctp_association *asoc,
struct sctp_outq *q,
 	q->sched_ops = sctp_default_sched_ops;
 	q->sched_config_len = 0;
 	q->sched_config = NULL;
+	q->sched_internal = NULL;
 	err = q->sched_ops->init(q, gfp);
 	if (err)
 		return err;
diff --git a/net/sctp/sctp_wfq.c b/net/sctp/sctp_wfq.c
new file mode 100644
index 0000000..00edd2c
--- /dev/null
+++ b/net/sctp/sctp_wfq.c
@@ -0,0 +1,150 @@
+/*
+ * SCTP multistream scheduling: weighted fair queue
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <net/sctp/sctp.h>
+
+static int quantum = 1500;
+module_param(quantum, int, 0644);
+MODULE_PARM_DESC(quantum, "quantum in bytes");
+
+/*
+ * Weighted fair queue internal data structure
+ *
+ * implemented using deficit round robin technique
+ */
+struct wfq {
+	__u16	rr_ptr;
+	__u16	deficit[0];
+};
+
+static int wfq_init(struct sctp_outq *q, gfp_t gfp)
+{
+	__u16 i, *config = q->sched_config;
+	struct wfq *internal;
+
+	/* initiate out_chunk_list */
+	q->out_chunk_list = kmalloc(q->asoc->c.sinit_num_ostreams
+				 * sizeof(struct list_head), gfp);
+	if (!q->out_chunk_list)
+		return -ENOMEM;
+	for (i = 0; i < q->asoc->c.sinit_num_ostreams; i++)
+		INIT_LIST_HEAD(&q->out_chunk_list[i]);
+
+	/* initiate internal data structure */
+	q->sched_internal = kmalloc((q->asoc->c.sinit_num_ostreams + 1) *
+					sizeof(__u16), gfp);
+	if (!q->sched_internal) {
+		kfree(q->out_chunk_list);
+		return -ENOMEM;
+	}
+	internal = (struct wfq *)q->sched_internal;
+	internal->rr_ptr = 0;
+	internal->deficit[0] = config[0] * quantum;
+	for (i = 1; i < q->asoc->c.sinit_num_ostreams; i++)
+		internal->deficit[i] = 0;
+
+	return 0;
+}
+
+static void wfq_release(struct sctp_outq *q)
+{
+	kfree(q->out_chunk_list);
+	kfree(q->sched_internal);
+	return;
+}
+
+static void wfq_enqueue_head_data(struct sctp_outq *q,
+					struct sctp_chunk *ch)
+{
+	list_add(&ch->list, &q->out_chunk_list[ch->sinfo.sinfo_stream]);
+	q->out_qlen += ch->skb->len;
+	return;
+}
+
+static void wfq_enqueue_tail_data(struct sctp_outq *q, struct sctp_chunk *ch)
+{
+	list_add_tail(&ch->list, &q->out_chunk_list[ch->sinfo.sinfo_stream]);
+	q->out_qlen += ch->skb->len;
+	return;
+}
+
+static struct sctp_chunk *wfq_dequeue_data(struct sctp_outq *q)
+{
+	struct sctp_chunk *ch = NULL;
+	struct wfq *internal = (struct wfq *)q->sched_internal;
+	__u16 i, cur = 0, *config = q->sched_config;
+	int flag = 0, hasdata = 0;
+
+	for (i = 0; i < q->asoc->c.sinit_num_ostreams || hasdata; i++) {
+		if (!list_empty(&q->out_chunk_list[internal->rr_ptr])) {
+			hasdata = 1;
+			struct list_head *tmp_entry +				q->out_chunk_list[internal->rr_ptr].next;
+			struct sctp_chunk *tmp_ch +				list_entry(tmp_entry, struct sctp_chunk, list);
+			if (tmp_ch->skb->len <+				internal->deficit[internal->rr_ptr]) {
+				internal->deficit[internal->rr_ptr] -+					tmp_ch->skb->len;
+				cur = internal->rr_ptr;
+				flag = 1;
+				break;
+			}
+		} else {
+			internal->deficit[internal->rr_ptr] = 0;
+		}
+		internal->rr_ptr = (internal->rr_ptr + 1) %
+					q->asoc->c.sinit_num_ostreams;
+		internal->deficit[internal->rr_ptr] ++				config[internal->rr_ptr] * quantum;
+	}
+
+	if (flag) {
+		struct list_head *entry = q->out_chunk_list[cur].next;
+		ch = list_entry(entry, struct sctp_chunk, list);
+		list_del_init(entry);
+		q->out_qlen -= ch->skb->len;
+	}
+	return ch;
+}
+
+static inline int wfq_is_empty(struct sctp_outq *q)
+{
+	__u16 i;
+	for (i = 0; i < q->asoc->c.sinit_num_ostreams; i++)
+		if (!list_empty(&q->out_chunk_list[i]))
+			return 0;
+	return 1;
+}
+
+static struct sctp_sched_ops sctp_wfq = {
+	.name			= "wfq",
+	.owner			= THIS_MODULE,
+	.init			= wfq_init,
+	.release		= wfq_release,
+	.enqueue_head_data	= wfq_enqueue_head_data,
+	.enqueue_tail_data	= wfq_enqueue_tail_data,
+	.dequeue_data		= wfq_dequeue_data,
+	.is_empty		= wfq_is_empty,
+};
+
+static int __init sctp_wfq_register(void)
+{
+	return sctp_register_sched(&sctp_wfq);
+}
+
+static void __exit sctp_wfq_unregister(void)
+{
+	sctp_unregister_sched(&sctp_wfq);
+}
+
+module_init(sctp_wfq_register);
+module_exit(sctp_wfq_unregister);
+
+MODULE_AUTHOR("Yaogong Wang");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SCTP Multistream Scheduling: Weighted Fair Queue");
-- 
1.7.0.4
