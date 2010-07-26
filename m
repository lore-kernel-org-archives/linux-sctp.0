From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Mon, 26 Jul 2010 02:03:17 +0000
Subject: Re: [PATCH v2] sctp: Process OOTB ASCONF/ASCONF-ACK Chunk at CLOSED
Message-Id: <4C4CECE5.7030306@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

RFC5061 said that If the received ASCONF Chunk is not associated with 
any association, the Chunk should be treated as OOTB. Do the same thing
for received ASCONF-ACK Chunk.

So, process OOTB ASCONF/ASCONF-ACK Chunk according to section 8.4 of RFC4960. 

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
v1-v2: Treat ASCONF-ACK chunk as OOTB chunk for no association.
---
 net/sctp/sm_statetable.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_statetable.c b/net/sctp/sm_statetable.c
index 6d9b3aa..23b3902 100644
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
@@ -470,7 +470,7 @@ static const sctp_sm_table_entry_t chunk_event_table[SCTP_NUM_BASE_CHUNK_TYPES][
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
