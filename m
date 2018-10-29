From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 29 Oct 2018 15:10:29 +0000
Subject: [PATCH net] sctp: clear the transport of some out_chunk_list chunks in sctp_assoc_rm_peer
Message-Id: <f3d3a876b124a96a8e44913abfa552a278cd758c.1540825829.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

If a transport is removed by asconf but there still are some chunks with
this transport queuing on out_chunk_list, later an use-after-free issue
will be caused when accessing this transport from these chunks in
sctp_outq_flush().

This is an old bug, we fix it by clearing the transport of these chunks
in out_chunk_list when removing a transport in sctp_assoc_rm_peer().

Reported-by: syzbot+56a40ceee5fb35932f4d@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/associola.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index a827a1f..6a28b96 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -499,8 +499,9 @@ void sctp_assoc_set_primary(struct sctp_association *asoc,
 void sctp_assoc_rm_peer(struct sctp_association *asoc,
 			struct sctp_transport *peer)
 {
-	struct list_head	*pos;
-	struct sctp_transport	*transport;
+	struct sctp_transport *transport;
+	struct list_head *pos;
+	struct sctp_chunk *ch;
 
 	pr_debug("%s: association:%p addr:%pISpc\n",
 		 __func__, asoc, &peer->ipaddr.sa);
@@ -564,7 +565,6 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
 	 */
 	if (!list_empty(&peer->transmitted)) {
 		struct sctp_transport *active = asoc->peer.active_path;
-		struct sctp_chunk *ch;
 
 		/* Reset the transport of each chunk on this list */
 		list_for_each_entry(ch, &peer->transmitted,
@@ -586,6 +586,10 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
 				sctp_transport_hold(active);
 	}
 
+	list_for_each_entry(ch, &asoc->outqueue.out_chunk_list, list)
+		if (ch->transport = peer)
+			ch->transport = NULL;
+
 	asoc->peer.transport_count--;
 
 	sctp_transport_free(peer);
-- 
2.1.0
