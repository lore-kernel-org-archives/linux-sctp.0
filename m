From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 19 Aug 2019 14:02:44 +0000
Subject: [PATCH net-next 2/8] sctp: not set peer.asconf_capable in sctp_association_init
Message-Id: <04b2de14df6de243e9faacc3a3de091adff45d52.1566223325.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1566223325.git.lucien.xin@gmail.com>
 <4c4682aab70fc11be7a505b11939dd998b9b21f5.1566223325.git.lucien.xin@gmail.com>
In-Reply-To: <4c4682aab70fc11be7a505b11939dd998b9b21f5.1566223325.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

asoc->peer.asconf_capable is to be set during handshake, and its
value should be initialized to 0. net->sctp.addip_noauth will be
checked in sctp_process_init when processing INIT_ACK on client
and COOKIE_ECHO on server.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/associola.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 5010cce..d2ffc9a 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -54,7 +54,6 @@ static struct sctp_association *sctp_association_init(
 					const struct sock *sk,
 					enum sctp_scope scope, gfp_t gfp)
 {
-	struct net *net = sock_net(sk);
 	struct sctp_sock *sp;
 	struct sctp_paramhdr *p;
 	int i;
@@ -214,14 +213,6 @@ static struct sctp_association *sctp_association_init(
 	asoc->peer.sack_needed = 1;
 	asoc->peer.sack_generation = 1;
 
-	/* Assume that the peer will tell us if he recognizes ASCONF
-	 * as part of INIT exchange.
-	 * The sctp_addip_noauth option is there for backward compatibility
-	 * and will revert old behavior.
-	 */
-	if (net->sctp.addip_noauth)
-		asoc->peer.asconf_capable = 1;
-
 	/* Create an input queue.  */
 	sctp_inq_init(&asoc->base.inqueue);
 	sctp_inq_set_th_handler(&asoc->base.inqueue, sctp_assoc_bh_rcv);
-- 
2.1.0
