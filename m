From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 08 Sep 2008 04:10:40 +0000
Subject: [PATCHv2] sctp: Fix the SNMP counter of SCTP_MIB_OUTOFBLUES
Message-Id: <48C4A5C0.9020303@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Change from v1:
- Add counter for OOTB SHUTDOWN-ACK in COOKIE-WAIT and COOKIE-ECHOED state.

sctp: Fix the SNMP counter of SCTP_MIB_OUTOFBLUES

RFC3873 defined SCTP_MIB_OUTOFBLUES:

 sctpOutOfBlues OBJECT-TYPE
   SYNTAX         Counter32
   MAX-ACCESS     read-only
   STATUS         current
   DESCRIPTION
        "The number of out of the blue packets received by the host.
        An out of the blue packet is an SCTP packet correctly formed,
        including the proper checksum, but for which the receiver was
        unable to identify an appropriate association."
   REFERENCE
        "Section 8.4 in RFC2960 deals with the Out-Of-The-Blue
         (OOTB) packet definition and procedures."

But OOTB packet INIT, INIT-ACK and SHUTDOWN-ACK(COOKIE-WAIT or
COOKIE-ECHOED state) are not counted by SCTP_MIB_OUTOFBLUES.

Case 1(INIT):

Endpoint A               Endpoint B
(CLOSED)                 (CLOSED)

 INIT     ---------->
          <----------    ABORT

Case 2(INIT-ACK):

Endpoint A               Endpoint B
(CLOSED)                 (CLOSED)

 INIT-ACK  ---------->
           <----------   ABORT

Case 3(SHUTDOWN-ACK):

Endpoint A               Endpoint B
(CLOSED)                 (CLOSED)

          <----------    INIT
 SHUTDOWN-ACK  ---------->
           <----------   ABORT

Case 4(SHUTDOWN-ACK):

Endpoint A               Endpoint B
(CLOSED)                 (COOKIE-ECHOED)

 SHUTDOWN-ACK  ---------->
           <----------   ABORT

This patch fixed the problem.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_statefuns.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 0b49a56..16b9ce1 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -315,8 +315,10 @@ sctp_disposition_t sctp_sf_do_5_1B_init(const struct sctp_endpoint *ep,
 	/* If the packet is an OOTB packet which is temporarily on the
 	 * control endpoint, respond with an ABORT.
 	 */
-	if (ep = sctp_sk((sctp_get_ctl_sock()))->ep)
+	if (ep = sctp_sk((sctp_get_ctl_sock()))->ep) {
+		SCTP_INC_STATS(SCTP_MIB_OUTOFBLUES);
 		return sctp_sf_tabort_8_4_8(ep, asoc, type, arg, commands);
+	}
 
 	/* 3.1 A packet containing an INIT chunk MUST have a zero Verification
 	 * Tag.
@@ -635,8 +637,10 @@ sctp_disposition_t sctp_sf_do_5_1D_ce(const struct sctp_endpoint *ep,
 	/* If the packet is an OOTB packet which is temporarily on the
 	 * control endpoint, respond with an ABORT.
 	 */
-	if (ep = sctp_sk((sctp_get_ctl_sock()))->ep)
+	if (ep = sctp_sk((sctp_get_ctl_sock()))->ep) {
+		SCTP_INC_STATS(SCTP_MIB_OUTOFBLUES);
 		return sctp_sf_tabort_8_4_8(ep, asoc, type, arg, commands);
+	}
 
 	/* Make sure that the COOKIE_ECHO chunk has a valid length.
 	 * In this case, we check that we have enough for at least a
@@ -3382,6 +3386,8 @@ sctp_disposition_t sctp_sf_do_8_5_1_E_sa(const struct sctp_endpoint *ep,
 	 * packet and the state function that handles OOTB SHUTDOWN_ACK is
 	 * called with a NULL association.
 	 */
+	SCTP_INC_STATS(SCTP_MIB_OUTOFBLUES);
+
 	return sctp_sf_shut_8_4_5(ep, NULL, type, arg, commands);
 }
 
-- 
1.5.3.8


