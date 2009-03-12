From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 12 Mar 2009 19:49:19 +0000
Subject: [PATCH net-next 3/4] sctp: fix to send FORWARD-TSN chunk only if peer has such capable
Message-Id: <1236887360-1904-4-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1236887360-1904-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1236887360-1904-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Wei Yongjun <yjwei@cn.fujitsu.com>, Vlad Yasevich <vladislav.yasevich@hp.com>

From: Wei Yongjun <yjwei@cn.fujitsu.com>

RFC3758 Section 3.3.1.  Sending Forward-TSN-Supported param in INIT

   Note that if the endpoint chooses NOT to include the parameter, then
   at no time during the life of the association can it send or process
   a FORWARD TSN.

If peer does not support PR-SCTP capable, don't send FORWARD-TSN chunk
to peer.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
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
1.5.4.3

