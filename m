From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 29 Sep 2020 13:48:55 +0000
Subject: [PATCH net-next 03/15] udp: do checksum properly in skb_udp_tunnel_segment
Message-Id: <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
 <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, Tom Herbert <therbert@google.com>, davem@davemloft.net

This patch fixes two things:

  When skb->ip_summed = CHECKSUM_PARTIAL, skb_checksum_help() should be
  called do the checksum, instead of gso_make_checksum(), which is used
  to do the checksum for current proto after calling skb_segment(), not
  after the inner proto's gso_segment().

  When offload_csum is disabled, the hardware will not do the checksum
  for the current proto, udp. So instead of calling gso_make_checksum(),
  it should calculate checksum for udp itself.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/udp_offload.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index e67a66f..c0b010b 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -131,14 +131,15 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 		uh->check = ~csum_fold(csum_add(partial,
 				       (__force __wsum)htonl(len)));
 
-		if (skb->encapsulation || !offload_csum) {
-			uh->check = gso_make_checksum(skb, ~uh->check);
-			if (uh->check = 0)
-				uh->check = CSUM_MANGLED_0;
-		} else {
+		if (skb->encapsulation)
+			skb_checksum_help(skb);
+
+		if (offload_csum) {
 			skb->ip_summed = CHECKSUM_PARTIAL;
 			skb->csum_start = skb_transport_header(skb) - skb->head;
 			skb->csum_offset = offsetof(struct udphdr, check);
+		} else {
+			uh->check = csum_fold(skb_checksum(skb, udp_offset, len, 0));
 		}
 	} while ((skb = skb->next));
 out:
-- 
2.1.0
