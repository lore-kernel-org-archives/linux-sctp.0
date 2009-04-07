From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 07 Apr 2009 07:44:29 +0000
Subject: [PATCH 2/2] sctp: fix report unrecognized parameter in ACSONF-ACK
Message-Id: <49DB045D.60303@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

RFC5061 Section 5.2.  Upon Reception of an ASCONF Chunk

V2)  In processing the chunk, the receiver should build a
     response message with the appropriate error TLVs, as
     specified in the Parameter type bits, for any ASCONF
     Parameter it does not understand.  To indicate an
     unrecognized parameter, Cause Type 8 should be used as
     defined in the ERROR in Section 3.3.10.8, [RFC4960].  The
     endpoint may also use the response to carry rejections for
     other reasons, such as resource shortages, etc., using the
     Error Cause TLV and an appropriate error condition.

So we should indicate an unrecognized parameter with error
SCTP_ERROR_UNKNOWN_PARAM in ACSONF-ACK chunk, not
SCTP_ERROR_INV_PARAM.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_make_chunk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 6851ee9..c78e31b 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2959,7 +2959,7 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 		sctp_assoc_set_primary(asoc, peer);
 		break;
 	default:
-		return SCTP_ERROR_INV_PARAM;
+		return SCTP_ERROR_UNKNOWN_PARAM;
 		break;
 	}
 
@@ -3273,7 +3273,7 @@ int sctp_process_asconf_ack(struct sctp_association *asoc,
 			retval = 1;
 			break;
 
-		case SCTP_ERROR_INV_PARAM:
+		case SCTP_ERROR_UNKNOWN_PARAM:
 			/* Disable sending this type of asconf parameter in
 			 * future.
 			 */
-- 
1.5.3.8




