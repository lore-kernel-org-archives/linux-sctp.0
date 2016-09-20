From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 20 Sep 2016 20:24:20 +0000
Subject: [PATCH next 2/2] sctp: make use of WORD_TRUNC macro
Message-Id: <44d3d3e5e0be1f4e557893f1dd8bcc38fae009fa.1474402102.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1474402102.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1474402102.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, David Miller <davem@davemloft.net>, David Laight <David.Laight@ACULAB.COM>

And avoid the usage of '&~3'. This is the last place still not using
the macro.
Also break the line to make it easier to read.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
When I checked it the other day I thought I had this patch applied by
the moment but I hadn't.

 net/sctp/chunk.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index 86be257c9881a9bf404a1be010fdcd1c55c8b89a..b0089989473eee65b257a11f29c353f39fe3c602 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -195,9 +195,10 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 	/* This is the biggest possible DATA chunk that can fit into
 	 * the packet
 	 */
-	max_data = (asoc->pathmtu -
-		sctp_sk(asoc->base.sk)->pf->af->net_header_len -
-		sizeof(struct sctphdr) - sizeof(struct sctp_data_chunk)) & ~3;
+	max_data = asoc->pathmtu -
+		   sctp_sk(asoc->base.sk)->pf->af->net_header_len -
+		   sizeof(struct sctphdr) - sizeof(struct sctp_data_chunk);
+	max_data = SCTP_TRUNC4(max_data);
 
 	max = asoc->frag_point;
 	/* If the the peer requested that we authenticate DATA chunks
-- 
2.7.4

