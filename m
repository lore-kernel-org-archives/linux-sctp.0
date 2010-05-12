From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Wed, 12 May 2010 09:30:30 +0000
Subject: [PATCH 2/3] sctp:check parameter value of length in HEARTBEAT chunk
Message-Id: <4BEA7536.7080004@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

When an endpoint receives HEARTBEAT that parameter value is invalid,
send an ABORT to peer with a Protocol Violation error code.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 net/sctp/sm_statefuns.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 3d3e36b..32e75ea 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1067,6 +1067,10 @@ sctp_disposition_t sctp_sf_beat_8_3(const struct sctp_endpoint *ep,
 	 */
 	chunk->subh.hb_hdr = (sctp_heartbeathdr_t *) chunk->skb->data;
 	paylen = ntohs(chunk->chunk_hdr->length) - sizeof(sctp_chunkhdr_t);
+
+	if (ntohs(chunk->subh.hb_hdr->info.length) != paylen)
+		sctp_sf_violation_paramvalue(ep, asoc, type, arg,
+					     commands);
 	if (!pskb_pull(chunk->skb, paylen))
 		goto nomem;
 
-- 
1.6.3.3
