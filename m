From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Sun, 26 Apr 2009 15:14:42 +0000
Subject: [PATCH 2/2] sctp: fix panic when T4-rto timer expire on removed transport
Message-Id: <49F47A62.40206@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

If T4-rto timer is expired on a removed transport, kernel panic
will occur when we do failure management on that transport.
You can reproduce this use the following sequence:

Endpoint A                           Endpoint B
(ESTABLISHED)                        (ESTABLISHED)

            <-----------------      ASCONF
                                    (SRC=X)
ASCONF        ----------------->
(Delete IP Address = X)
            <-----------------      ASCONF-ACK
                                    (Success Indication)
            <-----------------      ASCONF
                                    (T4-rto timer expire)

This patch fixed the problem.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/associola.c    |    7 +++++++
 net/sctp/sm_statefuns.c |    4 +++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 35c67bf..b4abf42 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -574,6 +574,13 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
 	if (asoc->shutdown_last_sent_to = peer)
 		asoc->shutdown_last_sent_to = NULL;
 
+	/* If we remove the transport an ASCONF was last sent to, set it to
+	 * NULL.
+	 */
+	if (asoc->addip_last_asconf &&
+	    asoc->addip_last_asconf->transport = peer)
+		asoc->addip_last_asconf->transport = NULL;
+
 	asoc->peer.transport_count--;
 
 	sctp_transport_free(peer);
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 10abc07..7288192 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -5475,7 +5475,9 @@ sctp_disposition_t sctp_sf_t4_timer_expire(
 	 * detection on the appropriate destination address as defined in
 	 * RFC2960 [5] section 8.1 and 8.2.
 	 */
-	sctp_add_cmd_sf(commands, SCTP_CMD_STRIKE, SCTP_TRANSPORT(transport));
+	if (transport)
+		sctp_add_cmd_sf(commands, SCTP_CMD_STRIKE,
+				SCTP_TRANSPORT(transport));
 
 	/* Reconfig T4 timer and transport. */
 	sctp_add_cmd_sf(commands, SCTP_CMD_SETUP_T4, SCTP_CHUNK(chunk));
-- 
1.5.3.8




