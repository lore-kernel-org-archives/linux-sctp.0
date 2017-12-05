From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 05 Dec 2017 15:16:07 +0000
Subject: [PATCH net-next 10/12] sctp: implement start_pd for sctp_stream_interleave
Message-Id: <ee787d191e0c861159d4d4fabb9db13d2168e55f.1512486606.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512486606.git.lucien.xin@gmail.com>
 <b830faf5987dbed8b1e724f039348e960b8537e3.1512486606.git.lucien.xin@gmail.com>
 <590ee9b2ecf13733272f9bb1888c60de1f5f47a4.1512486606.git.lucien.xin@gmail.com>
 <4facf144fb29f5b161dd665e3326311001812a1c.1512486606.git.lucien.xin@gmail.com>
 <b8551388363da7b56f7e56132414c1399557a12d.1512486606.git.lucien.xin@gmail.com>
 <ddf7cc34d5fdbdcbe3e8b4e546799c55edff5ca2.1512486606.git.lucien.xin@gmail.com>
 <010d0fbcbdcb70224859dc281e622e0fdf6f46c5.1512486606.git.lucien.xin@gmail.com>
 <7dd410b23c38f41fb8402880185f5e583dabbc04.1512486606.git.lucien.xin@gmail.com>
 <08ec459b56ee8c72c588bdb2350d5619e3678ae5.1512486606.git.lucien.xin@gmail.com>
 <167166ed3ee953dbcee3aef43496d8c7b44c6b95.1512486606.git.lucien.xin@gmail.com>
In-Reply-To: <167166ed3ee953dbcee3aef43496d8c7b44c6b95.1512486606.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

start_pd is added as a member of sctp_stream_interleave, used to
do partial_delivery for data or idata when datalen >= asoc->rwnd
in sctp_eat_data. The codes have been done in last patches, but
they need to be extracted into start_pd, so that it could be used
for SCTP_CMD_PART_DELIVER cmd as well.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/stream_interleave.h | 1 +
 net/sctp/sm_sideeffect.c             | 2 +-
 net/sctp/stream_interleave.c         | 2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/sctp/stream_interleave.h b/include/net/sctp/stream_interleave.h
index 16a71cb..317d9b3 100644
--- a/include/net/sctp/stream_interleave.h
+++ b/include/net/sctp/stream_interleave.h
@@ -45,6 +45,7 @@ struct sctp_stream_interleave {
 				 struct sctp_ulpevent *event);
 	void	(*renege_events)(struct sctp_ulpq *ulpq,
 				 struct sctp_chunk *chunk, gfp_t gfp);
+	void	(*start_pd)(struct sctp_ulpq *ulpq, gfp_t gfp);
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream);
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 2bec17a..3671054 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1731,7 +1731,7 @@ static int sctp_cmd_interpreter(enum sctp_event event_type,
 			break;
 
 		case SCTP_CMD_PART_DELIVER:
-			sctp_ulpq_partial_delivery(&asoc->ulpq, GFP_ATOMIC);
+			asoc->stream.si->start_pd(&asoc->ulpq, GFP_ATOMIC);
 			break;
 
 		case SCTP_CMD_RENEGE:
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 86d6c21..2132181 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -661,6 +661,7 @@ static struct sctp_stream_interleave sctp_stream_interleave_0 = {
 	.ulpevent_data		= sctp_ulpq_tail_data,
 	.enqueue_event		= sctp_ulpq_tail_event,
 	.renege_events		= sctp_ulpq_renege,
+	.start_pd		= sctp_ulpq_partial_delivery,
 };
 
 static struct sctp_stream_interleave sctp_stream_interleave_1 = {
@@ -672,6 +673,7 @@ static struct sctp_stream_interleave sctp_stream_interleave_1 = {
 	.ulpevent_data		= sctp_ulpevent_idata,
 	.enqueue_event		= sctp_enqueue_event,
 	.renege_events		= sctp_renege_events,
+	.start_pd		= sctp_intl_start_pd,
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream)
-- 
2.1.0

