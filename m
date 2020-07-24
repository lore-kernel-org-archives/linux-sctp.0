From: Christoph Hellwig <hch@lst.de>
Date: Fri, 24 Jul 2020 06:48:55 +0000
Subject: [PATCH v2 net-next] sctp: fix slab-out-of-bounds in SCTP_DELAYED_SACK processing
Message-Id: <20200724064855.132552-1-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, syzbot+0e4699d000d8b874d8dc@syzkaller.appspotmail.com

This sockopt accepts two kinds of parameters, using struct
sctp_sack_info and struct sctp_assoc_value. The mentioned commit didn't
notice an implicit cast from the smaller (latter) struct to the bigger
one (former) when copying the data from the user space, which now leads
to an attempt to write beyond the buffer (because it assumes the storing
buffer is bigger than the parameter itself).

Fix it by allocating a sctp_sack_info on stack and filling it out based
on the small struct for the compat case.

Changelog stole from an earlier patch from Marcelo Ricardo Leitner.

Fixes: ebb25defdc17 ("sctp: pass a kernel pointer to sctp_setsockopt_delayed_ack")
Reported-by: syzbot+0e4699d000d8b874d8dc@syzkaller.appspotmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 50 +++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9a767f35971865..2c6f910b3afac0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2749,31 +2749,12 @@ static void sctp_apply_asoc_delayed_ack(struct sctp_sack_info *params,
  *    timer to expire.  The default value for this is 2, setting this
  *    value to 1 will disable the delayed sack algorithm.
  */
-
-static int sctp_setsockopt_delayed_ack(struct sock *sk,
-				       struct sctp_sack_info *params,
-				       unsigned int optlen)
+static int __sctp_setsockopt_delayed_ack(struct sock *sk,
+					 struct sctp_sack_info *params)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_association *asoc;
 
-	if (optlen = sizeof(struct sctp_sack_info)) {
-		if (params->sack_delay = 0 && params->sack_freq = 0)
-			return 0;
-	} else if (optlen = sizeof(struct sctp_assoc_value)) {
-		pr_warn_ratelimited(DEPRECATED
-				    "%s (pid %d) "
-				    "Use of struct sctp_assoc_value in delayed_ack socket option.\n"
-				    "Use struct sctp_sack_info instead\n",
-				    current->comm, task_pid_nr(current));
-
-		if (params->sack_delay = 0)
-			params->sack_freq = 1;
-		else
-			params->sack_freq = 0;
-	} else
-		return -EINVAL;
-
 	/* Validate value parameter. */
 	if (params->sack_delay > 500)
 		return -EINVAL;
@@ -2821,6 +2802,33 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
 	return 0;
 }
 
+static int sctp_setsockopt_delayed_ack(struct sock *sk,
+				       struct sctp_sack_info *params,
+				       unsigned int optlen)
+{
+	if (optlen = sizeof(struct sctp_assoc_value)) {
+		struct sctp_assoc_value *v = (struct sctp_assoc_value *)params;
+		struct sctp_sack_info p;
+
+		pr_warn_ratelimited(DEPRECATED
+				    "%s (pid %d) "
+				    "Use of struct sctp_assoc_value in delayed_ack socket option.\n"
+				    "Use struct sctp_sack_info instead\n",
+				    current->comm, task_pid_nr(current));
+
+		p.sack_assoc_id = v->assoc_id;
+		p.sack_delay = v->assoc_value;
+		p.sack_freq = v->assoc_value ? 0 : 1;
+		return __sctp_setsockopt_delayed_ack(sk, &p);
+	}
+
+	if (optlen != sizeof(struct sctp_sack_info))
+		return -EINVAL;
+	if (params->sack_delay = 0 && params->sack_freq = 0)
+		return 0;
+	return __sctp_setsockopt_delayed_ack(sk, params);
+}
+
 /* 7.1.3 Initialization Parameters (SCTP_INITMSG)
  *
  * Applications can specify protocol parameters for the default association
-- 
2.27.0
