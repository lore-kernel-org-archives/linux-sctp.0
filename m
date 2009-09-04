From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Fri, 04 Sep 2009 06:36:55 +0000
Subject: [PATCH 1/3] sctp: implement definition for SACK-IMMEDIATELY extension
Message-Id: <4AA0B587.6000508@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

This patch implement the definition for SACK-IMMEDIATELY
extension.

Section 3.  The I-bit in the DATA Chunk Header

   The following Figure 1 shows the extended DATA chunk.

    0                   1                   2                   3
    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |   Type = 0    |  Res  |I|U|B|E|           Length              |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                              TSN                              |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |        Stream Identifier      |     Stream Sequence Number    |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                  Payload Protocol Identifier                  |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   \                                                               \
   /                           User Data                           /
   \                                                               \
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

                                 Figure 1

   The only difference between the DATA chunk in Figure 1 and the DATA
   chunk defined in [RFC4960] is the addition of the I-bit in the flags
   field of the chunk header.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/linux/sctp.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index b464b9d..c20d3ce 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -242,6 +242,7 @@ enum {
 	SCTP_DATA_FIRST_FRAG	= 0x02,
 	SCTP_DATA_NOT_FRAG	= 0x03,
 	SCTP_DATA_UNORDERED	= 0x04,
+	SCTP_DATA_SACK_IMM	= 0x08,
 };
 enum { SCTP_DATA_FRAG_MASK = 0x03, };
 
-- 
1.6.2.2




