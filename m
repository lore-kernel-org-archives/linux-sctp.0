From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 08 Oct 2020 09:47:58 +0000
Subject: [PATCHv2 net-next 02/17] udp6: move the mss check after udp gso tunnel processing
Message-Id: <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1602150362.git.lucien.xin@gmail.com>
 <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net

For some protocol's gso, like SCTP, it's using GSO_BY_FRAGS for
gso_size. When using UDP to encapsulate its packet, it will
return error in udp6_ufo_fragment() as skb->len < gso_size,
and it will never go to the gso tunnel processing.

So we should move this check after udp gso tunnel processing,
the same as udp4_ufo_fragment() does. While at it, also tidy
the variables up.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/udp_offload.c | 154 ++++++++++++++++++++++++-------------------------
 1 file changed, 76 insertions(+), 78 deletions(-)

diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 584157a..3c5ec8e 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -17,96 +17,94 @@
 static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 					 netdev_features_t features)
 {
+	u8 nexthdr, frag_hdr_sz = sizeof(struct frag_hdr);
+	unsigned int unfrag_ip6hlen, unfrag_len, mss;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
-	unsigned int mss;
-	unsigned int unfrag_ip6hlen, unfrag_len;
-	struct frag_hdr *fptr;
+	const struct ipv6hdr *ipv6h;
 	u8 *packet_start, *prevhdr;
-	u8 nexthdr;
-	u8 frag_hdr_sz = sizeof(struct frag_hdr);
+	struct frag_hdr *fptr;
+	int tnl_hlen, err;
+	struct udphdr *uh;
 	__wsum csum;
-	int tnl_hlen;
-	int err;
 
-	mss = skb_shinfo(skb)->gso_size;
-	if (unlikely(skb->len <= mss))
+	if (skb->encapsulation &&
+	    (skb_shinfo(skb)->gso_type &
+	     (SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM))) {
+		segs = skb_udp_tunnel_segment(skb, features, true);
 		goto out;
+	}
 
-	if (skb->encapsulation && skb_shinfo(skb)->gso_type &
-	    (SKB_GSO_UDP_TUNNEL|SKB_GSO_UDP_TUNNEL_CSUM))
-		segs = skb_udp_tunnel_segment(skb, features, true);
-	else {
-		const struct ipv6hdr *ipv6h;
-		struct udphdr *uh;
+	if (!(skb_shinfo(skb)->gso_type & (SKB_GSO_UDP | SKB_GSO_UDP_L4)))
+		goto out;
 
-		if (!(skb_shinfo(skb)->gso_type & (SKB_GSO_UDP | SKB_GSO_UDP_L4)))
-			goto out;
+	if (!pskb_may_pull(skb, sizeof(struct udphdr)))
+		goto out;
 
-		if (!pskb_may_pull(skb, sizeof(struct udphdr)))
-			goto out;
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
+		return __udp_gso_segment(skb, features);
 
-		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
-			return __udp_gso_segment(skb, features);
-
-		/* Do software UFO. Complete and fill in the UDP checksum as HW cannot
-		 * do checksum of UDP packets sent as multiple IP fragments.
-		 */
-
-		uh = udp_hdr(skb);
-		ipv6h = ipv6_hdr(skb);
-
-		uh->check = 0;
-		csum = skb_checksum(skb, 0, skb->len, 0);
-		uh->check = udp_v6_check(skb->len, &ipv6h->saddr,
-					  &ipv6h->daddr, csum);
-		if (uh->check = 0)
-			uh->check = CSUM_MANGLED_0;
-
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-
-		/* If there is no outer header we can fake a checksum offload
-		 * due to the fact that we have already done the checksum in
-		 * software prior to segmenting the frame.
-		 */
-		if (!skb->encap_hdr_csum)
-			features |= NETIF_F_HW_CSUM;
-
-		/* Check if there is enough headroom to insert fragment header. */
-		tnl_hlen = skb_tnl_header_len(skb);
-		if (skb->mac_header < (tnl_hlen + frag_hdr_sz)) {
-			if (gso_pskb_expand_head(skb, tnl_hlen + frag_hdr_sz))
-				goto out;
-		}
+	mss = skb_shinfo(skb)->gso_size;
+	if (unlikely(skb->len <= mss))
+		goto out;
 
-		/* Find the unfragmentable header and shift it left by frag_hdr_sz
-		 * bytes to insert fragment header.
-		 */
-		err = ip6_find_1stfragopt(skb, &prevhdr);
-		if (err < 0)
-			return ERR_PTR(err);
-		unfrag_ip6hlen = err;
-		nexthdr = *prevhdr;
-		*prevhdr = NEXTHDR_FRAGMENT;
-		unfrag_len = (skb_network_header(skb) - skb_mac_header(skb)) +
-			     unfrag_ip6hlen + tnl_hlen;
-		packet_start = (u8 *) skb->head + SKB_GSO_CB(skb)->mac_offset;
-		memmove(packet_start-frag_hdr_sz, packet_start, unfrag_len);
-
-		SKB_GSO_CB(skb)->mac_offset -= frag_hdr_sz;
-		skb->mac_header -= frag_hdr_sz;
-		skb->network_header -= frag_hdr_sz;
-
-		fptr = (struct frag_hdr *)(skb_network_header(skb) + unfrag_ip6hlen);
-		fptr->nexthdr = nexthdr;
-		fptr->reserved = 0;
-		fptr->identification = ipv6_proxy_select_ident(dev_net(skb->dev), skb);
-
-		/* Fragment the skb. ipv6 header and the remaining fields of the
-		 * fragment header are updated in ipv6_gso_segment()
-		 */
-		segs = skb_segment(skb, features);
+	/* Do software UFO. Complete and fill in the UDP checksum as HW cannot
+	 * do checksum of UDP packets sent as multiple IP fragments.
+	 */
+
+	uh = udp_hdr(skb);
+	ipv6h = ipv6_hdr(skb);
+
+	uh->check = 0;
+	csum = skb_checksum(skb, 0, skb->len, 0);
+	uh->check = udp_v6_check(skb->len, &ipv6h->saddr,
+				 &ipv6h->daddr, csum);
+	if (uh->check = 0)
+		uh->check = CSUM_MANGLED_0;
+
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+	/* If there is no outer header we can fake a checksum offload
+	 * due to the fact that we have already done the checksum in
+	 * software prior to segmenting the frame.
+	 */
+	if (!skb->encap_hdr_csum)
+		features |= NETIF_F_HW_CSUM;
+
+	/* Check if there is enough headroom to insert fragment header. */
+	tnl_hlen = skb_tnl_header_len(skb);
+	if (skb->mac_header < (tnl_hlen + frag_hdr_sz)) {
+		if (gso_pskb_expand_head(skb, tnl_hlen + frag_hdr_sz))
+			goto out;
 	}
 
+	/* Find the unfragmentable header and shift it left by frag_hdr_sz
+	 * bytes to insert fragment header.
+	 */
+	err = ip6_find_1stfragopt(skb, &prevhdr);
+	if (err < 0)
+		return ERR_PTR(err);
+	unfrag_ip6hlen = err;
+	nexthdr = *prevhdr;
+	*prevhdr = NEXTHDR_FRAGMENT;
+	unfrag_len = (skb_network_header(skb) - skb_mac_header(skb)) +
+		     unfrag_ip6hlen + tnl_hlen;
+	packet_start = (u8 *)skb->head + SKB_GSO_CB(skb)->mac_offset;
+	memmove(packet_start - frag_hdr_sz, packet_start, unfrag_len);
+
+	SKB_GSO_CB(skb)->mac_offset -= frag_hdr_sz;
+	skb->mac_header -= frag_hdr_sz;
+	skb->network_header -= frag_hdr_sz;
+
+	fptr = (struct frag_hdr *)(skb_network_header(skb) + unfrag_ip6hlen);
+	fptr->nexthdr = nexthdr;
+	fptr->reserved = 0;
+	fptr->identification = ipv6_proxy_select_ident(dev_net(skb->dev), skb);
+
+	/* Fragment the skb. ipv6 header and the remaining fields of the
+	 * fragment header are updated in ipv6_gso_segment()
+	 */
+	segs = skb_segment(skb, features);
+
 out:
 	return segs;
 }
-- 
2.1.0
