From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Wed, 03 Oct 2018 10:45:56 +0000
Subject: [PATCH] sctp: fix fall-through annotation
Message-Id: <20181003104556.GA23489@embeddedor.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>

Replace "fallthru" with a proper "fall through" annotation.

This fix is part of the ongoing efforts to enabling
-Wimplicit-fallthrough

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/sctp/outqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index d74d00b..42191ed 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1048,7 +1048,7 @@ static void sctp_outq_flush_data(struct sctp_flush_ctx *ctx,
 		if (!ctx->packet || !ctx->packet->has_cookie_echo)
 			return;
 
-		/* fallthru */
+		/* fall through */
 	case SCTP_STATE_ESTABLISHED:
 	case SCTP_STATE_SHUTDOWN_PENDING:
 	case SCTP_STATE_SHUTDOWN_RECEIVED:
-- 
2.7.4
