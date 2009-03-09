From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 09 Mar 2009 08:55:08 +0000
Subject: [PATCH] sctp: fix to send FORWARD-TSN chunk only if peer has such
Message-Id: <49B4D96C.302@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

RFC3758 Section 3.3.1.  Sending Forward-TSN-Supported param in INIT

   Note that if the endpoint chooses NOT to include the parameter, then
   at no time during the life of the association can it send or process
   a FORWARD TSN.

If peer does not support PR-SCTP capable, don't send FORWARD-TSN chunk
to peer.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/outqueue.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index a367d15..d765fc5 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1758,6 +1758,9 @@ static void sctp_generate_fwdtsn(struct sctp_outq *q, __u32 ctsn)
 	struct sctp_chunk *chunk;
 	struct list_head *lchunk, *temp;
 
+	if (!asoc->peer.prsctp_capable)
+		return;
+
 	/* PR-SCTP C1) Let SackCumAck be the Cumulative TSN ACK carried in the
 	 * received SACK.
 	 *
-- 
1.5.3.8




