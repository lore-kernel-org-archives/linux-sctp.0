From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 22 Aug 2020 23:15:57 +0000
Subject: [PATCH 3/7] net: sctp: bind_addr.c: delete duplicated word
Message-Id: <20200822231601.32125-4-rdunlap@infradead.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200822231601.32125-1-rdunlap@infradead.org>
In-Reply-To: <20200822231601.32125-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-sctp@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>

Drop the repeated word "of".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/sctp/bind_addr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200731.orig/net/sctp/bind_addr.c
+++ linux-next-20200731/net/sctp/bind_addr.c
@@ -505,7 +505,7 @@ int sctp_in_scope(struct net *net, const
 		return 0;
 	/*
 	 * For INIT and INIT-ACK address list, let L be the level of
-	 * of requested destination address, sender and receiver
+	 * requested destination address, sender and receiver
 	 * SHOULD include all of its addresses with level greater
 	 * than or equal to L.
 	 *
