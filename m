From: Mao Wenan <maowenan@huawei.com>
Date: Thu, 12 Sep 2019 03:45:18 +0000
Subject: [PATCH v2 net 2/3] sctp: remove redundant assignment when call sctp_get_port_local
Message-Id: <20190912040219.67517-3-maowenan@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <7a450679-40ca-8a84-4cba-7a16f22ea3c0@huawei.com>
 <20190912040219.67517-1-maowenan@huawei.com>
In-Reply-To: <20190912040219.67517-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Mao Wenan <maowenan@huawei.com>

There are more parentheses in if clause when call sctp_get_port_local
in sctp_do_bind, and redundant assignment to 'ret'. This patch is to
do cleanup.

Signed-off-by: Mao Wenan <maowenan@huawei.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 net/sctp/socket.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 5e1934c48709..2f810078c91d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -399,9 +399,8 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
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
2.20.1
