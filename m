From: Wang Weidong <wangweidong1@huawei.com>
Date: Fri, 06 Dec 2013 01:36:30 +0000
Subject: [PATCH v3 net-next 4/4] sctp: fix some comments in associola.c
Message-Id: <1386293790-19956-5-git-send-email-wangweidong1@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1386293790-19956-1-git-send-email-wangweidong1@huawei.com>
In-Reply-To: <1386293790-19956-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com, vyasevich@gmail.com, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

fix some typos

Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/sctp/associola.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index bf61fe7..812b2ce 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -128,7 +128,7 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
 	 */
 	asoc->param_flags = sp->param_flags;
 
-	/* Initialize the maximum mumber of new data packets that can be sent
+	/* Initialize the maximum number of new data packets that can be sent
 	 * in a burst.
 	 */
 	asoc->max_burst = sp->max_burst;
@@ -231,7 +231,7 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
 
 	/* Assume that the peer will tell us if he recognizes ASCONF
 	 * as part of INIT exchange.
-	 * The sctp_addip_noauth option is there for backward compatibilty
+	 * The sctp_addip_noauth option is there for backward compatibility
 	 * and will revert old behavior.
 	 */
 	if (net->sctp.addip_noauth)
@@ -1223,7 +1223,7 @@ void sctp_assoc_update(struct sctp_association *asoc,
 		}
 	}
 
-	/* SCTP-AUTH: Save the peer parameters from the new assocaitions
+	/* SCTP-AUTH: Save the peer parameters from the new associations
 	 * and also move the association shared keys over
 	 */
 	kfree(asoc->peer.peer_random);
@@ -1448,7 +1448,7 @@ void sctp_assoc_rwnd_decrease(struct sctp_association *asoc, unsigned int len)
 
 	/* If we've reached or overflowed our receive buffer, announce
 	 * a 0 rwnd if rwnd would still be positive.  Store the
-	 * the pottential pressure overflow so that the window can be restored
+	 * the potential pressure overflow so that the window can be restored
 	 * back to original value.
 	 */
 	if (rx_count >= asoc->base.sk->sk_rcvbuf)
-- 
1.7.12


