From: Chang Xiangzhong <changxiangzhong@gmail.com>
Date: Thu, 14 Nov 2013 20:40:23 +0000
Subject: [PATCH] net: sctp: recover a tranport when an ack comes
Message-Id: <1384461624-17636-1-git-send-email-changxiangzhong@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dreibh@simula.no, ernstgr@simula.no, Chang Xiangzhong <changxiangzhong@gmail.com>

Expected Behavior:
When hearing an ack from a tranport/path, set its state to normal/on if it's
in abnormal(__partial_failure__ or inactive) state.

state machine of tranport->state
Whenever a T3_RTX timer expires, then transport->error_count++.
When (association->pf_retrans < transport->error_count < tranport->pathmaxrtx)
	transport->state = SCTP_PF //partial failure

When a heartbeat-ack comes or conventional ack acknowledged its availability,
	transport->state = SCTP_ON

Signed-off-by: Chang Xiangzhong <changxiangzhong@gmail.com>
Fixes: 5aa93bcf66f ("sctp: Implement quick failover draft from tsvwg")
---
 net/sctp/outqueue.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 94df758..2557fa5 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1517,6 +1517,7 @@ static void sctp_check_transmitted(struct sctp_outq *q,
 			 * active if it is not so marked.
 			 */
 			if ((transport->state = SCTP_INACTIVE ||
+			     transport->state = SCTP_PF ||
 			     transport->state = SCTP_UNCONFIRMED) &&
 			    sctp_cmp_addr_exact(&transport->ipaddr, saddr)) {
 				sctp_assoc_control_transport(
-- 
1.7.9.5

