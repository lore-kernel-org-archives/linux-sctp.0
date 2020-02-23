From: Jules Irenge <jbi.octave@gmail.com>
Date: Sun, 23 Feb 2020 23:16:45 +0000
Subject: [PATCH 04/30] sctp: Add missing annotation for sctp_err_finish()
Message-Id: <20200223231711.157699-5-jbi.octave@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <0/30>
 <20200223231711.157699-1-jbi.octave@gmail.com>
In-Reply-To: <20200223231711.157699-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: boqun.feng@gmail.com
Cc: jbi.octave@gmail.com, linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, "open list:SCTP PROTOCOL" <linux-sctp@vger.kernel.org>, "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>

Sparse reports a warning at sctp_err_finish()
warning: context imbalance in sctp_err_finish() - unexpected unlock

The root cause is a missing annotation at sctp_err_finish()
Add the missing  __releases(&((__sk)->sk_lock.slock)) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/sctp/input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index efaaefc3bb1c..55d4fc6f371d 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -548,6 +548,7 @@ struct sock *sctp_err_lookup(struct net *net, int family, struct sk_buff *skb,
 
 /* Common cleanup code for icmp/icmpv6 error handler. */
 void sctp_err_finish(struct sock *sk, struct sctp_transport *t)
+	__releases(&((__sk)->sk_lock.slock))
 {
 	bh_unlock_sock(sk);
 	sctp_transport_put(t);
-- 
2.24.1
