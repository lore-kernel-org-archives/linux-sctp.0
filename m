From: Kevin Kou <qdkevin.kou@gmail.com>
Date: Fri, 27 Dec 2019 13:11:16 +0000
Subject: [PATCH net-next] sctp: add enabled check for path tracepoint loop.
Message-Id: <20191227131116.375-1-qdkevin.kou@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc: nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net, qdkevin.kou@gmail.com

sctp_outq_sack is the main function handles SACK, it is called very
frequently. As the commit "move trace_sctp_probe_path into sctp_outq_sack"
added below code to this function, sctp tracepoint is disabled most of time,
but the loop of transport list will be always called even though the
tracepoint is disabled, this is unnecessary.

+	/* SCTP path tracepoint for congestion control debugging. */
+	list_for_each_entry(transport, transport_list, transports) {
+		trace_sctp_probe_path(transport, asoc);
+	}

This patch is to add tracepoint enabled check at outside of the loop of
transport list, and avoid traversing the loop when trace is disabled,
it is a small optimization.

Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
---
 net/sctp/outqueue.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index adceb22..83ddcfe 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1240,8 +1240,9 @@ int sctp_outq_sack(struct sctp_outq *q, struct sctp_chunk *chunk)
 	transport_list = &asoc->peer.transport_addr_list;
 
 	/* SCTP path tracepoint for congestion control debugging. */
-	list_for_each_entry(transport, transport_list, transports) {
-		trace_sctp_probe_path(transport, asoc);
+	if (trace_sctp_probe_path_enabled()) {
+		list_for_each_entry(transport, transport_list, transports)
+			trace_sctp_probe_path(transport, asoc);
 	}
 
 	sack_ctsn = ntohl(sack->cum_tsn_ack);
-- 
1.8.3.1
