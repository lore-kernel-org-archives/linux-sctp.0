From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 06 Apr 2017 05:10:52 +0000
Subject: [PATCH net] sctp: listen on the sock only when it's state is listening or closed
Message-Id: <19f73778f8e27b05ee9aa25ece57db6b0e73d197.1491455452.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, andreyknvl@google.com

Now sctp doesn't check sock's state before listening on it. It could
even cause changing a sock with any state to become a listening sock
when doing sctp_listen.

This patch is to fix it by checking sock's state in sctp_listen, so
that it will listen on the sock with right state.

Reported-by: Andrey Konovalov <andreyknvl@google.com>
Tested-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c1401f4..d9d4c92 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7034,6 +7034,9 @@ int sctp_inet_listen(struct socket *sock, int backlog)
 	if (sock->state != SS_UNCONNECTED)
 		goto out;
 
+	if (!sctp_sstate(sk, LISTENING) && !sctp_sstate(sk, CLOSED))
+		goto out;
+
 	/* If backlog is zero, disable listening. */
 	if (!backlog) {
 		if (sctp_sstate(sk, CLOSED))
-- 
2.1.0

