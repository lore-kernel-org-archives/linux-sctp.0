From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 13 Nov 2017 04:43:50 +0000
Subject: [PATCH net] sctp: do not free asoc when it is already dead in sctp_sendmsg
Message-Id: <dd66b7c05a6e6242192f8af40223447d3db4705f.1510548230.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com

Now in sctp_sendmsg sctp_wait_for_sndbuf could schedule out without
holding sock sk. It means the current asoc can be freed elsewhere,
like when receiving an abort packet.

If the asoc is just created in sctp_sendmsg and sctp_wait_for_sndbuf
returns err, the asoc will be freed again due to new_asoc is not nil.
An use-after-free issue would be triggered by this.

This patch is to fix it by setting new_asoc with nil if the asoc is
already dead when cpu schedules back, so that it will not be freed
again in sctp_sendmsg.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6f45d17..f575976 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -83,8 +83,8 @@
 /* Forward declarations for internal helper functions. */
 static int sctp_writeable(struct sock *sk);
 static void sctp_wfree(struct sk_buff *skb);
-static int sctp_wait_for_sndbuf(struct sctp_association *, long *timeo_p,
-				size_t msg_len);
+static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
+				size_t msg_len, struct sctp_association **new);
 static int sctp_wait_for_packet(struct sock *sk, int *err, long *timeo_p);
 static int sctp_wait_for_connect(struct sctp_association *, long *timeo_p);
 static int sctp_wait_for_accept(struct sock *sk, long timeo);
@@ -1962,7 +1962,7 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 	if (!sctp_wspace(asoc)) {
-		err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len);
+		err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len, &new_asoc);
 		if (err)
 			goto out_free;
 	}
@@ -7822,7 +7822,7 @@ void sctp_sock_rfree(struct sk_buff *skb)
 
 /* Helper function to wait for space in the sndbuf.  */
 static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
-				size_t msg_len)
+				size_t msg_len, struct sctp_association **new)
 {
 	struct sock *sk = asoc->base.sk;
 	int err = 0;
@@ -7839,10 +7839,13 @@ static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
 	for (;;) {
 		prepare_to_wait_exclusive(&asoc->wait, &wait,
 					  TASK_INTERRUPTIBLE);
+		if (asoc->base.dead) {
+			*new = NULL;
+			goto do_error;
+		}
 		if (!*timeo_p)
 			goto do_nonblock;
-		if (sk->sk_err || asoc->state >= SCTP_STATE_SHUTDOWN_PENDING ||
-		    asoc->base.dead)
+		if (sk->sk_err || asoc->state >= SCTP_STATE_SHUTDOWN_PENDING)
 			goto do_error;
 		if (signal_pending(current))
 			goto do_interrupted;
-- 
2.1.0

