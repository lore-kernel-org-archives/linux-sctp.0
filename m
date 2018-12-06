From: Jakub Audykowicz <jakub.audykowicz@gmail.com>
Date: Thu, 06 Dec 2018 07:58:37 +0000
Subject: [PATCH net] sctp: fix pr_warn max_data argument type mismatch
Message-Id: <20181206075837.13336-1-jakub.audykowicz@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net
Cc: netdev@vger.kernel.org, Jakub Audykowicz <jakub.audykowicz@gmail.com>

My previous patch introduced a compilation warning regarding a type
mismatch (int vs size_t). This is a one-letter fix for good housekeeping.

Signed-off-by: Jakub Audykowicz <jakub.audykowicz@gmail.com>
---
 net/sctp/chunk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index d5b91bc8a377..ee5638358ad5 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -194,7 +194,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 	if (unlikely(!max_data)) {
 		max_data = sctp_min_frag_point(sctp_sk(asoc->base.sk),
 					       sctp_datachk_len(&asoc->stream));
-		pr_warn_ratelimited("%s: asoc:%p frag_point is zero, forcing max_data to default minimum (%d)",
+		pr_warn_ratelimited("%s: asoc:%p frag_point is zero, forcing max_data to default minimum (%ld)",
 				    __func__, asoc, max_data);
 	}
 
-- 
2.17.1
