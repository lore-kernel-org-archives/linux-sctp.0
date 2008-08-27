From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 27 Aug 2008 02:41:54 +0000
Subject: [PATCH] sctp: Fix the SNMP number of SCTP_MIB_CURRESTAB
Message-Id: <48B4BEF2.30108@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

RFC3873 defined SCTP_MIB_CURRESTAB:
  sctpCurrEstab OBJECT-TYPE
    SYNTAX         Gauge32
    MAX-ACCESS     read-only
    STATUS         current
    DESCRIPTION
         "The number of associations for which the current state is
         either ESTABLISHED, SHUTDOWN-RECEIVED or SHUTDOWN-PENDING."
    REFERENCE
         "Section 4 in RFC2960 covers the SCTP   Association state
         diagram."

If the T4 RTO timer expires many times(timeout), the association will enter
CLOSED state, so we should dec the number of SCTP_MIB_CURRESTAB, not inc the
number of SCTP_MIB_CURRESTAB.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_statefuns.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 8848d32..0b49a56 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -5406,7 +5406,7 @@ sctp_disposition_t sctp_sf_t4_timer_expire(
 		sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
 				SCTP_PERR(SCTP_ERROR_NO_ERROR));
 		SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
-		SCTP_INC_STATS(SCTP_MIB_CURRESTAB);
+		SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
 		return SCTP_DISPOSITION_ABORT;
 	}
 
-- 
1.5.3.8



