From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Mon, 17 May 2010 05:55:51 +0000
Subject: Re: [PATCH 3/3 v2] sctp: check invalid value of length parameter
Message-Id: <4BF0DA67.9070006@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

 
RFC4960, section 3.3.7 said:
 If an endpoint receives an ABORT with a format error or no TCB is
 found, it MUST silently discard it.

When an endpoint receives ABORT that parameter value is invalid,
drop it.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
v1->v2:
1. As Vlad's suggestion, use chunk->chunk_end to point to end of chunk.
---
 net/sctp/sm_statefuns.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 03904a6..edb71e6 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2412,8 +2412,15 @@ static sctp_disposition_t __sctp_sf_do_9_1_abort(const struct sctp_endpoint *ep,
 
 	/* See if we have an error cause code in the chunk.  */
 	len = ntohs(chunk->chunk_hdr->length);
-	if (len >= sizeof(struct sctp_chunkhdr) + sizeof(struct sctp_errhdr))
+	if (len >= sizeof(struct sctp_chunkhdr) + sizeof(struct sctp_errhdr)) {
+
+		sctp_errhdr_t *err;
+		sctp_walk_errors(err, chunk->chunk_hdr);
+		if ((void *)err != (void *)chunk->chunk_end)
+			return sctp_sf_pdiscard(ep, asoc, type, arg, commands);
+
 		error = ((sctp_errhdr_t *)chunk->skb->data)->cause;
+	}
 
 	sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNRESET));
 	/* ASSOC_FAILED will DELETE_TCB. */
-- 
1.6.3.3
