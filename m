From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 07 Apr 2009 08:36:14 +0000
Subject: [PATCH] sctp: fix a typo in net/sctp/sm_statetable.c
Message-Id: <49DB107E.8080405@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Just fix a typo in net/sctp/sm_statetable.c.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_statetable.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/sm_statetable.c b/net/sctp/sm_statetable.c
index 5c8186d..6d9b3aa 100644
--- a/net/sctp/sm_statetable.c
+++ b/net/sctp/sm_statetable.c
@@ -698,7 +698,7 @@ chunk_event_table_unknown[SCTP_STATE_NUM_STATES] = {
 	TYPE_SCTP_FUNC(sctp_sf_do_prm_asconf), \
 	/* SCTP_STATE_SHUTDOWN_ACK_SENT */ \
 	TYPE_SCTP_FUNC(sctp_sf_error_shutdown), \
-} /* TYPE_SCTP_PRIMITIVE_REQUESTHEARTBEAT */
+} /* TYPE_SCTP_PRIMITIVE_ASCONF */
 
 /* The primary index for this table is the primitive type.
  * The secondary index for this table is the state.
-- 
1.5.3.8




