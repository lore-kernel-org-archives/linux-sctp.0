From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 10 Jun 2017 07:27:12 +0000
Subject: [PATCHv2 net-next] sctp: no need to check assoc id before calling sctp_assoc_set_id
Message-Id: <ea556c7733c5bf63532ce35186e4bc7a519bf858.1497079632.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

sctp_assoc_set_id does the assoc id check in the beginning when
processing dupcookie, no need to do the same check before calling
it.

v1->v2:
  fix some typo errs Marcelo pointed in changelog.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/associola.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 288c5e0..72b07dd 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1181,12 +1181,8 @@ void sctp_assoc_update(struct sctp_association *asoc,
 		if (sctp_state(asoc, COOKIE_WAIT))
 			sctp_stream_update(&asoc->stream, &new->stream);
 
-		if (!asoc->assoc_id) {
-			/* get a new association id since we don't have one
-			 * yet.
-			 */
-			sctp_assoc_set_id(asoc, GFP_ATOMIC);
-		}
+		/* get a new assoc id if we don't have one yet. */
+		sctp_assoc_set_id(asoc, GFP_ATOMIC);
 	}
 
 	/* SCTP-AUTH: Save the peer parameters from the new associations
-- 
2.1.0

