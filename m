From: Vladislav Yasevich <vyasevich@gmail.com>
Date: Wed, 02 May 2018 02:07:35 +0000
Subject: [PATCH V2 net-next 2/6] sctp: Handle sctp packets with CHECKSUM_PARTIAL
Message-Id: <20180502020739.19239-3-vyasevic@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180502020739.19239-1-vyasevic@redhat.com>
In-Reply-To: <20180502020739.19239-1-vyasevic@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org, mst@redhat.com, jasowang@redhat.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, Vladislav Yasevich <vyasevic@redhat.com>

With SCTP checksum offload available in virtio, it is now
possible for virtio to receive a sctp packet with CHECKSUM_PARTIAL
set (guest-to-guest traffic).  SCTP doesn't really have a
partial checksum like TCP does, because CRC32c can't do partial
additive checksumming.  It's all or nothing.  So an SCTP packet
with CHECKSUM_PARTIAL will have checksum set to 0.  Let SCTP
treat this as a valid checksum if CHECKSUM_PARTIAL is set.

Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
---
 net/sctp/input.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index ba8a6e6..055b8ffa 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -80,8 +80,17 @@ static inline int sctp_rcv_checksum(struct net *net, struct sk_buff *skb)
 {
 	struct sctphdr *sh = sctp_hdr(skb);
 	__le32 cmp = sh->checksum;
-	__le32 val = sctp_compute_cksum(skb, 0);
+	__le32 val = 0;
 
+	/* In sctp PARTIAL checksum is always 0.  This is a case of
+	 * a packet received from guest that supports checksum offload.
+	 * Assume it's correct as there is really no way to verify,
+	 * and we want to avaoid computing it unnecesarily.
+	 */
+	if (skb->ip_summed = CHECKSUM_PARTIAL)
+		return 0;
+
+	val = sctp_compute_cksum(skb, 0);
 	if (val != cmp) {
 		/* CRC failure, dump it. */
 		__SCTP_INC_STATS(net, SCTP_MIB_CHECKSUMERRORS);
-- 
2.9.5

