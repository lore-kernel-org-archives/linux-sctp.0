From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 22 Aug 2020 23:16:01 +0000
Subject: [PATCH 7/7] net: sctp: ulpqueue.c: delete duplicated word
Message-Id: <20200822231601.32125-8-rdunlap@infradead.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200822231601.32125-1-rdunlap@infradead.org>
In-Reply-To: <20200822231601.32125-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-sctp@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>

Drop the repeated word "an".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/sctp/ulpqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200731.orig/net/sctp/ulpqueue.c
+++ linux-next-20200731/net/sctp/ulpqueue.c
@@ -740,7 +740,7 @@ static void sctp_ulpq_reasm_drain(struct
 
 
 /* Helper function to gather skbs that have possibly become
- * ordered by an an incoming chunk.
+ * ordered by an incoming chunk.
  */
 static void sctp_ulpq_retrieve_ordered(struct sctp_ulpq *ulpq,
 					      struct sctp_ulpevent *event)
