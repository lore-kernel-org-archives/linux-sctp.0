From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 08 Oct 2020 09:48:08 +0000
Subject: [PATCHv2 net-next 12/17] sctp: call sk_setup_caps in sctp_packet_transmit instead
Message-Id: <ad362276ba90a8af3178f19aba15a7e67107652f.1602150362.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1602150362.git.lucien.xin@gmail.com>
 <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
 <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
 <483d9eec159b22172fe04dacd58d7f88dfc2f301.1602150362.git.lucien.xin@gmail.com>
 <17cab00046ea7fe36c8383925a4fc3fbc028c511.1602150362.git.lucien.xin@gmail.com>
 <6f5a15bba0e2b5d3da6be90fd222c5ee41691d32.1602150362.git.lucien.xin@gmail.com>
 <af7bd8219b32d7f864eaef8ed8e970fc9bde928c.1602150362.git.lucien.xin@gmail.com>
 <baba90f09cbb5de03a6216c9f6308d0e4fb2f3c1.1602150362.git.lucien.xin@gmail.com>
 <bcb5453d0f8abd3d499c8af467340ade1698af11.1602150362.git.lucien.xin@gmail.com>
 <bdbd57b89b92716d17fecce1f658c60cca261bee.1602150362.git.lucien.xin@gmail.com>
 <92d28810a72dee9d0d49e7433b65027cb52de191.1602150362.git.lucien.xin@gmail.com>
 <1128490426bfb52572ba338e7a631658da49f34c.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <1128490426bfb52572ba338e7a631658da49f34c.1602150362.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net

sk_setup_caps() was originally called in Commit 90017accff61 ("sctp:
Add GSO support"), as:

  "We have to refresh this in case we are xmiting to more than one
   transport at a time"

This actually happens in the loop of sctp_outq_flush_transports(),
and it shouldn't be tied to gso, so move it out of gso part and
before sctp_packet_pack().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/output.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 1441eaf..fb16500 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -508,12 +508,6 @@ static int sctp_packet_pack(struct sctp_packet *packet,
 					sizeof(struct inet6_skb_parm)));
 		skb_shinfo(head)->gso_segs = pkt_count;
 		skb_shinfo(head)->gso_size = GSO_BY_FRAGS;
-		rcu_read_lock();
-		if (skb_dst(head) != tp->dst) {
-			dst_hold(tp->dst);
-			sk_setup_caps(sk, tp->dst);
-		}
-		rcu_read_unlock();
 		goto chksum;
 	}
 
@@ -593,6 +587,13 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 	}
 	skb_dst_set(head, dst);
 
+	rcu_read_lock();
+	if (__sk_dst_get(sk) != tp->dst) {
+		dst_hold(tp->dst);
+		sk_setup_caps(sk, tp->dst);
+	}
+	rcu_read_unlock();
+
 	/* pack up chunks */
 	pkt_count = sctp_packet_pack(packet, head, gso, gfp);
 	if (!pkt_count) {
-- 
2.1.0
