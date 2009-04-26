From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Sun, 26 Apr 2009 15:13:35 +0000
Subject: [PATCH 1/2] sctp: fix panic when T2-shutdown timer expire on removed
Message-Id: <49F47A1F.2000109@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

If T2-shutdown timer is expired on a removed transport, kernel
panic will occur when we do failure management on that transport.
You can reproduce this use the following sequence:

  Endpoint A                           Endpoint B
  (ESTABLISHED)                        (ESTABLISHED)

                <-----------------      SHUTDOWN
                                        (SRC=X)
  ASCONF        ----------------->
  (Delete IP Address = X)
                <-----------------      ASCONF-ACK
                                        (Success Indication)
                <-----------------      SHUTDOWN
                                        (T2-shutdown timer expire)
This patch fixed the problem.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/associola.c    |    8 ++++++++
 net/sctp/sm_statefuns.c |   10 +++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index f4b2304..35c67bf 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -566,6 +566,14 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
 	if (asoc->init_last_sent_to = peer)
 		asoc->init_last_sent_to = NULL;
 
+	/* If we remove the transport an SHUTDOWN was last sent to, set it
+	 * to NULL. Combined with the update of the retran path above, this
+	 * will cause the next SHUTDOWN to be sent to the next available
+	 * transport, maintaining the cycle.
+	 */
+	if (asoc->shutdown_last_sent_to = peer)
+		asoc->shutdown_last_sent_to = NULL;
+
 	asoc->peer.transport_count--;
 
 	sctp_transport_free(peer);
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 55a61aa..10abc07 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -5432,9 +5432,13 @@ sctp_disposition_t sctp_sf_t2_timer_expire(const struct sctp_endpoint *ep,
 	if (!reply)
 		goto nomem;
 
-	/* Do some failure management (Section 8.2). */
-	sctp_add_cmd_sf(commands, SCTP_CMD_STRIKE,
-			SCTP_TRANSPORT(asoc->shutdown_last_sent_to));
+	/* Do some failure management (Section 8.2).
+	 * If we remove the transport an SHUTDOWN was last sent to, don't
+	 * do failure management.
+	 */
+	if (asoc->shutdown_last_sent_to)
+		sctp_add_cmd_sf(commands, SCTP_CMD_STRIKE,
+				SCTP_TRANSPORT(asoc->shutdown_last_sent_to));
 
 	/* Set the transport for the SHUTDOWN/ACK chunk and the timeout for
 	 * the T2-shutdown timer.
-- 
1.5.3.8




