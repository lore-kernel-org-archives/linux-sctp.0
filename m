From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 03 Feb 2010 05:04:22 +0000
Subject: [PATCH] sctp: avoid irq lock inversion while call sk->sk_data_ready()
Message-Id: <4B6903D6.8070106@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

sk->sk_data_ready() of sctp socket can be called from both BH and non-BH
contexts, but the default sk->sk_data_ready(), sock_def_readable(), can
not be used in this case. Therefore, we have to make a new function
sctp_data_ready() to grab sk->sk_data_ready() with BH disabling.

============================[ INFO: possible irq lock inversion dependency detected ]
2.6.33-rc6 #129
---------------------------------------------------------
sctp_darn/1517 just changed the state of lock:
 (clock-AF_INET){++.?..}, at: [<c06aab60>] sock_def_readable+0x20/0x80
but this lock took another, SOFTIRQ-unsafe lock in the past:
 (slock-AF_INET){+.-...}

and interrupts could create inverse lock ordering between them.

other info that might help us debug this:
1 lock held by sctp_darn/1517:
 #0:  (sk_lock-AF_INET){+.+.+.}, at: [<cdfe363d>] sctp_sendmsg+0x23d/0xc00 [sctp]

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 include/net/sctp/sctp.h |    1 +
 net/sctp/endpointola.c  |    1 +
 net/sctp/socket.c       |   10 ++++++++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 78740ec..fa6cde5 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -128,6 +128,7 @@ extern int sctp_register_pf(struct sctp_pf *, sa_family_t);
 int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb);
 int sctp_inet_listen(struct socket *sock, int backlog);
 void sctp_write_space(struct sock *sk);
+void sctp_data_ready(struct sock *sk, int len);
 unsigned int sctp_poll(struct file *file, struct socket *sock,
 		poll_table *wait);
 void sctp_sock_rfree(struct sk_buff *skb);
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index 905fda5..7ec09ba 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -144,6 +144,7 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 	/* Use SCTP specific send buffer space queues.  */
 	ep->sndbuf_policy = sctp_sndbuf_policy;
 
+	sk->sk_data_ready = sctp_data_ready;
 	sk->sk_write_space = sctp_write_space;
 	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 67fdac9..b437e2a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -6185,6 +6185,16 @@ do_nonblock:
 	goto out;
 }
 
+void sctp_data_ready(struct sock *sk, int len)
+{
+	read_lock_bh(&sk->sk_callback_lock);
+	if (sk_has_sleeper(sk))
+		wake_up_interruptible_sync_poll(sk->sk_sleep, POLLIN |
+						POLLRDNORM | POLLRDBAND);
+	sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
+	read_unlock_bh(&sk->sk_callback_lock);
+}
+
 /* If socket sndbuf has changed, wake up all per association waiters.  */
 void sctp_write_space(struct sock *sk)
 {
-- 
1.6.5.2


