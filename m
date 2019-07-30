From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 30 Jul 2019 12:38:19 +0000
Subject: [PATCHv2 net-next 1/5] sctp: only copy the available addr data in sctp_transport_init
Message-Id: <bb6e9856c2db0f24b91fb326fbe3c9c013f2459b.1564490276.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1564490276.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1564490276.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

'addr' passed to sctp_transport_init is not always a whole size
of union sctp_addr, like the path:

  sctp_sendmsg() ->
  sctp_sendmsg_new_asoc() ->
  sctp_assoc_add_peer() ->
  sctp_transport_new() -> sctp_transport_init()

In the next patches, we will also pass the address length of data
only to sctp_assoc_add_peer().

So sctp_transport_init() should copy the only available data from
addr to peer->ipaddr, instead of 'peer->ipaddr = *addr' which may
cause slab-out-of-bounds.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index e2f8e36..7235a60 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -43,8 +43,8 @@ static struct sctp_transport *sctp_transport_init(struct net *net,
 						  gfp_t gfp)
 {
 	/* Copy in the address.  */
-	peer->ipaddr = *addr;
 	peer->af_specific = sctp_get_af_specific(addr->sa.sa_family);
+	memcpy(&peer->ipaddr, addr, peer->af_specific->sockaddr_len);
 	memset(&peer->saddr, 0, sizeof(union sctp_addr));
 
 	peer->sack_generation = 0;
-- 
2.1.0
