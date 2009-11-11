From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 11 Nov 2009 21:54:37 +0000
Subject: [PATCH] sctp: Set socket source address when additing first transport
Message-Id: <1257976477-31326-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1257879454-31661-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1257879454-31661-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>

Recent commits
	sctp: Get rid of an extra routing lookup when adding a transport
and
	sctp: Set source addresses on the association before adding transports

changed when routes are added to the sctp transports.  As such,
we didn't set the socket source address correctly when adding the first
transport.  The first transport is always the primary/active one, so
when adding it, set the socket source address.  This was causing
regression failures in SCTP tests.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/transport.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index c256e48..3b141bb 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -308,7 +308,8 @@ void sctp_transport_route(struct sctp_transport *transport,
 		/* Initialize sk->sk_rcv_saddr, if the transport is the
 		 * association's active path for getsockname().
 		 */
-		if (asoc && (transport = asoc->peer.active_path))
+		if (asoc && (!asoc->peer.primary_path ||
+				(transport = asoc->peer.active_path)))
 			opt->pf->af->to_sk_saddr(&transport->saddr,
 						 asoc->base.sk);
 	} else
-- 
1.6.0.4

