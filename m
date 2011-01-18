From: Holger Freyther <zecke@selfish.org>
Date: Tue, 18 Jan 2011 11:32:11 +0000
Subject: [PATCH] sctp: Remove store to ret as it is not used
Message-Id: <4D357A3B.3000606@selfish.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

The store to ret is not needed. In case it is 0 the method
will be exited directly, if not ret will be assigned again
and then returned to the caller.

Signed-off-by: Holger Hans Peter Freyther <zecke@selfish.org>
Acked-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/socket.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index e47e39e..86ce53d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -393,9 +393,8 @@ SCTP_STATIC int sctp_do_bind(struct sock *sk, union
sctp_addr *addr, int len)
 	 * detection.
 	 */
 	addr->v4.sin_port = htons(snum);
-	if ((ret = sctp_get_port_local(sk, addr))) {
+	if (sctp_get_port_local(sk, addr))
 		return -EADDRINUSE;
-	}
  	/* Refresh ephemeral port.  */
 	if (!bp->port)
-- 
1.7.3.4

