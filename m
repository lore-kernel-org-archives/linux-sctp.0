From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 09 Sep 2019 07:56:47 +0000
Subject: [PATCH net-next 1/5] sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
Message-Id: <b486e6b5e434f8fd2462addc81916d83b5a31707.1568015756.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1568015756.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1568015756.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

SCTP Quick failover draft section 5.1, point 5 has been removed
from rfc7829. Instead, "the sender SHOULD (i) notify the Upper
Layer Protocol (ULP) about this state transition", as said in
section 3.2, point 8.

So this patch is to add SCTP_ADDR_POTENTIALLY_FAILED, defined
in section 7.1, "which is reported if the affected address
becomes PF". Also remove transport cwnd's update when moving
from PF back to ACTIVE , which is no longer in rfc7829 either.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  1 +
 net/sctp/associola.c      | 17 ++++-------------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 6d5b164..45a85d7 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -410,6 +410,7 @@ enum sctp_spc_state {
 	SCTP_ADDR_ADDED,
 	SCTP_ADDR_MADE_PRIM,
 	SCTP_ADDR_CONFIRMED,
+	SCTP_ADDR_POTENTIALLY_FAILED,
 };
 
 
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index d2ffc9a..7278b7e 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -798,14 +798,6 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 			spc_state = SCTP_ADDR_CONFIRMED;
 		else
 			spc_state = SCTP_ADDR_AVAILABLE;
-		/* Don't inform ULP about transition from PF to
-		 * active state and set cwnd to 1 MTU, see SCTP
-		 * Quick failover draft section 5.1, point 5
-		 */
-		if (transport->state = SCTP_PF) {
-			ulp_notify = false;
-			transport->cwnd = asoc->pathmtu;
-		}
 		transport->state = SCTP_ACTIVE;
 		break;
 
@@ -814,19 +806,18 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 		 * to inactive state.  Also, release the cached route since
 		 * there may be a better route next time.
 		 */
-		if (transport->state != SCTP_UNCONFIRMED)
+		if (transport->state != SCTP_UNCONFIRMED) {
 			transport->state = SCTP_INACTIVE;
-		else {
+			spc_state = SCTP_ADDR_UNREACHABLE;
+		} else {
 			sctp_transport_dst_release(transport);
 			ulp_notify = false;
 		}
-
-		spc_state = SCTP_ADDR_UNREACHABLE;
 		break;
 
 	case SCTP_TRANSPORT_PF:
 		transport->state = SCTP_PF;
-		ulp_notify = false;
+		spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
 		break;
 
 	default:
-- 
2.1.0
