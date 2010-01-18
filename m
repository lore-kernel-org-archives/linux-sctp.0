From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 18 Jan 2010 05:30:47 +0000
Subject: [PATCH] sctp: assure at least one T3-rtx timer is running if a FORWARD
Message-Id: <4B53F207.3090903@cn.fujitsu.com>
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
 net/sctp/outqueue.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index d36aea4..67ec3ba 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -939,6 +939,13 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 				goto sctp_flush_out;
 		}
 
+		/* PR-SCTP C5) If a FORWARD TSN is sent, the sender MUST assure
+		 * that at least one T3-rtx timer is running.
+		 */
+		if (!list_empty(&q->abandoned) &&
+		    list_empty(&q->out_chunk_list))
+			sctp_transport_reset_timers(transport, 0);
+
 		/* Apply Max.Burst limitation to the current transport in
 		 * case it will be used for new data.  We are going to
 		 * rest it before we return, but we want to apply the limit
-- 
1.6.2.2


