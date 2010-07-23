From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Fri, 23 Jul 2010 08:50:18 +0000
Subject: [PATCH] sctp: Process OOTB ASCONF Chunk at CLOSED state
Message-Id: <4C4957CA.9050009@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

RFC5061 said that If the received ASCONF Chunk is not associated with 
any association, the Chunk should be treated as OOTB. So, process
this OOTB chunk according to section 8.4 of RFC4960.

Quote from RFC5061:
5.2. Upon Reception of an ASCONF Chunk
   D3)  If neither D1, D2, nor D2-ext locates the association, treat the
        chunk as an Out Of The Blue packet as defined in [RFC4960].


Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 net/sctp/sm_statetable.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/sm_statetable.c b/net/sctp/sm_statetable.c
index 6d9b3aa..ca300db 100644
--- a/net/sctp/sm_statetable.c
+++ b/net/sctp/sm_statetable.c
@@ -449,7 +449,7 @@ static const sctp_sm_table_entry_t chunk_event_table[SCTP_NUM_BASE_CHUNK_TYPES][
 	/* SCTP_STATE_EMPTY */ \
 	TYPE_SCTP_FUNC(sctp_sf_ootb), \
 	/* SCTP_STATE_CLOSED */ \
-	TYPE_SCTP_FUNC(sctp_sf_discard_chunk), \
+	TYPE_SCTP_FUNC(sctp_sf_ootb), \
 	/* SCTP_STATE_COOKIE_WAIT */ \
 	TYPE_SCTP_FUNC(sctp_sf_discard_chunk), \
 	/* SCTP_STATE_COOKIE_ECHOED */ \
-- 
1.6.3.3

