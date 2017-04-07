From: Davide Caratti <dcaratti@redhat.com>
Date: Fri, 07 Apr 2017 14:16:09 +0000
Subject: [PATCH RFC net-next v3 6/7] openvswitch: more accurate checksumming in queue_userspace_packet()
Message-Id: <82f2e030e76627e43d3184567f89cd76743b7cdf.1491562390.git.dcaratti@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CALx6S34cSH+z+humkp5s7UHAqnafHHB-GTqobHyb-SfKNe+MiA@mail.gmail.com>
In-Reply-To: <CALx6S34cSH+z+humkp5s7UHAqnafHHB-GTqobHyb-SfKNe+MiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tom Herbert <tom@herbertland.com>, Alexander Duyck <alexander.duyck@gmail.com>, David Laight <David.Laight@aculab.com>, "David S . Miller" <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org

if skb carries an SCTP packet and ip_summed is CHECKSUM_PARTIAL, it needs
CRC32c in place of Internet Checksum: use skb_csum_hwoffload_help to avoid
corrupting such packets while queueing them towards userspace.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/openvswitch/datapath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 9c62b63..457f40d 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -453,7 +453,7 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 
 	/* Complete checksum if needed */
 	if (skb->ip_summed = CHECKSUM_PARTIAL &&
-	    (err = skb_checksum_help(skb)))
+	    (err = skb_csum_hwoffload_help(skb, 0)))
 		goto out;
 
 	/* Older versions of OVS user space enforce alignment of the last
-- 
2.7.4

