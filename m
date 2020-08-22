From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 22 Aug 2020 23:15:55 +0000
Subject: [PATCH 1/7] net: sctp: associola.c: delete duplicated words
Message-Id: <20200822231601.32125-2-rdunlap@infradead.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200822231601.32125-1-rdunlap@infradead.org>
In-Reply-To: <20200822231601.32125-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-sctp@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>

Drop the repeated word "the" in two places.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/sctp/associola.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200731.orig/net/sctp/associola.c
+++ linux-next-20200731/net/sctp/associola.c
@@ -1351,7 +1351,7 @@ static void sctp_select_active_and_retra
 	}
 
 	/* We did not find anything useful for a possible retransmission
-	 * path; either primary path that we found is the the same as
+	 * path; either primary path that we found is the same as
 	 * the current one, or we didn't generally find an active one.
 	 */
 	if (trans_sec = NULL)
@@ -1537,7 +1537,7 @@ void sctp_assoc_rwnd_decrease(struct sct
 
 	/* If we've reached or overflowed our receive buffer, announce
 	 * a 0 rwnd if rwnd would still be positive.  Store the
-	 * the potential pressure overflow so that the window can be restored
+	 * potential pressure overflow so that the window can be restored
 	 * back to original value.
 	 */
 	if (rx_count >= asoc->base.sk->sk_rcvbuf)
