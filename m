From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 03 Jan 2018 22:59:51 +0000
Subject: [PATCH net v2 1/2] sctp: do not retransmit upon FragNeeded if PMTU discovery is disabled
Message-Id: <f96c4b84a1d19d16424cca1eaafc382d4bcd313b.1515020059.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1515020059.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1515020059.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Xin Long <lucien.xin@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Currently, if PMTU discovery is disabled on a given transport, but the
configured value is higher than the actual PMTU, it is likely that we
will get some icmp Frag Needed. The issue is, if PMTU discovery is
disabled, we won't update the information and will issue a
retransmission immediately, which may very well trigger another ICMP,
and another retransmission, leading to a loop.

The fix is to simply not trigger immediate retransmissions if PMTU
discovery is disabled on the given transport.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/input.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 621b5ca3fd1c17c3d7ef7bb1c7677ab98cebbe77..4a8e76f4834c90de9398455862423e598b8354a7 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -399,13 +399,18 @@ void sctp_icmp_frag_needed(struct sock *sk, struct sctp_association *asoc,
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
+
+	/* Update association pmtu. */
+	sctp_assoc_sync_pmtu(asoc);
 
 	/* Retransmit with the new pmtu setting.
 	 * Normally, if PMTU discovery is disabled, an ICMP Fragmentation
-- 
2.14.3

