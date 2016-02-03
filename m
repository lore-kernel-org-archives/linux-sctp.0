From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 03 Feb 2016 15:33:30 +0000
Subject: [PATCH net] sctp: translate network order to host order when users get a hmacid
Message-Id: <f763fd2125356a2484bef0b6d083fdd38b13e8db.1454513610.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, davem@davemloft.net

Commit ed5a377d87dc ("sctp: translate host order to network order when
setting a hmacid") corrected the hmacid byte-order when setting a hmacid.
but the same issue also exists on getting a hmacid.

We fix it by changing hmacids to host order when users get them with
getsockopt.

Fixes: Commit ed5a377d87dc ("sctp: translate host order to network order when setting a hmacid")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 5ca2ebf..e878da0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5538,6 +5538,7 @@ static int sctp_getsockopt_hmac_ident(struct sock *sk, int len,
 	struct sctp_hmac_algo_param *hmacs;
 	__u16 data_len = 0;
 	u32 num_idents;
+	int i;
 
 	if (!ep->auth_enable)
 		return -EACCES;
@@ -5555,8 +5556,12 @@ static int sctp_getsockopt_hmac_ident(struct sock *sk, int len,
 		return -EFAULT;
 	if (put_user(num_idents, &p->shmac_num_idents))
 		return -EFAULT;
-	if (copy_to_user(p->shmac_idents, hmacs->hmac_ids, data_len))
-		return -EFAULT;
+	for (i = 0; i < num_idents; i++) {
+		__u16 hmacid = ntohs(hmacs->hmac_ids[i]);
+
+		if (copy_to_user(&p->shmac_idents[i], &hmacid, sizeof(__u16)))
+			return -EFAULT;
+	}
 	return 0;
 }
 
-- 
2.1.0

