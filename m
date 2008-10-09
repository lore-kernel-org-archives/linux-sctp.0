From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 09 Oct 2008 13:29:35 +0000
Subject: [PATCH net-next 3/3] sctp: update SNMP statiscts when T5 timer expired.
Message-Id: <1223558975-1550-5-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1223558975-1550-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1223558975-1550-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>

The T5 timer is the timer for the over-all shutdown procedure.  If
this timer expires, then shutdown procedure has not completed and we
ABORT the association.  We should update SCTP_MIB_ABORTED and
SCTP_MIB_CURRESTAB  when aborting.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/sm_statefuns.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index f5094f1..d4c3fbc 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -5489,6 +5489,9 @@ sctp_disposition_t sctp_sf_t5_timer_expire(const struct sctp_endpoint *ep,
 	sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
 			SCTP_PERR(SCTP_ERROR_NO_ERROR));
 
+	SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
+	SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
+
 	return SCTP_DISPOSITION_DELETE_TCB;
 nomem:
 	return SCTP_DISPOSITION_NOMEM;
-- 
1.5.3.5

