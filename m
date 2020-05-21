From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:47:01 +0000
Subject: [PATCH 26/49] sctp: pass a kernel pointer to sctp_setsockopt_auth_key
Message-Id: <20200521174724.2635475-27-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200521174724.2635475-1-hch@lst.de>
In-Reply-To: <20200521174724.2635475-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Use the kernel pointer that sctp_setsockopt has available instead of
directly handling the user pointer.  Adapt sctp_setsockopt to use a
kzfree for this case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 88edf5413fd22..d3442dcd49aa8 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3591,11 +3591,10 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
  * association shared key.
  */
 static int sctp_setsockopt_auth_key(struct sock *sk,
-				    char __user *optval,
+				    struct sctp_authkey *authkey,
 				    unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
-	struct sctp_authkey *authkey;
 	struct sctp_association *asoc;
 	int ret = -EINVAL;
 
@@ -3606,10 +3605,6 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 	 */
 	optlen = min_t(unsigned int, optlen, USHRT_MAX + sizeof(*authkey));
 
-	authkey = memdup_user(optval, optlen);
-	if (IS_ERR(authkey))
-		return PTR_ERR(authkey);
-
 	if (authkey->sca_keylength > optlen - sizeof(*authkey))
 		goto out;
 
@@ -3646,7 +3641,6 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 	}
 
 out:
-	kzfree(authkey);
 	return ret;
 }
 
@@ -4688,7 +4682,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_hmac_ident(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_KEY:
-		retval = sctp_setsockopt_auth_key(sk, optval, optlen);
+		retval = sctp_setsockopt_auth_key(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_ACTIVE_KEY:
 		retval = sctp_setsockopt_active_key(sk, optval, optlen);
@@ -4771,7 +4765,10 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	}
 
 	release_sock(sk);
-	kfree(kopt);
+	if (optname = SCTP_AUTH_KEY)
+		kzfree(kopt);
+	else
+		kfree(kopt);
 
 out_nounlock:
 	return retval;
-- 
2.26.2
