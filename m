From: Chang Xiangzhong <changxiangzhong@gmail.com>
Date: Thu, 12 Dec 2013 20:42:32 +0000
Subject: Try to Implement load balancer for transmit & retransmit
Message-Id: <1386880952-18756-1-git-send-email-changxiangzhong@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

The current implementation uses only one path as the "active path" and one
path as a "retran path". This patch tries to use all of the pathes for
transmission. But I'm afraid there must be something missing, such things like
state update and etcs. 

The current implementation is very simple - just distribute the load on all of
the pathes - just check if it satisifes cwnd>flight_size.

And comments would be appreciated! 
---
 include/net/sctp/cmt.h   |    5 +++-
 net/sctp/Makefile        |    4 +--
 net/sctp/associola.c     |   33 +++++++++++++++++++--
 net/sctp/cmt_debug.c     |    2 +-
 net/sctp/outqueue.c      |   73 +++++++++++++++++++++++++++++++++++-----------
 net/sctp/protocol.c      |    1 +
 net/sctp/sm_sideeffect.c |    2 +-
 7 files changed, 95 insertions(+), 25 deletions(-)

diff --git a/include/net/sctp/cmt.h b/include/net/sctp/cmt.h
index edbbfc2..858def8 100644
--- a/include/net/sctp/cmt.h
+++ b/include/net/sctp/cmt.h
@@ -47,8 +47,11 @@
 	extern char* cmt_print_assoc(struct sctp_association *asoc);
 	extern char* cmt_print_sackhdr(struct sctp_sackhdr *sack);
 	extern char* cmt_print_queued_tsn(struct list_head *queue, 
-					  struct sctp_transport *transport);
+					  struct sctp_transport *t);
 	extern char* cmt_print_cwnd(struct list_head *transport_list);
+	
+	extern struct sctp_transport* sctp_assoc_most_vacant_path(
+			struct sctp_association *asoc);
 #endif
 
 /* SACK Chunk Specific Flags*/
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 626bdca..28f1f60 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1295,6 +1295,33 @@ void sctp_assoc_update(struct sctp_association *asoc,
 	sctp_auth_asoc_init_active_key(asoc, GFP_ATOMIC);
 }
 
+struct sctp_transport*
+sctp_assoc_most_vacant_path(struct sctp_association *asoc, int threshold)
+{
+	struct sctp_transport *t, *ret = NULL;
+	int vacancy, best=-1;
+	if (threshold < 0)
+		threshold = 0;
+	list_for_each_entry(t, &asoc->peer.transport_addr_list, transports) {
+		vacancy = t->cwnd - t->flight_size;
+		if (t->state != SCTP_ACTIVE || vacancy <= threshold /*t->pathmtu/4*/)
+			continue;
+		// This is in slow-start state
+		if (t->ssthresh > t->cwnd) {
+			ret = t;
+			break;
+		}
+		if (vacancy > best) {
+			best = vacancy;
+			ret = t;	
+		}
+
+
+	}
+	cmt_debug("==>Find a most vacant path: %p\n", ret);
+	return ret;
+}
+

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index d20816d..9010080 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -57,13 +57,13 @@
 
 #include <net/sctp/sctp.h>
 #include <net/sctp/sm.h>
-#include <net/sctp/cmt_debug.h>
+#include <net/sctp/cmt.h>
 
 
 /* Declare internal functions here.  */
@@ -920,14 +920,32 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 		 * current cwnd).
 		 */
 		if (!list_empty(&q->retransmit)) {
-			if (asoc->peer.retran_path->state = SCTP_UNCONFIRMED)
-				goto sctp_flush_out;
-			if (transport = asoc->peer.retran_path)
-				goto retran;
 
-			/* Switch transports & prepare the packet.  */
-
-			transport = asoc->peer.retran_path;
+if (q->fast_rtx && !rtx_timeout)
+{
+	struct sctp_chunk *chunk, *chunk1;
+	int chunk_size = 0; // not count the header!
+	list_for_each_entry_safe(
+			chunk, chunk1, &q->retransmit, transmitted_list) {
+		// not the one to fast_rtx
+		if (sctp_chunk_abandoned(chunk) 
+		    || chunk->tsn_gap_acked
+		    || !chunk->fast_retransmit) {
+			continue;
+		}
+		// found the chunk to fast_rtx
+		chunk_size = ntohs(chunk->chunk_hdr->length);
+		break;	
+	}
+	transport = sctp_assoc_most_vacant_path(asoc, chunk_size);
+	cmt_debug("%s: fast_rtx most vacant=%p, chunk_size=%d", __func__, transport, chunk_size);
+} else {
+	transport = sctp_assoc_most_vacant_path(asoc, -1);
+}
+			if (!transport) {
+				cmt_debug("could not find a vacant path!\n");
+				goto sctp_flush_out;
+			}
 
 			if (list_empty(&transport->send_ready)) {
 				list_add_tail(&transport->send_ready,
@@ -989,12 +1007,22 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 			/* If there is a specified transport, use it.
 			 * Otherwise, we want to use the active path.
 			 */
-			new_transport = chunk->transport;
+			bool path_specified;
+retry:			new_transport = chunk->transport;
 			if (!new_transport ||
 			    ((new_transport->state = SCTP_INACTIVE) ||
 			     (new_transport->state = SCTP_UNCONFIRMED) ||
-			     (new_transport->state = SCTP_PF)))
-				new_transport = asoc->peer.active_path;
+			     (new_transport->state = SCTP_PF))) {
+				path_specified = false;
+				// new_transport = asoc->peer.active_path;
+				new_transport = sctp_assoc_most_vacant_path(
+						asoc, -1);
+				if (!new_transport) {// no available path
+					sctp_outq_head_data(q, chunk);
+					goto sctp_flush_out;
+				}
+			} else 
+				path_specified = true;
 			if (new_transport->state = SCTP_UNCONFIRMED)
 				continue;
 
@@ -1032,7 +1060,18 @@ static int sctp_outq_flush(struct sctp_outq *q, int rtx_timeout)
 
 			switch (status) {
 			case SCTP_XMIT_CWND_FULL:// 3
-			case SCTP_XMIT_PMTU_FULL://1
+				cmt_debug("==>CWND full\n");
+				// The App didn't specify a path, so the path
+				// was chosen by us. Then we could retry with
+				// another path
+				if (!path_specified) {
+					cmt_debug("==>retry!\n");
+					goto retry;
+				}	       
+			// PMTU_FULL not likely. As sctp_packet_transmit_chunk
+			// would flush the transport and transmit the next 
+			// chunk in the queue if PMTU_FULL happens.
+			case SCTP_XMIT_PMTU_FULL://1 
 			case SCTP_XMIT_RWND_FULL://2
 			case SCTP_XMIT_NAGLE_DELAY://4
 				/* We could not append this chunk, so put
