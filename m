From: Wang Weidong <wangweidong1@huawei.com>
Date: Fri, 25 Oct 2013 01:50:05 +0000
Subject: [PATCH 4/4] sctp: fix comment in chunk.c
Message-Id: <1382665805-13952-5-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1382665805-13952-1-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1382665805-13952-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net, nhorman@tuxdriver.com, vyasevich@gmail.com
Cc: dingtianhong@huawei.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

fix a spelling

Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/sctp/chunk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index 7bd5ed4..f2044fc 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -201,7 +201,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 
 	max = asoc->frag_point;
 	/* If the the peer requested that we authenticate DATA chunks
-	 * we need to accound for bundling of the AUTH chunks along with
+	 * we need to account for bundling of the AUTH chunks along with
 	 * DATA.
 	 */
 	if (sctp_auth_send_cid(SCTP_CID_DATA, asoc)) {
-- 
1.7.12


