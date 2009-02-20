From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 20 Feb 2009 01:51:40 +0000
Subject: [PATCH] sctp: fix the length check in sctp_getsockopt_maxburst()
Message-Id: <499E0CAC.8050402@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

The code in sctp_getsockopt_maxburst() doesn't allow len to be larger
then struct sctp_assoc_value, which is a common case where app writers
just pass down the sizeof(buf) or something similar.

This patch fix the problem.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/socket.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 5ab68f9..fe0b40c 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5287,7 +5287,8 @@ static int sctp_getsockopt_maxburst(struct sock *sk, int len,
 		printk(KERN_WARNING
 		   "SCTP: Use struct sctp_assoc_value instead\n");
 		params.assoc_id = 0;
-	} else if (len = sizeof (struct sctp_assoc_value)) {
+	} else if (len >= sizeof(struct sctp_assoc_value)) {
+		len = sizeof(struct sctp_assoc_value);
 		if (copy_from_user(&params, optval, len))
 			return -EFAULT;
 	} else
-- 
1.5.3.8




