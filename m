From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 15 Apr 2009 08:08:50 +0000
Subject: [PATCH] sctp: fix the format of invalid mandatory parameter format
Message-Id: <49E59612.70504@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

RFC 4960 defined the format of invalid mandatory parameter:

   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |     Cause Code=7              |      Cause Length=4           |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

But invalid mandatory parameter sent in ASCONF-ACK chunk include the
invalid paramter complete with TLV.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 net/sctp/sm_make_chunk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 6851ee9..46de41a 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2822,7 +2822,7 @@ static void sctp_add_asconf_response(struct sctp_chunk *chunk, __be32 crr_id,
 	} else {
 		response_type = SCTP_PARAM_ERR_CAUSE;
 		err_param_len = sizeof(err_param);
-		if (asconf_param)
+		if (asconf_param && err_code != SCTP_ERROR_INV_PARAM)
 			asconf_param_len  				 ntohs(asconf_param->param_hdr.length);
 	}
@@ -2844,7 +2844,7 @@ static void sctp_add_asconf_response(struct sctp_chunk *chunk, __be32 crr_id,
 	sctp_addto_chunk(chunk, err_param_len, &err_param);
 
 	/* Add the failed TLV copied from ASCONF chunk. */
-	if (asconf_param)
+	if (asconf_param && err_code != SCTP_ERROR_INV_PARAM)
 		sctp_addto_chunk(chunk, asconf_param_len, asconf_param);
 }
 
-- 
1.5.3.8




