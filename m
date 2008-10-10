From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 10 Oct 2008 06:31:26 +0000
Subject: [PATCH] sctp: Fix to handle SHUTDOWN in SHUTDOWN-PENDING state
Message-Id: <48EEF6BE.4040705@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

If SHUTDOWN is received in SHUTDOWN-PENDING state, enpoint should enter
the SHUTDOWN-RECEIVED state and check the Cumulative TSN Ack field of
the SHUTDOWN chunk (RFC 4960 Section 9.2). If the SHUTDOWN chunk can
acknowledge all of the send DATA chunks, SHUTDOWN-ACK should be sent.

But now endpoint just silently discarded the SHUTDOWN chunk.

SHUTDOWN received in SHUTDOWN-PENDING state can happend when the last
SACK is lost by network, or the SHUTDOWN chunk can acknowledge all of
the received DATA chunks. The packet sequence(SACK lost) is like this:

Endpoint A                       Endpoint B       ULP
(ESTABLISHED)                    (ESTABLISHED)

               <-----------      DATA
                                             <--- shutdown
                                 Enter SHUTDOWN-PENDING state
  SACK         ----lost---->

  SHUTDOWN(*1) ------------>

               <-----------      SHUTDOWN-ACK

 (*1) silently discarded now.

This patch fix to handle SHUTDOWN in SHUTDOWN-PENDING state as the same
as ESTABLISHED state.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_statetable.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/sm_statetable.c b/net/sctp/sm_statetable.c
index dd4ddc4..a5b5590 100644
--- a/net/sctp/sm_statetable.c
+++ b/net/sctp/sm_statetable.c
@@ -266,7 +266,7 @@ const sctp_sm_table_entry_t *sctp_sm_lookup_event(sctp_event_t event_type,
 	/* SCTP_STATE_ESTABLISHED */ \
 	TYPE_SCTP_FUNC(sctp_sf_do_9_2_shutdown), \
 	/* SCTP_STATE_SHUTDOWN_PENDING */ \
-	TYPE_SCTP_FUNC(sctp_sf_discard_chunk), \
+	TYPE_SCTP_FUNC(sctp_sf_do_9_2_shutdown), \
 	/* SCTP_STATE_SHUTDOWN_SENT */ \
 	TYPE_SCTP_FUNC(sctp_sf_do_9_2_shutdown_ack), \
 	/* SCTP_STATE_SHUTDOWN_RECEIVED */ \
-- 
1.5.3.8



