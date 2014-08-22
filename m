From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 22 Aug 2014 11:03:29 +0000
Subject: [PATCH net 1/2] net: sctp: spare unnecessary comparison in sctp_trans_elect_best
Message-Id: <1408705410-28558-2-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1408705410-28558-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1408705410-28558-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

When both transports are the same, we don't have to go down that
road only to realize that we will return the very same transport.
We are guaranteed that curr is always non-NULL. Therefore, just
short-circuit this special case.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 net/sctp/associola.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index aaafb32..104fae4 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1245,7 +1245,7 @@ static struct sctp_transport *sctp_trans_elect_best(struct sctp_transport *curr,
 {
 	u8 score_curr, score_best;
 
-	if (best = NULL)
+	if (best = NULL || curr = best)
 		return curr;
 
 	score_curr = sctp_trans_score(curr);
-- 
1.7.11.7

