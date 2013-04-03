From: Wei Yongjun <weiyj.lk@gmail.com>
Date: Wed, 03 Apr 2013 13:02:28 +0000
Subject: [PATCH -next] sctp: fix error return code in __sctp_connect()
Message-Id: <CAPgLHd-X5Qw64BnaSMr2ny6==jXGpRAYC7_1MGhP2v_GcVeApQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, sri@us.ibm.com, nhorman@tuxdriver.com, davem@davemloft.net
Cc: yongjun_wei@trendmicro.com.cn, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 net/sctp/socket.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index dd21ae3..f631c5f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1119,9 +1119,10 @@ static int __sctp_connect(struct sock* sk,
 		/* Make sure the destination port is correctly set
 		 * in all addresses.
 		 */
-		if (asoc && asoc->peer.port && asoc->peer.port != port)
+		if (asoc && asoc->peer.port && asoc->peer.port != port) {
+			err = -EINVAL;
 			goto out_free;
-
+		}
 
 		/* Check if there already is a matching association on the
 		 * endpoint (other than the one created here).

