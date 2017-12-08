From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 08 Dec 2017 13:04:07 +0000
Subject: [PATCHv2 net-next 10/12] sctp: implement start_pd for sctp_stream_interleave
Message-Id: <0de955e81dc688c578d1b54ab7de5bcda70acfcb.1512738021.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512738021.git.lucien.xin@gmail.com>
 <2fef1243f8181062aeb17f7052e5b022ec274a8e.1512738021.git.lucien.xin@gmail.com>
 <7347f16f5b620ed98fdb5f7ac54db4a70e1fd27e.1512738021.git.lucien.xin@gmail.com>
 <9a2bf9495313a79f0bbffb8edaaef25269804feb.1512738021.git.lucien.xin@gmail.com>
 <ed729ca6023dea0812e4caa4d5da3259df375127.1512738021.git.lucien.xin@gmail.com>
 <be593df99566267deff68ff477d2355dfffada80.1512738021.git.lucien.xin@gmail.com>
 <083a620b71eb0446997f308372bdbe2d1e0fdc55.1512738021.git.lucien.xin@gmail.com>
 <9b28c98bbb59126b2be7b81cd4bd16336f99ba69.1512738021.git.lucien.xin@gmail.com>
 <47320a14e77bc56bcce883b79aebc0509386f9e5.1512738021.git.lucien.xin@gmail.com>
 <1a253f52ab5310dcad8f518652e50b959043d8b2.1512738021.git.lucien.xin@gmail.com>
In-Reply-To: <1a253f52ab5310dcad8f518652e50b959043d8b2.1512738021.git.lucien.xin@gmail.com>
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
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
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
index d62ad5c..4dce8d3 100644
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

