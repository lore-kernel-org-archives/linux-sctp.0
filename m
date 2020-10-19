From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 19 Oct 2020 12:25:19 +0000
Subject: [PATCHv4 net-next 02/16] udp6: move the mss check after udp gso tunnel processing
Message-Id: <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net, gnault@redhat.com, pabeni@redhat.com, willemdebruijn.kernel@gmail.com

For some protocol's gso, like SCTP, it's using GSO_BY_FRAGS for
gso_size. When using UDP to encapsulate its packet, it will
return error in udp6_ufo_fragment() as skb->len < gso_size,
and it will never go to the gso tunnel processing.

So we should move this check after udp gso tunnel processing,
the same as udp4_ufo_fragment() does.

v1->v2:
  - no change.
v2->v3:
  - not do any cleanup.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv6/udp_offload.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 584157a..aa602af 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -28,10 +28,6 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 	int tnl_hlen;
 	int err;
 
-	mss = skb_shinfo(skb)->gso_size;
-	if (unlikely(skb->len <= mss))
-		goto out;
-
 	if (skb->encapsulation && skb_shinfo(skb)->gso_type &
 	    (SKB_GSO_UDP_TUNNEL|SKB_GSO_UDP_TUNNEL_CSUM))
 		segs = skb_udp_tunnel_segment(skb, features, true);
@@ -48,6 +44,10 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
 			return __udp_gso_segment(skb, features);
 
+		mss = skb_shinfo(skb)->gso_size;
+		if (unlikely(skb->len <= mss))
+			goto out;
+
 		/* Do software UFO. Complete and fill in the UDP checksum as HW cannot
 		 * do checksum of UDP packets sent as multiple IP fragments.
 		 */
-- 
2.1.0
