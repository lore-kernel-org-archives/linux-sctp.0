From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 02 Mar 2020 06:57:15 +0000
Subject: [PATCH net] sctp: return a one-to-one type socket when doing peeloff
Message-Id: <b3091c0764023bbbb17a26a71e124d0f81349f20.1583132235.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, jere.leppanen@nokia.com, michael.tuexen@lurchi.franken.de

As it says in rfc6458#section-9.2:

  The application uses the sctp_peeloff() call to branch off an
  association into a separate socket.  (Note that the semantics are
  somewhat changed from the traditional one-to-one style accept()
  call.)  Note also that the new socket is a one-to-one style socket.
  Thus, it will be confined to operations allowed for a one-to-one
  style socket.

Prior to this patch, sctp_peeloff() returned a one-to-many type socket,
on which some operations are not allowed, like shutdown, as Jere
reported.

This patch is to change it to return a one-to-one type socket instead.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Leppanen, Jere (Nokia - FI/Espoo) <jere.leppanen@nokia.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1b56fc4..2b55beb 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -88,8 +88,7 @@ static int sctp_send_asconf(struct sctp_association *asoc,
 static int sctp_do_bind(struct sock *, union sctp_addr *, int);
 static int sctp_autobind(struct sock *sk);
 static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
-			     struct sctp_association *assoc,
-			     enum sctp_socket_type type);
+			     struct sctp_association *assoc);
 
 static unsigned long sctp_memory_pressure;
 static atomic_long_t sctp_memory_allocated;
@@ -4965,7 +4964,7 @@ static struct sock *sctp_accept(struct sock *sk, int flags, int *err, bool kern)
 	/* Populate the fields of the newsk from the oldsk and migrate the
 	 * asoc to the newsk.
 	 */
-	error = sctp_sock_migrate(sk, newsk, asoc, SCTP_SOCKET_TCP);
+	error = sctp_sock_migrate(sk, newsk, asoc);
 	if (error) {
 		sk_common_release(newsk);
 		newsk = NULL;
@@ -5711,7 +5710,7 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
 		return -EINVAL;
 
 	/* Create a new socket.  */
-	err = sock_create(sk->sk_family, SOCK_SEQPACKET, IPPROTO_SCTP, &sock);
+	err = sock_create(sk->sk_family, SOCK_STREAM, IPPROTO_SCTP, &sock);
 	if (err < 0)
 		return err;
 
@@ -5727,8 +5726,7 @@ int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id, struct socket **sockp)
 	/* Populate the fields of the newsk from the oldsk and migrate the
 	 * asoc to the newsk.
 	 */
-	err = sctp_sock_migrate(sk, sock->sk, asoc,
-				SCTP_SOCKET_UDP_HIGH_BANDWIDTH);
+	err = sctp_sock_migrate(sk, sock->sk, asoc);
 	if (err) {
 		sock_release(sock);
 		sock = NULL;
@@ -9453,8 +9451,7 @@ static inline void sctp_copy_descendant(struct sock *sk_to,
  * and its messages to the newsk.
  */
 static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
-			     struct sctp_association *assoc,
-			     enum sctp_socket_type type)
+			     struct sctp_association *assoc)
 {
 	struct sctp_sock *oldsp = sctp_sk(oldsk);
 	struct sctp_sock *newsp = sctp_sk(newsk);
@@ -9562,7 +9559,7 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	 * original UDP-style socket or created with the accept() call on a
 	 * TCP-style socket..
 	 */
-	newsp->type = type;
+	newsp->type = SCTP_SOCKET_TCP;
 
 	/* Mark the new socket "in-use" by the user so that any packets
 	 * that may arrive on the association after we've moved it are
-- 
2.1.0
