From: Morten Hustveit <mortehu@ping.uio.no>
Date: Wed, 19 Jan 2011 15:10:49 +0000
Subject: [PATCH] sctp: implement automatic buffer tuning
Message-Id: <20110119151047.GA8630@rossum.ping.uio.no>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

The purpose of this patch is to keep the send and receive buffers closer to
their optimal values, without having to allocate large buffers for all sockets.
Connections with large bandwidth delay products are given larger buffers, while
connections with small bandwidth delay products get buffers at or close to the
default values.

sk_sndbuf is maintained at twice the size of the largest congestion window for
the socket.  The value is never decreased automatically.

We continually monitor the amount of data delivered to user space over the
course of one RTT for each socket.  sk_rcvbuf is maintained at twice this
amount.  The value is never decreased automatically.

Signed-off-by: Morten Hustveit <mortehu@ping.uio.no>
---
 include/net/sctp/sctp.h    |    4 ++
 include/net/sctp/structs.h |   15 +++++++
 net/sctp/associola.c       |   11 ++++-
 net/sctp/protocol.c        |    4 +-
 net/sctp/sm_make_chunk.c   |    2 +-
 net/sctp/socket.c          |   92 +++++++++++++++++++++++++++++++++++++++++++-
 net/sctp/transport.c       |    4 +-
 net/sctp/ulpevent.c        |    5 +-
 8 files changed, 127 insertions(+), 10 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 505845d..c377dd4 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -128,6 +128,10 @@ extern int sctp_register_pf(struct sctp_pf *, sa_family_t);
 int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb);
 int sctp_inet_listen(struct socket *sock, int backlog);
 void sctp_write_space(struct sock *sk);
+int sctp_raise_sndbuf(struct sctp_transport *transport);
+int sctp_raise_rcvbuf(struct sctp_association *asoc, int rcvmem);
+unsigned int sctp_rcvbuf_adjust(struct sctp_association *asoc,
+				unsigned int len);
 void sctp_data_ready(struct sock *sk, int len);
 unsigned int sctp_poll(struct file *file, struct socket *sock,
 		poll_table *wait);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index cc9185c..015a73d 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -272,6 +272,10 @@ extern struct sctp_globals {
 #define sctp_checksum_disable		(sctp_globals.checksum_disable)
 #define sctp_rwnd_upd_shift		(sctp_globals.rwnd_update_shift)
 
+extern long sysctl_sctp_mem[3];
+extern int sysctl_sctp_rmem[3];
+extern int sysctl_sctp_wmem[3];
+
 /* SCTP Socket type: UDP or TCP style. */
 typedef enum {
 	SCTP_SOCKET_UDP = 0,
@@ -1752,6 +1756,17 @@ struct sctp_association {
 	 */
 	__u32 rwnd_press;
 
+	/* Timer used for calculating the appropriate receive buffer space. */
+	struct {
+		/* The starting time of the current measurement period. */
+		unsigned long start_time;
+
+		/* The number of bytes delivered to user space in the current
+		 * measurement period.
+		 */
+		int delivered;
+	} rcvq_space;
+
 	/* This is the sndbuf size in use for the association.
 	 * This corresponds to the sndbuf size for the association,
 	 * as specified in the sk->sndbuf.
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 5f1fb8b..7ad88f5 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1462,7 +1462,9 @@ void sctp_assoc_rwnd_increase(struct sctp_association *asoc, unsigned len)
 /* Decrease asoc's rwnd by len. */
 void sctp_assoc_rwnd_decrease(struct sctp_association *asoc, unsigned len)
 {
+	struct sock *sk = asoc->base.sk;
 	int rx_count;
+	int rcvmem;
 	int over = 0;
 
 	SCTP_ASSERT(asoc->rwnd, "rwnd zero", return);
@@ -1471,14 +1473,19 @@ void sctp_assoc_rwnd_decrease(struct sctp_association *asoc, unsigned len)
 	if (asoc->ep->rcvbuf_policy)
 		rx_count = atomic_read(&asoc->rmem_alloc);
 	else
-		rx_count = atomic_read(&asoc->base.sk->sk_rmem_alloc);
+		rx_count = atomic_read(&sk->sk_rmem_alloc);
+
+	if (rx_count >= sk->sk_rcvbuf) {
+		rcvmem = min_t(int, rx_count + len, sysctl_sctp_rmem[2]);
+		sctp_raise_rcvbuf(asoc, rcvmem);
+	}
 
 	/* If we've reached or overflowed our receive buffer, announce
 	 * a 0 rwnd if rwnd would still be positive.  Store the
 	 * the pottential pressure overflow so that the window can be restored
 	 * back to original value.
 	 */
-	if (rx_count >= asoc->base.sk->sk_rcvbuf)
+	if (rx_count >= sk->sk_rcvbuf)
 		over = 1;
 
 	if (asoc->rwnd >= len) {
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index e58f947..eca25b2 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1184,8 +1184,8 @@ SCTP_STATIC __init int sctp_init(void)
 	sysctl_sctp_rmem[2] = max(sysctl_sctp_rmem[1], max_share);
 
 	sysctl_sctp_wmem[0] = SK_MEM_QUANTUM;
-	sysctl_sctp_wmem[1] = 16*1024;
-	sysctl_sctp_wmem[2] = max(64*1024, max_share);
+	sysctl_sctp_wmem[1] = 120*1024;
+	sysctl_sctp_wmem[2] = max(sysctl_sctp_wmem[1], max_share);
 
 	/* Size and allocate the association hash table.
 	 * The methodology is similar to that of the tcp hash tables.
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 2cc46f0..9c0629a 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2352,7 +2352,7 @@ int sctp_process_init(struct sctp_association *asoc, sctp_cid_t cid,
 	 */
 	list_for_each_entry(transport, &asoc->peer.transport_addr_list,
 			transports) {
-		transport->ssthresh = asoc->peer.i.a_rwnd;
+		transport->ssthresh = sysctl_sctp_wmem[2] / 2;
 	}
 
 	/* Set up the TSN tracking pieces.  */
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a09b0dd..7115098 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1946,6 +1946,7 @@ SCTP_STATIC int sctp_recvmsg(struct kiocb *iocb, struct sock *sk,
 	struct sctp_ulpevent *event = NULL;
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sk_buff *skb;
+	int rcvbuf_increment;
 	int copied;
 	int err = 0;
 	int skb_len;
@@ -2016,8 +2017,10 @@ SCTP_STATIC int sctp_recvmsg(struct kiocb *iocb, struct sock *sk,
 		 * rwnd by that amount. If all the data in the skb is read,
 		 * rwnd is updated when the event is freed.
 		 */
-		if (!sctp_ulpevent_is_notification(event))
-			sctp_assoc_rwnd_increase(event->asoc, copied);
+		if (!sctp_ulpevent_is_notification(event)) {
+			rcvbuf_increment = sctp_rcvbuf_adjust(event->asoc, len);
+			sctp_assoc_rwnd_increase(event->asoc, copied + rcvbuf_increment);
+		}
 		goto out;
 	} else if ((event->msg_flags & MSG_NOTIFICATION) ||
 		   (event->msg_flags & MSG_EOR))
@@ -3769,6 +3772,9 @@ SCTP_STATIC int sctp_init_sock(struct sock *sk)
 
 	SCTP_DBG_OBJCNT_INC(sock);
 
+	sk->sk_sndbuf = sysctl_sctp_wmem[1];
+	sk->sk_rcvbuf = sysctl_sctp_rmem[1];
+
 	local_bh_disable();
 	percpu_counter_inc(&sctp_sockets_allocated);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
@@ -6253,6 +6259,88 @@ void sctp_write_space(struct sock *sk)
 	}
 }
 
+int sctp_raise_sndbuf(struct sctp_transport *transport)
+{
+	struct sctp_association *asoc = transport->asoc;
+	struct sock *sk = asoc->base.sk;
+	int sndmem;
+
+	sndmem = min_t(int, transport->cwnd * 2, sysctl_sctp_wmem[2]);
+
+	if (sk->sk_sndbuf >= sndmem)
+		return 1;
+
+	if (sk->sk_userlocks & SOCK_SNDBUF_LOCK)
+		return 0;
+
+	if (sctp_memory_pressure)
+		return 0;
+
+	if (atomic_long_read(&sctp_memory_allocated) >= sysctl_sctp_mem[0])
+		return 0;
+
+	if (transport->flight_size >= transport->cwnd)
+		return 0;
+
+	sk->sk_sndbuf = sndmem;
+
+        return 1;
+}
+
+int sctp_raise_rcvbuf(struct sctp_association *asoc, int rcvmem)
+{
+	struct sock *sk = asoc->base.sk;
+
+	if (sk->sk_rcvbuf >= rcvmem)
+		return 1;
+
+	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK)
+		return 0;
+
+	if (sctp_memory_pressure)
+		return 0;
+
+	if (atomic_long_read(&sctp_memory_allocated) >= sysctl_sctp_mem[0])
+		return 0;
+
+        sk->sk_rcvbuf = rcvmem;
+
+        return 1;
+}
+
+unsigned int sctp_rcvbuf_adjust(struct sctp_association *asoc, unsigned int len)
+{
+	struct sctp_transport *transport = asoc->peer.last_data_from;
+	struct sock *sk = asoc->base.sk;
+	unsigned long time;
+	unsigned increment = 0;
+	int rcvmem = 0;
+
+	if (!asoc->rcvq_space.start_time)
+		goto new_measure;
+
+	asoc->rcvq_space.delivered += len;
+
+	time = jiffies - asoc->rcvq_space.start_time;
+
+	if (time < transport->rtt || !transport->rtt)
+		return 0;
+
+	rcvmem = min_t(int, asoc->rcvq_space.delivered * 2, sysctl_sctp_rmem[2]);
+
+	if (sk->sk_rcvbuf < rcvmem) {
+		increment = rcvmem - sk->sk_rcvbuf;
+		if (!sctp_raise_rcvbuf(asoc, rcvmem))
+			increment = 0;
+	}
+
+new_measure:
+	asoc->rcvq_space.start_time = jiffies;
+	asoc->rcvq_space.delivered = 0;
+
+	return increment;
+}
+
 /* Is there any sndbuf space available on the socket?
  *
  * Note that sk_wmem_alloc is the sum of the send buffers on all of the
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index d3ae493..4c1768e 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -466,6 +466,8 @@ void sctp_transport_raise_cwnd(struct sctp_transport *transport,
 
 	transport->cwnd = cwnd;
 	transport->partial_bytes_acked = pba;
+
+	sctp_raise_sndbuf(transport);
 }
 
 /* This routine is used to lower the transport's cwnd when congestion is
@@ -621,7 +623,7 @@ void sctp_transport_reset(struct sctp_transport *t)
 	 */
 	t->cwnd = min(4*asoc->pathmtu, max_t(__u32, 2*asoc->pathmtu, 4380));
 	t->burst_limited = 0;
-	t->ssthresh = asoc->peer.i.a_rwnd;
+	t->ssthresh = sysctl_sctp_wmem[2] / 2;
 	t->rto = asoc->rto_initial;
 	t->rtt = 0;
 	t->srtt = 0;
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index aa72e89..4395e52b 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -987,7 +987,7 @@ static void sctp_ulpevent_receive_data(struct sctp_ulpevent *event,
 static void sctp_ulpevent_release_data(struct sctp_ulpevent *event)
 {
 	struct sk_buff *skb, *frag;
-	unsigned int	len;
+	unsigned int	len, rcvbuf_increment;
 
 	/* Current stack structures assume that the rcv buffer is
 	 * per socket.   For UDP style sockets this is not true as
@@ -1012,7 +1012,8 @@ static void sctp_ulpevent_release_data(struct sctp_ulpevent *event)
 	}
 
 done:
-	sctp_assoc_rwnd_increase(event->asoc, len);
+	rcvbuf_increment = sctp_rcvbuf_adjust(event->asoc, len);
+	sctp_assoc_rwnd_increase(event->asoc, len + rcvbuf_increment);
 	sctp_ulpevent_release_owner(event);
 }
 
