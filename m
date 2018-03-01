From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 01 Mar 2018 15:05:16 +0000
Subject: [PATCH net-next 7/9] sctp: remove the unnecessary transport looking up from sctp_sendmsg
Message-Id: <45d67b278e2b79a28295148582e2fd22c1f45b57.1519916440.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1519916440.git.lucien.xin@gmail.com>
 <1dbdb93e27d978da9fe883dbe72db78fbb58ec95.1519916440.git.lucien.xin@gmail.com>
 <eca6be098ff541b1e4a98b06dee76c0272590901.1519916440.git.lucien.xin@gmail.com>
 <588fe081ed87c02258db4caf0377979d19a8132a.1519916440.git.lucien.xin@gmail.com>
 <fd4d3e9c299ccd3354d7c1af3a3eb6d732acf392.1519916440.git.lucien.xin@gmail.com>
 <ee810edf89a6df987e822bda0da4bc4559a5ea97.1519916440.git.lucien.xin@gmail.com>
 <ea4722d28716a0f98826a7853e1eb7c5f4d53ca9.1519916440.git.lucien.xin@gmail.com>
In-Reply-To: <ea4722d28716a0f98826a7853e1eb7c5f4d53ca9.1519916440.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net

Now sctp_assoc_lookup_paddr can only be called only if daddr has
been set. But if daddr has been set, sctp_endpoint_lookup_assoc
would be done, where it could already have the transport.

So this unnecessary transport looking up should be removed, but
only reset transport as NULL when SCTP_ADDR_OVER is not set for
UDP type socket.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index bd1a657..4260310 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1911,7 +1911,7 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_association *new_asoc = NULL, *asoc = NULL;
-	struct sctp_transport *transport, *chunk_tp;
+	struct sctp_transport *transport = NULL;
 	struct sctp_sndrcvinfo _sinfo, *sinfo;
 	sctp_assoc_t associd = 0;
 	struct sctp_cmsgs cmsgs = { NULL };
@@ -1966,29 +1966,17 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 		new_asoc = asoc;
 	}
 
+	if (!sctp_style(sk, TCP) && !(sinfo_flags & SCTP_ADDR_OVER))
+		transport = NULL;
+
 	/* Update snd_info with the asoc */
 	sctp_sendmsg_update_sinfo(asoc, sinfo, &cmsgs);
 
-	/* If an address is passed with the sendto/sendmsg call, it is used
-	 * to override the primary destination address in the TCP model, or
-	 * when SCTP_ADDR_OVER flag is set in the UDP model.
-	 */
-	if ((sctp_style(sk, TCP) && daddr) ||
-	    (sinfo_flags & SCTP_ADDR_OVER)) {
-		chunk_tp = sctp_assoc_lookup_paddr(asoc, daddr);
-		if (!chunk_tp) {
-			err = -EINVAL;
-			goto out_free;
-		}
-	} else
-		chunk_tp = NULL;
-
 	/* Send msg to the asoc */
-	err = sctp_sendmsg_to_asoc(asoc, msg, msg_len, chunk_tp, sinfo);
-
-out_free:
+	err = sctp_sendmsg_to_asoc(asoc, msg, msg_len, transport, sinfo);
 	if (err < 0 && err != -ESRCH && new_asoc)
 		sctp_association_free(asoc);
+
 out_unlock:
 	release_sock(sk);
 out_nounlock:
-- 
2.1.0

