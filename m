From: "Lee A. Roberts" <lee.roberts@hp.com>
Date: Thu, 28 Feb 2013 14:37:28 +0000
Subject: [PATCH v3 2/4] sctp: fix association hangs due to reneging packets below the cumulative TSN ACK poin
Message-Id: <1362062250-26749-3-git-send-email-lee.roberts@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1361991273-30578-1-git-send-email-lee.roberts@hp.com>
In-Reply-To: <1361991273-30578-1-git-send-email-lee.roberts@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, lee.roberts@hp.com

From: "Lee A. Roberts" <lee.roberts@hp.com>

In sctp_ulpq_renege_list(), do not renege packets below the
cumulative TSN ACK point.

Signed-off-by: Lee A. Roberts <lee.roberts@hp.com>
---
 net/sctp/ulpqueue.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index ada1746..63afddc 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -969,11 +969,16 @@ static __u16 sctp_ulpq_renege_list(struct sctp_ulpq *ulpq,
 
 	tsnmap = &ulpq->asoc->peer.tsn_map;
 
-	while ((skb = __skb_dequeue_tail(list)) != NULL) {
-		freed += skb_headlen(skb);
+	while ((skb = skb_peek_tail(list)) != NULL) {
 		event = sctp_skb2event(skb);
 		tsn = event->tsn;
 
+		/* Don't renege below the Cumulative TSN ACK Point. */
+		if (TSN_lte(tsn, sctp_tsnmap_get_ctsn(tsnmap)))
+			break;
+
+		__skb_unlink(skb, list);
+		freed += skb_headlen(skb);
 		sctp_ulpevent_free(event);
 		sctp_tsnmap_renege(tsnmap, tsn);
 		if (freed >= needed)
-- 
1.7.9.5

