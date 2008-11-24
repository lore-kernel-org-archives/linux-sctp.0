From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 24 Nov 2008 04:00:22 +0000
Subject: sctp: Fix a typo in socket.c
Message-Id: <492A26D6.8010602@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Just fix a typo in socket.c.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/socket.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b3d0360..8d0dacc 100644
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
 
@@ -4213,9 +4213,9 @@ static int sctp_getsockopt_delayed_ack(struct sock *sk, int len,
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
1.6.0.2.530.g67faa



