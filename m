From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:04 +0000
Subject: [PATCH 27/51] sctp: pass a kernel pointer to sctp_setsockopt_auth_key
Message-Id: <20200719072228.112645-28-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200719072228.112645-1-hch@lst.de>
In-Reply-To: <20200719072228.112645-1-hch@lst.de>
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
 net/sctp/socket.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 365145746b559d..b4dcccba5787e3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3594,11 +3594,10 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
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
 
@@ -3609,10 +3608,6 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 	 */
 	optlen = min_t(unsigned int, optlen, USHRT_MAX + sizeof(*authkey));
 
-	authkey = memdup_user(optval, optlen);
-	if (IS_ERR(authkey))
-		return PTR_ERR(authkey);
-
 	if (authkey->sca_keylength > optlen - sizeof(*authkey))
 		goto out;
 
@@ -3650,7 +3645,6 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 
 out:
 	memzero_explicit(authkey, optlen);
-	kfree(authkey);
 	return ret;
 }
 
@@ -4692,7 +4686,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_hmac_ident(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_KEY:
-		retval = sctp_setsockopt_auth_key(sk, optval, optlen);
+		retval = sctp_setsockopt_auth_key(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_ACTIVE_KEY:
 		retval = sctp_setsockopt_active_key(sk, optval, optlen);
-- 
2.27.0
