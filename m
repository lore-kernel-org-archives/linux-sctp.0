From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 23 Apr 2010 10:22:20 +0000
Subject: [PATCH 2/2] sctp: COOKIE-ACK should back to where the COOKIE-ECHO
Message-Id: <4BD174DC.40308@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

An endpoint SHOULD transmit reply chunks (e.g., SACK, HEARTBEAT ACK,
etc.) to the same destination transport address from which it
received the DATA or control chunk to which it is replying.

But if endpoint is multi-homed, retransmit COOKIE-ECHO will cause
COOKIE-ACK be sent back to the destination transport address from
which the INIT chunk is received. This patch fixed it while
retransmit COOKIE-ECHO is because of either COOKIE-ECHO lost or
COOKIE-ACK lost.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_statefuns.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index abf601a..e95f6e5 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -724,10 +724,15 @@ sctp_disposition_t sctp_sf_do_5_1D_ce(const struct sctp_endpoint *ep,
 	peer_init = &chunk->subh.cookie_hdr->c.peer_init[0];
 
 	if (!sctp_process_init(new_asoc, chunk->chunk_hdr->type,
-			       &chunk->subh.cookie_hdr->c.peer_addr,
+			       sctp_source(chunk),
 			       peer_init, GFP_ATOMIC))
 		goto nomem_init;
 
+	/* The peer's original address may not appear in address parameters */
+	if (!sctp_assoc_add_peer(new_asoc, &chunk->subh.cookie_hdr->c.peer_addr,
+				 GFP_ATOMIC, SCTP_UNCONFIRMED))
+		goto nomem_init;
+
 	/* SCTP-AUTH:  Now that we've populate required fields in
 	 * sctp_process_init, set up the assocaition shared keys as
 	 * necessary so that we can potentially authenticate the ACK
@@ -1914,6 +1919,9 @@ static sctp_disposition_t sctp_sf_do_dupcook_d(const struct sctp_endpoint *ep,
 		}
 	}
 
+	sctp_add_cmd_sf(commands, SCTP_CMD_TRANSPORT_ON,
+			SCTP_TRANSPORT(chunk->transport));
+
 	repl = sctp_make_cookie_ack(new_asoc, chunk);
 	if (!repl)
 		goto nomem;
-- 
1.6.5.2


