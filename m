From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 16 Aug 2012 13:16:19 +0000
Subject: [patch] sctp: fix bogus if statement in sctp_auth_recv_cid()
Message-Id: <20120816131618.GA23279@elgon.mountain>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

There is an extra semi-colon here, so we always return 0 instead of
calling __sctp_auth_cid().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Only needed for linux-next.

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index aaa6c12..159b9bc 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -695,7 +695,7 @@ int sctp_auth_recv_cid(sctp_cid_t chunk, const struct sctp_association *asoc)
 		return 0;
 
 	net = sock_net(asoc->base.sk);
-	if (!net->sctp.auth_enable);
+	if (!net->sctp.auth_enable)
 		return 0;
 
 	return __sctp_auth_cid(chunk,
