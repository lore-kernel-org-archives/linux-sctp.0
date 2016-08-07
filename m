From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 07 Aug 2016 06:15:13 +0000
Subject: [PATCH net] sctp: use event->chunk when it's valid
Message-Id: <b2a38bf9d9d9b9b10a3243149badd56fbb971c4e.1470550513.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net

Commit 52253db924d1 ("sctp: also point GSO head_skb to the sk when
it's available") used event->chunk->head_skb to get the head_skb in
sctp_ulpevent_set_owner().

But at that moment, the event->chunk was NULL, as it cloned the skb
in sctp_ulpevent_make_rcvmsg(). Therefore, that patch didn't really
work.

This patch is to move the event->chunk initialization before calling
sctp_ulpevent_receive_data() so that it uses event->chunk when it's
valid.

Fixes: 52253db924d1 ("sctp: also point GSO head_skb to the sk when it's available")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/ulpevent.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index 1bc4f71..d85b803 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -702,14 +702,14 @@ struct sctp_ulpevent *sctp_ulpevent_make_rcvmsg(struct sctp_association *asoc,
 	 */
 	sctp_ulpevent_init(event, 0, skb->len + sizeof(struct sk_buff));
 
-	sctp_ulpevent_receive_data(event, asoc);
-
 	/* And hold the chunk as we need it for getting the IP headers
 	 * later in recvmsg
 	 */
 	sctp_chunk_hold(chunk);
 	event->chunk = chunk;
 
+	sctp_ulpevent_receive_data(event, asoc);
+
 	event->stream = ntohs(chunk->subh.data_hdr->stream);
 	event->ssn = ntohs(chunk->subh.data_hdr->ssn);
 	event->ppid = chunk->subh.data_hdr->ppid;
-- 
2.1.0

