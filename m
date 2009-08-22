From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Sat, 22 Aug 2009 03:27:37 +0000
Subject: [PATCH] sctp: fix check the chunk length of received HEARTBEAT-ACK
Message-Id: <4A8F65A9.7080404@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

The receiver of the HEARTBEAT should respond with a HEARTBEAT ACK
that contains the Heartbeat Information field copied from the
received HEARTBEAT chunk. So the received HEARTBEAT-ACK chunk
must have a length of:
  sizeof(sctp_chunkhdr_t) + sizeof(sctp_sender_hb_info_t)

A badly formatted HB-ACK chunk, it is possible that we may access
invalid memory.  We should really make sure that the chunk format
is what we expect, before attempting to touch the data.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_statefuns.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 071c668..a4b63e8 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1106,7 +1106,8 @@ sctp_disposition_t sctp_sf_backbeat_8_3(const struct sctp_endpoint *ep,
 		return sctp_sf_pdiscard(ep, asoc, type, arg, commands);
 
 	/* Make sure that the HEARTBEAT-ACK chunk has a valid length.  */
-	if (!sctp_chunk_length_valid(chunk, sizeof(sctp_heartbeat_chunk_t)))
+	if (!sctp_chunk_length_valid(chunk, sizeof(sctp_chunkhdr_t) +
+					    sizeof(sctp_sender_hb_info_t)))
 		return sctp_sf_violation_chunklen(ep, asoc, type, arg,
 						  commands);
 
-- 
1.6.2.2




