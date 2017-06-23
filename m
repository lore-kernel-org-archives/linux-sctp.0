From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 23 Jun 2017 22:59:33 +0000
Subject: [PATCH net-next 1/4] sctp: update order of adjustments of partial_bytes_acked and cwnd
Message-Id: <98e065d2430bf0997c1d3ece3a56af78a60e7ce3.1498251459.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1498251459.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1498251459.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>

RFC4960 Errata 3.12 says RFC4960 is unclear about the order of
adjustments applied to partial_bytes_acked and cwnd in the congestion
avoidance phase, and that the actual order should be:
partial_bytes_acked is reset to (partial_bytes_acked - cwnd). Next, cwnd
is increased by MTU.

We were first increasing cwnd, and then subtracting the new value pba,
which leads to a different result as pba is smaller than what it should
and could cause cwnd to not grow as much.

See-also: https://tools.ietf.org/html/draft-ietf-tsvwg-rfc4960-errata-01#section-3.12
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/transport.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 721eeebfcd8a50609877db61ede41575e012606a..04b6dd1a07ded25fe5874518b0944a6d9df4099b 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -452,17 +452,18 @@ void sctp_transport_raise_cwnd(struct sctp_transport *transport,
 		 * chunks acknowledged by the new Cumulative TSN Ack and by
 		 * Gap Ack Blocks.
 		 *
-		 * When partial_bytes_acked is equal to or greater than cwnd
-		 * and before the arrival of the SACK the sender had cwnd or
-		 * more bytes of data outstanding (i.e., before arrival of the
-		 * SACK, flightsize was greater than or equal to cwnd),
-		 * increase cwnd by MTU, and reset partial_bytes_acked to
-		 * (partial_bytes_acked - cwnd).
+		 * When partial_bytes_acked is equal to or greater than
+		 * cwnd and before the arrival of the SACK the sender
+		 * had cwnd or more bytes of data outstanding (i.e.,
+		 * before arrival of the SACK, flightsize was greater
+		 * than or equal to cwnd), partial_bytes_acked is reset
+		 * to (partial_bytes_acked - cwnd). Next, cwnd is
+		 * increased by MTU. (RFC 4960 Errata 3.12)
 		 */
 		pba += bytes_acked;
 		if (pba >= cwnd) {
+			pba = pba - cwnd;
 			cwnd += pmtu;
-			pba = ((cwnd < pba) ? (pba - cwnd) : 0);
 		}
 
 		pr_debug("%s: congestion avoidance: transport:%p, "
-- 
2.9.4

