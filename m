From: Wally Zhao <wallyzhao@gmail.com>
Date: Wed, 30 Oct 2019 08:08:26 +0000
Subject: [PATCH] sctp: set ooo_okay properly for Transmit Packet Steering
Message-Id: <1572451637-14085-1-git-send-email-wallyzhao@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: wally.zhao@nokia-sbell.com, Wally Zhao <wallyzhao@gmail.com>

Unlike tcp_transmit_skb,
sctp_packet_transmit does not set ooo_okay explicitly,
causing unwanted Tx queue switching when multiqueue is in use;
Tx queue switching may cause out-of-order packets.
Change sctp_packet_transmit to allow Tx queue switching only for
the first in flight packet, to avoid unwanted Tx queue switching.

Signed-off-by: Wally Zhao <wallyzhao@gmail.com>
---
 net/sctp/output.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index dbda7e7..5ff75cc 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -626,6 +626,10 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 	/* neighbour should be confirmed on successful transmission or
 	 * positive error
 	 */
+
+	/* allow switch tx queue only for the first in flight pkt */
+	head->ooo_okay = asoc->outqueue.outstanding_bytes = 0;
+
 	if (tp->af_specific->sctp_xmit(head, tp) >= 0 &&
 	    tp->dst_pending_confirm)
 		tp->dst_pending_confirm = 0;
-- 
1.8.3.1
