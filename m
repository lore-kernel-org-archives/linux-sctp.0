From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 30 Jul 2016 06:14:41 +0000
Subject: [PATCH net] sctp: allow receiving msg when TCP-style sk is in CLOSED state
Message-Id: <d108342f2f89cfdf7f9abc529a746a032e236b78.1469859281.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net

Commit 141ddefce7c8 ("sctp: change sk state to CLOSED instead of
CLOSING in sctp_sock_migrate") changed sk state to CLOSED if the
assoc is closed when sctp_accept clones a new sk.

If there is still data in sk receive queue, users will not be able
to read it any more, as sctp_recvmsg returns directly if sk state
is CLOSED.

This patch is to add CLOSED state check in sctp_recvmsg to allow
reading data from TCP-style sk with CLOSED state as what TCP does.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 8812e1b..9fc417a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2079,7 +2079,7 @@ static int sctp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	lock_sock(sk);
 
 	if (sctp_style(sk, TCP) && !sctp_sstate(sk, ESTABLISHED) &&
-	    !sctp_sstate(sk, CLOSING)) {
+	    !sctp_sstate(sk, CLOSING) && !sctp_sstate(sk, CLOSED)) {
 		err = -ENOTCONN;
 		goto out;
 	}
-- 
2.1.0

