From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 12 Jun 2013 12:59:19 +0000
Subject: [PATCH net-next stable] sctp: fully initialize sctp_outq in sctp_outq_init
Message-Id: <1371041959-17697-1-git-send-email-nhorman@tuxdriver.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, netdev@vger.kernel.org, davem@davemloft.net

In commit 2f94aabd9f6c925d77aecb3ff020f1cc12ed8f86, we modified
sctp_outq_teardown to use sctp_outq_init to fully re-initalize the outq
structure.  Steve West recently asked me why I removed the q->error = 0
initalization from sctp_outq_teardown.  I did so because I was operating under
the impression that sctp_outq_init would properly initalize that value for us,
but it doesn't.  sctp_outq_init operates under the assumption that the outq
struct is all 0's (as it is when called from sctp_association_init), but using
it in __sctp_outq_teardown violates that assumption. We should do a memset in
sctp_outq_init to ensure that the entire structure is in a known state there
instead.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: "West, Steve (NSN - US/Fort Worth)" <steve.west@nsn.com>
CC: Vlad Yasevich <vyasevich@gmail.com>
CC: netdev@vger.kernel.org
CC: davem@davemloft.net
---
 net/sctp/outqueue.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 32a4625..d8b6958 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -206,6 +206,9 @@ static inline int sctp_cacc_skip(struct sctp_transport *primary,
  */
 void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
 {
+
+	memset(q, 0, sizeof(struct sctp_outq));
+
 	q->asoc = asoc;
 	INIT_LIST_HEAD(&q->out_chunk_list);
 	INIT_LIST_HEAD(&q->control_chunk_list);
@@ -213,11 +216,7 @@ void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
 	INIT_LIST_HEAD(&q->sacked);
 	INIT_LIST_HEAD(&q->abandoned);
 
-	q->fast_rtx = 0;
-	q->outstanding_bytes = 0;
 	q->empty = 1;
-	q->cork  = 0;
-	q->out_qlen = 0;
 }
 
 /* Free the outqueue structure and any related pending chunks.
-- 
1.8.1.4

