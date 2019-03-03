From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 03 Mar 2019 09:54:53 +0000
Subject: [PATCH net 1/3] sctp: sctp_sock_migrate() returns error if sctp_bind_addr_dup() fails
Message-Id: <6837e72485125c8740900fd17fa84ac68b8892a5.1551606805.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1551606805.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1551606805.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

It should fail to create the new sk if sctp_bind_addr_dup() fails
when accepting or peeloff an association.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a2771b3..22adb8d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -102,9 +102,9 @@ static int sctp_send_asconf(struct sctp_association *asoc,
 			    struct sctp_chunk *chunk);
 static int sctp_do_bind(struct sock *, union sctp_addr *, int);
 static int sctp_autobind(struct sock *sk);
-static void sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
-			      struct sctp_association *assoc,
-			      enum sctp_socket_type type);
+static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
+			     struct sctp_association *assoc,
+			     enum sctp_socket_type type);
 
 static unsigned long sctp_memory_pressure;
 static atomic_long_t sctp_memory_allocated;
@@ -4655,7 +4655,11 @@ static struct sock *sctp_accept(struct sock *sk, int flags, int *err, bool kern)
 	/* Populate the fields of the newsk from the oldsk and migrate the
 	 * asoc to the newsk.
 	 */
-	sctp_sock_migrate(sk, newsk, asoc, SCTP_SOCKET_TCP);
+	error = sctp_sock_migrate(sk, newsk, asoc, SCTP_SOCKET_TCP);
+	if (error) {
+		sk_common_release(newsk);
+		newsk = NULL;
+	}
 
 out:
 	release_sock(sk);
@@ -5401,7 +5405,12 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
 	/* Populate the fields of the newsk from the oldsk and migrate the
 	 * asoc to the newsk.
 	 */
-	sctp_sock_migrate(sk, sock->sk, asoc, SCTP_SOCKET_UDP_HIGH_BANDWIDTH);
+	err = sctp_sock_migrate(sk, sock->sk, asoc,
+				SCTP_SOCKET_UDP_HIGH_BANDWIDTH);
+	if (err) {
+		sock_release(sock);
+		sock = NULL;
+	}
 
 	*sockp = sock;
 
@@ -8924,9 +8933,9 @@ static inline void sctp_copy_descendant(struct sock *sk_to,
 /* Populate the fields of the newsk from the oldsk and migrate the assoc
  * and its messages to the newsk.
  */
-static void sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
-			      struct sctp_association *assoc,
-			      enum sctp_socket_type type)
+static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
+			     struct sctp_association *assoc,
+			     enum sctp_socket_type type)
 {
 	struct sctp_sock *oldsp = sctp_sk(oldsk);
 	struct sctp_sock *newsp = sctp_sk(newsk);
@@ -8935,6 +8944,7 @@ static void sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	struct sk_buff *skb, *tmp;
 	struct sctp_ulpevent *event;
 	struct sctp_bind_hashbucket *head;
+	int err;
 
 	/* Migrate socket buffer sizes and all the socket level options to the
 	 * new socket.
@@ -8963,8 +8973,10 @@ static void sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	/* Copy the bind_addr list from the original endpoint to the new
 	 * endpoint so that we can handle restarts properly
 	 */
-	sctp_bind_addr_dup(&newsp->ep->base.bind_addr,
-				&oldsp->ep->base.bind_addr, GFP_KERNEL);
+	err = sctp_bind_addr_dup(&newsp->ep->base.bind_addr,
+				 &oldsp->ep->base.bind_addr, GFP_KERNEL);
+	if (err)
+		return err;
 
 	/* Move any messages in the old socket's receive queue that are for the
 	 * peeled off association to the new socket's receive queue.
@@ -9049,6 +9061,8 @@ static void sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	}
 
 	release_sock(newsk);
+
+	return 0;
 }
 
 
-- 
2.1.0
