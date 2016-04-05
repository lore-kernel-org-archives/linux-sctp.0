From: Bastien Philbert <bastienphilbert@gmail.com>
Date: Tue, 05 Apr 2016 21:36:41 +0000
Subject: [PATCH] sctp: Fix error handling for switch statement case in the function sctp_cmd_interprete
Message-Id: <1459892201-21397-1-git-send-email-bastienphilbert@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com
Cc: nhorman@tuxdriver.com, davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

This fixes error handling for the switch statement case
SCTP_CMD_SEND_PKT by making the error value of the call
to sctp_packet_transmit equal the variable error due to
this function being able to fail with a error code. In
addition allow the call to sctp_ootb_pkt_free afterwards
to free up the no longer in use sctp packet even if the
call to the function sctp_packet_transmit fails in order
to avoid a memory leak here for not freeing the sctp

Signed-off-by: Bastien Philbert <bastienphilbert@gmail.com>
---
 net/sctp/sm_sideeffect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 7fe56d0..f3a8b58 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1434,7 +1434,7 @@ static int sctp_cmd_interpreter(sctp_event_t event_type,
 		case SCTP_CMD_SEND_PKT:
 			/* Send a full packet to our peer.  */
 			packet = cmd->obj.packet;
-			sctp_packet_transmit(packet, gfp);
+			error = sctp_packet_transmit(packet, gfp);
 			sctp_ootb_pkt_free(packet);
 			break;
 
-- 
2.5.0

