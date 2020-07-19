From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:14 +0000
Subject: [PATCH 37/51] sctp: pass a kernel pointer to sctp_setsockopt_reconfig_supported
Message-Id: <20200719072228.112645-38-hch@lst.de>
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
 net/sctp/socket.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 0eeb6e6162ad61..270c5d53fbf7c3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3996,27 +3996,21 @@ static int sctp_setsockopt_default_prinfo(struct sock *sk,
 }
 
 static int sctp_setsockopt_reconfig_supported(struct sock *sk,
-					      char __user *optval,
+					      struct sctp_assoc_value *params,
 					      unsigned int optlen)
 {
-	struct sctp_assoc_value params;
 	struct sctp_association *asoc;
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
 
-	sctp_sk(sk)->ep->reconf_enable = !!params.assoc_value;
+	sctp_sk(sk)->ep->reconf_enable = !!params->assoc_value;
 
 	retval = 0;
 
@@ -4688,7 +4682,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_default_prinfo(sk, kopt, optlen);
 		break;
 	case SCTP_RECONFIG_SUPPORTED:
-		retval = sctp_setsockopt_reconfig_supported(sk, optval, optlen);
+		retval = sctp_setsockopt_reconfig_supported(sk, kopt, optlen);
 		break;
 	case SCTP_ENABLE_STREAM_RESET:
 		retval = sctp_setsockopt_enable_strreset(sk, optval, optlen);
-- 
2.27.0
