From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 08 Nov 2019 05:20:33 +0000
Subject: [PATCHv4 net-next 2/5] sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
Message-Id: <7fa091e035b70859acbfd74ea06fcb3064c4bef7.1573190212.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1573190212.git.lucien.xin@gmail.com>
 <d008eb59f963118ae264e0151da79c382f16a69b.1573190212.git.lucien.xin@gmail.com>
In-Reply-To: <d008eb59f963118ae264e0151da79c382f16a69b.1573190212.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net, David Laight <david.laight@aculab.com>

SCTP Quick failover draft section 5.1, point 5 has been removed
from rfc7829. Instead, "the sender SHOULD (i) notify the Upper
Layer Protocol (ULP) about this state transition", as said in
section 3.2, point 8.

So this patch is to add SCTP_ADDR_POTENTIALLY_FAILED, defined
in section 7.1, "which is reported if the affected address
becomes PF". Also remove transport cwnd's update when moving
from PF back to ACTIVE , which is no longer in rfc7829 either.

Note that ulp_notify will be set to false if asoc->expose is
not 'enabled', according to last patch.

v2->v3:
  - define SCTP_ADDR_PF SCTP_ADDR_POTENTIALLY_FAILED.
v3->v4:
  - initialize spc_state with SCTP_ADDR_AVAILABLE, as Marcelo suggested.
  - check asoc->pf_expose in sctp_assoc_control_transport(), as Marcelo
    suggested.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 include/uapi/linux/sctp.h |  2 ++
 net/sctp/associola.c      | 32 ++++++++++++++------------------
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 765f41a..d99b428 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -410,6 +410,8 @@ enum sctp_spc_state {
 	SCTP_ADDR_ADDED,
 	SCTP_ADDR_MADE_PRIM,
 	SCTP_ADDR_CONFIRMED,
+	SCTP_ADDR_POTENTIALLY_FAILED,
+#define SCTP_ADDR_PF	SCTP_ADDR_POTENTIALLY_FAILED
 };
 
 
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 4cadff5..c183d0e 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -787,8 +787,8 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 				  enum sctp_transport_cmd command,
 				  sctp_sn_error_t error)
 {
+	int spc_state = SCTP_ADDR_AVAILABLE;
 	bool ulp_notify = true;
-	int spc_state = 0;
 
 	/* Record the transition on the transport.  */
 	switch (command) {
@@ -797,19 +797,13 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 		 * to heartbeat success, report the SCTP_ADDR_CONFIRMED
 		 * state to the user, otherwise report SCTP_ADDR_AVAILABLE.
 		 */
-		if (SCTP_UNCONFIRMED = transport->state &&
-		    SCTP_HEARTBEAT_SUCCESS = error)
-			spc_state = SCTP_ADDR_CONFIRMED;
-		else
-			spc_state = SCTP_ADDR_AVAILABLE;
-		/* Don't inform ULP about transition from PF to
-		 * active state and set cwnd to 1 MTU, see SCTP
-		 * Quick failover draft section 5.1, point 5
-		 */
-		if (transport->state = SCTP_PF) {
+		if (transport->state = SCTP_PF &&
+		    asoc->pf_expose != SCTP_PF_EXPOSE_ENABLE)
 			ulp_notify = false;
-			transport->cwnd = asoc->pathmtu;
-		}
+		else if (transport->state = SCTP_UNCONFIRMED &&
+			 error = SCTP_HEARTBEAT_SUCCESS)
+			spc_state = SCTP_ADDR_CONFIRMED;
+
 		transport->state = SCTP_ACTIVE;
 		break;
 
@@ -818,19 +812,21 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
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
+		if (asoc->pf_expose != SCTP_PF_EXPOSE_ENABLE)
+			ulp_notify = false;
+		else
+			spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
 		break;
 
 	default:
-- 
2.1.0
