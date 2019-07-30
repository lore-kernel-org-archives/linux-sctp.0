From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 30 Jul 2019 12:38:20 +0000
Subject: [PATCHv2 net-next 2/5] sctp: check addr_size with sa_family_t size in __sctp_setsockopt_connectx
Message-Id: <2fe592e724eee4e9b00097485a5bccf317907874.1564490276.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1564490276.git.lucien.xin@gmail.com>
 <bb6e9856c2db0f24b91fb326fbe3c9c013f2459b.1564490276.git.lucien.xin@gmail.com>
In-Reply-To: <bb6e9856c2db0f24b91fb326fbe3c9c013f2459b.1564490276.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Now __sctp_connect() is called by __sctp_setsockopt_connectx() and
sctp_inet_connect(), the latter has done addr_size check with size
of sa_family_t.

In the next patch to clean up __sctp_connect(), we will remove
addr_size check with size of sa_family_t from __sctp_connect()
for the 1st address.

So before doing that, __sctp_setsockopt_connectx() should do
this check first, as sctp_inet_connect() does.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index aa80cda..e9c5b39 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1311,7 +1311,8 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
 	pr_debug("%s: sk:%p addrs:%p addrs_size:%d\n",
 		 __func__, sk, addrs, addrs_size);
 
-	if (unlikely(addrs_size <= 0))
+	/* make sure the 1st addr's sa_family is accessible later */
+	if (unlikely(addrs_size < sizeof(sa_family_t)))
 		return -EINVAL;
 
 	kaddrs = memdup_user(addrs, addrs_size);
-- 
2.1.0
