From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 21 Oct 2018 04:43:38 +0000
Subject: [PATCH net-next 3/3] sctp: process sk_reuseport in sctp_get_port_local
Message-Id: <8695b919f856029566aa477b966ec61ab5611338.1540095102.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1540095102.git.lucien.xin@gmail.com>
 <08b533092a01a8f7cf2eb4c459fe3570a8df702b.1540095102.git.lucien.xin@gmail.com>
 <661578e3134c79c575d934b3267b327773fd34f7.1540095102.git.lucien.xin@gmail.com>
In-Reply-To: <661578e3134c79c575d934b3267b327773fd34f7.1540095102.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

When socks' sk_reuseport is set, the same port and address are allowed
to be bound into these socks who have the same uid.

Note that the difference from sk_reuse is that it allows multiple socks
to listen on the same port and address.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h |  4 +++-
 net/sctp/socket.c          | 46 +++++++++++++++++++++++++++++++++-------------
 2 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 15d017f..af9d494 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -96,7 +96,9 @@ struct sctp_stream;
 
 struct sctp_bind_bucket {
 	unsigned short	port;
-	unsigned short	fastreuse;
+	signed char	fastreuse;
+	signed char	fastreuseport;
+	kuid_t		fastuid;
 	struct hlist_node	node;
 	struct hlist_head	owner;
 	struct net	*net;
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 44e7d8c..8605705 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7642,8 +7642,10 @@ static struct sctp_bind_bucket *sctp_bucket_create(
 
 static long sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 {
-	bool reuse = (sk->sk_reuse || sctp_sk(sk)->reuse);
+	struct sctp_sock *sp = sctp_sk(sk);
+	bool reuse = (sk->sk_reuse || sp->reuse);
 	struct sctp_bind_hashbucket *head; /* hash list */
+	kuid_t uid = sock_i_uid(sk);
 	struct sctp_bind_bucket *pp;
 	unsigned short snum;
 	int ret;
@@ -7719,7 +7721,10 @@ static long sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 
 		pr_debug("%s: found a possible match\n", __func__);
 
-		if (pp->fastreuse && reuse && sk->sk_state != SCTP_SS_LISTENING)
+		if ((pp->fastreuse && reuse &&
+		     sk->sk_state != SCTP_SS_LISTENING) ||
+		    (pp->fastreuseport && sk->sk_reuseport &&
+		     uid_eq(pp->fastuid, uid)))
 			goto success;
 
 		/* Run through the list of sockets bound to the port
@@ -7733,16 +7738,18 @@ static long sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 		 * in an endpoint.
 		 */
 		sk_for_each_bound(sk2, &pp->owner) {
-			struct sctp_endpoint *ep2;
-			ep2 = sctp_sk(sk2)->ep;
+			struct sctp_sock *sp2 = sctp_sk(sk2);
+			struct sctp_endpoint *ep2 = sp2->ep;
 
 			if (sk = sk2 ||
-			    (reuse && (sk2->sk_reuse || sctp_sk(sk2)->reuse) &&
-			     sk2->sk_state != SCTP_SS_LISTENING))
+			    (reuse && (sk2->sk_reuse || sp2->reuse) &&
+			     sk2->sk_state != SCTP_SS_LISTENING) ||
+			    (sk->sk_reuseport && sk2->sk_reuseport &&
+			     uid_eq(uid, sock_i_uid(sk2))))
 				continue;
 
-			if (sctp_bind_addr_conflict(&ep2->base.bind_addr, addr,
-						 sctp_sk(sk2), sctp_sk(sk))) {
+			if (sctp_bind_addr_conflict(&ep2->base.bind_addr,
+						    addr, sp2, sp)) {
 				ret = (long)sk2;
 				goto fail_unlock;
 			}
@@ -7765,19 +7772,32 @@ static long sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 			pp->fastreuse = 1;
 		else
 			pp->fastreuse = 0;
-	} else if (pp->fastreuse &&
-		   (!reuse || sk->sk_state = SCTP_SS_LISTENING))
-		pp->fastreuse = 0;
+
+		if (sk->sk_reuseport) {
+			pp->fastreuseport = 1;
+			pp->fastuid = uid;
+		} else {
+			pp->fastreuseport = 0;
+		}
+	} else {
+		if (pp->fastreuse &&
+		    (!reuse || sk->sk_state = SCTP_SS_LISTENING))
+			pp->fastreuse = 0;
+
+		if (pp->fastreuseport &&
+		    (!sk->sk_reuseport || !uid_eq(pp->fastuid, uid)))
+			pp->fastreuseport = 0;
+	}
 
 	/* We are set, so fill up all the data in the hash table
 	 * entry, tie the socket list information with the rest of the
 	 * sockets FIXME: Blurry, NPI (ipg).
 	 */
 success:
-	if (!sctp_sk(sk)->bind_hash) {
+	if (!sp->bind_hash) {
 		inet_sk(sk)->inet_num = snum;
 		sk_add_bind_node(sk, &pp->owner);
-		sctp_sk(sk)->bind_hash = pp;
+		sp->bind_hash = pp;
 	}
 	ret = 0;
 
-- 
2.1.0
