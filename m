From: Stephen Hemminger <shemminger@vyatta.com>
Date: Sat, 29 Dec 2012 04:18:55 +0000
Subject: [PATCH] sctp: make sctp_addr_wq_timeout_handler static
Message-Id: <20121228201855.4275db64@nehalam.linuxnetplumber.net>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Sridhar Samudrala <sri@us.ibm.com>, Neil Horman <nhorman@tuxdriver.com>, "David S. Miller" <davem@davemloft.net>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Fix sparse warning about local function that should be static.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/net/sctp/protocol.c	2012-12-27 11:36:34.817072247 -0800
+++ b/net/sctp/protocol.c	2012-12-28 20:02:51.445778974 -0800
@@ -595,7 +595,7 @@ static void sctp_v4_ecn_capable(struct s
 	INET_ECN_xmit(sk);
 }
 
-void sctp_addr_wq_timeout_handler(unsigned long arg)
+static void sctp_addr_wq_timeout_handler(unsigned long arg)
 {
 	struct net *net = (struct net *)arg;
 	struct sctp_sockaddr_entry *addrw, *temp;
