From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 22 Jul 2019 17:37:57 +0000
Subject: [PATCH net-next 1/4] sctp: check addr_size with sa_family_t size in __sctp_setsockopt_connectx
Message-Id: <c875aa0a5b2965636dc3da83398856627310b280.1563817029.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1563817029.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1563817029.git.lucien.xin@gmail.com>
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
 net/sctp/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index aa80cda..5f92e4a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1311,7 +1311,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
 	pr_debug("%s: sk:%p addrs:%p addrs_size:%d\n",
 		 __func__, sk, addrs, addrs_size);
 
-	if (unlikely(addrs_size <= 0))
+	if (unlikely(addrs_size < sizeof(sa_family_t)))
 		return -EINVAL;
 
 	kaddrs = memdup_user(addrs, addrs_size);
-- 
2.1.0
