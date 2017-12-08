From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 08 Dec 2017 13:04:05 +0000
Subject: [PATCHv2 net-next 08/12] sctp: implement enqueue_event for sctp_stream_interleave
Message-Id: <47320a14e77bc56bcce883b79aebc0509386f9e5.1512738021.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1512738021.git.lucien.xin@gmail.com>
 <2fef1243f8181062aeb17f7052e5b022ec274a8e.1512738021.git.lucien.xin@gmail.com>
 <7347f16f5b620ed98fdb5f7ac54db4a70e1fd27e.1512738021.git.lucien.xin@gmail.com>
 <9a2bf9495313a79f0bbffb8edaaef25269804feb.1512738021.git.lucien.xin@gmail.com>
 <ed729ca6023dea0812e4caa4d5da3259df375127.1512738021.git.lucien.xin@gmail.com>
 <be593df99566267deff68ff477d2355dfffada80.1512738021.git.lucien.xin@gmail.com>
 <083a620b71eb0446997f308372bdbe2d1e0fdc55.1512738021.git.lucien.xin@gmail.com>
 <9b28c98bbb59126b2be7b81cd4bd16336f99ba69.1512738021.git.lucien.xin@gmail.com>
In-Reply-To: <9b28c98bbb59126b2be7b81cd4bd16336f99ba69.1512738021.git.lucien.xin@gmail.com>
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
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
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
index 62adaaa..991a530 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -124,7 +124,7 @@ static void sctp_datamsg_destroy(struct sctp_datamsg *msg)
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

