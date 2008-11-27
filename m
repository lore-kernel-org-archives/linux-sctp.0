From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 27 Nov 2008 02:31:30 +0000
Subject: [PATCHv2] sctp: Avoid memory overflow while FWD-TSN chunk is received
Message-Id: <492E0682.3050807@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

If FWD-TSN chunk is received with bad stream ID, the sctp will not do the
validity check, this may cause memory overflow when overwrite the TSN of
the stream ID.

The FORWARD-TSN chunk is like this:

FORWARD-TSN chunk
  Type                       = 192
  Flags                      = 0
  Length                     = 172
  NewTSN                     = 99
  Stream                     = 10000
  StreamSequence             = 0xFFFF

This patch fix this problem by discard the chunk if stream ID is not
less than MIS.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_statefuns.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index a6a0ea7..679fcde 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3691,6 +3691,7 @@ sctp_disposition_t sctp_sf_eat_fwd_tsn(const struct sctp_endpoint *ep,
 {
 	struct sctp_chunk *chunk = arg;
 	struct sctp_fwdtsn_hdr *fwdtsn_hdr;
+	struct sctp_fwdtsn_skip *skip;
 	__u16 len;
 	__u32 tsn;
 
@@ -3720,6 +3721,12 @@ sctp_disposition_t sctp_sf_eat_fwd_tsn(const struct sctp_endpoint *ep,
 	if (sctp_tsnmap_check(&asoc->peer.tsn_map, tsn) < 0)
 		goto discard_noforce;
 
+	/* Silently discard the chunk if stream-id is not valid */
+	sctp_walk_fwdtsn(skip, chunk) {
+		if (ntohs(skip->stream) >= asoc->c.sinit_max_instreams)
+			goto discard_noforce;
+	}
+
 	sctp_add_cmd_sf(commands, SCTP_CMD_REPORT_FWDTSN, SCTP_U32(tsn));
 	if (len > sizeof(struct sctp_fwdtsn_hdr))
 		sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_FWDTSN,
@@ -3751,6 +3758,7 @@ sctp_disposition_t sctp_sf_eat_fwd_tsn_fast(
 {
 	struct sctp_chunk *chunk = arg;
 	struct sctp_fwdtsn_hdr *fwdtsn_hdr;
+	struct sctp_fwdtsn_skip *skip;
 	__u16 len;
 	__u32 tsn;
 
@@ -3780,6 +3788,12 @@ sctp_disposition_t sctp_sf_eat_fwd_tsn_fast(
 	if (sctp_tsnmap_check(&asoc->peer.tsn_map, tsn) < 0)
 		goto gen_shutdown;
 
+	/* Silently discard the chunk if stream-id is not valid */
+	sctp_walk_fwdtsn(skip, chunk) {
+		if (ntohs(skip->stream) >= asoc->c.sinit_max_instreams)
+			goto gen_shutdown;
+	}
+
 	sctp_add_cmd_sf(commands, SCTP_CMD_REPORT_FWDTSN, SCTP_U32(tsn));
 	if (len > sizeof(struct sctp_fwdtsn_hdr))
 		sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_FWDTSN,
-- 
1.6.0.2.530.g67faa



