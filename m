From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 08 Jan 2018 21:02:27 +0000
Subject: [PATCH net 1/3] sctp: GFP_ATOMIC is not needed in sctp_setsockopt_events
Message-Id: <e0c9397b8bce4f31cd50825141550a054e262db7.1515436112.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1515436112.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1515436112.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, haliu@redhat.com

So replace it with GFP_USER and also add __GFP_NOWARN.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b4fb6e4886d264f302fc67b8d822cd8bdb5f3f41..54c046783a89e76c9909ee85c83e6be38ada41a7 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2277,7 +2277,7 @@ static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
 
 		if (asoc && sctp_outq_is_empty(&asoc->outqueue)) {
 			event = sctp_ulpevent_make_sender_dry_event(asoc,
-					GFP_ATOMIC);
+					GFP_USER | __GFP_NOWARN);
 			if (!event)
 				return -ENOMEM;
 
-- 
2.14.3

