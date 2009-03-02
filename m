From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 02 Mar 2009 19:46:12 +0000
Subject: [PATCH net-next 3/5] sctp: fix the length check in sctp_getsockopt_maxburst()
Message-Id: <1236023174-18314-4-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <>
 <1236023174-18314-1-git-send-email-vladislav.yasevich@hp.com>
 <1236023174-18314-2-git-send-email-vladislav.yasevich@hp.com>
 <1236023174-18314-3-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1236023174-18314-3-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, Wei Yongjun <yjwei@cn.fujitsu.com>, Vlad Yasevich <vladislav.yasevich@hp.com>

From: Wei Yongjun <yjwei@cn.fujitsu.com>

The code in sctp_getsockopt_maxburst() doesn't allow len to be larger
then struct sctp_assoc_value, which is a common case where app writers
just pass down the sizeof(buf) or something similar.

This patch fix the problem.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/socket.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4bc558c..bbd3cd2 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5286,7 +5286,8 @@ static int sctp_getsockopt_maxburst(struct sock *sk, int len,
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
1.5.4.3

