From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Tue, 19 Apr 2011 05:09:41 +0000
Subject: [PATCH net-next-2.6 1/8] sctp: delete unused macro definition of
Message-Id: <4DAD1915.70503@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DAD18AB.3040401@cn.fujitsu.com>
In-Reply-To: <4DAD18AB.3040401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, lksctp <linux-sctp@vger.kernel.org>

The macro never be used.
And if needed, can use !sctp_chunk_is_data instead of.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/constants.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index c70d8cc..deac13d 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -150,7 +150,6 @@ SCTP_SUBTYPE_CONSTRUCTOR(OTHER,		sctp_event_other_t,	other)
 SCTP_SUBTYPE_CONSTRUCTOR(PRIMITIVE,	sctp_event_primitive_t,	primitive)
 
 
-#define sctp_chunk_is_control(a) (a->chunk_hdr->type != SCTP_CID_DATA)
 #define sctp_chunk_is_data(a) (a->chunk_hdr->type = SCTP_CID_DATA)
 
 /* Calculate the actual data size in a data chunk */
-- 
1.6.5.2


