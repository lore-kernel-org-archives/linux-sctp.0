From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 20 Nov 2018 11:12:10 +0000
Subject: [PATCH net] sctp: hold transport before accessing its asoc in sctp_epaddr_lookup_transport
Message-Id: <6d2d91c6173328d6e8868849686aae34e51c889f.1542712330.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <607dd2950d09fc83404d670a73099523087d4963.1535366311.git.lucien.xin@gmail.com>
In-Reply-To: <607dd2950d09fc83404d670a73099523087d4963.1535366311.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Without holding transport to dereference its asoc, a use after
free panic can be caused in sctp_epaddr_lookup_transport. Note
that a sock lock can't protect these transports that belong to
other socks.

A similar fix as Commit bab1be79a516 ("sctp: hold transport
before accessing its asoc in sctp_transport_get_next") is
needed to hold the transport before accessing its asoc in
sctp_epaddr_lookup_transport.

Fixes: 7fda702f9315 ("sctp: use new rhlist interface on sctp transport rhashtable")
Reported-by: syzbot+aad231d51b1923158444@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/input.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 69584e9..c2c0816 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -972,9 +972,15 @@ struct sctp_transport *sctp_epaddr_lookup_transport(
 	list = rhltable_lookup(&sctp_transport_hashtable, &arg,
 			       sctp_hash_params);
 
-	rhl_for_each_entry_rcu(t, tmp, list, node)
-		if (ep = t->asoc->ep)
+	rhl_for_each_entry_rcu(t, tmp, list, node) {
+		if (!sctp_transport_hold(t))
+			continue;
+		if (ep = t->asoc->ep) {
+			sctp_transport_put(t);
 			return t;
+		}
+		sctp_transport_put(t);
+	}
 
 	return NULL;
 }
-- 
2.1.0
