From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 29 Oct 2018 15:13:11 +0000
Subject: [PATCH net] sctp: check policy more carefully when getting pr status
Message-Id: <cadb9859cc2015b176433d4ac7bb1bc228f97574.1540825991.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

When getting pr_assocstatus and pr_streamstatus by sctp_getsockopt,
it doesn't correctly process the case when policy is set with
SCTP_PR_SCTP_ALL | SCTP_PR_SCTP_MASK. It even causes a
slab-out-of-bounds in sctp_getsockopt_pr_streamstatus().

This patch fixes it by return -EINVAL for this case.

Fixes: 0ac1077e3a54 ("sctp: get pr_assoc and pr_stream all status with SCTP_PR_SCTP_ALL")
Reported-by: syzbot+5da0d0a72a9e7d791748@syzkaller.appspotmail.com
Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index fc0386e..739f3e5 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7083,14 +7083,15 @@ static int sctp_getsockopt_pr_assocstatus(struct sock *sk, int len,
 	}
 
 	policy = params.sprstat_policy;
-	if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)))
+	if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)) ||
+	    ((policy & SCTP_PR_SCTP_ALL) && (policy & SCTP_PR_SCTP_MASK)))
 		goto out;
 
 	asoc = sctp_id2assoc(sk, params.sprstat_assoc_id);
 	if (!asoc)
 		goto out;
 
-	if (policy & SCTP_PR_SCTP_ALL) {
+	if (policy = SCTP_PR_SCTP_ALL) {
 		params.sprstat_abandoned_unsent = 0;
 		params.sprstat_abandoned_sent = 0;
 		for (policy = 0; policy <= SCTP_PR_INDEX(MAX); policy++) {
@@ -7142,7 +7143,8 @@ static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
 	}
 
 	policy = params.sprstat_policy;
-	if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)))
+	if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)) ||
+	    ((policy & SCTP_PR_SCTP_ALL) && (policy & SCTP_PR_SCTP_MASK)))
 		goto out;
 
 	asoc = sctp_id2assoc(sk, params.sprstat_assoc_id);
-- 
2.1.0
