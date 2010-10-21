From: Nicolas Kaiser <nikai@nikai.net>
Date: Thu, 21 Oct 2010 10:14:09 +0000
Subject: [PATCH] sctp: remove redundant chunk length check
Message-Id: <20101021121409.6de7d429@absol.kitzblitz>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

Checking the chunk length at this point appears redundant, as
the rest of the packet gets discarded anyway.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 net/sctp/sm_statefuns.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 4b4eb7c..9840615 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3418,12 +3418,6 @@ static sctp_disposition_t sctp_sf_shut_8_4_5(const struct sctp_endpoint *ep,
 
 		SCTP_INC_STATS(SCTP_MIB_OUTCTRLCHUNKS);
 
-		/* If the chunk length is invalid, we don't want to process
-		 * the reset of the packet.
-		 */
-		if (!sctp_chunk_length_valid(chunk, sizeof(sctp_chunkhdr_t)))
-			return sctp_sf_pdiscard(ep, asoc, type, arg, commands);
-
 		/* We need to discard the rest of the packet to prevent
 		 * potential bomming attacks from additional bundled chunks.
 		 * This is documented in SCTP Threats ID.
-- 
1.7.2.2
