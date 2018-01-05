From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 05 Jan 2018 13:17:17 +0000
Subject: [PATCH net v3 1/2] sctp: do not retransmit upon FragNeeded if PMTU discovery is disabled
Message-Id: <eb7d3a0d82ec330da624712e7c972834f9f4184e.1515152627.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1515152627.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1515152627.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Xin Long <lucien.xin@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, marcelo.leitner@gmail.com

Currently, if PMTU discovery is disabled on a given transport, but the
configured value is higher than the actual PMTU, it is likely that we
will get some icmp Frag Needed. The issue is, if PMTU discovery is
disabled, we won't update the information and will issue a
retransmission immediately, which may very well trigger another ICMP,
and another retransmission, leading to a loop.

The fix is to simply not trigger immediate retransmissions if PMTU
discovery is disabled on the given transport.

Changes from v2:
- updated stale comment, noticed by Xin Long

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/input.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 621b5ca3fd1c17c3d7ef7bb1c7677ab98cebbe77..9320661cc41da0b280f69f379128ab7d062e5528 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -399,20 +399,20 @@ void sctp_icmp_frag_needed(struct sock *sk, struct sctp_association *asoc,
 		return;
 	}
 
-	if (t->param_flags & SPP_PMTUD_ENABLE) {
-		/* Update transports view of the MTU */
-		sctp_transport_update_pmtu(t, pmtu);
+	if (!(t->param_flags & SPP_PMTUD_ENABLE))
+		/* We can't allow retransmitting in such case, as the
+		 * retransmission would be sized just as before, and thus we
+		 * would get another icmp, and retransmit again.
+		 */
+		return;
 
-		/* Update association pmtu. */
-		sctp_assoc_sync_pmtu(asoc);
-	}
+	/* Update transports view of the MTU */
+	sctp_transport_update_pmtu(t, pmtu);
 
-	/* Retransmit with the new pmtu setting.
-	 * Normally, if PMTU discovery is disabled, an ICMP Fragmentation
-	 * Needed will never be sent, but if a message was sent before
-	 * PMTU discovery was disabled that was larger than the PMTU, it
-	 * would not be fragmented, so it must be re-transmitted fragmented.
-	 */
+	/* Update association pmtu. */
+	sctp_assoc_sync_pmtu(asoc);
+
+	/* Retransmit with the new pmtu setting. */
 	sctp_retransmit(&asoc->outqueue, t, SCTP_RTXR_PMTUD);
 }
 
-- 
2.14.3

