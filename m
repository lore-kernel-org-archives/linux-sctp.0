From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 03 Jun 2016 14:42:45 +0000
Subject: [PATCHv2 net-next] sctp: sctp should change socket state when shutdown is received
Message-Id: <67353a74d044f1f643cdfe1442136b44d7188ea9.1464964965.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net, davem@davemloft.net, eric.dumazet@gmail.com

Now sctp doesn't change socket state upon shutdown reception. It changes
just the assoc state, even though it's a TCP-style socket.

For some cases, if we really need to check sk->sk_state, it's necessary to
fix this issue, at least when we use ss or netstat to dump, we can get a
more exact information.

As an improvement, we will change sk->sk_state when we change asoc->state
to SHUTDOWN_RECEIVED, and also do it in sctp_shutdown to keep consistent with
sctp_close.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_sideeffect.c | 4 +++-
 net/sctp/socket.c        | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index aa37122..12d4519 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -806,8 +806,10 @@ static void sctp_cmd_new_state(sctp_cmd_seq_t *cmds,
 
 		/* Set the RCV_SHUTDOWN flag when a SHUTDOWN is received. */
 		if (sctp_state(asoc, SHUTDOWN_RECEIVED) &&
-		    sctp_sstate(sk, ESTABLISHED))
+		    sctp_sstate(sk, ESTABLISHED)) {
+			sk->sk_state = SCTP_SS_CLOSING;
 			sk->sk_shutdown |= RCV_SHUTDOWN;
+		}
 	}
 
 	if (sctp_state(asoc, COOKIE_WAIT)) {
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 67154b8..91a460d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4193,6 +4193,7 @@ static void sctp_shutdown(struct sock *sk, int how)
 		return;
 
 	if (how & SEND_SHUTDOWN) {
+		sk->sk_state = SCTP_SS_CLOSING;
 		ep = sctp_sk(sk)->ep;
 		if (!list_empty(&ep->asocs)) {
 			asoc = list_entry(ep->asocs.next,
-- 
2.1.0

