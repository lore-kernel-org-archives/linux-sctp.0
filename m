From: Sasha Levin <sashal@kernel.org>
Date: Mon, 28 Jan 2019 15:55:40 +0000
Subject: [PATCH AUTOSEL 4.19 034/258] sctp: Fix SKB list traversal in sctp_intl_store_reasm().
Message-Id: <20190128155924.51521-34-sashal@kernel.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190128155924.51521-1-sashal@kernel.org>
In-Reply-To: <20190128155924.51521-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Sasha Levin <sashal@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 348bbc25c40844c5efa083a3842c7f53d70a815e ]

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
index 500449b72eca..2b499a85db0e 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -140,7 +140,7 @@ static void sctp_intl_store_reasm(struct sctp_ulpq *ulpq,
 				  struct sctp_ulpevent *event)
 {
 	struct sctp_ulpevent *cevent;
-	struct sk_buff *pos;
+	struct sk_buff *pos, *loc;
 
 	pos = skb_peek_tail(&ulpq->reasm);
 	if (!pos) {
@@ -166,23 +166,30 @@ static void sctp_intl_store_reasm(struct sctp_ulpq *ulpq,
 		return;
 	}
 
+	loc = NULL;
 	skb_queue_walk(&ulpq->reasm, pos) {
 		cevent = sctp_skb2event(pos);
 
 		if (event->stream < cevent->stream ||
 		    (event->stream = cevent->stream &&
-		     MID_lt(event->mid, cevent->mid)))
+		     MID_lt(event->mid, cevent->mid))) {
+			loc = pos;
 			break;
-
+		}
 		if (event->stream = cevent->stream &&
 		    event->mid = cevent->mid &&
 		    !(cevent->msg_flags & SCTP_DATA_FIRST_FRAG) &&
 		    (event->msg_flags & SCTP_DATA_FIRST_FRAG ||
-		     event->fsn < cevent->fsn))
+		     event->fsn < cevent->fsn)) {
+			loc = pos;
 			break;
+		}
 	}
 
-	__skb_queue_before(&ulpq->reasm, pos, sctp_event2skb(event));
+	if (!loc)
+		__skb_queue_tail(&ulpq->reasm, sctp_event2skb(event));
+	else
+		__skb_queue_before(&ulpq->reasm, loc, sctp_event2skb(event));
 }
 
 static struct sctp_ulpevent *sctp_intl_retrieve_partial(
-- 
2.19.1
