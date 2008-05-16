From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Date: Fri, 16 May 2008 00:38:39 +0000
Subject: [PATCH] [SCTP] retran_path update bug fix
Message-Id: <482CD78F.2070308@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org, vladislav <vladislav.yasevich@hp.com>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>

If the current retran_path is the only active one, it should
update it to the the next inactive one.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 net/sctp/associola.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index d29f792..4ae1f8b 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1208,6 +1208,9 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
 	struct list_head *head = &asoc->peer.transport_addr_list;
 	struct list_head *pos;
 
+	if (asoc->peer.transport_count = 1)
+		return;
+
 	/* Find the next transport in a round-robin fashion. */
 	t = asoc->peer.retran_path;
 	pos = &t->transports;
@@ -1222,6 +1225,15 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
 
 		t = list_entry(pos, struct sctp_transport, transports);
 
+		/* We have exhausted the list, but didn't find any
+		 * other active transports.  If so, use the next
+		 * transport.
+		 */
+		if (t = asoc->peer.retran_path) {
+			t = next;
+			break;
+		}
+
 		/* Try to find an active transport. */
 
 		if ((t->state = SCTP_ACTIVE) ||
@@ -1234,15 +1246,6 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
 			if (!next)
 				next = t;
 		}
-
-		/* We have exhausted the list, but didn't find any
-		 * other active transports.  If so, use the next
-		 * transport.
-		 */
-		if (t = asoc->peer.retran_path) {
-			t = next;
-			break;
-		}
 	}
 
 	asoc->peer.retran_path = t;
-- 
1.5.3


