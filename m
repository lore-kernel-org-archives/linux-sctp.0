From: Wang Weidong <wangweidong1@huawei.com>
Date: Fri, 08 Nov 2013 06:17:50 +0000
Subject: [PATCH net-next v2 3/4] sctp: convert sctp_peer_needs_update to boolean
Message-Id: <1383891471-20892-4-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1383891471-20892-1-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1383891471-20892-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com
Cc: davem@davemloft.net, dingtianhong@huawei.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

sctp_peer_needs_update only return 0 or 1.

Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/sctp/associola.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 98acb47..8dab0bf 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1349,7 +1349,7 @@ void sctp_assoc_sync_pmtu(struct sock *sk, struct sctp_association *asoc)
 }
 
 /* Should we send a SACK to update our peer? */
-static inline int sctp_peer_needs_update(struct sctp_association *asoc)
+static inline bool sctp_peer_needs_update(struct sctp_association *asoc)
 {
 	struct net *net = sock_net(asoc->base.sk);
 	switch (asoc->state) {
@@ -1361,12 +1361,12 @@ static inline int sctp_peer_needs_update(struct sctp_association *asoc)
 		    ((asoc->rwnd - asoc->a_rwnd) >= max_t(__u32,
 			   (asoc->base.sk->sk_rcvbuf >> net->sctp.rwnd_upd_shift),
 			   asoc->pathmtu)))
-			return 1;
+			return true;
 		break;
 	default:
 		break;
 	}
-	return 0;
+	return false;
 }
 
 /* Increase asoc's rwnd by len and send any window update SACK if needed. */
-- 
1.7.12


