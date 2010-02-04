From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 04 Feb 2010 09:09:39 +0000
Subject: [PATCH] sctp: do not send packet to response OOTB packet if no route
Message-Id: <4B6A8ED3.3050207@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

When we send a response packet to the OOTB packet, first we try to
get the route with both the OOTB packet's src and dest address, this
may return no route in some case, such as we had set the outbound
sctp packet should be discarded by IPsec. Then when we really to
transmit the response packet, we will only use the OOTB packet's
src address to lookup a route, this will alaways fail or get an
alert address which is not the OOTB packet's dest address. So we
should not try to send the response packet if there is no route at
the first setp.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_statefuns.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 47bc20d..2847861 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -5835,6 +5835,12 @@ static struct sctp_packet *sctp_ootb_pkt_new(const struct sctp_association *asoc
 	sctp_transport_route(transport, (union sctp_addr *)&chunk->dest,
 			     sctp_sk(sctp_get_ctl_sock()));
 
+	/* No router for this OOTB packet */
+	if (!transport->dst) {
+		kfree(transport);
+		goto nomem;
+	}
+
 	packet = sctp_packet_init(&transport->packet, transport, sport, dport);
 	packet = sctp_packet_config(packet, vtag, 0);
 
-- 
1.6.5.2


