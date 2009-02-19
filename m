From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 19 Feb 2009 09:23:24 +0000
Subject: [PATCH 2/4] sctp: remove dup code in net/sctp/socket.c
Message-Id: <499D250C.1030604@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Remove dup check of "if (optlen < sizeof(int))".

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/socket.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index dea864f..4bc558c 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3069,9 +3069,6 @@ static int sctp_setsockopt_maxburst(struct sock *sk,
 	int val;
 	int assoc_id = 0;
 
-	if (optlen < sizeof(int))
-		return -EINVAL;
-
 	if (optlen = sizeof(int)) {
 		printk(KERN_WARNING
 		   "SCTP: Use of int in max_burst socket option deprecated\n");
@@ -5283,9 +5280,6 @@ static int sctp_getsockopt_maxburst(struct sock *sk, int len,
 	struct sctp_sock *sp;
 	struct sctp_association *asoc;
 
-	if (len < sizeof(int))
-		return -EINVAL;
-
 	if (len = sizeof(int)) {
 		printk(KERN_WARNING
 		   "SCTP: Use of int in max_burst socket option deprecated\n");
-- 
1.5.3.8




