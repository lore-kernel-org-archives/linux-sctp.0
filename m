From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 15 Jan 2018 09:02:00 +0000
Subject: [PATCH net] sctp: do not allow the v4 socket to bind a v4mapped v6 address
Message-Id: <e43f937592a7b022a72bdbbd784742ee6b3f6def.1516006920.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

The check in sctp_sockaddr_af is not robust enough to forbid binding a
v4mapped v6 addr on a v4 socket.

The worse thing is that v4 socket's bind_verify would not convert this
v4mapped v6 addr to a v4 addr. syzbot even reported a crash as the v4
socket bound a v6 addr.

This patch is to fix it by doing the common sa.sa_family check first,
then AF_INET check for v4mapped v6 addrs.

Fixes: 7dab83de50c7 ("sctp: Support ipv6only AF_INET6 sockets.")
Reported-by: syzbot+7b7b518b1228d2743963@syzkaller.appspotmail.com
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index feb2ca6..039fcb6 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -335,16 +335,14 @@ static struct sctp_af *sctp_sockaddr_af(struct sctp_sock *opt,
 	if (len < sizeof (struct sockaddr))
 		return NULL;
 
+	if (!opt->pf->af_supported(addr->sa.sa_family, opt))
+		return NULL;
+
 	/* V4 mapped address are really of AF_INET family */
 	if (addr->sa.sa_family = AF_INET6 &&
-	    ipv6_addr_v4mapped(&addr->v6.sin6_addr)) {
-		if (!opt->pf->af_supported(AF_INET, opt))
-			return NULL;
-	} else {
-		/* Does this PF support this AF? */
-		if (!opt->pf->af_supported(addr->sa.sa_family, opt))
-			return NULL;
-	}
+	    ipv6_addr_v4mapped(&addr->v6.sin6_addr) &&
+	    !opt->pf->af_supported(AF_INET, opt))
+		return NULL;
 
 	/* If we get this far, af is valid. */
 	af = sctp_get_af_specific(addr->sa.sa_family);
-- 
2.1.0

