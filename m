From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 13 Apr 2011 01:20:48 +0000
Subject: [PATCH] sctp: fix oops when updating retransmit path with DEBUG on
Message-Id: <4DA4FA70.50506@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: lksctp <linux-sctp@vger.kernel.org>

From: Vlad Yasevich <vladislav.yasevich@hp.com>

commit fbdf501c9374966a56829ecca3a7f25d2b49a305
  sctp: Do no select unconfirmed transports for retransmissions

Introduced the initial falt.

commit d598b166ced20d9b9281ea3527c0e18405ddb803
  sctp: Make sure we always return valid retransmit path

Solved the problem, but forgot to change the DEBUG statement.
Thus it was still possible to dereference a NULL pointer.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/associola.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 0698cad..922fdd7 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1323,6 +1323,8 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
 
 	if (t)
 		asoc->peer.retran_path = t;
+	else
+		t = asoc->peer.retran_path;
 
 	SCTP_DEBUG_PRINTK_IPADDR("sctp_assoc_update_retran_path:association"
 				 " %p addr: ",
-- 
1.6.5.2


