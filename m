From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 28 Apr 2010 18:47:19 +0000
Subject: [PATCH 2/5] sctp: fix potential reference of a freed pointer
Message-Id: <1272480442-32673-3-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1272480442-32673-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1272480442-32673-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>

When sctp attempts to update an assocition, it removes any
addresses that were not in the updated INITs.  However, the loop
may attempt to refrence a transport with address after removing it.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/associola.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index df5abbf..99c93ee 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1194,8 +1194,10 @@ void sctp_assoc_update(struct sctp_association *asoc,
 	/* Remove any peer addresses not present in the new association. */
 	list_for_each_safe(pos, temp, &asoc->peer.transport_addr_list) {
 		trans = list_entry(pos, struct sctp_transport, transports);
-		if (!sctp_assoc_lookup_paddr(new, &trans->ipaddr))
-			sctp_assoc_del_peer(asoc, &trans->ipaddr);
+		if (!sctp_assoc_lookup_paddr(new, &trans->ipaddr)) {
+			sctp_assoc_rm_peer(asoc, trans);
+			continue;
+		}
 
 		if (asoc->state >= SCTP_STATE_ESTABLISHED)
 			sctp_transport_reset(trans);
-- 
1.6.0.4

