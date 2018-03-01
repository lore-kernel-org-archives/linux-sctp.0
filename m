From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 01 Mar 2018 15:05:10 +0000
Subject: [PATCH net-next 1/9] sctp: factor out sctp_sendmsg_to_asoc from sctp_sendmsg
Message-Id: <1dbdb93e27d978da9fe883dbe72db78fbb58ec95.1519916440.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1519916440.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1519916440.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

This patch is to move the codes for checking and sending on
one asoc after this asoc has been found or created into
sctp_sendmsg_to_asoc.

Note that 'err != -ESRCH' check is for the case that asoc is
freed when waiting for tx buffer in sctp_sendmsg_to_asoc.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 230 +++++++++++++++++++++++-------------------------------
 1 file changed, 99 insertions(+), 131 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index bf271f8..183129e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1606,6 +1606,100 @@ static int sctp_error(struct sock *sk, int flags, int err)
 static int sctp_msghdr_parse(const struct msghdr *msg,
 			     struct sctp_cmsgs *cmsgs);
 
+static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
+				struct msghdr *msg, size_t msg_len,
+				struct sctp_transport *transport,
+				struct sctp_sndrcvinfo *sinfo)
+{
+	struct sock *sk = asoc->base.sk;
+	struct net *net = sock_net(sk);
+	struct sctp_datamsg *datamsg;
+	bool wait_connect = false;
+	struct sctp_chunk *chunk;
+	long timeo;
+	int err;
+
+	if (sinfo->sinfo_stream >= asoc->stream.outcnt) {
+		err = -EINVAL;
+		goto err;
+	}
+
+	if (unlikely(!asoc->stream.out[sinfo->sinfo_stream].ext)) {
+		err = sctp_stream_init_ext(&asoc->stream, sinfo->sinfo_stream);
+		if (err)
+			goto err;
+	}
+
+	if (sctp_sk(sk)->disable_fragments && msg_len > asoc->frag_point) {
+		err = -EMSGSIZE;
+		goto err;
+	}
+
+	if (sctp_state(asoc, CLOSED)) {
+		err = sctp_primitive_ASSOCIATE(net, asoc, NULL);
+		if (err)
+			goto err;
+
+		if (sctp_sk(sk)->strm_interleave) {
+			timeo = sock_sndtimeo(sk, 0);
+			err = sctp_wait_for_connect(asoc, &timeo);
+			if (err)
+				goto err;
+		} else {
+			wait_connect = true;
+		}
+
+		pr_debug("%s: we associated primitively\n", __func__);
+	}
+
+	if (asoc->pmtu_pending)
+		sctp_assoc_pending_pmtu(asoc);
+
+	if (sctp_wspace(asoc) < msg_len)
+		sctp_prsctp_prune(asoc, sinfo, msg_len - sctp_wspace(asoc));
+
+	if (!sctp_wspace(asoc)) {
+		timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
+		err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len);
+		if (err)
+			goto err;
+	}
+
+	datamsg = sctp_datamsg_from_user(asoc, sinfo, &msg->msg_iter);
+	if (IS_ERR(datamsg)) {
+		err = PTR_ERR(datamsg);
+		goto err;
+	}
+
+	asoc->force_delay = !!(msg->msg_flags & MSG_MORE);
+
+	list_for_each_entry(chunk, &datamsg->chunks, frag_list) {
+		sctp_chunk_hold(chunk);
+		sctp_set_owner_w(chunk);
+		chunk->transport = transport;
+	}
+
+	err = sctp_primitive_SEND(net, asoc, datamsg);
+	if (err) {
+		sctp_datamsg_free(datamsg);
+		goto err;
+	}
+
+	pr_debug("%s: we sent primitively\n", __func__);
+
+	sctp_datamsg_put(datamsg);
+
+	if (unlikely(wait_connect)) {
+		timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
+		sctp_wait_for_connect(asoc, &timeo);
+	}
+
+	err = msg_len;
+
+err:
+	return err;
+}
+
 static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 {
 	struct net *net = sock_net(sk);
@@ -1622,11 +1716,8 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 	sctp_assoc_t associd = 0;
 	struct sctp_cmsgs cmsgs = { NULL };
 	enum sctp_scope scope;
-	bool fill_sinfo_ttl = false, wait_connect = false;
-	struct sctp_datamsg *datamsg;
-	int msg_flags = msg->msg_flags;
+	bool fill_sinfo_ttl = false;
 	__u16 sinfo_flags = 0;
-	long timeo;
 	int err;
 
 	err = 0;
@@ -1923,49 +2014,6 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 		goto out_free;
 	}
 
-	if (asoc->pmtu_pending)
-		sctp_assoc_pending_pmtu(asoc);
-
-	/* If fragmentation is disabled and the message length exceeds the
-	 * association fragmentation point, return EMSGSIZE.  The I-D
-	 * does not specify what this error is, but this looks like
-	 * a great fit.
-	 */
-	if (sctp_sk(sk)->disable_fragments && (msg_len > asoc->frag_point)) {
-		err = -EMSGSIZE;
-		goto out_free;
-	}
-
-	/* Check for invalid stream. */
-	if (sinfo->sinfo_stream >= asoc->stream.outcnt) {
-		err = -EINVAL;
-		goto out_free;
-	}
-
-	/* Allocate sctp_stream_out_ext if not already done */
-	if (unlikely(!asoc->stream.out[sinfo->sinfo_stream].ext)) {
-		err = sctp_stream_init_ext(&asoc->stream, sinfo->sinfo_stream);
-		if (err)
-			goto out_free;
-	}
-
-	if (sctp_wspace(asoc) < msg_len)
-		sctp_prsctp_prune(asoc, sinfo, msg_len - sctp_wspace(asoc));
-
-	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
-	if (!sctp_wspace(asoc)) {
-		/* sk can be changed by peel off when waiting for buf. */
-		err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len);
-		if (err) {
-			if (err = -ESRCH) {
-				/* asoc is already dead. */
-				new_asoc = NULL;
-				err = -EPIPE;
-			}
-			goto out_free;
-		}
-	}
-
 	/* If an address is passed with the sendto/sendmsg call, it is used
 	 * to override the primary destination address in the TCP model, or
 	 * when SCTP_ADDR_OVER flag is set in the UDP model.
@@ -1980,96 +2028,16 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 	} else
 		chunk_tp = NULL;
 
-	/* Auto-connect, if we aren't connected already. */
-	if (sctp_state(asoc, CLOSED)) {
-		err = sctp_primitive_ASSOCIATE(net, asoc, NULL);
-		if (err < 0)
-			goto out_free;
-
-		/* If stream interleave is enabled, wait_connect has to be
-		 * done earlier than data enqueue, as it needs to make data
-		 * or idata according to asoc->intl_enable which is set
-		 * after connection is done.
-		 */
-		if (sctp_sk(asoc->base.sk)->strm_interleave) {
-			timeo = sock_sndtimeo(sk, 0);
-			err = sctp_wait_for_connect(asoc, &timeo);
-			if (err)
-				goto out_unlock;
-		} else {
-			wait_connect = true;
-		}
-
-		pr_debug("%s: we associated primitively\n", __func__);
-	}
-
-	/* Break the message into multiple chunks of maximum size. */
-	datamsg = sctp_datamsg_from_user(asoc, sinfo, &msg->msg_iter);
-	if (IS_ERR(datamsg)) {
-		err = PTR_ERR(datamsg);
-		goto out_free;
-	}
-	asoc->force_delay = !!(msg->msg_flags & MSG_MORE);
-
-	/* Now send the (possibly) fragmented message. */
-	list_for_each_entry(chunk, &datamsg->chunks, frag_list) {
-		sctp_chunk_hold(chunk);
-
-		/* Do accounting for the write space.  */
-		sctp_set_owner_w(chunk);
-
-		chunk->transport = chunk_tp;
-	}
-
-	/* Send it to the lower layers.  Note:  all chunks
-	 * must either fail or succeed.   The lower layer
-	 * works that way today.  Keep it that way or this
-	 * breaks.
-	 */
-	err = sctp_primitive_SEND(net, asoc, datamsg);
-	/* Did the lower layer accept the chunk? */
-	if (err) {
-		sctp_datamsg_free(datamsg);
-		goto out_free;
-	}
-
-	pr_debug("%s: we sent primitively\n", __func__);
-
-	sctp_datamsg_put(datamsg);
-	err = msg_len;
-
-	if (unlikely(wait_connect)) {
-		timeo = sock_sndtimeo(sk, msg_flags & MSG_DONTWAIT);
-		sctp_wait_for_connect(asoc, &timeo);
-	}
-
-	/* If we are already past ASSOCIATE, the lower
-	 * layers are responsible for association cleanup.
-	 */
-	goto out_unlock;
+	/* Send msg to the asoc */
+	err = sctp_sendmsg_to_asoc(asoc, msg, msg_len, chunk_tp, sinfo);
 
 out_free:
-	if (new_asoc)
+	if (err < 0 && err != -ESRCH && new_asoc)
 		sctp_association_free(asoc);
 out_unlock:
 	release_sock(sk);
-
 out_nounlock:
-	return sctp_error(sk, msg_flags, err);
-
-#if 0
-do_sock_err:
-	if (msg_len)
-		err = msg_len;
-	else
-		err = sock_error(sk);
-	goto out;
-
-do_interrupted:
-	if (msg_len)
-		err = msg_len;
-	goto out;
-#endif /* 0 */
+	return sctp_error(sk, msg->msg_flags, err);
 }
 
 /* This is an extended version of skb_pull() that removes the data from the
-- 
2.1.0

