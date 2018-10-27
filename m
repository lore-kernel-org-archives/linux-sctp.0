From: Tomas Bortoli <tomasbortoli@gmail.com>
Date: Sat, 27 Oct 2018 20:53:20 +0000
Subject: [PATCH v2] sctp: socket.c validate sprstat_policy
Message-Id: <20181027205320.14975-1-tomasbortoli@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Bortoli <tomasbortoli@gmail.com>

It is possible to perform out-of-bound reads on
sctp_getsockopt_pr_streamstatus() and on
sctp_getsockopt_pr_assocstatus() by passing from userspace a
sprstat_policy that overflows the abandoned_sent/abandoned_unsent
fixed length arrays. The over-read data are directly copied/leaked
to userspace.

Signed-off-by: Tomas Bortoli <tomasbortoli@gmail.com>
Reported-by: syzbot+5da0d0a72a9e7d791748@syzkaller.appspotmail.com
---
 net/sctp/socket.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index fc0386e8ff23..14dce5d95817 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7083,7 +7083,9 @@ static int sctp_getsockopt_pr_assocstatus(struct sock *sk, int len,
 	}
 
 	policy = params.sprstat_policy;
-	if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)))
+	if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)) ||
+	    __SCTP_PR_INDEX(policy) > SCTP_PR_INDEX(MAX) ||
+	    __SCTP_PR_INDEX(policy) < 0)
 		goto out;
 
 	asoc = sctp_id2assoc(sk, params.sprstat_assoc_id);
@@ -7142,7 +7144,9 @@ static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
 	}
 
 	policy = params.sprstat_policy;
-	if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)))
+	if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)) ||
+	    __SCTP_PR_INDEX(policy) > SCTP_PR_INDEX(MAX) ||
+	    __SCTP_PR_INDEX(policy) < 0)
 		goto out;
 
 	asoc = sctp_id2assoc(sk, params.sprstat_assoc_id);
-- 
2.11.0
