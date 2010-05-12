From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Wed, 12 May 2010 09:30:34 +0000
Subject: [PATCH 3/3] sctp: check invalid value of length parameter in error
Message-Id: <4BEA753A.7080609@cn.fujitsu.com>
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
 net/sctp/sm_statefuns.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 32e75ea..0d2e62f 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2423,8 +2423,15 @@ static sctp_disposition_t __sctp_sf_do_9_1_abort(const struct sctp_endpoint *ep,
 
 	/* See if we have an error cause code in the chunk.  */
 	len = ntohs(chunk->chunk_hdr->length);
-	if (len >= sizeof(struct sctp_chunkhdr) + sizeof(struct sctp_errhdr))
+	if (len >= sizeof(struct sctp_chunkhdr) + sizeof(struct sctp_errhdr)) {
+
+		sctp_errhdr_t *err;
+		sctp_walk_errors(err, chunk->chunk_hdr);
+		if ((void *)err != (void *)chunk->chunk_hdr + len)
+			return sctp_sf_pdiscard(ep, asoc, type, arg, commands);
+
 		error = ((sctp_errhdr_t *)chunk->skb->data)->cause;
+	}
 
 	sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNRESET));
 	/* ASSOC_FAILED will DELETE_TCB. */
-- 
1.6.3.3
