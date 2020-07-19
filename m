From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:25 +0000
Subject: [PATCH 48/51] sctp: pass a kernel pointer to sctp_setsockopt_auth_supported
Message-Id: <20200719072228.112645-49-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200719072228.112645-1-hch@lst.de>
In-Reply-To: <20200719072228.112645-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Use the kernel pointer that sctp_setsockopt has available instead of
directly handling the user pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b52acbf231ab9e..ca369447237a77 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4326,29 +4326,23 @@ static int sctp_setsockopt_asconf_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_auth_supported(struct sock *sk,
-					  char __user *optval,
+					  struct sctp_assoc_value *params,
 					  unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
 	struct sctp_endpoint *ep;
 	int retval = -EINVAL;
 
-	if (optlen != sizeof(params))
-		goto out;
-
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
+	if (optlen != sizeof(*params))
 		goto out;
-	}
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	ep = sctp_sk(sk)->ep;
-	if (params.assoc_value) {
+	if (params->assoc_value) {
 		retval = sctp_auth_init(ep, GFP_KERNEL);
 		if (retval)
 			goto out;
@@ -4358,7 +4352,7 @@ static int sctp_setsockopt_auth_supported(struct sock *sk,
 		}
 	}
 
-	ep->auth_enable = !!params.assoc_value;
+	ep->auth_enable = !!params->assoc_value;
 	retval = 0;
 
 out:
@@ -4638,7 +4632,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_asconf_supported(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_SUPPORTED:
-		retval = sctp_setsockopt_auth_supported(sk, optval, optlen);
+		retval = sctp_setsockopt_auth_supported(sk, kopt, optlen);
 		break;
 	case SCTP_ECN_SUPPORTED:
 		retval = sctp_setsockopt_ecn_supported(sk, optval, optlen);
-- 
2.27.0
