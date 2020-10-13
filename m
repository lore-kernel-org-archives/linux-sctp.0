From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 13 Oct 2020 07:27:28 +0000
Subject: [PATCHv3 net-next 03/16] udp: support sctp over udp in skb_udp_tunnel_segment
Message-Id: <dbad21ff524e119f83ae4444d1ae393ab165fa7c.1602574012.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
 <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net, gnault@redhat.com, pabeni@redhat.com, willemdebruijn.kernel@gmail.com

For the gso of sctp over udp packets, sctp_gso_segment() will be called in
skb_udp_tunnel_segment(), we need to set transport_header to sctp header.

As all the current HWs can't handle both crc checksum and udp checksum at
the same time, the crc checksum has to be done in sctp_gso_segment() by
removing the NETIF_F_SCTP_CRC flag from the features.

Meanwhile, if the HW can't do udp checksum, csum and csum_start has to be
set correctly, and udp checksum will be done in __skb_udp_tunnel_segment()
by calling gso_make_checksum().

Thanks to Paolo, Marcelo and Guillaume for helping with this one.

v1->v2:
  - no change.
v2->v3:
  - remove the he NETIF_F_SCTP_CRC flag from the features.
  - set csum and csum_start in sctp_gso_make_checksum().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/udp_offload.c | 3 +++
 net/sctp/offload.c     | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index e67a66f..4d31255 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -49,6 +49,7 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 	__skb_pull(skb, tnl_hlen);
 	skb_reset_mac_header(skb);
 	skb_set_network_header(skb, skb_inner_network_offset(skb));
+	skb_set_transport_header(skb, skb_inner_transport_offset(skb));
 	skb->mac_len = skb_inner_network_offset(skb);
 	skb->protocol = new_protocol;
 
@@ -67,6 +68,8 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 				      (NETIF_F_HW_CSUM | NETIF_F_IP_CSUM))));
 
 	features &= skb->dev->hw_enc_features;
+	/* CRC checksum can't be handled by HW when it's a udp tunneling packet. */
+	features &= ~NETIF_F_SCTP_CRC;
 
 	/* The only checksum offload we care about from here on out is the
 	 * outer one so strip the existing checksum feature flags and
diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index 74847d6..9f6f818 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -27,7 +27,11 @@ static __le32 sctp_gso_make_checksum(struct sk_buff *skb)
 {
 	skb->ip_summed = CHECKSUM_NONE;
 	skb->csum_not_inet = 0;
-	gso_reset_checksum(skb, ~0);
+	/* csum and csum_start in gso cb may be needed to do the udp
+	 * checksum when it's a udp tunneling packet.
+	 */
+	SKB_GSO_CB(skb)->csum = (__force __wsum)~0;
+	SKB_GSO_CB(skb)->csum_start = skb_headroom(skb) + skb->len;
 	return sctp_compute_cksum(skb, skb_transport_offset(skb));
 }
 
-- 
2.1.0
