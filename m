From: <zyjzyj2000@gmail.com>
Date: Tue, 08 Dec 2015 09:47:22 +0000
Subject: [PATCH 1/1] net:sctp: disable to inform ULP about transition from PF to active state
Message-Id: <1449568042-9176-1-git-send-email-zyjzyj2000@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc: alexandre.dietsch@windriver.com, stefan.costandache@windriver.com

From: yzhu1 <zyjzyj2000@gmail.com>

This feature is introduced in the commit 5aa93bc "sctp: Implement
quick failover draft from tsvwg". This feature should be disabled
if the quick failover feature is disabled.

Signed-off-by: yzhu1 <zyjzyj2000@gmail.com>
---
 net/sctp/associola.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 559afd0..7438625 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -795,7 +795,8 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 		 * active state and set cwnd to 1 MTU, see SCTP
 		 * Quick failover draft section 5.1, point 5
 		 */
-		if (transport->state = SCTP_PF) {
+		if ((asoc->pf_retrans < asoc->max_retrans) && 
+			(transport->state = SCTP_PF)) {
 			ulp_notify = false;
 			transport->cwnd = asoc->pathmtu;
 		}
-- 
1.7.9.5

