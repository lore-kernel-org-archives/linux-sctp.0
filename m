From: Chang Xiangzhong <changxiangzhong@gmail.com>
Date: Thu, 21 Nov 2013 21:56:28 +0000
Subject: [PATCH] net: sctp: find the correct highest_new_tsn in sack
Message-Id: <1385070988-29554-1-git-send-email-changxiangzhong@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Chang Xiangzhong <changxiangzhong@gmail.com>

Function sctp_check_transmitted(transport t, ...) would iterate all of
transport->transmitted queue and looking for the highest __newly__ acked tsn.
The original algorithm would depend on the order of the assoc->transport_list
(in function sctp_outq_sack line 1215 - 1226). The result might not be the
expected due to the order of the tranport_list.

Solution: checking if the exising is smaller than the new one before assigning

Signed-off-by: Chang Xiangzhong <changxiangzhong@gmail.com>
---
 net/sctp/outqueue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index ef9e2bb..1b494fa 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1397,7 +1397,8 @@ static void sctp_check_transmitted(struct sctp_outq *q,
 			 */
 			if (!tchunk->tsn_gap_acked) {
 				tchunk->tsn_gap_acked = 1;
-				*highest_new_tsn_in_sack = tsn;
+				if (TSN_lt(*highest_new_tsn_in_sack, tsn))
+					*highest_new_tsn_in_sack = tsn;
 				bytes_acked += sctp_data_size(tchunk);
 				if (!tchunk->transport)
 					migrate_bytes += sctp_data_size(tchunk);
-- 
1.8.4.3

