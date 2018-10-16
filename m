From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 16 Oct 2018 19:07:51 +0000
Subject: [PATCH net-next 2/2] sctp: use sk_wmem_queued to check for writable space
Message-Id: <e794048df28ac777385e7ecde80e63e65d0d7d69.1539716812.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1539716812.git.lucien.xin@gmail.com>
 <69e02c98600ba4e4142056bd25fbe3a006f94e52.1539716812.git.lucien.xin@gmail.com>
In-Reply-To: <69e02c98600ba4e4142056bd25fbe3a006f94e52.1539716812.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

sk->sk_wmem_queued is used to count the size of chunks in out queue
while sk->sk_wmem_alloc is for counting the size of chunks has been
sent. sctp is increasing both of them before enqueuing the chunks,
and using sk->sk_wmem_alloc to check for writable space.

However, sk_wmem_alloc is also increased by 1 for the skb allocked
for sending in sctp_packet_transmit() but it will not wake up the
waiters when sk_wmem_alloc is decreased in this skb's destructor.

If msg size is equal to sk_sndbuf and sendmsg is waiting for sndbuf,
the check 'msg_len <= sctp_wspace(asoc)' in sctp_wait_for_sndbuf()
will keep waiting if there's a skb allocked in sctp_packet_transmit,
and later even if this skb got freed, the waiting thread will never
get waked up.

This issue has been there since very beginning, so we change to use
sk->sk_wmem_queued to check for writable space as sk_wmem_queued is
not increased for the skb allocked for sending, also as TCP does.

SOCK_SNDBUF_LOCK check is also removed here as it's for tx buf auto
tuning which I will add in another patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 38 +++++++++-----------------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c6f2950..111ebd8 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -83,7 +83,7 @@
 #include <net/sctp/stream_sched.h>
 
 /* Forward declarations for internal helper functions. */
-static int sctp_writeable(struct sock *sk);
+static bool sctp_writeable(struct sock *sk);
 static void sctp_wfree(struct sk_buff *skb);
 static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
 				size_t msg_len);
@@ -119,25 +119,10 @@ static void sctp_enter_memory_pressure(struct sock *sk)
 /* Get the sndbuf space available at the time on the association.  */
 static inline int sctp_wspace(struct sctp_association *asoc)
 {
-	int amt;
+	struct sock *sk = asoc->base.sk;
 
-	if (asoc->ep->sndbuf_policy)
-		amt = asoc->sndbuf_used;
-	else
-		amt = sk_wmem_alloc_get(asoc->base.sk);
-
-	if (amt >= asoc->base.sk->sk_sndbuf) {
-		if (asoc->base.sk->sk_userlocks & SOCK_SNDBUF_LOCK)
-			amt = 0;
-		else {
-			amt = sk_stream_wspace(asoc->base.sk);
-			if (amt < 0)
-				amt = 0;
-		}
-	} else {
-		amt = asoc->base.sk->sk_sndbuf - amt;
-	}
-	return amt;
+	return asoc->ep->sndbuf_policy ? sk->sk_sndbuf - asoc->sndbuf_used
+				       : sk_stream_wspace(sk);
 }
 
 /* Increment the used sndbuf space count of the corresponding association by
@@ -1925,10 +1910,10 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 		asoc->pmtu_pending = 0;
 	}
 
-	if (sctp_wspace(asoc) < msg_len)
+	if (sctp_wspace(asoc) < (int)msg_len)
 		sctp_prsctp_prune(asoc, sinfo, msg_len - sctp_wspace(asoc));
 
-	if (!sctp_wspace(asoc)) {
+	if (sctp_wspace(asoc) <= 0) {
 		timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 		err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len);
 		if (err)
@@ -8535,7 +8520,7 @@ static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
 			goto do_error;
 		if (signal_pending(current))
 			goto do_interrupted;
-		if (msg_len <= sctp_wspace(asoc))
+		if ((int)msg_len <= sctp_wspace(asoc))
 			break;
 
 		/* Let another process have a go.  Since we are going
@@ -8610,14 +8595,9 @@ void sctp_write_space(struct sock *sk)
  * UDP-style sockets or TCP-style sockets, this code should work.
  *  - Daisy
  */
-static int sctp_writeable(struct sock *sk)
+static bool sctp_writeable(struct sock *sk)
 {
-	int amt = 0;
-
-	amt = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
-	if (amt < 0)
-		amt = 0;
-	return amt;
+	return sk->sk_sndbuf > sk->sk_wmem_queued;
 }
 
 /* Wait for an association to go into ESTABLISHED state. If timeout is 0,
-- 
2.1.0
