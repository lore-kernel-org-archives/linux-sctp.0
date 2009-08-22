From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Sat, 22 Aug 2009 03:10:08 +0000
Subject: [PATCH] sctp: fix retransmit for multi-homed endpoints
Message-Id: <4A8F618F.70708@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

When T3-rtx has expired on multi-homed endpoints, the outstanding
DATA chunks may be retransmited to different path, if there are new
outstanding DATA chunks can be transmit. Such as the following:

  Endpoint (IP=X,Y)                Endpoint (IP=M,N)
                                           <--- Send (SizeH0)
              <--------------   DATA1 (SRC=M)
                                           <--- Send (SizeH0)
                                   (DATA2 not send with Nagle Algo)
             ...T3-rtx expired...
              <--------------   DATA1 (SRC=N)
              <--------------   DATA2 (SRC=M)

DATA1 and DATA2 should be sent bundled with SRC=N. So this patch
fixed it.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/outqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index d765fc5..4109db8 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -960,7 +960,7 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 				new_transport = asoc->peer.active_path;
 
 			/* Change packets if necessary.  */
-			if (new_transport != transport) {
+			if (new_transport != transport && !rtx_timeout) {
 				transport = new_transport;
 
 				/* Schedule to have this transport's
-- 
1.6.2.2




