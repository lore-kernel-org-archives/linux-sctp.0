From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 09 Mar 2009 08:53:58 +0000
Subject: [PATCH] sctp: fix to indicate ASCONF support in INIT-ACK only if
Message-Id: <49B4D926.7050802@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patch fix to indicate ASCONF support in INIT-ACK only if peer has
such capable.

This patch also fix to calc the chunk size if peer has no FWD-TSN
capable.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_make_chunk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index b40e95f..9484f33 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -372,10 +372,10 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
 	if (asoc->peer.ecn_capable)
 		chunksize += sizeof(ecap_param);
 
-	if (sctp_prsctp_enable)
+	if (asoc->peer.prsctp_capable)
 		chunksize += sizeof(prsctp_param);
 
-	if (sctp_addip_enable) {
+	if (asoc->peer.asconf_capable) {
 		extensions[num_ext] = SCTP_CID_ASCONF;
 		extensions[num_ext+1] = SCTP_CID_ASCONF_ACK;
 		num_ext += 2;
-- 
1.5.3.8




