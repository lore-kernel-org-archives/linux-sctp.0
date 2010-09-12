From: Yaogong Wang <ywang15@ncsu.edu>
Date: Sun, 12 Sep 2010 01:13:12 +0000
Subject: [PATCHv2 4/5] sctp: a sample module of strict priority queue
Message-Id: <AANLkTi=8ArxUh2-8PJvD8paDGVBHdDjKk=xQDKo6i2==@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-kernel@vger.kernel.org

Provide a sample kernel module that uses the pluggable multistream
scheduling framework. This module implements strict priority queue.

Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
---
 net/sctp/Kconfig     |   12 ++++++
 net/sctp/Makefile    |    1 +
 net/sctp/sctp_prio.c |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+), 0 deletions(-)
 create mode 100644 net/sctp/sctp_prio.c

diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
index 126b014..85c8ded 100644
--- a/net/sctp/Kconfig
+++ b/net/sctp/Kconfig
@@ -37,6 +37,18 @@ menuconfig IP_SCTP

 if IP_SCTP

+config SCTP_SCHED_PRIO
+	tristate "SCTP Multistream Scheduling: Priority Queue"
+	default m
+	help
+	  This module provides the ability to use priority queue
+	  to schedule multiple streams within an association.
+
+	  To compile this code as a module, choose M here: the
+	  module will be called sctp_prio.
+
+	  If in doubt, say N.
+
 config NET_SCTPPROBE
 	tristate "SCTP: Association probing"
         depends on PROC_FS && KPROBES
diff --git a/net/sctp/Makefile b/net/sctp/Makefile
index 4e8b65d..89be03a 100644
--- a/net/sctp/Makefile
+++ b/net/sctp/Makefile
@@ -4,6 +4,7 @@

 obj-$(CONFIG_IP_SCTP) += sctp.o
 obj-$(CONFIG_NET_SCTPPROBE) += sctp_probe.o
+obj-$(CONFIG_SCTP_SCHED_PRIO) += sctp_prio.o

 sctp-y := sm_statetable.o sm_statefuns.o sm_sideeffect.o \
 	  protocol.o endpointola.o associola.o \
diff --git a/net/sctp/sctp_prio.c b/net/sctp/sctp_prio.c
new file mode 100644
index 0000000..11e7e11
--- /dev/null
+++ b/net/sctp/sctp_prio.c
@@ -0,0 +1,103 @@
+/*
+ * SCTP multistream scheduling: priority queue
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <net/sctp/sctp.h>
+
+static int prio_init(struct sctp_outq *q, gfp_t gfp)
+{
+	__u16 i;
+	q->out_chunk_list = kmalloc(q->asoc->c.sinit_num_ostreams
+				 * sizeof(struct list_head), gfp);
+	if (!q->out_chunk_list)
+		return -ENOMEM;
+	for (i = 0; i < q->asoc->c.sinit_num_ostreams; i++)
+		INIT_LIST_HEAD(&q->out_chunk_list[i]);
+
+	return 0;
+}
+
+static void prio_release(struct sctp_outq *q)
+{
+	kfree(q->out_chunk_list);
+	return;
+}
+
+static void prio_enqueue_head_data(struct sctp_outq *q,
+					struct sctp_chunk *ch)
+{
+	list_add(&ch->list, &q->out_chunk_list[ch->sinfo.sinfo_stream]);
+	q->out_qlen += ch->skb->len;
+	return;
+}
+
+static void prio_enqueue_tail_data(struct sctp_outq *q, struct sctp_chunk *ch)
+{
+	list_add_tail(&ch->list, &q->out_chunk_list[ch->sinfo.sinfo_stream]);
+	q->out_qlen += ch->skb->len;
+	return;
+}
+
+static struct sctp_chunk *prio_dequeue_data(struct sctp_outq *q)
+{
+	struct sctp_chunk *ch = NULL;
+	__u16 prio = 0, i, cur = 0, *config = q->sched_config;
+	int flag = 0;
+
+	for (i = 0; i < q->asoc->c.sinit_num_ostreams; i++) {
+		if (!list_empty(&q->out_chunk_list[i]) &&
+			(flag = 0 || config[i] < prio)) {
+				cur = i;
+				flag = 1;
+				prio = config[i];
+		}
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
+static inline int prio_is_empty(struct sctp_outq *q)
+{
+	__u16 i;
+	for (i = 0; i < q->asoc->c.sinit_num_ostreams; i++)
+		if (!list_empty(&q->out_chunk_list[i]))
+			return 0;
+	return 1;
+}
+
+static struct sctp_sched_ops sctp_prio = {
+	.name			= "prio",
+	.owner			= THIS_MODULE,
+	.init			= prio_init,
+	.release		= prio_release,
+	.enqueue_head_data	= prio_enqueue_head_data,
+	.enqueue_tail_data	= prio_enqueue_tail_data,
+	.dequeue_data		= prio_dequeue_data,
+	.is_empty		= prio_is_empty,
+};
+
+static int __init sctp_prio_register(void)
+{
+	return sctp_register_sched(&sctp_prio);
+}
+
+static void __exit sctp_prio_unregister(void)
+{
+	sctp_unregister_sched(&sctp_prio);
+}
+
+module_init(sctp_prio_register);
+module_exit(sctp_prio_unregister);
+
+MODULE_AUTHOR("Yaogong Wang");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SCTP Multistream Scheduling: Priority Queue");
-- 
1.7.0.4
