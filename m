From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 09 Aug 2013 13:09:08 +0000
Subject: [PATCH net] net: sctp: sctp_assoc_control_transport: fix MTU size in SCTP_PF state
Message-Id: <1376053748-31783-1-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: kheiss@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>

The SCTP Quick failover draft [1] section 5.1, point 5 says that the cwnd
should be 1 MTU. So, instead of 1, set it to 1 MTU.

  [1] https://tools.ietf.org/html/draft-nishida-tsvwg-sctp-failover-05

Reported-by: Karl Heiss <kheiss@gmail.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
---
 net/sctp/associola.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index bce5b79..ab67efc 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -846,12 +846,12 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 		else
 			spc_state = SCTP_ADDR_AVAILABLE;
 		/* Don't inform ULP about transition from PF to
-		 * active state and set cwnd to 1, see SCTP
+		 * active state and set cwnd to 1 MTU, see SCTP
 		 * Quick failover draft section 5.1, point 5
 		 */
 		if (transport->state = SCTP_PF) {
 			ulp_notify = false;
-			transport->cwnd = 1;
+			transport->cwnd = asoc->pathmtu;
 		}
 		transport->state = SCTP_ACTIVE;
 		break;
-- 
1.7.11.7

