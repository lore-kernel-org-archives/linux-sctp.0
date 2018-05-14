From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 14 May 2018 17:34:36 +0000
Subject: [PATCH net-next v3 1/8] sctp: add sctp_packet_singleton
Message-Id: <5c6e1ac9cc236d6c9bff13212986e4cd23ea387f.1526318522.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1526318522.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1526318522.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>

Factor out the code for generating singletons. It's used only once, but
helps to keep the context contained.

The const variables are to ease the reading of subsequent calls in there.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/outqueue.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index dee7cbd5483149024f2f3195db2fe4d473b1a00a..300bd0dfc7c14c9df579dbe2f9e78dd8356ae1a3 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -776,6 +776,20 @@ void sctp_outq_uncork(struct sctp_outq *q, gfp_t gfp)
 	sctp_outq_flush(q, 0, gfp);
 }
 
+static int sctp_packet_singleton(struct sctp_transport *transport,
+				 struct sctp_chunk *chunk, gfp_t gfp)
+{
+	const struct sctp_association *asoc = transport->asoc;
+	const __u16 sport = asoc->base.bind_addr.port;
+	const __u16 dport = asoc->peer.port;
+	const __u32 vtag = asoc->peer.i.init_tag;
+	struct sctp_packet singleton;
+
+	sctp_packet_init(&singleton, transport, sport, dport);
+	sctp_packet_config(&singleton, vtag, 0);
+	sctp_packet_append_chunk(&singleton, chunk);
+	return sctp_packet_transmit(&singleton, gfp);
+}
 
 /*
  * Try to flush an outqueue.
@@ -789,10 +803,7 @@ void sctp_outq_uncork(struct sctp_outq *q, gfp_t gfp)
 static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 {
 	struct sctp_packet *packet;
-	struct sctp_packet singleton;
 	struct sctp_association *asoc = q->asoc;
-	__u16 sport = asoc->base.bind_addr.port;
-	__u16 dport = asoc->peer.port;
 	__u32 vtag = asoc->peer.i.init_tag;
 	struct sctp_transport *transport = NULL;
 	struct sctp_transport *new_transport;
@@ -905,10 +916,7 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 		case SCTP_CID_INIT:
 		case SCTP_CID_INIT_ACK:
 		case SCTP_CID_SHUTDOWN_COMPLETE:
-			sctp_packet_init(&singleton, transport, sport, dport);
-			sctp_packet_config(&singleton, vtag, 0);
-			sctp_packet_append_chunk(&singleton, chunk);
-			error = sctp_packet_transmit(&singleton, gfp);
+			error = sctp_packet_singleton(transport, chunk, gfp);
 			if (error < 0) {
 				asoc->base.sk->sk_err = -error;
 				return;
-- 
2.14.3

