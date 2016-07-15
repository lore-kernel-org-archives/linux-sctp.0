From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 15 Jul 2016 19:40:02 +0000
Subject: [PATCH net-next] sctp: fix GSO for IPv6
Message-Id: <cc3fc851d2ff9abfe104807381cc21280648410d.1468609983.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org

commit 90017accff61 ("sctp: Add GSO support") didn't register SCTP GSO
offloading for IPv6 and yet didn't put any restrictions on generating
GSO packets while in IPv6, which causes all IPv6 GSO'ed packets to be
silently dropped.

The fix is to properly register the offload this time.

Fixes: 90017accff61 ("sctp: Add GSO support")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
I guess sctp multi-homing outsmarted myself during testing, ugh.

 net/sctp/offload.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index a37887b373a75524a54a1443f7df2d45ecf6cef7..7e869d0cca69826ee3e892e389bacdc9a58a1637 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -92,7 +92,28 @@ static const struct net_offload sctp_offload = {
 	},
 };
 
+static const struct net_offload sctp6_offload = {
+	.callbacks = {
+		.gso_segment = sctp_gso_segment,
+	},
+};
+
 int __init sctp_offload_init(void)
 {
-	return inet_add_offload(&sctp_offload, IPPROTO_SCTP);
+	int ret;
+
+	ret = inet_add_offload(&sctp_offload, IPPROTO_SCTP);
+	if (ret)
+		goto out;
+
+	ret = inet6_add_offload(&sctp6_offload, IPPROTO_SCTP);
+	if (ret)
+		goto ipv4;
+
+	return ret;
+
+ipv4:
+	inet_del_offload(&sctp_offload, IPPROTO_SCTP);
+out:
+	return ret;
 }
-- 
2.7.4

