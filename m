From: Wang Weidong <wangweidong1@huawei.com>
Date: Fri, 08 Nov 2013 02:55:08 +0000
Subject: [PATCH net-next 3/5] sctp: if we done update ssnmap, free the new ssnmap
Message-Id: <1383879310-22792-4-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383879310-22792-1-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1383879310-22792-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com
Cc: dingtianhong@huawei.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

I found that free the old parameters after update the peer parameters.
So we should free the new ssnmap which not updated.

Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/sctp/associola.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 2d53d4c..bca1ad1 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1223,6 +1223,10 @@ void sctp_assoc_update(struct sctp_association *asoc,
 		}
 	}
 
+	/* if we don't update the ssnmap, we should free it. */
+	if (new->ssnmap)
+		sctp_ssnmap_free(new->ssnmap);
+
 	/* SCTP-AUTH: Save the peer parameters from the new assocaitions
 	 * and also move the association shared keys over
 	 */
-- 
1.7.12


