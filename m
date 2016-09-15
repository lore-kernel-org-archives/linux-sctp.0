From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 15 Sep 2016 18:12:30 +0000
Subject: [PATCH next] sctp: make use of WORD_TRUNC macro
Message-Id: <b40b1bd4adff2d389588d9a4710af0399ce68d1e.1473963064.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

No functional change. Just to avoid the usage of '&~3'.
Also break the line to make it easier to read.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/chunk.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index a55e54738b81ff8cf9cd711cf5fc466ac71374c0..adae4a41ca2078cfee387631f76e5cb768c2269c 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -182,9 +182,10 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 	/* This is the biggest possible DATA chunk that can fit into
 	 * the packet
 	 */
-	max_data = (asoc->pathmtu -
-		sctp_sk(asoc->base.sk)->pf->af->net_header_len -
-		sizeof(struct sctphdr) - sizeof(struct sctp_data_chunk)) & ~3;
+	max_data = asoc->pathmtu -
+		   sctp_sk(asoc->base.sk)->pf->af->net_header_len -
+		   sizeof(struct sctphdr) - sizeof(struct sctp_data_chunk);
+	max_data = WORD_TRUNC(max_data);
 
 	max = asoc->frag_point;
 	/* If the the peer requested that we authenticate DATA chunks
-- 
2.7.4

