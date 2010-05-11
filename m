From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 11 May 2010 06:43:02 +0000
Subject: [PATCH for net-next-2.6] sctp: fix oops when update assoc retran
Message-Id: <4BE8FC76.40000@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

commit fbdf501c9374966a56829ecca3a7f25d2b49a305
  sctp: Do no select unconfirmed transports for retransmissions

added code to make sure that we do not select unconfirmed paths
for data transmission.  This caused a problem when there are only
2 paths, 1 unconfirmed and 1 unreachable.  In that case, the next
retransmit path returned is NULL and that causes a kernel crash.

commit d598b166ced20d9b9281ea3527c0e18405ddb803
  sctp: Make sure we always return valid retransmit path
try to fix it, but if DEBUG is configured, the oops is still
exists.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/associola.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 3912420..1f49af5 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1323,15 +1323,16 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
 		}
 	}
 
-	if (t)
+	if (t) {
 		asoc->peer.retran_path = t;
 
-	SCTP_DEBUG_PRINTK_IPADDR("sctp_assoc_update_retran_path:association"
-				 " %p addr: ",
-				 " port: %d\n",
-				 asoc,
-				 (&t->ipaddr),
-				 ntohs(t->ipaddr.v4.sin_port));
+		SCTP_DEBUG_PRINTK_IPADDR("sctp_assoc_update_retran_path:"
+					 "association %p addr: ",
+					 " port: %d\n",
+					 asoc,
+					 (&t->ipaddr),
+					 ntohs(t->ipaddr.v4.sin_port));
+	}
 }
 
 /* Choose the transport for sending retransmit packet.  */
-- 
1.6.5.2


