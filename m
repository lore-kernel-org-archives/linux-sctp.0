From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 29 Sep 2020 13:48:56 +0000
Subject: [PATCH net-next 04/15] udp: support sctp over udp in skb_udp_tunnel_segment
Message-Id: <97963ca7171b92486f46477b55928182abe44806.1601387231.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
 <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
 <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, Tom Herbert <therbert@google.com>, davem@davemloft.net

To call sctp_gso_segment() properly in skb_udp_tunnel_segment() for sctp
over udp packets, we need to set transport_header to sctp header. When
skb->ip_summed = CHECKSUM_PARTIAL, skb_crc32c_csum_help() should be
called for the inner sctp packet.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/udp_offload.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index c0b010b..a484405 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -49,6 +49,7 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 	__skb_pull(skb, tnl_hlen);
 	skb_reset_mac_header(skb);
 	skb_set_network_header(skb, skb_inner_network_offset(skb));
+	skb_set_transport_header(skb, skb_inner_transport_offset(skb));
 	skb->mac_len = skb_inner_network_offset(skb);
 	skb->protocol = new_protocol;
 
@@ -131,8 +132,12 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 		uh->check = ~csum_fold(csum_add(partial,
 				       (__force __wsum)htonl(len)));
 
-		if (skb->encapsulation)
-			skb_checksum_help(skb);
+		if (skb->encapsulation) {
+			if (skb->csum_not_inet)
+				skb_crc32c_csum_help(skb);
+			else
+				skb_checksum_help(skb);
+		}
 
 		if (offload_csum) {
 			skb->ip_summed = CHECKSUM_PARTIAL;
-- 
2.1.0
