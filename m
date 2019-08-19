From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 19 Aug 2019 14:02:45 +0000
Subject: [PATCH net-next 3/8] sctp: check asoc peer.asconf_capable before processing asconf
Message-Id: <b868cd2896190a99a8553d0cfd372e72f3dbb1b7.1566223325.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1566223325.git.lucien.xin@gmail.com>
 <4c4682aab70fc11be7a505b11939dd998b9b21f5.1566223325.git.lucien.xin@gmail.com>
 <04b2de14df6de243e9faacc3a3de091adff45d52.1566223325.git.lucien.xin@gmail.com>
In-Reply-To: <04b2de14df6de243e9faacc3a3de091adff45d52.1566223325.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

asconf chunks should be dropped when the asoc doesn't support
asconf feature.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 2c244b2..0c21c52 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3721,7 +3721,8 @@ enum sctp_disposition sctp_sf_do_asconf(struct net *net,
 	 * is received unauthenticated it MUST be silently discarded as
 	 * described in [I-D.ietf-tsvwg-sctp-auth].
 	 */
-	if (!net->sctp.addip_noauth && !chunk->auth)
+	if (!asoc->peer.asconf_capable ||
+	    (!net->sctp.addip_noauth && !chunk->auth))
 		return sctp_sf_discard_chunk(net, ep, asoc, type, arg,
 					     commands);
 
@@ -3863,7 +3864,8 @@ enum sctp_disposition sctp_sf_do_asconf_ack(struct net *net,
 	 * is received unauthenticated it MUST be silently discarded as
 	 * described in [I-D.ietf-tsvwg-sctp-auth].
 	 */
-	if (!net->sctp.addip_noauth && !asconf_ack->auth)
+	if (!asoc->peer.asconf_capable ||
+	    (!net->sctp.addip_noauth && !asconf_ack->auth))
 		return sctp_sf_discard_chunk(net, ep, asoc, type, arg,
 					     commands);
 
-- 
2.1.0
