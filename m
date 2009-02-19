From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 19 Feb 2009 09:20:53 +0000
Subject: [PATCH 1/4] sctp: Add some missing types for debug message
Message-Id: <499D2475.5070907@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patch add the type name "AUTH" and primitive type name
"PRIMITIVE_ASCONF" for debug message.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/debug.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/sctp/debug.c b/net/sctp/debug.c
index 67715f4..7ff548a 100644
--- a/net/sctp/debug.c
+++ b/net/sctp/debug.c
@@ -86,6 +86,9 @@ const char *sctp_cname(const sctp_subtype_t cid)
 	case SCTP_CID_FWD_TSN:
 		return "FWD_TSN";
 
+	case SCTP_CID_AUTH:
+		return "AUTH";
+
 	default:
 		break;
 	}
@@ -135,6 +138,7 @@ static const char *sctp_primitive_tbl[SCTP_NUM_PRIMITIVE_TYPES] = {
 	"PRIMITIVE_ABORT",
 	"PRIMITIVE_SEND",
 	"PRIMITIVE_REQUESTHEARTBEAT",
+	"PRIMITIVE_ASCONF",
 };
 
 /* Lookup primitive debug name. */
-- 
1.5.3.8




