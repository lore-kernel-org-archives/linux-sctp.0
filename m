From: Holger Freyther <zecke@selfish.org>
Date: Wed, 23 Mar 2011 10:56:46 +0000
Subject: [PATCH] sctp: Remove store to ret as it is not used
Message-Id: <1300877806-3949-1-git-send-email-zecke@selfish.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Holger Hans Peter Freyther <zecke@selfish.org>

From: Holger Hans Peter Freyther <zecke@selfish.org>

The store to ret is not needed. In case it is 0 the method
will be exited directly, if not ret will be assigned again
and then returned to the caller.

Signed-off-by: Holger Hans Peter Freyther <zecke@selfish.org>
Acked-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/socket.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b2bed35..5f72996 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -393,9 +393,8 @@ SCTP_STATIC int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
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
1.7.4

