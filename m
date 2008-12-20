From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Sat, 20 Dec 2008 01:47:49 +0000
Subject: [PATCH net-next 2/5] sctp: Fix a typo in socket.c
Message-Id: <1229737672-28328-4-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1229737672-28328-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1229737672-28328-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, Wei Yongjun <yjwei@cn.fujitsu.com>, Vlad Yasevich <vladislav.yasevich@hp.com>

From: Wei Yongjun <yjwei@cn.fujitsu.com>

Just fix a typo in socket.c.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/socket.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 0738843..e432927 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2404,9 +2404,9 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
 		if (params.sack_delay = 0 && params.sack_freq = 0)
 			return 0;
 	} else if (optlen = sizeof(struct sctp_assoc_value)) {
-		printk(KERN_WARNING "SCTP: Use of struct sctp_sack_info "
+		printk(KERN_WARNING "SCTP: Use of struct sctp_assoc_value "
 		       "in delayed_ack socket option deprecated\n");
-		printk(KERN_WARNING "SCTP: struct sctp_sack_info instead\n");
+		printk(KERN_WARNING "SCTP: Use struct sctp_sack_info instead\n");
 		if (copy_from_user(&params, optval, optlen))
 			return -EFAULT;
 
@@ -4221,9 +4221,9 @@ static int sctp_getsockopt_delayed_ack(struct sock *sk, int len,
 		if (copy_from_user(&params, optval, len))
 			return -EFAULT;
 	} else if (len = sizeof(struct sctp_assoc_value)) {
-		printk(KERN_WARNING "SCTP: Use of struct sctp_sack_info "
+		printk(KERN_WARNING "SCTP: Use of struct sctp_assoc_value "
 		       "in delayed_ack socket option deprecated\n");
-		printk(KERN_WARNING "SCTP: struct sctp_sack_info instead\n");
+		printk(KERN_WARNING "SCTP: Use struct sctp_sack_info instead\n");
 		if (copy_from_user(&params, optval, len))
 			return -EFAULT;
 	} else
-- 
1.5.3.5

