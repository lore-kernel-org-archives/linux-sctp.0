From: Sasha Levin <sashal@kernel.org>
Date: Mon, 28 Jan 2019 15:39:16 +0000
Subject: [PATCH AUTOSEL 4.20 039/304] sctp: Fix SKB list traversal in sctp_intl_store_ordered().
Message-Id: <20190128154341.47195-39-sashal@kernel.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Sasha Levin <sashal@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit e15e067d0656625c77c52b4e5f0cfbf0c0c3583f ]

Same change as made to sctp_intl_store_reasm().

To be fully correct, an iterator has an undefined value when something
like skb_queue_walk() naturally terminates.

This will actually matter when SKB queues are converted over to
list_head.

Formalize what this code ends up doing with the current
implementation.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/stream_interleave.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 0a78cdf86463..500449b72eca 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -383,7 +383,7 @@ static void sctp_intl_store_ordered(struct sctp_ulpq *ulpq,
 				    struct sctp_ulpevent *event)
 {
 	struct sctp_ulpevent *cevent;
-	struct sk_buff *pos;
+	struct sk_buff *pos, *loc;
 
 	pos = skb_peek_tail(&ulpq->lobby);
 	if (!pos) {
@@ -403,18 +403,25 @@ static void sctp_intl_store_ordered(struct sctp_ulpq *ulpq,
 		return;
 	}
 
+	loc = NULL;
 	skb_queue_walk(&ulpq->lobby, pos) {
 		cevent = (struct sctp_ulpevent *)pos->cb;
 
-		if (cevent->stream > event->stream)
+		if (cevent->stream > event->stream) {
+			loc = pos;
 			break;
-
+		}
 		if (cevent->stream = event->stream &&
-		    MID_lt(event->mid, cevent->mid))
+		    MID_lt(event->mid, cevent->mid)) {
+			loc = pos;
 			break;
+		}
 	}
 
-	__skb_queue_before(&ulpq->lobby, pos, sctp_event2skb(event));
+	if (!loc)
+		__skb_queue_tail(&ulpq->lobby, sctp_event2skb(event));
+	else
+		__skb_queue_before(&ulpq->lobby, loc, sctp_event2skb(event));
 }
 
 static void sctp_intl_retrieve_ordered(struct sctp_ulpq *ulpq,
-- 
2.19.1
