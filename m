From: Christoph Hellwig <hch@lst.de>
Date: Fri, 29 May 2020 12:09:42 +0000
Subject: [PATCH 3/4] net: add a new bind_add method
Message-Id: <20200529120943.101454-4-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200529120943.101454-1-hch@lst.de>
In-Reply-To: <20200529120943.101454-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, cluster-devel@redhat.com, netdev@vger.kernel.org

The SCTP protocol allows to bind multiple address to a socket.  That
feature is currently only exposed as a socket option.  Add a bind_add
method struct proto that allows to bind additional addresses, and
switch the dlm code to use the method instead of going through the
socket option from kernel space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dlm/lowcomms.c  |  9 +++------
 include/net/sock.h |  6 +++++-
 net/core/sock.c    |  8 ++++++++
 net/sctp/socket.c  | 14 ++++++++++++++
 4 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 9f1c3cdc9d653..3543a8fec9075 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -882,6 +882,7 @@ static void writequeue_entry_complete(struct writequeue_entry *e, int completed)
 static int sctp_bind_addrs(struct connection *con, uint16_t port)
 {
 	struct sockaddr_storage localaddr;
+	struct sockaddr *addr = (struct sockaddr *)&localaddr;
 	int i, addr_len, result = 0;
 
 	for (i = 0; i < dlm_local_count; i++) {
@@ -889,13 +890,9 @@ static int sctp_bind_addrs(struct connection *con, uint16_t port)
 		make_sockaddr(&localaddr, port, &addr_len);
 
 		if (!i)
-			result = kernel_bind(con->sock,
-					     (struct sockaddr *)&localaddr,
-					     addr_len);
+			result = kernel_bind(con->sock, addr, addr_len);
 		else
-			result = kernel_setsockopt(con->sock, SOL_SCTP,
-						   SCTP_SOCKOPT_BINDX_ADD,
-						   (char *)&localaddr, addr_len);
+			result = sock_bind_add(con->sock->sk, addr, addr_len);
 
 		if (result < 0) {
 			log_print("Can't bind to %d addr number %d, %d.\n",
diff --git a/include/net/sock.h b/include/net/sock.h
index d994daa418ec2..6e9f713a78607 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1156,7 +1156,9 @@ struct proto {
 	int			(*sendpage)(struct sock *sk, struct page *page,
 					int offset, size_t size, int flags);
 	int			(*bind)(struct sock *sk,
-					struct sockaddr *uaddr, int addr_len);
+					struct sockaddr *addr, int addr_len);
+	int			(*bind_add)(struct sock *sk,
+					struct sockaddr *addr, int addr_len);
 
 	int			(*backlog_rcv) (struct sock *sk,
 						struct sk_buff *skb);
@@ -2698,4 +2700,6 @@ void sock_set_reuseaddr(struct sock *sk);
 void sock_set_reuseport(struct sock *sk);
 void sock_set_sndtimeo(struct sock *sk, s64 secs);
 
+int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len);
+
 #endif	/* _SOCK_H */
diff --git a/net/core/sock.c b/net/core/sock.c
index 2ca3425b519c0..61ec573221a60 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3712,3 +3712,11 @@ bool sk_busy_loop_end(void *p, unsigned long start_time)
 }
 EXPORT_SYMBOL(sk_busy_loop_end);
 #endif /* CONFIG_NET_RX_BUSY_POLL */
+
+int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len)
+{
+	if (!sk->sk_prot->bind_add)
+		return -EOPNOTSUPP;
+	return sk->sk_prot->bind_add(sk, addr, addr_len);
+}
+EXPORT_SYMBOL(sock_bind_add);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6e745ac3c4a59..d57e1a002ffc8 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1052,6 +1052,18 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 	return err;
 }
 
+static int sctp_bind_add(struct sock *sk, struct sockaddr *addrs,
+		int addrlen)
+{
+	int err;
+
+	lock_sock(sk);
+	err = sctp_setsockopt_bindx_kernel(sk, addrs, addrlen,
+					   SCTP_BINDX_ADD_ADDR);
+	release_sock(sk);
+	return err;
+}
+
 static int sctp_connect_new_asoc(struct sctp_endpoint *ep,
 				 const union sctp_addr *daddr,
 				 const struct sctp_initmsg *init,
@@ -9620,6 +9632,7 @@ struct proto sctp_prot = {
 	.sendmsg     =	sctp_sendmsg,
 	.recvmsg     =	sctp_recvmsg,
 	.bind        =	sctp_bind,
+	.bind_add    =  sctp_bind_add,
 	.backlog_rcv =	sctp_backlog_rcv,
 	.hash        =	sctp_hash,
 	.unhash      =	sctp_unhash,
@@ -9662,6 +9675,7 @@ struct proto sctpv6_prot = {
 	.sendmsg	= sctp_sendmsg,
 	.recvmsg	= sctp_recvmsg,
 	.bind		= sctp_bind,
+	.bind_add	= sctp_bind_add,
 	.backlog_rcv	= sctp_backlog_rcv,
 	.hash		= sctp_hash,
 	.unhash		= sctp_unhash,
-- 
2.26.2
