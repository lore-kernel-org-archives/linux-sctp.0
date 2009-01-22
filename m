From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 22 Jan 2009 22:36:07 +0000
Subject: [PATCH 3/4] sctp: Properly timestamp outgoing data chunks for rtx purposes
Message-Id: <1232663768-4028-4-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1232663768-4028-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1232663768-4028-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, davem@davemloft.net, Vlad Yasevich <vladislav.yasevich@hp.com>

Recent changes to the retransmit code exposed a long standing
bug where it was possible for a chunk to be time stamped
after the retransmit timer was reset.  This caused a rare
situation where the retrnamist timer has expired, but
nothing was marked for retrnasmission because all of
timesamps on data were less then 1 rto ago.  As result,
the timer was never restarted since nothing was retransmitted,
and this resulted in a hung association that did couldn't
complete the data transfer.  The solution is to timestamp
the chunk when it's added to the packet for transmission
purposes.  After the packet is trsnmitted the rtx timer
is restarted.  This guarantees that when the timer expires,
there will be data to retransmit.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/output.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index c3f417f..7363935 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -324,14 +324,16 @@ append:
 	switch (chunk->chunk_hdr->type) {
 	    case SCTP_CID_DATA:
 		retval = sctp_packet_append_data(packet, chunk);
+		if (SCTP_XMIT_OK != retval)
+			goto finish;
 		/* Disallow SACK bundling after DATA. */
 		packet->has_sack = 1;
 		/* Disallow AUTH bundling after DATA */
 		packet->has_auth = 1;
 		/* Let it be knows that packet has DATA in it */
 		packet->has_data = 1;
-		if (SCTP_XMIT_OK != retval)
-			goto finish;
+		/* timestamp the chunk for rtx purposes */
+		chunk->sent_at = jiffies;
 		break;
 	    case SCTP_CID_COOKIE_ECHO:
 		packet->has_cookie_echo = 1;
@@ -470,7 +472,6 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 			} else
 				chunk->resent = 1;
 
-			chunk->sent_at = jiffies;
 			has_data = 1;
 		}
 
-- 
1.5.3.5

