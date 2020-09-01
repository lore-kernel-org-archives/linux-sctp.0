From: Petr Malat <oss@malat.biz>
Date: Tue, 01 Sep 2020 09:00:07 +0000
Subject: [PATCH] sctp: Honour SCTP_PARTIAL_DELIVERY_POINT even under memory pressure
Message-Id: <20200901090007.31061-1-oss@malat.biz>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org, Petr Malat <oss@malat.biz>

Command SCTP_CMD_PART_DELIVER issued under memory pressure calls
sctp_ulpq_partial_delivery(), which tries to fetch and partially deliver
the first message it finds without checking if the message is longer than
SCTP_PARTIAL_DELIVERY_POINT. According to the RFC 6458 paragraph 8.1.21.
such a behavior is invalid. Fix it by returning the first message only if
its part currently available is longer than SCTP_PARTIAL_DELIVERY_POINT.

Signed-off-by: Petr Malat <oss@malat.biz>
---
 net/sctp/ulpqueue.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index 1c6c640607c5..cada0b7f1548 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -610,6 +610,7 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_first(struct sctp_ulpq *ulpq)
 	struct sctp_ulpevent *cevent;
 	__u32 ctsn, next_tsn;
 	struct sctp_ulpevent *retval;
+	size_t pd_point, pd_len = 0;
 
 	/* The chunks are held in the reasm queue sorted by TSN.
 	 * Walk through the queue sequentially and look for a sequence of
@@ -633,8 +634,9 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_first(struct sctp_ulpq *ulpq)
 				first_frag = pos;
 				next_tsn = ctsn + 1;
 				last_frag = pos;
+				pd_len = pos->len;
 			} else
-				goto done;
+				goto check;
 			break;
 
 		case SCTP_DATA_MIDDLE_FRAG:
@@ -643,15 +645,19 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_first(struct sctp_ulpq *ulpq)
 			if (ctsn = next_tsn) {
 				next_tsn++;
 				last_frag = pos;
+				pd_len += pos->len;
 			} else
-				goto done;
+				goto check;
 			break;
 
 		case SCTP_DATA_LAST_FRAG:
 			if (!first_frag)
 				return NULL;
-			else
+			if (ctsn = next_tsn) {
+				last_frag = pos;
 				goto done;
+			} else
+				goto check;
 			break;
 
 		default:
@@ -659,6 +665,11 @@ static struct sctp_ulpevent *sctp_ulpq_retrieve_first(struct sctp_ulpq *ulpq)
 		}
 	}
 
+check:
+	pd_point = sctp_sk(ulpq->asoc->base.sk)->pd_point;
+	if (pd_point && pd_point > pd_len)
+		return NULL;
+
 	/* We have the reassembled event. There is no need to look
 	 * further.
 	 */
-- 
2.20.1
