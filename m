From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 25 May 2018 17:41:02 +0000
Subject: [PATCH net] sctp: not allow to set rto_min with a value below 200 msecs
Message-Id: <dc48b7c6a6dd1d8f19215cea6713d5723779d564.1527270062.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, David Ahern <dsa@cumulusnetworks.com>, Eric Dumazet <edumazet@google.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, syzkaller@googlegroups.com

syzbot reported a rcu_sched self-detected stall on CPU which is caused
by too small value set on rto_min with SCTP_RTOINFO sockopt. With this
value, hb_timer will get stuck there, as in its timer handler it starts
this timer again with this value, then goes to the timer handler again.

This problem is there since very beginning, and thanks to Eric for the
reproducer shared from a syzbot mail.

This patch fixes it by not allowing to set rto_min with a value below
200 msecs, which is based on TCP's, by either setsockopt or sysctl.

Reported-by: syzbot+3dcd59a1f907245f891f@syzkaller.appspotmail.com
Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/constants.h |  1 +
 net/sctp/socket.c            | 10 +++++++---
 net/sctp/sysctl.c            |  3 ++-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 20ff237..2ee7a7b 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -277,6 +277,7 @@ enum { SCTP_MAX_GABS = 16 };
 #define SCTP_RTO_INITIAL	(3 * 1000)
 #define SCTP_RTO_MIN		(1 * 1000)
 #define SCTP_RTO_MAX		(60 * 1000)
+#define SCTP_RTO_HARD_MIN	200
 
 #define SCTP_RTO_ALPHA          3   /* 1/8 when converted to right shifts. */
 #define SCTP_RTO_BETA           2   /* 1/4 when converted to right shifts. */
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ae7e7c6..6ef12c7 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3029,7 +3029,8 @@ static int sctp_setsockopt_nodelay(struct sock *sk, char __user *optval,
  * be changed.
  *
  */
-static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigned int optlen)
+static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval,
+				   unsigned int optlen)
 {
 	struct sctp_rtoinfo rtoinfo;
 	struct sctp_association *asoc;
@@ -3056,10 +3057,13 @@ static int sctp_setsockopt_rtoinfo(struct sock *sk, char __user *optval, unsigne
 	else
 		rto_max = asoc ? asoc->rto_max : sp->rtoinfo.srto_max;
 
-	if (rto_min)
+	if (rto_min) {
+		if (rto_min < SCTP_RTO_HARD_MIN)
+			return -EINVAL;
 		rto_min = asoc ? msecs_to_jiffies(rto_min) : rto_min;
-	else
+	} else {
 		rto_min = asoc ? asoc->rto_min : sp->rtoinfo.srto_min;
+	}
 
 	if (rto_min > rto_max)
 		return -EINVAL;
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 33ca5b7..7ec854a 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -52,6 +52,7 @@ static int rto_alpha_min = 0;
 static int rto_beta_min = 0;
 static int rto_alpha_max = 1000;
 static int rto_beta_max = 1000;
+static int rto_hard_min = SCTP_RTO_HARD_MIN;
 
 static unsigned long max_autoclose_min = 0;
 static unsigned long max_autoclose_max @@ -116,7 +117,7 @@ static struct ctl_table sctp_net_table[] = {
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_sctp_do_rto_min,
-		.extra1         = &one,
+		.extra1         = &rto_hard_min,
 		.extra2         = &init_net.sctp.rto_max
 	},
 	{
-- 
2.1.0

