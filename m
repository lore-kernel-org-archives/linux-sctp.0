From: Jules Irenge <jbi.octave@gmail.com>
Date: Sun, 23 Feb 2020 23:16:47 +0000
Subject: [PATCH 06/30] sctp: Add missing annotation for sctp_transport_walk_stop()
Message-Id: <20200223231711.157699-7-jbi.octave@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <0/30>
 <20200223231711.157699-1-jbi.octave@gmail.com>
In-Reply-To: <20200223231711.157699-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: boqun.feng@gmail.com
Cc: jbi.octave@gmail.com, linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, "open list:SCTP PROTOCOL" <linux-sctp@vger.kernel.org>, "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>

Sparse reports a warning at sctp_transport_walk_stop()

warning: context imbalance in sctp_transport_walk_stop
	- wrong count at exit

The root cause is the missing annotation at sctp_transport_walk_stop()
Add the missing __releases(RCU) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/sctp/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 05be67bb0474..fed26a1e9518 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5340,7 +5340,7 @@ void sctp_transport_walk_start(struct rhashtable_iter *iter) __acquires(RCU)
 	rhashtable_walk_start(iter);
 }
 
-void sctp_transport_walk_stop(struct rhashtable_iter *iter)
+void sctp_transport_walk_stop(struct rhashtable_iter *iter) __releases(RCU)
 {
 	rhashtable_walk_stop(iter);
 	rhashtable_walk_exit(iter);
-- 
2.24.1
