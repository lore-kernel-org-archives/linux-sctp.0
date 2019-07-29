From: "Enrico Weigelt, metux IT consult" <info@metux.net>
Date: Mon, 29 Jul 2019 18:55:21 +0000
Subject: [PATCH] net: sctp: drop unneeded likely() call around IS_ERR()
Message-Id: <1564426521-22525-1-git-send-email-info@metux.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1559768607-17439-1-git-send-email-info@metux.net>
In-Reply-To: <1559768607-17439-1-git-send-email-info@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Enrico Weigelt <info@metux.net>

IS_ERR() already calls unlikely(), so this extra unlikely() call
around IS_ERR() is not needed.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 net/sctp/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index aa80cda..9d1f83b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -985,7 +985,7 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 		return -EINVAL;
 
 	kaddrs = memdup_user(addrs, addrs_size);
-	if (unlikely(IS_ERR(kaddrs)))
+	if (IS_ERR(kaddrs))
 		return PTR_ERR(kaddrs);
 
 	/* Walk through the addrs buffer and count the number of addresses. */
@@ -1315,7 +1315,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
 		return -EINVAL;
 
 	kaddrs = memdup_user(addrs, addrs_size);
-	if (unlikely(IS_ERR(kaddrs)))
+	if (IS_ERR(kaddrs))
 		return PTR_ERR(kaddrs);
 
 	/* Allow security module to validate connectx addresses. */
-- 
1.9.1
