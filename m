From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 21 Jan 2019 18:42:09 +0000
Subject: [PATCH net] sctp: set chunk transport correctly when it's a new asoc
Message-Id: <d08f8708003363950333c0690960ce3d97897bd4.1548096129.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

In the paths:

  sctp_sf_do_unexpected_init() ->
    sctp_make_init_ack()
  sctp_sf_do_dupcook_a/b()() ->
    sctp_sf_do_5_1D_ce()

The new chunk 'retval' transport is set from the incoming chunk 'chunk'
transport. However, 'retval' transport belong to the new asoc, which
is a different one from 'chunk' transport's asoc.

It will cause that the 'retval' chunk gets set with a wrong transport.
Later when sending it and because of Commit b9fd683982c9 ("sctp: add
sctp_packet_singleton"), sctp_packet_singleton() will set some fields,
like vtag to 'retval' chunk from that wrong transport's asoc.

This patch is to fix it by setting 'retval' transport correctly which
belongs to the right asoc in sctp_make_init_ack() and
sctp_sf_do_5_1D_ce().

Fixes: b9fd683982c9 ("sctp: add sctp_packet_singleton")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_make_chunk.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index f4ac6c5..d05c576 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -495,7 +495,10 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
 	 *
 	 * [INIT ACK back to where the INIT came from.]
 	 */
-	retval->transport = chunk->transport;
+	if (chunk->transport)
+		retval->transport +			sctp_assoc_lookup_paddr(asoc,
+						&chunk->transport->ipaddr);
 
 	retval->subh.init_hdr  		sctp_addto_chunk(retval, sizeof(initack), &initack);
@@ -642,8 +645,10 @@ struct sctp_chunk *sctp_make_cookie_ack(const struct sctp_association *asoc,
 	 *
 	 * [COOKIE ACK back to where the COOKIE ECHO came from.]
 	 */
-	if (retval && chunk)
-		retval->transport = chunk->transport;
+	if (retval && chunk && chunk->transport)
+		retval->transport +			sctp_assoc_lookup_paddr(asoc,
+						&chunk->transport->ipaddr);
 
 	return retval;
 }
-- 
2.1.0
