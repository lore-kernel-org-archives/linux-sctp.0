From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 03 Jul 2018 08:30:47 +0000
Subject: [PATCHv2 net] sctp: fix the issue that pathmtu may be set lower than MINSEGMENT
Message-Id: <0ebc621b57952699c67c558dde3ce61b784e3f74.1530606647.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, syzkaller@googlegroups.com

After commit b6c5734db070 ("sctp: fix the handling of ICMP Frag Needed
for too small MTUs"), sctp_transport_update_pmtu would refetch pathmtu
from the dst and set it to transport's pathmtu without any check.

The new pathmtu may be lower than MINSEGMENT if the dst is obsolete and
updated by .get_dst() in sctp_transport_update_pmtu. In this case, it
could have a smaller MTU as well, and thus we should validate it
against MINSEGMENT instead.

Syzbot reported a warning in sctp_mtu_payload caused by this.

This patch refetches the pathmtu by calling sctp_dst_mtu where it does
the check against MINSEGMENT.

v1->v2:
  - refetch the pathmtu by calling sctp_dst_mtu instead as Marcelo's
    suggestion.

Fixes: b6c5734db070 ("sctp: fix the handling of ICMP Frag Needed for too small MTUs")
Reported-by: syzbot+f0d9d7cba052f9344b03@syzkaller.appspotmail.com
Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 445b7ef..12cac85 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -282,7 +282,7 @@ bool sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu)
 
 	if (dst) {
 		/* Re-fetch, as under layers may have a higher minimum size */
-		pmtu = SCTP_TRUNC4(dst_mtu(dst));
+		pmtu = sctp_dst_mtu(dst);
 		change = t->pathmtu != pmtu;
 	}
 	t->pathmtu = pmtu;
-- 
2.1.0

