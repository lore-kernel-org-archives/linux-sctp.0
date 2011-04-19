From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 19 Apr 2011 05:14:47 +0000
Subject: [PATCH net-next-2.6 7/8] sctp: Allow bindx_del to accept 0 port
Message-Id: <4DAD1A47.5080007@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DAD18AB.3040401@cn.fujitsu.com>
In-Reply-To: <4DAD18AB.3040401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, lksctp <linux-sctp@vger.kernel.org>

From: Vlad Yasevich <vladislav.yasevich@hp.com>

We allow 0 port when adding new addresses.  It only
makes sence to allow 0 port when removing addresses.
When removing the currently bound port will be used
when the port in the address is set to 0.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/socket.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 5c9980a..431b890 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -658,11 +658,15 @@ static int sctp_bindx_rem(struct sock *sk, struct sockaddr *addrs, int addrcnt)
 			goto err_bindx_rem;
 		}
 
-		if (sa_addr->v4.sin_port != htons(bp->port)) {
+		if (sa_addr->v4.sin_port &&
+		    sa_addr->v4.sin_port != htons(bp->port)) {
 			retval = -EINVAL;
 			goto err_bindx_rem;
 		}
 
+		if (!sa_addr->v4.sin_port)
+			sa_addr->v4.sin_port = htons(bp->port);
+
 		/* FIXME - There is probably a need to check if sk->sk_saddr and
 		 * sk->sk_rcv_addr are currently set to one of the addresses to
 		 * be removed. This is something which needs to be looked into
-- 
1.6.5.2


