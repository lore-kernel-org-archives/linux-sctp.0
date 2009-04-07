From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 07 Apr 2009 07:41:39 +0000
Subject: [PATCH 1/2] sctp: fix error cause codes of ADD-IP extension
Message-Id: <49DB03B3.6060306@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

RFC5061 had changed the error cause codes for Dynamic Address
Reconfiguration As the following:

       Cause Code
       Value          Cause Code
       ---------      ----------------
       0x00A0          Request to Delete Last Remaining IP Address
       0x00A1          Operation Refused Due to Resource Shortage
       0x00A2          Request to Delete Source IP Address
       0x00A3          Association Aborted Due to Illegal ASCONF-ACK
       0x00A4          Request Refused - No Authorization

This patch fix the error cause codes.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/linux/sctp.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index c2731bf..b464b9d 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -487,17 +487,17 @@ typedef enum {
 	 *
 	 * Value          Cause Code
 	 * ---------      ----------------
-	 * 0x0100          Request to Delete Last Remaining IP Address.
-	 * 0x0101          Operation Refused Due to Resource Shortage.
-	 * 0x0102          Request to Delete Source IP Address.
-	 * 0x0103          Association Aborted due to illegal ASCONF-ACK
-	 * 0x0104          Request refused - no authorization.
+	 * 0x00A0          Request to Delete Last Remaining IP Address.
+	 * 0x00A1          Operation Refused Due to Resource Shortage.
+	 * 0x00A2          Request to Delete Source IP Address.
+	 * 0x00A3          Association Aborted due to illegal ASCONF-ACK
+	 * 0x00A4          Request refused - no authorization.
 	 */
-	SCTP_ERROR_DEL_LAST_IP	= cpu_to_be16(0x0100),
-	SCTP_ERROR_RSRC_LOW	= cpu_to_be16(0x0101),
-	SCTP_ERROR_DEL_SRC_IP	= cpu_to_be16(0x0102),
-	SCTP_ERROR_ASCONF_ACK   = cpu_to_be16(0x0103),
-	SCTP_ERROR_REQ_REFUSED	= cpu_to_be16(0x0104),
+	SCTP_ERROR_DEL_LAST_IP	= cpu_to_be16(0x00A0),
+	SCTP_ERROR_RSRC_LOW	= cpu_to_be16(0x00A1),
+	SCTP_ERROR_DEL_SRC_IP	= cpu_to_be16(0x00A2),
+	SCTP_ERROR_ASCONF_ACK   = cpu_to_be16(0x00A3),
+	SCTP_ERROR_REQ_REFUSED	= cpu_to_be16(0x00A4),
 
 	/* AUTH Section 4.  New Error Cause
 	 *
-- 
1.5.3.8




