From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:46:59 +0000
Subject: [PATCH 24/49] sctp: pass a kernel pointer to sctp_setsockopt_auth_chunk
Message-Id: <20200521174724.2635475-25-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200521174724.2635475-1-hch@lst.de>
In-Reply-To: <20200521174724.2635475-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Use the kernel pointer that sctp_setsockopt has available instead of
directly handling the user pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index e62e8dbe961ec..aa06affcd66e0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3532,21 +3532,18 @@ static int sctp_setsockopt_maxburst(struct sock *sk,
  * will only effect future associations on the socket.
  */
 static int sctp_setsockopt_auth_chunk(struct sock *sk,
-				      char __user *optval,
+				      struct sctp_authchunk *val,
 				      unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct sctp_authchunk val;
 
 	if (!ep->auth_enable)
 		return -EACCES;
 
 	if (optlen != sizeof(struct sctp_authchunk))
 		return -EINVAL;
-	if (copy_from_user(&val, optval, optlen))
-		return -EFAULT;
 
-	switch (val.sauth_chunk) {
+	switch (val->sauth_chunk) {
 	case SCTP_CID_INIT:
 	case SCTP_CID_INIT_ACK:
 	case SCTP_CID_SHUTDOWN_COMPLETE:
@@ -3555,7 +3552,7 @@ static int sctp_setsockopt_auth_chunk(struct sock *sk,
 	}
 
 	/* add this chunk id to the endpoint */
-	return sctp_auth_ep_add_chunkid(ep, val.sauth_chunk);
+	return sctp_auth_ep_add_chunkid(ep, val->sauth_chunk);
 }
 
 /*
@@ -4696,7 +4693,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_maxburst(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_CHUNK:
-		retval = sctp_setsockopt_auth_chunk(sk, optval, optlen);
+		retval = sctp_setsockopt_auth_chunk(sk, kopt, optlen);
 		break;
 	case SCTP_HMAC_IDENT:
 		retval = sctp_setsockopt_hmac_ident(sk, optval, optlen);
-- 
2.26.2
