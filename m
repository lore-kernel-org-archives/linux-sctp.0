From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Mon, 17 May 2010 05:54:45 +0000
Subject: Re: [PATCH 1/3 v3] sctp: check parameter value of length in ERROR
Message-Id: <4BF0DA25.9090505@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


When an endpoint receives ERROR that parameter value is invalid,
send an ABORT to peer with a Protocol Violation error code.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
v2->v3:
1. Use sctp_sf_violation_paramvalue() to send ABORT with a Protocol Violation error code.

v1->v2:
1. As Vlad's suggestion, use chunk->chunk_end to point to end of chunk.
---
 net/sctp/sm_statefuns.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 24b2cd5..03904a6 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3204,6 +3204,7 @@ sctp_disposition_t sctp_sf_operr_notify(const struct sctp_endpoint *ep,
 					sctp_cmd_seq_t *commands)
 {
 	struct sctp_chunk *chunk = arg;
+	sctp_errhdr_t *err;
 
 	if (!sctp_vtag_verify(chunk, asoc))
 		return sctp_sf_pdiscard(ep, asoc, type, arg, commands);
@@ -3212,6 +3213,10 @@ sctp_disposition_t sctp_sf_operr_notify(const struct sctp_endpoint *ep,
 	if (!sctp_chunk_length_valid(chunk, sizeof(sctp_operr_chunk_t)))
 		return sctp_sf_violation_chunklen(ep, asoc, type, arg,
 						  commands);
+	sctp_walk_errors(err, chunk->chunk_hdr);
+	if ((void *)err != (void *)chunk->chunk_end)
+		return sctp_sf_violation_paramlen(ep, asoc, type, arg,
+						  (void *)err, commands);
 
 	sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_OPERR,
 			SCTP_CHUNK(chunk));
-- 
1.6.3.3
