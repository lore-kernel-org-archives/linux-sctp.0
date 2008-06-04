From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 04 Jun 2008 18:25:46 +0000
Subject: [PATCH 1/6] SCTP: retran_path update bug fix
Message-Id: <1212603951-24932-2-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1212603951-24932-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1212603951-24932-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, davem@davemloft.net, Gui Jianfeng <guijianfeng@cn.fujitsu.com>, Vlad Yasevich <vladislav.yasevich@hp.com>

From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

If the current retran_path is the only active one, it should
update it to the the next inactive one.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/associola.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index b4cd2b7..5326348 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1203,6 +1203,9 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
 	struct list_head *head = &asoc->peer.transport_addr_list;
 	struct list_head *pos;
 
+	if (asoc->peer.transport_count = 1)
+		return;
+
 	/* Find the next transport in a round-robin fashion. */
 	t = asoc->peer.retran_path;
 	pos = &t->transports;
@@ -1217,6 +1220,15 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
 
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
@@ -1229,15 +1241,6 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
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
1.5.3.5

