From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 21 Jan 2019 18:42:41 +0000
Subject: [PATCH net] sctp: set flow sport from saddr only when it's 0
Message-Id: <91961be2ab833139b1a4b0188ba47c2581b991d4.1548096161.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Now sctp_transport_pmtu() passes transport->saddr into .get_dst() to set
flow sport from 'saddr'. However, transport->saddr is set only when
transport->dst exists in sctp_transport_route().

If sctp_transport_pmtu() is called without transport->saddr set, like
when transport->dst doesn't exists, the flow sport will be set to 0
from transport->saddr, which will cause a wrong route to be got.

Commit 6e91b578bf3f ("sctp: re-use sctp_transport_pmtu in
sctp_transport_route") made the issue be triggered more easily
since sctp_transport_pmtu() would be called in sctp_transport_route()
after that.

In gerneral, fl4->fl4_sport should always be set to
htons(asoc->base.bind_addr.port), unless transport->asoc doesn't exist
in sctp_v4/6_get_dst(), which is the case:

  sctp_ootb_pkt_new() ->
    sctp_transport_route()

For that, we can simply handle it by setting flow sport from saddr only
when it's 0 in sctp_v4/6_get_dst().

Fixes: 6e91b578bf3f ("sctp: re-use sctp_transport_pmtu in sctp_transport_route")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/ipv6.c     | 3 ++-
 net/sctp/protocol.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index ed8e006..6200cd2 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -280,7 +280,8 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 
 	if (saddr) {
 		fl6->saddr = saddr->v6.sin6_addr;
-		fl6->fl6_sport = saddr->v6.sin6_port;
+		if (!fl6->fl6_sport)
+			fl6->fl6_sport = saddr->v6.sin6_port;
 
 		pr_debug("src=%pI6 - ", &fl6->saddr);
 	}
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 4e0eeb1..6abc8b2 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -440,7 +440,8 @@ static void sctp_v4_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 	}
 	if (saddr) {
 		fl4->saddr = saddr->v4.sin_addr.s_addr;
-		fl4->fl4_sport = saddr->v4.sin_port;
+		if (!fl4->fl4_sport)
+			fl4->fl4_sport = saddr->v4.sin_port;
 	}
 
 	pr_debug("%s: dst:%pI4, src:%pI4 - ", __func__, &fl4->daddr,
-- 
2.1.0
