From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 11 May 2018 23:30:08 +0000
Subject: [PATCH net-next 3/3] sctp: checkpatch fixups
Message-Id: <0a3362579929f389bdf41e3ad2dc1325a2df5931.1526078163.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1526078163.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1526078163.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Xin Long <lucien.xin@gmail.com>

A collection of fixups from previous patches, left for later to not
introduce unnecessary changes while moving code around.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/outqueue.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index a594d181fa1178c34cf477e13d700f7b37e72e21..9a2fa7d6d68b1d695cd745ed612eb32193f947e0 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -812,8 +812,7 @@ static void sctp_outq_select_transport(struct sctp_flush_ctx *ctx,
 
 	if (!new_transport) {
 		if (!sctp_chunk_is_data(chunk)) {
-			/*
-			 * If we have a prior transport pointer, see if
+			/* If we have a prior transport pointer, see if
 			 * the destination address of the chunk
 			 * matches the destination address of the
 			 * current transport.  If not a match, then
@@ -912,8 +911,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 		sctp_outq_select_transport(ctx, chunk);
 
 		switch (chunk->chunk_hdr->type) {
-		/*
-		 * 6.10 Bundling
+		/* 6.10 Bundling
 		 *   ...
 		 *   An endpoint MUST NOT bundle INIT, INIT ACK or SHUTDOWN
 		 *   COMPLETE with any other chunks.  [Send them immediately.]
@@ -1061,8 +1059,7 @@ static void sctp_outq_flush_data(struct sctp_flush_ctx *ctx,
 		return;
 	}
 
-	/*
-	 * RFC 2960 6.1  Transmission of DATA Chunks
+	/* RFC 2960 6.1  Transmission of DATA Chunks
 	 *
 	 * C) When the time comes for the sender to transmit,
 	 * before sending new DATA chunks, the sender MUST
@@ -1101,8 +1098,7 @@ static void sctp_outq_flush_data(struct sctp_flush_ctx *ctx,
 
 		sctp_outq_select_transport(ctx, chunk);
 
-		pr_debug("%s: outq:%p, chunk:%p[%s], tx-tsn:0x%x skb->head:%p "
-			 "skb->users:%d\n",
+		pr_debug("%s: outq:%p, chunk:%p[%s], tx-tsn:0x%x skb->head:%p skb->users:%d\n",
 			 __func__, ctx->q, chunk, chunk && chunk->chunk_hdr ?
 			 sctp_cname(SCTP_ST_CHUNK(chunk->chunk_hdr->type)) :
 			 "illegal chunk", ntohl(chunk->subh.data_hdr->tsn),
@@ -1175,8 +1171,7 @@ static void sctp_outq_flush_transports(struct sctp_flush_ctx *ctx)
 	}
 }
 
-/*
- * Try to flush an outqueue.
+/* Try to flush an outqueue.
  *
  * Description: Send everything in q which we legally can, subject to
  * congestion limitations.
@@ -1196,8 +1191,7 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 		.gfp = gfp,
 	};
 
-	/*
-	 * 6.10 Bundling
+	/* 6.10 Bundling
 	 *   ...
 	 *   When bundling control chunks with DATA chunks, an
 	 *   endpoint MUST place control chunks first in the outbound
@@ -1768,7 +1762,7 @@ static int sctp_acked(struct sctp_sackhdr *sack, __u32 tsn)
 	if (TSN_lte(tsn, ctsn))
 		goto pass;
 
-	/* 3.3.4 Selective Acknowledgement (SACK) (3):
+	/* 3.3.4 Selective Acknowledgment (SACK) (3):
 	 *
 	 * Gap Ack Blocks:
 	 *  These fields contain the Gap Ack Blocks. They are repeated
-- 
2.14.3

