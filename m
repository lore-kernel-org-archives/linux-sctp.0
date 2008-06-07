From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Sat, 07 Jun 2008 02:50:07 +0000
Subject: [PATCH net-next] sctp: Fix problems with the new SCTP_DELAYED_ACK code
Message-Id: <1212807007-24379-1-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>

The default sack frequency should be 2.  Also fix copy/paste
error when updating all transports.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/socket.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 81600ee..253e5ea 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2471,7 +2471,7 @@ static int sctp_setsockopt_delayed_ack(struct sock *sk,
 					(trans->param_flags & ~SPP_SACKDELAY) |
 					SPP_SACKDELAY_ENABLE;
 			}
-			if (params.sack_delay = 1) {
+			if (params.sack_freq = 1) {
 				trans->param_flags  					(trans->param_flags & ~SPP_SACKDELAY) |
 					SPP_SACKDELAY_DISABLE;
@@ -3536,7 +3536,7 @@ SCTP_STATIC int sctp_init_sock(struct sock *sk)
 	sp->pathmaxrxt  = sctp_max_retrans_path;
 	sp->pathmtu     = 0; // allow default discovery
 	sp->sackdelay   = sctp_sack_timeout;
-	sp->sackfreq	= 3;
+	sp->sackfreq	= 2;
 	sp->param_flags = SPP_HB_ENABLE |
 			  SPP_PMTUD_ENABLE |
 			  SPP_SACKDELAY_ENABLE;
-- 
1.5.3.5

