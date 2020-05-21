From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:47:00 +0000
Subject: [PATCH 25/49] sctp: pass a kernel pointer to sctp_setsockopt_hmac_ident
Message-Id: <20200521174724.2635475-26-hch@lst.de>
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
 net/sctp/socket.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index aa06affcd66e0..88edf5413fd22 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3562,13 +3562,11 @@ static int sctp_setsockopt_auth_chunk(struct sock *sk,
  * endpoint requires the peer to use.
  */
 static int sctp_setsockopt_hmac_ident(struct sock *sk,
-				      char __user *optval,
+				      struct sctp_hmacalgo *hmacs,
 				      unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct sctp_hmacalgo *hmacs;
 	u32 idents;
-	int err;
 
 	if (!ep->auth_enable)
 		return -EACCES;
@@ -3578,21 +3576,12 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
 	optlen = min_t(unsigned int, optlen, sizeof(struct sctp_hmacalgo) +
 					     SCTP_AUTH_NUM_HMACS * sizeof(u16));
 
-	hmacs = memdup_user(optval, optlen);
-	if (IS_ERR(hmacs))
-		return PTR_ERR(hmacs);
-
 	idents = hmacs->shmac_num_idents;
 	if (idents = 0 || idents > SCTP_AUTH_NUM_HMACS ||
-	    (idents * sizeof(u16)) > (optlen - sizeof(struct sctp_hmacalgo))) {
-		err = -EINVAL;
-		goto out;
-	}
+	    (idents * sizeof(u16)) > (optlen - sizeof(struct sctp_hmacalgo)))
+		return -EINVAL;
 
-	err = sctp_auth_ep_set_hmacs(ep, hmacs);
-out:
-	kfree(hmacs);
-	return err;
+	return sctp_auth_ep_set_hmacs(ep, hmacs);
 }
 
 /*
@@ -4696,7 +4685,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_auth_chunk(sk, kopt, optlen);
 		break;
 	case SCTP_HMAC_IDENT:
-		retval = sctp_setsockopt_hmac_ident(sk, optval, optlen);
+		retval = sctp_setsockopt_hmac_ident(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_KEY:
 		retval = sctp_setsockopt_auth_key(sk, optval, optlen);
-- 
2.26.2
