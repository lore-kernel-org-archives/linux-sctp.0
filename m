From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 03 Sep 2018 07:47:10 +0000
Subject: [PATCH net 1/2] sctp: fix invalid reference to the index variable of the iterator
Message-Id: <9bd4358faebc29f93b2889d2356278e623420e40.1535960717.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1535960717.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1535960717.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Now in sctp_apply_peer_addr_params(), if SPP_IPV6_FLOWLABEL flag is set
and trans is NULL, it would use trans as the index variable to traverse
transport_addr_list, then trans is set as the last transport of it.

Later, if SPP_DSCP flag is set, it would enter into the wrong branch as
trans is actually an invalid reference.

So fix it by using a new index variable to traverse transport_addr_list
for both SPP_DSCP and SPP_IPV6_FLOWLABEL flags process.

Fixes: 0b0dce7a36fb ("sctp: add spp_ipv6_flowlabel and spp_dscp for sctp_paddrparams")
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index aa76586..a0ccfa4 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2663,14 +2663,15 @@ static int sctp_apply_peer_addr_params(struct sctp_paddrparams *params,
 					   SCTP_FLOWLABEL_VAL_MASK;
 			trans->flowlabel |= SCTP_FLOWLABEL_SET_MASK;
 		} else if (asoc) {
-			list_for_each_entry(trans,
-					    &asoc->peer.transport_addr_list,
+			struct sctp_transport *t;
+
+			list_for_each_entry(t, &asoc->peer.transport_addr_list,
 					    transports) {
-				if (trans->ipaddr.sa.sa_family != AF_INET6)
+				if (t->ipaddr.sa.sa_family != AF_INET6)
 					continue;
-				trans->flowlabel = params->spp_ipv6_flowlabel &
-						   SCTP_FLOWLABEL_VAL_MASK;
-				trans->flowlabel |= SCTP_FLOWLABEL_SET_MASK;
+				t->flowlabel = params->spp_ipv6_flowlabel &
+					       SCTP_FLOWLABEL_VAL_MASK;
+				t->flowlabel |= SCTP_FLOWLABEL_SET_MASK;
 			}
 			asoc->flowlabel = params->spp_ipv6_flowlabel &
 					  SCTP_FLOWLABEL_VAL_MASK;
@@ -2687,12 +2688,13 @@ static int sctp_apply_peer_addr_params(struct sctp_paddrparams *params,
 			trans->dscp = params->spp_dscp & SCTP_DSCP_VAL_MASK;
 			trans->dscp |= SCTP_DSCP_SET_MASK;
 		} else if (asoc) {
-			list_for_each_entry(trans,
-					    &asoc->peer.transport_addr_list,
+			struct sctp_transport *t;
+
+			list_for_each_entry(t, &asoc->peer.transport_addr_list,
 					    transports) {
-				trans->dscp = params->spp_dscp &
-					      SCTP_DSCP_VAL_MASK;
-				trans->dscp |= SCTP_DSCP_SET_MASK;
+				t->dscp = params->spp_dscp &
+					  SCTP_DSCP_VAL_MASK;
+				t->dscp |= SCTP_DSCP_SET_MASK;
 			}
 			asoc->dscp = params->spp_dscp & SCTP_DSCP_VAL_MASK;
 			asoc->dscp |= SCTP_DSCP_SET_MASK;
-- 
2.1.0
