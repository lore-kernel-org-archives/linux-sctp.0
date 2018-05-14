From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 14 May 2018 17:34:41 +0000
Subject: [PATCH net-next v3 6/8] sctp: move transport flush code out of sctp_outq_flush
Message-Id: <875fc90196a94e4353966cd3e1d3afd91b81e151.1526318522.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1526318522.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1526318522.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>

To the new sctp_outq_flush_transports.

Comment on Nagle is outdated and removed. Nagle is performed earlier, while
checking if the chunk fits the packet: if the outq length is not enough to
fill the packet, it returns SCTP_XMIT_DELAY.

So by when it gets to sctp_outq_flush_transports, it has to go through all
enlisted transports.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/outqueue.c | 56 +++++++++++++++++++++++++----------------------------
 1 file changed, 26 insertions(+), 30 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index bfa2e43dfd31d115862b65d1650858fcaa6f203b..44465e64857b79636a78917a12776402ccb8f990 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1176,6 +1176,29 @@ static void sctp_outq_flush_data(struct sctp_outq *q,
 	}
 }
 
+static void sctp_outq_flush_transports(struct sctp_outq *q,
+				       struct list_head *transport_list,
+				       gfp_t gfp)
+{
+	struct list_head *ltransport;
+	struct sctp_packet *packet;
+	struct sctp_transport *t;
+	int error = 0;
+
+	while ((ltransport = sctp_list_dequeue(transport_list)) != NULL) {
+		t = list_entry(ltransport, struct sctp_transport, send_ready);
+		packet = &t->packet;
+		if (!sctp_packet_empty(packet)) {
+			error = sctp_packet_transmit(packet, gfp);
+			if (error < 0)
+				q->asoc->base.sk->sk_err = -error;
+		}
+
+		/* Clear the burst limited state, if any */
+		sctp_transport_burst_reset(t);
+	}
+}
+
 /*
  * Try to flush an outqueue.
  *
@@ -1187,17 +1210,10 @@ static void sctp_outq_flush_data(struct sctp_outq *q,
  */
 static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 {
-	struct sctp_packet *packet;
-	struct sctp_association *asoc = q->asoc;
+	/* Current transport being used. It's NOT the same as curr active one */
 	struct sctp_transport *transport = NULL;
-	int error = 0;
-
 	/* These transports have chunks to send. */
-	struct list_head transport_list;
-	struct list_head *ltransport;
-
-	INIT_LIST_HEAD(&transport_list);
-	packet = NULL;
+	LIST_HEAD(transport_list);
 
 	/*
 	 * 6.10 Bundling
@@ -1218,27 +1234,7 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 
 sctp_flush_out:
 
-	/* Before returning, examine all the transports touched in
-	 * this call.  Right now, we bluntly force clear all the
-	 * transports.  Things might change after we implement Nagle.
-	 * But such an examination is still required.
-	 *
-	 * --xguo
-	 */
-	while ((ltransport = sctp_list_dequeue(&transport_list)) != NULL) {
-		struct sctp_transport *t = list_entry(ltransport,
-						      struct sctp_transport,
-						      send_ready);
-		packet = &t->packet;
-		if (!sctp_packet_empty(packet)) {
-			error = sctp_packet_transmit(packet, gfp);
-			if (error < 0)
-				asoc->base.sk->sk_err = -error;
-		}
-
-		/* Clear the burst limited state, if any */
-		sctp_transport_burst_reset(t);
-	}
+	sctp_outq_flush_transports(q, &transport_list, gfp);
 }
 
 /* Update unack_data based on the incoming SACK chunk */
-- 
2.14.3

