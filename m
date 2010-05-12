From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Wed, 12 May 2010 09:25:50 +0000
Subject: [PATCH CLEANUP] sctp: delete unused macro definition of sctp_chunk_is_control
Message-Id: <4BEA741E.4070804@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


The macro never be used.
And if needed, can use !sctp_chunk_is_data instead of.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 include/net/sctp/constants.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 6390884..e852a08 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -154,7 +154,6 @@ SCTP_SUBTYPE_CONSTRUCTOR(OTHER,		sctp_event_other_t,	other)
 SCTP_SUBTYPE_CONSTRUCTOR(PRIMITIVE,	sctp_event_primitive_t,	primitive)
 
 
-#define sctp_chunk_is_control(a) (a->chunk_hdr->type != SCTP_CID_DATA)
 #define sctp_chunk_is_data(a) (a->chunk_hdr->type = SCTP_CID_DATA)
 
 /* Calculate the actual data size in a data chunk */
-- 
1.6.3.3
