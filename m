From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 16 Apr 2013 21:07:14 +0000
Subject: [PATCH net-next 5/9] net: sctp: outqueue: simplify sctp_outq_uncork function
Message-Id: <1366146438-8815-6-git-send-email-dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1366146438-8815-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1366146438-8815-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Just a minor edit to simplify the function. No need for this
error variable here.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 net/sctp/outqueue.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index d4c137e..32a4625 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -701,11 +701,10 @@ redo:
 /* Cork the outqueue so queued chunks are really queued. */
 int sctp_outq_uncork(struct sctp_outq *q)
 {
-	int error = 0;
 	if (q->cork)
 		q->cork = 0;
-	error = sctp_outq_flush(q, 0);
-	return error;
+
+	return sctp_outq_flush(q, 0);
 }
 
 
-- 
1.7.11.7

