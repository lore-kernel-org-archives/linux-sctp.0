From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 03 Sep 2018 07:47:11 +0000
Subject: [PATCH net 2/2] sctp: not traverse asoc trans list if non-ipv6 trans exists for ipv6_flowlabel
Message-Id: <e494ce31d5c7d5b748a0887de6bda4b73b78484a.1535960717.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1535960717.git.lucien.xin@gmail.com>
 <9bd4358faebc29f93b2889d2356278e623420e40.1535960717.git.lucien.xin@gmail.com>
In-Reply-To: <9bd4358faebc29f93b2889d2356278e623420e40.1535960717.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

When users set params.spp_address and get a trans, ipv6_flowlabel flag
should be applied into this trans. But even if this one is not an ipv6
trans, it should not go to apply it into all other transes of the asoc
but simply ignore it.

Fixes: 0b0dce7a36fb ("sctp: add spp_ipv6_flowlabel and spp_dscp for sctp_paddrparams")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a0ccfa4..f73e9d3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2658,10 +2658,12 @@ static int sctp_apply_peer_addr_params(struct sctp_paddrparams *params,
 	}
 
 	if (params->spp_flags & SPP_IPV6_FLOWLABEL) {
-		if (trans && trans->ipaddr.sa.sa_family = AF_INET6) {
-			trans->flowlabel = params->spp_ipv6_flowlabel &
-					   SCTP_FLOWLABEL_VAL_MASK;
-			trans->flowlabel |= SCTP_FLOWLABEL_SET_MASK;
+		if (trans) {
+			if (trans->ipaddr.sa.sa_family = AF_INET6) {
+				trans->flowlabel = params->spp_ipv6_flowlabel &
+						   SCTP_FLOWLABEL_VAL_MASK;
+				trans->flowlabel |= SCTP_FLOWLABEL_SET_MASK;
+			}
 		} else if (asoc) {
 			struct sctp_transport *t;
 
-- 
2.1.0
