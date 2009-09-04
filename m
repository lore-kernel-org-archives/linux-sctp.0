From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 04 Sep 2009 06:37:39 +0000
Subject: [PATCH 2/3] sctp: implement the receiver side for SACK-IMMEDIATELY
Message-Id: <4AA0B5B3.7010604@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patch implement the receiver side for SACK-IMMEDIATELY
extension:

  Section 4.2.  Receiver Side Considerations

  On reception of an SCTP packet containing a DATA chunk with the I-bit
  set, the receiver SHOULD NOT delay the sending of the corresponding
  SACK chunk and SHOULD send it back immediately.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_statefuns.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 45b8bca..53db544 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2865,6 +2865,7 @@ sctp_disposition_t sctp_sf_eat_data_6_2(const struct sctp_endpoint *ep,
 					sctp_cmd_seq_t *commands)
 {
 	struct sctp_chunk *chunk = arg;
+	sctp_arg_t force = SCTP_NOFORCE();
 	int error;
 
 	if (!sctp_vtag_verify(chunk, asoc)) {
@@ -2895,6 +2896,9 @@ sctp_disposition_t sctp_sf_eat_data_6_2(const struct sctp_endpoint *ep,
 		BUG();
 	}
 
+	if (chunk->chunk_hdr->flags & SCTP_DATA_SACK_IMM)
+		force = SCTP_FORCE();
+
 	if (asoc->autoclose) {
 		sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_RESTART,
 				SCTP_TO(SCTP_EVENT_TIMEOUT_AUTOCLOSE));
@@ -2923,7 +2927,7 @@ sctp_disposition_t sctp_sf_eat_data_6_2(const struct sctp_endpoint *ep,
 	 * more aggressive than the following algorithms allow.
 	 */
 	if (chunk->end_of_packet)
-		sctp_add_cmd_sf(commands, SCTP_CMD_GEN_SACK, SCTP_NOFORCE());
+		sctp_add_cmd_sf(commands, SCTP_CMD_GEN_SACK, force);
 
 	return SCTP_DISPOSITION_CONSUME;
 
@@ -2948,7 +2952,7 @@ discard_force:
 
 discard_noforce:
 	if (chunk->end_of_packet)
-		sctp_add_cmd_sf(commands, SCTP_CMD_GEN_SACK, SCTP_NOFORCE());
+		sctp_add_cmd_sf(commands, SCTP_CMD_GEN_SACK, force);
 
 	return SCTP_DISPOSITION_DISCARD;
 consume:
-- 
1.6.2.2




