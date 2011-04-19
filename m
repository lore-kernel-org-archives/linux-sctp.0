From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 19 Apr 2011 05:15:22 +0000
Subject: [PATCH net-next-2.6 8/8] sctp: Release all routes when processing
Message-Id: <4DAD1A6A.1090805@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DAD18AB.3040401@cn.fujitsu.com>
In-Reply-To: <4DAD18AB.3040401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, lksctp <linux-sctp@vger.kernel.org>

From: Vlad Yasevich <vladislav.yasevich@hp.com>

When processing an ACK for ADD_IP parameter, we only release
the routes on non-active transports.  This can cause a wrong
source address to be used.  We can release the routes and
cause new route lookups and source address selection so that
new addresses can be used as source.  Additionally, we don't need
to lookup routes for all transports at the same time.  We can let
the transmit code path update the cached route when the transport
actually sends something.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_make_chunk.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 844adfd..f87ccb1 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3193,11 +3193,8 @@ static void sctp_asconf_param_success(struct sctp_association *asoc,
 		local_bh_enable();
 		list_for_each_entry(transport, &asoc->peer.transport_addr_list,
 				transports) {
-			if (transport->state = SCTP_ACTIVE)
-				continue;
 			dst_release(transport->dst);
-			sctp_transport_route(transport, NULL,
-					     sctp_sk(asoc->base.sk));
+			transport->dst = NULL;
 		}
 		break;
 	case SCTP_PARAM_DEL_IP:
@@ -3207,8 +3204,7 @@ static void sctp_asconf_param_success(struct sctp_association *asoc,
 		list_for_each_entry(transport, &asoc->peer.transport_addr_list,
 				transports) {
 			dst_release(transport->dst);
-			sctp_transport_route(transport, NULL,
-					     sctp_sk(asoc->base.sk));
+			transport->dst = NULL;
 		}
 		break;
 	default:
-- 
1.6.5.2


