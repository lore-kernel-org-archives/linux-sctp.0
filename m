From: Andrei Pelinescu-Onciul <andrei@iptel.org>
Date: Thu, 12 Nov 2009 15:52:16 +0000
Subject: [PATCH 3/3] sctp: limit maximum autoclose setsockopt value
Message-Id: <20091112155216.GP10897@shell.iptel.org>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

To avoid overflowing the maximum timer interval when transforming
the  autoclose interval from seconds to jiffies, limit the maximum
autoclose value to MAX_SCHEDULE_TIMEOUT/HZ.

Signed-off-by: Andrei Pelinescu-Onciul <andrei@iptel.org>
---
 net/sctp/socket.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 971890d..2f55723 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2072,6 +2072,9 @@ static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
 		return -EINVAL;
 	if (copy_from_user(&sp->autoclose, optval, optlen))
 		return -EFAULT;
+	/* make sure it won't exceed MAX_SCHEDULE_TIMEOUT */
+	if (sp->autoclose > (MAX_SCHEDULE_TIMEOUT / HZ) )
+		sp->autoclose = MAX_SCHEDULE_TIMEOUT / HZ ;
 
 	return 0;
 }
-- 
1.6.5.2

