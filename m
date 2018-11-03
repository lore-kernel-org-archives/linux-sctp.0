From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 03 Nov 2018 06:01:31 +0000
Subject: [PATCH net] sctp: define SCTP_SS_DEFAULT for Stream schedulers
Message-Id: <4986625e9c58cccdfbb6c809a82c77a83b57a541.1541224891.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

According to rfc8260#section-4.3.2, SCTP_SS_DEFAULT is required to
defined as SCTP_SS_FCFS or SCTP_SS_RR.

SCTP_SS_FCFS is used for SCTP_SS_DEFAULT's value in this patch.

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Reported-by: Jianwen Ji <jiji@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h | 1 +
 net/sctp/outqueue.c       | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 680ecc3..c81feb3 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -1153,6 +1153,7 @@ struct sctp_add_streams {
 /* SCTP Stream schedulers */
 enum sctp_sched_type {
 	SCTP_SS_FCFS,
+	SCTP_SS_DEFAULT = SCTP_SS_FCFS,
 	SCTP_SS_PRIO,
 	SCTP_SS_RR,
 	SCTP_SS_MAX = SCTP_SS_RR
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 9cb854b..c37e1c2 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -212,7 +212,7 @@ void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
 	INIT_LIST_HEAD(&q->retransmit);
 	INIT_LIST_HEAD(&q->sacked);
 	INIT_LIST_HEAD(&q->abandoned);
-	sctp_sched_set_sched(asoc, SCTP_SS_FCFS);
+	sctp_sched_set_sched(asoc, SCTP_SS_DEFAULT);
 }
 
 /* Free the outqueue structure and any related pending chunks.
-- 
2.1.0
