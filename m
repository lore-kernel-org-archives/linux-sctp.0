From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 15 Apr 2019 09:15:06 +0000
Subject: [PATCHv2 net-next 1/2] sctp: implement memory accounting on tx path
Message-Id: <9da4d979147cda7dfe8d24bdecb181abc9184060.1555319573.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1555319573.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1555319573.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net, Matteo Croce <mcroce@redhat.com>, Vladis Dronov <vdronov@redhat.com>

Now when sending packets, sk_mem_charge() and sk_mem_uncharge() have been
used to set sk_forward_alloc. We just need to call sk_wmem_schedule() to
check if the allocated should be raised, and call sk_mem_reclaim() to
check if the allocated should be reduced when it's under memory pressure.

If sk_wmem_schedule() returns false, which means no memory is allowed to
allocate, it will block and wait for memory to become available.

Note different from tcp, sctp wait_for_buf happens before allocating any
skb, so memory accounting check is done with the whole msg_len before it
too.

Reported-by: Matteo Croce <mcroce@redhat.com>
Tested-by: Matteo Croce <mcroce@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6140471..06c6f4a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1913,7 +1913,10 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 	if (sctp_wspace(asoc) < (int)msg_len)
 		sctp_prsctp_prune(asoc, sinfo, msg_len - sctp_wspace(asoc));
 
-	if (sctp_wspace(asoc) <= 0) {
+	if (sk_under_memory_pressure(sk))
+		sk_mem_reclaim(sk);
+
+	if (sctp_wspace(asoc) <= 0 || !sk_wmem_schedule(sk, msg_len)) {
 		timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 		err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len);
 		if (err)
@@ -8891,7 +8894,10 @@ static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
 			goto do_error;
 		if (signal_pending(current))
 			goto do_interrupted;
-		if ((int)msg_len <= sctp_wspace(asoc))
+		if (sk_under_memory_pressure(sk))
+			sk_mem_reclaim(sk);
+		if ((int)msg_len <= sctp_wspace(asoc) &&
+		    sk_wmem_schedule(sk, msg_len))
 			break;
 
 		/* Let another process have a go.  Since we are going
-- 
2.1.0
