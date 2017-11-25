From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 25 Nov 2017 13:18:36 +0000
Subject: [PATCH net 3/3] sctp: do not abandon the other frags in unsent outq if one msg has outstanding frags
Message-Id: <12f2aba36279bcf52a1e9836a68c0e592c8d35bc.1511615658.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1511615658.git.lucien.xin@gmail.com>
 <9c96424d052af79cfcefeec8bc53b6b541c1900f.1511615658.git.lucien.xin@gmail.com>
 <527417b933f70998528cbbfcdf4f6a8405fb0292.1511615658.git.lucien.xin@gmail.com>
In-Reply-To: <527417b933f70998528cbbfcdf4f6a8405fb0292.1511615658.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

Now for the abandoned chunks in unsent outq, it would just free the chunks.
Because no tsn is assigned to them yet, there's no need to send fwd tsn to
peer, unlike for the abandoned chunks in sent outq.

The problem is when parts of the msg have been sent and the other frags
are still in unsent outq, if they are abandoned/dropped, the peer would
never get this msg reassembled.

So these frags in unsent outq can't be dropped if this msg already has
outstanding frags.

This patch does the check in sctp_chunk_abandoned and
sctp_prsctp_prune_unsent.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/chunk.c    | 4 ++++
 net/sctp/outqueue.c | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index 9213805..7f8baa4 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -308,6 +308,10 @@ int sctp_chunk_abandoned(struct sctp_chunk *chunk)
 	if (chunk->msg->abandoned)
 		return 1;
 
+	if (!chunk->has_tsn &&
+	    !(chunk->chunk_hdr->flags & SCTP_DATA_FIRST_FRAG))
+		return 0;
+
 	if (SCTP_PR_TTL_ENABLED(chunk->sinfo.sinfo_flags) &&
 	    time_after(jiffies, chunk->msg->expires_at)) {
 		struct sctp_stream_out *streamout diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 4ab164b..7d67fee 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -407,7 +407,8 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 
 	list_for_each_entry_safe(chk, temp, &q->out_chunk_list, list) {
 		if (!chk->msg->abandoned &&
-		    (!SCTP_PR_PRIO_ENABLED(chk->sinfo.sinfo_flags) ||
+		    (!(chk->chunk_hdr->flags & SCTP_DATA_FIRST_FRAG) ||
+		     !SCTP_PR_PRIO_ENABLED(chk->sinfo.sinfo_flags) ||
 		     chk->sinfo.sinfo_timetolive <= sinfo->sinfo_timetolive))
 			continue;
 
-- 
2.1.0

