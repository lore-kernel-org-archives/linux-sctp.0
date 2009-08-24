From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 24 Aug 2009 16:26:12 +0000
Subject: [PATCH] sctp: Try to encourage SACK bundling with DATA.
Message-Id: <1251131172-20602-3-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

If the association has a SACK timer pending and now DATA queued
to be send, we'll try to bundle the SACK with the next application send.
As such, try encourage bundling by accounting for SACK in the size
of the first chunk fragment.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/chunk.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index 1748ef9..05b532e 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -196,6 +196,15 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 	whole = 0;
 	first_len = max;
 
+	/* Check to see if we have a pending SACK and try to let it be bundled
+	 * with this message.  Do this if we don't have any data queued already.
+	 * To check that, look at out_qlen and retransmit list.
+	 */
+	if (timer_pending(&asoc->timers[SCTP_EVENT_TIMEOUT_SACK]) &&
+	    asoc->outqueue.out_qlen = 0 &&
+	    list_empty(&asoc->outqueue.retransmit))
+		first_len -= WORD_ROUND(sizeof(sctp_sack_chunk_t));
+
 	/* Encourage Cookie-ECHO bundling. */
 	if (asoc->state < SCTP_STATE_COOKIE_ECHOED) {
 		whole = msg_len / (max - SCTP_ARBITRARY_COOKIE_ECHO_LEN);
-- 
1.5.4.3

