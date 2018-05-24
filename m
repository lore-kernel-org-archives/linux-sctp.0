From: Davide Caratti <dcaratti@redhat.com>
Date: Thu, 24 May 2018 15:49:35 +0000
Subject: [PATCH net-next] vrf: add CRC32c offload to device features
Message-Id: <bb3aa69eaef613f033f8f52674740286ba67dc31.1527175921.git.dcaratti@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: David Ahern <dsa@cumulusnetworks.com>, Vlad Yasevich <vyasevich@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

SCTP sockets originated in a VRF can improve their performance if CRC32c
computation is delegated to underlying devices: update device features,
setting NETIF_F_SCTP_CRC. Iterating the following command in the topology
proposed with [1],

 # ip vrf exec vrf-h2 netperf -H 192.0.2.1 -t SCTP_STREAM -- -m 10K

the measured throughput in Mbit/s improved from 2395 ± 1% to 2720 ± 1%.

[1] https://www.spinics.net/lists/netdev/msg486007.html

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 drivers/net/vrf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 90b5f3900c22..f93547f257fb 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1254,7 +1254,7 @@ static void vrf_setup(struct net_device *dev)
 
 	/* enable offload features */
 	dev->features   |= NETIF_F_GSO_SOFTWARE;
-	dev->features   |= NETIF_F_RXCSUM | NETIF_F_HW_CSUM;
+	dev->features   |= NETIF_F_RXCSUM | NETIF_F_HW_CSUM | NETIF_F_SCTP_CRC;
 	dev->features   |= NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA;
 
 	dev->hw_features = dev->features;
-- 
2.17.0

