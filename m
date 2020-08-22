From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 22 Aug 2020 23:16:00 +0000
Subject: [PATCH 6/7] net: sctp: sm_make_chunk.c: delete duplicated words + fix typo
Message-Id: <20200822231601.32125-7-rdunlap@infradead.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200822231601.32125-1-rdunlap@infradead.org>
In-Reply-To: <20200822231601.32125-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-sctp@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>

Drop the repeated words "for", "that", and "a".
Change "his" to "this".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/sctp/sm_make_chunk.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20200731.orig/net/sctp/sm_make_chunk.c
+++ linux-next-20200731/net/sctp/sm_make_chunk.c
@@ -1235,7 +1235,7 @@ nodata:
 
 /* Create an Operation Error chunk of a fixed size, specifically,
  * min(asoc->pathmtu, SCTP_DEFAULT_MAXSEGMENT) - overheads.
- * This is a helper function to allocate an error chunk for for those
+ * This is a helper function to allocate an error chunk for those
  * invalid parameter codes in which we may not want to report all the
  * errors, if the incoming chunk is large. If it can't fit in a single
  * packet, we ignore it.
@@ -1780,7 +1780,7 @@ no_hmac:
 	 * for init collision case of lost COOKIE ACK.
 	 * If skb has been timestamped, then use the stamp, otherwise
 	 * use current time.  This introduces a small possibility that
-	 * that a cookie may be considered expired, but his would only slow
+	 * a cookie may be considered expired, but this would only slow
 	 * down the new association establishment instead of every packet.
 	 */
 	if (sock_flag(ep->base.sk, SOCK_TIMESTAMP))
@@ -2319,7 +2319,7 @@ int sctp_process_init(struct sctp_associ
 
 	/* This implementation defaults to making the first transport
 	 * added as the primary transport.  The source address seems to
-	 * be a a better choice than any of the embedded addresses.
+	 * be a better choice than any of the embedded addresses.
 	 */
 	if (!sctp_assoc_add_peer(asoc, peer_addr, gfp, SCTP_ACTIVE))
 		goto nomem;
