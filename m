From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 22 Aug 2020 23:15:59 +0000
Subject: [PATCH 5/7] net: sctp: protocol.c: delete duplicated words + punctuation
Message-Id: <20200822231601.32125-6-rdunlap@infradead.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200822231601.32125-1-rdunlap@infradead.org>
In-Reply-To: <20200822231601.32125-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-sctp@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>

Drop the repeated words "of" and "that".
Add some punctuation for readability.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/sctp/protocol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20200731.orig/net/sctp/protocol.c
+++ linux-next-20200731/net/sctp/protocol.c
@@ -372,7 +372,7 @@ static int sctp_v4_available(union sctp_
  * Level 3 - private addresses.
  * Level 4 - global addresses
  * For INIT and INIT-ACK address list, let L be the level of
- * of requested destination address, sender and receiver
+ * requested destination address, sender and receiver
  * SHOULD include all of its addresses with level greater
  * than or equal to L.
  *
@@ -1483,10 +1483,10 @@ static __init int sctp_init(void)
 	num_entries = (1UL << order) * PAGE_SIZE /
 		      sizeof(struct sctp_bind_hashbucket);
 
-	/* And finish by rounding it down to the nearest power of two
-	 * this wastes some memory of course, but its needed because
+	/* And finish by rounding it down to the nearest power of two.
+	 * This wastes some memory of course, but it's needed because
 	 * the hash function operates based on the assumption that
-	 * that the number of entries is a power of two
+	 * the number of entries is a power of two.
 	 */
 	sctp_port_hashsize = rounddown_pow_of_two(num_entries);
 
