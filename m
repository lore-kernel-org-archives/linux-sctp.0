From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 28 Jan 2019 07:08:24 +0000
Subject: [PATCH net-next 02/24] sctp: use SCTP_FUTURE_ASSOC for SCTP_PEER_ADDR_PARAMS sockopt
Message-Id: <bf66a45aa6763646c07e1b8be102466f07fc1648.1548659198.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1548659198.git.lucien.xin@gmail.com>
 <3ca66b981a0fe9368bd976676fe7450634b091cd.1548659198.git.lucien.xin@gmail.com>
In-Reply-To: <3ca66b981a0fe9368bd976676fe7450634b091cd.1548659198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Check with SCTP_FUTURE_ASSOC instead in
sctp_/setgetsockopt_peer_addr_params, it's compatible with 0.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a52d132..4c43b95 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2750,12 +2750,13 @@ static int sctp_setsockopt_peer_addr_params(struct sock *sk,
 			return -EINVAL;
 	}
 
-	/* Get association, if assoc_id != 0 and the socket is a one
-	 * to many style socket, and an association was not found, then
-	 * the id was invalid.
+	/* Get association, if assoc_id != SCTP_FUTURE_ASSOC and the
+	 * socket is a one to many style socket, and an association
+	 * was not found, then the id was invalid.
 	 */
 	asoc = sctp_id2assoc(sk, params.spp_assoc_id);
-	if (!asoc && params.spp_assoc_id && sctp_style(sk, UDP))
+	if (!asoc && params.spp_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Heartbeat demand can only be sent on a transport or
@@ -5676,12 +5677,13 @@ static int sctp_getsockopt_peer_addr_params(struct sock *sk, int len,
 		}
 	}
 
-	/* Get association, if assoc_id != 0 and the socket is a one
-	 * to many style socket, and an association was not found, then
-	 * the id was invalid.
+	/* Get association, if assoc_id != SCTP_FUTURE_ASSOC and the
+	 * socket is a one to many style socket, and an association
+	 * was not found, then the id was invalid.
 	 */
 	asoc = sctp_id2assoc(sk, params.spp_assoc_id);
-	if (!asoc && params.spp_assoc_id && sctp_style(sk, UDP)) {
+	if (!asoc && params.spp_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP)) {
 		pr_debug("%s: failed no association\n", __func__);
 		return -EINVAL;
 	}
-- 
2.1.0
