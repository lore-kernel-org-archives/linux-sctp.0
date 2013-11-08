From: Wang Weidong <wangweidong1@huawei.com>
Date: Fri, 08 Nov 2013 06:17:49 +0000
Subject: [PATCH net-next v2 2/4] sctp: remove the else path
Message-Id: <1383891471-20892-3-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383891471-20892-1-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1383891471-20892-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com
Cc: davem@davemloft.net, dingtianhong@huawei.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Make the code more simplification.

Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/sctp/associola.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 667f984..98acb47 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -954,17 +954,13 @@ int sctp_cmp_addr_exact(const union sctp_addr *ss1,
  */
 struct sctp_chunk *sctp_get_ecne_prepend(struct sctp_association *asoc)
 {
-	struct sctp_chunk *chunk;
+	if (!asoc->need_ecne)
+		return NULL;
 
 	/* Send ECNE if needed.
 	 * Not being able to allocate a chunk here is not deadly.
 	 */
-	if (asoc->need_ecne)
-		chunk = sctp_make_ecne(asoc, asoc->last_ecne_tsn);
-	else
-		chunk = NULL;
-
-	return chunk;
+	return sctp_make_ecne(asoc, asoc->last_ecne_tsn);
 }
 
 /*
-- 
1.7.12


