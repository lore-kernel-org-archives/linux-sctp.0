From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 04 Jan 2020 06:15:02 +0000
Subject: [PATCH net] sctp: free cmd->obj.chunk for the unprocessed SCTP_CMD_REPLY
Message-Id: <f5ea0cd0d1ae40046da27fcf9f3cf5c21772be49.1578118502.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

This patch is to fix a memleak caused by no place to free cmd->obj.chunk
for the unprocessed SCTP_CMD_REPLY. This issue occurs when failing to
process a cmd while there're still SCTP_CMD_REPLY cmds on the cmd seq
with an allocated chunk in cmd->obj.chunk.

So fix it by freeing cmd->obj.chunk for each SCTP_CMD_REPLY cmd left on
the cmd seq when any cmd returns error. While at it, also remove 'nomem'
label.

Reported-by: syzbot+107c4aff5f392bf1517f@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_sideeffect.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index acd737d..834e9f8 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1363,8 +1363,10 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 			/* Generate an INIT ACK chunk.  */
 			new_obj = sctp_make_init_ack(asoc, chunk, GFP_ATOMIC,
 						     0);
-			if (!new_obj)
-				goto nomem;
+			if (!new_obj) {
+				error = -ENOMEM;
+				break;
+			}
 
 			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
 					SCTP_CHUNK(new_obj));
@@ -1386,7 +1388,8 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 			if (!new_obj) {
 				if (cmd->obj.chunk)
 					sctp_chunk_free(cmd->obj.chunk);
-				goto nomem;
+				error = -ENOMEM;
+				break;
 			}
 			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
 					SCTP_CHUNK(new_obj));
@@ -1433,8 +1436,10 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 
 			/* Generate a SHUTDOWN chunk.  */
 			new_obj = sctp_make_shutdown(asoc, chunk);
-			if (!new_obj)
-				goto nomem;
+			if (!new_obj) {
+				error = -ENOMEM;
+				break;
+			}
 			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
 					SCTP_CHUNK(new_obj));
 			break;
@@ -1770,11 +1775,17 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 			break;
 		}
 
-		if (error)
+		if (error) {
+			cmd = sctp_next_cmd(commands);
+			while (cmd) {
+				if (cmd->verb = SCTP_CMD_REPLY)
+					sctp_chunk_free(cmd->obj.chunk);
+				cmd = sctp_next_cmd(commands);
+			}
 			break;
+		}
 	}
 
-out:
 	/* If this is in response to a received chunk, wait until
 	 * we are done with the packet to open the queue so that we don't
 	 * send multiple packets in response to a single request.
@@ -1789,7 +1800,4 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 		sp->data_ready_signalled = 0;
 
 	return error;
-nomem:
-	error = -ENOMEM;
-	goto out;
 }
-- 
2.1.0
