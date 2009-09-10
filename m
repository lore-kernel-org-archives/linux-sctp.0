From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 10 Sep 2009 03:32:26 +0000
Subject: [PATCH 3/3 v2] sctp: implement the sender side for SACK-IMMEDIATELY
Message-Id: <4AA8734A.3040308@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patch implement the sender side for SACK-IMMEDIATELY
extension.

  Section 4.1.  Sender Side Considerations

  Whenever the sender of a DATA chunk can benefit from the
  corresponding SACK chunk being sent back without delay, the sender
  MAY set the I-bit in the DATA chunk header.

  Reasons for setting the I-bit include

  o  The sender is in the SHUTDOWN-PENDING state.

  o  The application requests to set the I-bit of the last DATA chunk
     of a user message when providing the user message to the SCTP
     implementation.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/user.h |    1 +
 net/sctp/chunk.c        |   11 ++++++++++-
 net/sctp/outqueue.c     |    7 +++++++
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/include/net/sctp/user.h b/include/net/sctp/user.h
index be2334a..50b2431 100644
--- a/include/net/sctp/user.h
+++ b/include/net/sctp/user.h
@@ -206,6 +206,7 @@ enum sctp_sinfo_flags {
 	SCTP_UNORDERED = 1,  /* Send/receive message unordered. */
 	SCTP_ADDR_OVER = 2,  /* Override the primary destination. */
 	SCTP_ABORT=4,        /* Send an ABORT message to the peer. */
+	SCTP_SACK_IMMEDIATELY = 8,	/* SACK should be sent without delay */
 	SCTP_EOF=MSG_FIN,    /* Initiate graceful shutdown process. */	
 };
 
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index acf7c4d..eaf4077 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -263,9 +263,18 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 		if (0 = i)
 			frag |= SCTP_DATA_FIRST_FRAG;
 
-		if ((i = (whole - 1)) && !over)
+		if ((i = (whole - 1)) && !over) {
 			frag |= SCTP_DATA_LAST_FRAG;
 
+			/* The application requests to set the I-bit of the
+			 * last DATA chunk of a user message when providing
+			 * the user message to the SCTP implementation.
+			 */
+			if ((sinfo->sinfo_flags & SCTP_EOF) ||
+			    (sinfo->sinfo_flags & SCTP_SACK_IMMEDIATELY))
+				frag |= SCTP_DATA_SACK_IMM;
+		}
+
 		chunk = sctp_make_datafrag_empty(asoc, sinfo, len, frag, 0);
 
 		if (!chunk)
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index c9f20e2..5732661 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1011,6 +1011,13 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 				break;
 
 			case SCTP_XMIT_OK:
+				/* The sender is in the SHUTDOWN-PENDING state,
+				 * The sender MAY set the I-bit in the DATA
+				 * chunk header.
+				 */
+				if (asoc->state = SCTP_STATE_SHUTDOWN_PENDING)
+					chunk->chunk_hdr->flags |= SCTP_DATA_SACK_IMM;
+
 				break;
 
 			default:
-- 
1.6.2.2




