From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 30 Jul 2016 05:58:35 +0000
Subject: [PATCH net] sctp: fix the issue sctp requeue auth chunk incorrectly
Message-Id: <af1555c524101278be2e5b07ff78a1eaacc0f7bb.1469858315.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net

sctp needs to queue auth chunk back when we know that we are going
to generate another segment. But commit f1533cce60d1 ("sctp: fix
panic when sending auth chunks") requeues the last chunk processed
which is probably not the auth chunk.

It causes panic when calculating the MAC in sctp_auth_calculate_hmac(),
as the incorrect offset of the auth chunk in skb->data.

This fix is to requeue it by using packet->auth.

Fixes: f1533cce60d1 ("sctp: fix panic when sending auth chunks")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 7425f6c..1f1682b 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -610,7 +610,8 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 				/* We will generate more packets, so re-queue
 				 * auth chunk.
 				 */
-				list_add(&chunk->list, &packet->chunk_list);
+				list_add(&packet->auth->list,
+					 &packet->chunk_list);
 			} else {
 				sctp_chunk_free(packet->auth);
 				packet->auth = NULL;
-- 
2.1.0

