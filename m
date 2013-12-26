From: Wang Weidong <wangweidong1@huawei.com>
Date: Thu, 26 Dec 2013 05:55:56 +0000
Subject: [PATCH net-next v2] sctp: move skb_dst_set() a bit downwards in sctp_packet_transmit()
Message-Id: <52BBC4EC.2070303@huawei.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52BA8DA2.6030405@huawei.com>
In-Reply-To: <52BA8DA2.6030405@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, David Miller <davem@davemloft.net>
Cc: Daniel Borkmann <dborkman@redhat.com>, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

skb_dst_set will use dst, if dst is NULL although is not a problem,
then goto the 'no_route' and free nskb, so do the skb_dst_set is pointless.
so move the skb_dst_set after dst check.
Remove the unnecessary initialization as well.

v2: fix the subject line because it would confuse people,
    as pointed out by Daniel.

Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 net/sctp/output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 3be70a4..9b76d62 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -387,7 +387,7 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	int err = 0;
 	int padding;		/* How much padding do we need?  */
 	__u8 has_data = 0;
-	struct dst_entry *dst = tp->dst;
+	struct dst_entry *dst;
 	unsigned char *auth = NULL;	/* pointer to auth in skb data */
 
 	pr_debug("%s: packet:%p\n", __func__, packet);
@@ -420,9 +420,9 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 		}
 	}
 	dst = dst_clone(tp->dst);
-	skb_dst_set(nskb, dst);
 	if (!dst)
 		goto no_route;
+	skb_dst_set(nskb, dst);
 
 	/* Build the SCTP header.  */
 	sh = (struct sctphdr *)skb_push(nskb, sizeof(struct sctphdr));
-- 
1.7.12



