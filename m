From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Sat, 19 Jul 2008 04:26:49 +0000
Subject: [PATCH 4/7] sctp: Do not leak memory on multiple listen() calls
Message-Id: <12164416171989-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <12164416121552-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <12164416121552-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>

SCTP permits multiple listen call and on subsequent calls
we leak he memory allocated for the crypto transforms.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/socket.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a0e879b..fd7ed9d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5773,7 +5773,7 @@ int sctp_inet_listen(struct socket *sock, int backlog)
 		goto out;
 
 	/* Allocate HMAC for generating cookie. */
-	if (sctp_hmac_alg) {
+	if (!sctp_sk(sk)->hmac && sctp_hmac_alg) {
 		tfm = crypto_alloc_hash(sctp_hmac_alg, 0, CRYPTO_ALG_ASYNC);
 		if (IS_ERR(tfm)) {
 			if (net_ratelimit()) {
@@ -5801,7 +5801,8 @@ int sctp_inet_listen(struct socket *sock, int backlog)
 		goto cleanup;
 
 	/* Store away the transform reference. */
-	sctp_sk(sk)->hmac = tfm;
+	if (!sctp_sk(sk)->hmac)
+		sctp_sk(sk)->hmac = tfm;
 out:
 	sctp_release_sock(sk);
 	return err;
-- 
1.5.2.5

