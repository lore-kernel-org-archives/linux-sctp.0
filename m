From: Julien Gomes <julien@arista.com>
Date: Wed, 06 Feb 2019 20:14:30 +0000
Subject: [PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length
Message-Id: <20190206201430.18830-1-julien@arista.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, vyasevich@gmail.com, lucien.xin@gmail.com, Julien Gomes <julien@arista.com>

Make sctp_setsockopt_events() able to accept sctp_event_subscribe
structures longer than the current definitions.

This should prevent unjustified setsockopt() failures due to struct
sctp_event_subscribe extensions (as in 4.11 and 4.12) when using
binaries that should be compatible, but were built with later kernel
uapi headers.

Signed-off-by: Julien Gomes <julien@arista.com>
---
 net/sctp/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9644bdc8e85c..f9717e2789da 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2311,7 +2311,7 @@ static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
 	int i;
 
 	if (optlen > sizeof(struct sctp_event_subscribe))
-		return -EINVAL;
+		optlen = sizeof(struct sctp_event_subscribe);
 
 	if (copy_from_user(&subscribe, optval, optlen))
 		return -EFAULT;
-- 
2.20.1
