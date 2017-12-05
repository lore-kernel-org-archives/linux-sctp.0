From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 05 Dec 2017 15:16:05 +0000
Subject: [PATCH net-next 08/12] sctp: implement enqueue_event for sctp_stream_interleave
Message-Id: <08ec459b56ee8c72c588bdb2350d5619e3678ae5.1512486606.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512486606.git.lucien.xin@gmail.com>
 <b830faf5987dbed8b1e724f039348e960b8537e3.1512486606.git.lucien.xin@gmail.com>
 <590ee9b2ecf13733272f9bb1888c60de1f5f47a4.1512486606.git.lucien.xin@gmail.com>
 <4facf144fb29f5b161dd665e3326311001812a1c.1512486606.git.lucien.xin@gmail.com>
 <b8551388363da7b56f7e56132414c1399557a12d.1512486606.git.lucien.xin@gmail.com>
 <ddf7cc34d5fdbdcbe3e8b4e546799c55edff5ca2.1512486606.git.lucien.xin@gmail.com>
 <010d0fbcbdcb70224859dc281e622e0fdf6f46c5.1512486606.git.lucien.xin@gmail.com>
 <7dd410b23c38f41fb8402880185f5e583dabbc04.1512486606.git.lucien.xin@gmail.com>
In-Reply-To: <7dd410b23c38f41fb8402880185f5e583dabbc04.1512486606.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

enqueue_event is added as a member of sctp_stream_interleave, used to
enqueue either data, idata or notification events into user socket rx
queue.

It replaces sctp_ulpq_tail_event used in the other places with
enqueue_event.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/stream_interleave.h | 2 ++
 net/sctp/associola.c                 | 2 +-
 net/sctp/chunk.c                     | 2 +-
 net/sctp/sm_sideeffect.c             | 9 +++++----
 net/sctp/socket.c                    | 2 +-
 net/sctp/stream_interleave.c         | 2 ++
 6 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/net/sctp/stream_interleave.h b/include/net/sctp/stream_interleave.h
index 02f60f5..a0f61bc 100644
--- a/include/net/sctp/stream_interleave.h
+++ b/include/net/sctp/stream_interleave.h
@@ -41,6 +41,8 @@ struct sctp_stream_interleave {
 	bool	(*validate_data)(struct sctp_chunk *chunk);
 	int	(*ulpevent_data)(struct sctp_ulpq *ulpq,
 				 struct sctp_chunk *chunk, gfp_t gfp);
+	int	(*enqueue_event)(struct sctp_ulpq *ulpq,
+				 struct sctp_ulpevent *event);
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream);
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 69394f4..837806d 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -861,7 +861,7 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 		event = sctp_ulpevent_make_peer_addr_change(asoc, &addr,
 					0, spc_state, error, GFP_ATOMIC);
 		if (event)
-			sctp_ulpq_tail_event(&asoc->ulpq, event);
+			asoc->stream.si->enqueue_event(&asoc->ulpq, event);
 	}
 
 	/* Select new active and retran paths. */
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index bded6af..6c121c6 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -123,7 +123,7 @@ static void sctp_datamsg_destroy(struct sctp_datamsg *msg)
 			ev = sctp_ulpevent_make_send_failed(asoc, chunk, sent,
 							    error, GFP_ATOMIC);
 			if (ev)
-				sctp_ulpq_tail_event(&asoc->ulpq, ev);
+				asoc->stream.si->enqueue_event(&asoc->ulpq, ev);
 		}
 
 		sctp_chunk_put(chunk);
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 9d25efb..f4e5eca 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -972,7 +972,7 @@ static void sctp_cmd_process_operr(struct sctp_cmd_seq *cmds,
 		if (!ev)
 			return;
 
-		sctp_ulpq_tail_event(&asoc->ulpq, ev);
+		asoc->stream.si->enqueue_event(&asoc->ulpq, ev);
 
 		switch (err_hdr->cause) {
 		case SCTP_ERROR_UNKNOWN_CHUNK:
@@ -1058,7 +1058,7 @@ static void sctp_cmd_assoc_change(struct sctp_cmd_seq *commands,
 					    asoc->c.sinit_max_instreams,
 					    NULL, GFP_ATOMIC);
 	if (ev)
-		sctp_ulpq_tail_event(&asoc->ulpq, ev);
+		asoc->stream.si->enqueue_event(&asoc->ulpq, ev);
 }
 
 /* Helper function to generate an adaptation indication event */
@@ -1070,7 +1070,7 @@ static void sctp_cmd_adaptation_ind(struct sctp_cmd_seq *commands,
 	ev = sctp_ulpevent_make_adaptation_indication(asoc, GFP_ATOMIC);
 
 	if (ev)
-		sctp_ulpq_tail_event(&asoc->ulpq, ev);
+		asoc->stream.si->enqueue_event(&asoc->ulpq, ev);
 }
 
 
@@ -1493,7 +1493,8 @@ static int sctp_cmd_interpreter(enum sctp_event event_type,
 			pr_debug("%s: sm_sideff: event_up:%p, ulpq:%p\n",
 				 __func__, cmd->obj.ulpevent, &asoc->ulpq);
 
-			sctp_ulpq_tail_event(&asoc->ulpq, cmd->obj.ulpevent);
+			asoc->stream.si->enqueue_event(&asoc->ulpq,
+						       cmd->obj.ulpevent);
 			break;
 
 		case SCTP_CMD_REPLY:
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 036f945..fe2cab9 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2294,7 +2294,7 @@ static int sctp_setsockopt_events(struct sock *sk, char __user *optval,
 			if (!event)
 				return -ENOMEM;
 
-			sctp_ulpq_tail_event(&asoc->ulpq, event);
+			asoc->stream.si->enqueue_event(&asoc->ulpq, event);
 		}
 	}
 
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 8238311..e853972 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -552,6 +552,7 @@ static struct sctp_stream_interleave sctp_stream_interleave_0 = {
 	.assign_number		= sctp_chunk_assign_ssn,
 	.validate_data		= sctp_validate_data,
 	.ulpevent_data		= sctp_ulpq_tail_data,
+	.enqueue_event		= sctp_ulpq_tail_event,
 };
 
 static struct sctp_stream_interleave sctp_stream_interleave_1 = {
@@ -561,6 +562,7 @@ static struct sctp_stream_interleave sctp_stream_interleave_1 = {
 	.assign_number		= sctp_chunk_assign_mid,
 	.validate_data		= sctp_validate_idata,
 	.ulpevent_data		= sctp_ulpevent_idata,
+	.enqueue_event		= sctp_enqueue_event,
 };
 
 void sctp_stream_interleave_init(struct sctp_stream *stream)
-- 
2.1.0

