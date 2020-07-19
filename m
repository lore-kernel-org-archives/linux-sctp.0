From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:15 +0000
Subject: [PATCH 38/51] sctp: pass a kernel pointer to sctp_setsockopt_enable_strreset
Message-Id: <20200719072228.112645-39-hch@lst.de>
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
 net/sctp/socket.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 270c5d53fbf7c3..9899d208f40f8d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4019,48 +4019,42 @@ static int sctp_setsockopt_reconfig_supported(struct sock *sk,
 }
 
 static int sctp_setsockopt_enable_strreset(struct sock *sk,
-					   char __user *optval,
+					   struct sctp_assoc_value *params,
 					   unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
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
 
-	if (params.assoc_value & (~SCTP_ENABLE_STRRESET_MASK))
+	if (params->assoc_value & (~SCTP_ENABLE_STRRESET_MASK))
 		goto out;
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (!asoc && params.assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, params->assoc_id);
+	if (!asoc && params->assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		goto out;
 
 	retval = 0;
 
 	if (asoc) {
-		asoc->strreset_enable = params.assoc_value;
+		asoc->strreset_enable = params->assoc_value;
 		goto out;
 	}
 
 	if (sctp_style(sk, TCP))
-		params.assoc_id = SCTP_FUTURE_ASSOC;
+		params->assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (params.assoc_id = SCTP_FUTURE_ASSOC ||
-	    params.assoc_id = SCTP_ALL_ASSOC)
-		ep->strreset_enable = params.assoc_value;
+	if (params->assoc_id = SCTP_FUTURE_ASSOC ||
+	    params->assoc_id = SCTP_ALL_ASSOC)
+		ep->strreset_enable = params->assoc_value;
 
-	if (params.assoc_id = SCTP_CURRENT_ASSOC ||
-	    params.assoc_id = SCTP_ALL_ASSOC)
+	if (params->assoc_id = SCTP_CURRENT_ASSOC ||
+	    params->assoc_id = SCTP_ALL_ASSOC)
 		list_for_each_entry(asoc, &ep->asocs, asocs)
-			asoc->strreset_enable = params.assoc_value;
+			asoc->strreset_enable = params->assoc_value;
 
 out:
 	return retval;
@@ -4685,7 +4679,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_reconfig_supported(sk, kopt, optlen);
 		break;
 	case SCTP_ENABLE_STREAM_RESET:
-		retval = sctp_setsockopt_enable_strreset(sk, optval, optlen);
+		retval = sctp_setsockopt_enable_strreset(sk, kopt, optlen);
 		break;
 	case SCTP_RESET_STREAMS:
 		retval = sctp_setsockopt_reset_streams(sk, optval, optlen);
-- 
2.27.0
