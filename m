From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 25 Nov 2017 13:18:35 +0000
Subject: [PATCH net 2/3] sctp: abandon the whole msg if one part of a fragmented message is abandoned
Message-Id: <527417b933f70998528cbbfcdf4f6a8405fb0292.1511615658.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1511615658.git.lucien.xin@gmail.com>
 <9c96424d052af79cfcefeec8bc53b6b541c1900f.1511615658.git.lucien.xin@gmail.com>
In-Reply-To: <9c96424d052af79cfcefeec8bc53b6b541c1900f.1511615658.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

As rfc3758#section-3.1 demands:

   A3) When a TSN is "abandoned", if it is part of a fragmented message,
       all other TSN's within that fragmented message MUST be abandoned
       at the same time.

Besides, if it couldn't handle this, the rest frags would never get
assembled in peer side.

This patch supports it by adding abandoned flag in sctp_datamsg, when
one chunk is being abandoned, set chunk->msg->abandoned as well. Next
time when checking for abandoned, go checking chunk->msg->abandoned
first.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h |  3 ++-
 net/sctp/chunk.c           |  7 +++++++
 net/sctp/outqueue.c        | 12 ++++++++----
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 16f949e..2f8f93d 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -503,7 +503,8 @@ struct sctp_datamsg {
 	/* Did the messenge fail to send? */
 	int send_error;
 	u8 send_failed:1,
-	   can_delay;	    /* should this message be Nagle delayed */
+	   can_delay:1,	/* should this message be Nagle delayed */
+	   abandoned:1;	/* should this message be abandoned */
 };
 
 struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *,
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index 7b261af..9213805 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -53,6 +53,7 @@ static void sctp_datamsg_init(struct sctp_datamsg *msg)
 	msg->send_failed = 0;
 	msg->send_error = 0;
 	msg->can_delay = 1;
+	msg->abandoned = 0;
 	msg->expires_at = 0;
 	INIT_LIST_HEAD(&msg->chunks);
 }
@@ -304,6 +305,9 @@ int sctp_chunk_abandoned(struct sctp_chunk *chunk)
 	if (!chunk->asoc->peer.prsctp_capable)
 		return 0;
 
+	if (chunk->msg->abandoned)
+		return 1;
+
 	if (SCTP_PR_TTL_ENABLED(chunk->sinfo.sinfo_flags) &&
 	    time_after(jiffies, chunk->msg->expires_at)) {
 		struct sctp_stream_out *streamout @@ -316,6 +320,7 @@ int sctp_chunk_abandoned(struct sctp_chunk *chunk)
 			chunk->asoc->abandoned_unsent[SCTP_PR_INDEX(TTL)]++;
 			streamout->ext->abandoned_unsent[SCTP_PR_INDEX(TTL)]++;
 		}
+		chunk->msg->abandoned = 1;
 		return 1;
 	} else if (SCTP_PR_RTX_ENABLED(chunk->sinfo.sinfo_flags) &&
 		   chunk->sent_count > chunk->sinfo.sinfo_timetolive) {
@@ -324,10 +329,12 @@ int sctp_chunk_abandoned(struct sctp_chunk *chunk)
 
 		chunk->asoc->abandoned_sent[SCTP_PR_INDEX(RTX)]++;
 		streamout->ext->abandoned_sent[SCTP_PR_INDEX(RTX)]++;
+		chunk->msg->abandoned = 1;
 		return 1;
 	} else if (!SCTP_PR_POLICY(chunk->sinfo.sinfo_flags) &&
 		   chunk->msg->expires_at &&
 		   time_after(jiffies, chunk->msg->expires_at)) {
+		chunk->msg->abandoned = 1;
 		return 1;
 	}
 	/* PRIO policy is processed by sendmsg, not here */
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 7029f8b..4ab164b 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -364,10 +364,12 @@ static int sctp_prsctp_prune_sent(struct sctp_association *asoc,
 	list_for_each_entry_safe(chk, temp, queue, transmitted_list) {
 		struct sctp_stream_out *streamout;
 
-		if (!SCTP_PR_PRIO_ENABLED(chk->sinfo.sinfo_flags) ||
-		    chk->sinfo.sinfo_timetolive <= sinfo->sinfo_timetolive)
+		if (!chk->msg->abandoned &&
+		    (!SCTP_PR_PRIO_ENABLED(chk->sinfo.sinfo_flags) ||
+		     chk->sinfo.sinfo_timetolive <= sinfo->sinfo_timetolive))
 			continue;
 
+		chk->msg->abandoned = 1;
 		list_del_init(&chk->transmitted_list);
 		sctp_insert_list(&asoc->outqueue.abandoned,
 				 &chk->transmitted_list);
@@ -404,10 +406,12 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 	q->sched->unsched_all(&asoc->stream);
 
 	list_for_each_entry_safe(chk, temp, &q->out_chunk_list, list) {
-		if (!SCTP_PR_PRIO_ENABLED(chk->sinfo.sinfo_flags) ||
-		    chk->sinfo.sinfo_timetolive <= sinfo->sinfo_timetolive)
+		if (!chk->msg->abandoned &&
+		    (!SCTP_PR_PRIO_ENABLED(chk->sinfo.sinfo_flags) ||
+		     chk->sinfo.sinfo_timetolive <= sinfo->sinfo_timetolive))
 			continue;
 
+		chk->msg->abandoned = 1;
 		sctp_sched_dequeue_common(q, chk);
 		asoc->sent_cnt_removable--;
 		asoc->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
-- 
2.1.0

