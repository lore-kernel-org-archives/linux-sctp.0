From: Jules Irenge <jbi.octave@gmail.com>
Date: Sun, 23 Feb 2020 23:16:46 +0000
Subject: [PATCH 05/30] sctp: Add missing annotation for sctp_transport_walk_start()
Message-Id: <20200223231711.157699-6-jbi.octave@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <0/30>
 <20200223231711.157699-1-jbi.octave@gmail.com>
In-Reply-To: <20200223231711.157699-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: boqun.feng@gmail.com
Cc: jbi.octave@gmail.com, linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, "open list:SCTP PROTOCOL" <linux-sctp@vger.kernel.org>, "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>

Sparse reports a warning at sctp_transport_walk_start()

warning: context imbalance in sctp_transport_walk_start
	- wrong count at exit

The root cause is the missing annotation at sctp_transport_walk_start()
Add the missing __acquires(RCU) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/sctp/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1b56fc440606..05be67bb0474 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5333,7 +5333,7 @@ int sctp_get_sctp_info(struct sock *sk, struct sctp_association *asoc,
 EXPORT_SYMBOL_GPL(sctp_get_sctp_info);
 
 /* use callback to avoid exporting the core structure */
-void sctp_transport_walk_start(struct rhashtable_iter *iter)
+void sctp_transport_walk_start(struct rhashtable_iter *iter) __acquires(RCU)
 {
 	rhltable_walk_enter(&sctp_transport_hashtable, iter);
 
-- 
2.24.1
