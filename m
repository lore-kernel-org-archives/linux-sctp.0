From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 23 May 2017 06:30:32 +0000
Subject: [PATCH net-next] sctp: no need to check asoc_id before calling sctp_assoc_set_id
Message-Id: <8ccb4ee656bcdfa790e4f3ee919bb300e4adc4cc.1495521032.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

sctp_assoc_set_id has already done the asoc_id check in the beginning
when processing dupcook, no need to do the same check before calling
it.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/associola.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index a9708da..ce2a3ec 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1181,12 +1181,8 @@ void sctp_assoc_update(struct sctp_association *asoc,
 			new->stream = NULL;
 		}
 
-		if (!asoc->assoc_id) {
-			/* get a new association id since we don't have one
-			 * yet.
-			 */
-			sctp_assoc_set_id(asoc, GFP_ATOMIC);
-		}
+		/* get a new association id if we don't have one yet. */
+		sctp_assoc_set_id(asoc, GFP_ATOMIC);
 	}
 
 	/* SCTP-AUTH: Save the peer parameters from the new associations
-- 
2.1.0

