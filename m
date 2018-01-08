From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 08 Jan 2018 21:02:28 +0000
Subject: [PATCH net 2/3] sctp: add a ceiling to optlen in some sockopts
Message-Id: <c0039da2f46d4c09201b56aa620e966f7a28b54e.1515436112.git.marcelo.leitner@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1515436112.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1515436112.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, haliu@redhat.com

Hangbin Liu reported that some sockopt calls could cause the kernel to log
a warning on memory allocation failure if the user supplied a large optlen
value. That is because some of them called memdup_user() without a ceiling
on optlen, allowing it to try to allocate really large buffers.

This patch adds a ceiling by limiting optlen to the maximum allowed that
would still make sense for these sockopt.

Reported-by: Hangbin Liu <haliu@redhat.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/socket.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 54c046783a89e76c9909ee85c83e6be38ada41a7..022b94f11fd8ac0d3b839b16dfc14f86abf2324f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3498,6 +3498,8 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
 
 	if (optlen < sizeof(struct sctp_hmacalgo))
 		return -EINVAL;
+	optlen = min_t(unsigned int, optlen, sizeof(struct sctp_hmacalgo) +
+					     SCTP_AUTH_NUM_HMACS * sizeof(u16));
 
 	hmacs = memdup_user(optval, optlen);
 	if (IS_ERR(hmacs))
@@ -3536,6 +3538,11 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 
 	if (optlen <= sizeof(struct sctp_authkey))
 		return -EINVAL;
+	/* authkey->sca_keylength is u16, so optlen can't be bigger than
+	 * this.
+	 */
+	optlen = min_t(unsigned int, optlen, USHRT_MAX +
+					     sizeof(struct sctp_authkey));
 
 	authkey = memdup_user(optval, optlen);
 	if (IS_ERR(authkey))
@@ -3893,6 +3900,9 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
 
 	if (optlen < sizeof(*params))
 		return -EINVAL;
+	/* srs_number_streams is u16, so optlen can't be bigger than this. */
+	optlen = min_t(unsigned int, optlen, USHRT_MAX +
+					     sizeof(__u16) * sizeof(*params));
 
 	params = memdup_user(optval, optlen);
 	if (IS_ERR(params))
-- 
2.14.3

