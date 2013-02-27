From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 27 Feb 2013 20:41:44 +0000
Subject: [patch] sctp: check len in sctp_getsockopt_assoc_stats()
Message-Id: <20130227204144.GA11300@longonot.mountain>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Michele Baldessari <michele@acksyn.org>
Cc: Sridhar Samudrala <sri@us.ibm.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

This check is missing an upper bound.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This should go in 3.8 -stable as well.

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c99458d..fbd8386 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5652,6 +5652,8 @@ static int sctp_getsockopt_assoc_stats(struct sock *sk, int len,
 	/* User must provide at least the assoc id */
 	if (len < sizeof(sctp_assoc_t))
 		return -EINVAL;
+	if (len > sizeof(struct sctp_assoc_stats))
+		len = sizeof(struct sctp_assoc_stats);
 
 	if (copy_from_user(&sas, optval, len))
 		return -EFAULT;
