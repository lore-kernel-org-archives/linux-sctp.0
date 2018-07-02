From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 02 Jul 2018 10:21:15 +0000
Subject: [PATCHv2 net-next 5/5] sctp: check for ipv6_pinfo legal sndflow with flowlabel in sctp_v6_get_dst
Message-Id: <94701d8675557612cea7afd70c93f5823cc900de.1530526661.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1530526661.git.lucien.xin@gmail.com>
 <6504d3609be85e1574b6f44051d2523342f9e955.1530526661.git.lucien.xin@gmail.com>
 <d4512b8239763cedc076bdbc3a10fe1fb9e88481.1530526661.git.lucien.xin@gmail.com>
 <cbeee9df0afd61d4f1bf1ac08a627b1d8e9dcf6a.1530526661.git.lucien.xin@gmail.com>
 <ec560e0a131aac9425c93a02eafd320c3bb5e584.1530526661.git.lucien.xin@gmail.com>
In-Reply-To: <ec560e0a131aac9425c93a02eafd320c3bb5e584.1530526661.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net, hideaki.yoshifuji@miraclelinux.com

The transport with illegal flowlabel should not be allowed to send
packets. Other transport protocols already denies this.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/ipv6.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 772513d..d83ddc4 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -262,6 +262,15 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 	if (t->flowlabel & SCTP_FLOWLABEL_SET_MASK)
 		fl6->flowlabel = htonl(t->flowlabel & SCTP_FLOWLABEL_VAL_MASK);
 
+	if (np->sndflow && (fl6->flowlabel & IPV6_FLOWLABEL_MASK)) {
+		struct ip6_flowlabel *flowlabel;
+
+		flowlabel = fl6_sock_lookup(sk, fl6->flowlabel);
+		if (!flowlabel)
+			goto out;
+		fl6_sock_release(flowlabel);
+	}
+
 	pr_debug("%s: dst=%pI6 ", __func__, &fl6->daddr);
 
 	if (asoc)
-- 
2.1.0

