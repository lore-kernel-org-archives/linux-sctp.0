From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 20 Jan 2010 02:50:30 +0000
Subject: [PATCH v2] sctp: assure at least one T3-rtx timer is running if a
Message-Id: <4B566F76.9070101@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

PR-SCTP extension section 3.5 Sender Side Implementation of PR-SCTP:
  C5) If a FORWARD TSN is sent, the sender MUST assure that at
      least one T3-rtx timer is running.

So this patch fix to assure at least one T3-rtx timer is running
if a FORWARD TSN is or will to sent.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/outqueue.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 229690f..7521217 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -853,6 +853,12 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 			if (status  != SCTP_XMIT_OK) {
 				/* put the chunk back */
 				list_add(&chunk->list, &q->control_chunk_list);
+			} else if (chunk->chunk_hdr->type = SCTP_CID_FWD_TSN) {
+				/* PR-SCTP C5) If a FORWARD TSN is sent, the
+				 * sender MUST assure that at least one T3-rtx
+				 * timer is running.
+				 */
+				sctp_transport_reset_timers(transport, 0);
 			}
 			break;
 
-- 
1.6.2.2


