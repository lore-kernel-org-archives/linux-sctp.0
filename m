From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 09 Oct 2008 13:29:34 +0000
Subject: [PATCH net-next 2/3] sctp: Fix SNMP number of SCTP_MIB_ABORTED during violation handling.
Message-Id: <1223558975-1550-4-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1223558975-1550-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1223558975-1550-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>

If ABORT chunks require authentication and a protocol violation
is triggered, we do not tear down the association.  Subsequently,
we should not increment SCTP_MIB_ABORTED.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/sm_statefuns.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 1588d06..f5094f1 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4188,11 +4188,10 @@ static sctp_disposition_t sctp_sf_abort_violation(
 		SCTP_INC_STATS(SCTP_MIB_OUTCTRLCHUNKS);
 	}
 
-discard:
-	sctp_sf_pdiscard(ep, asoc, SCTP_ST_CHUNK(0), arg, commands);
-
 	SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
 
+discard:
+	sctp_sf_pdiscard(ep, asoc, SCTP_ST_CHUNK(0), arg, commands);
 	return SCTP_DISPOSITION_ABORT;
 
 nomem_pkt:
@@ -4265,12 +4264,10 @@ static sctp_disposition_t sctp_sf_violation_paramlen(
 	sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
 			SCTP_PERR(SCTP_ERROR_PROTO_VIOLATION));
 	SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
+	SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
 
 discard:
 	sctp_sf_pdiscard(ep, asoc, SCTP_ST_CHUNK(0), arg, commands);
-
-	SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
-
 	return SCTP_DISPOSITION_ABORT;
 nomem:
 	return SCTP_DISPOSITION_NOMEM;
-- 
1.5.3.5

