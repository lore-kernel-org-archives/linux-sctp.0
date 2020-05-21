From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:47:15 +0000
Subject: [PATCH 40/49] sctp: pass a kernel pointer to sctp_setsockopt_add_streams
Message-Id: <20200521174724.2635475-41-hch@lst.de>
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
 net/sctp/socket.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 185c07916281c..84881913dbc7f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4095,29 +4095,19 @@ static int sctp_setsockopt_reset_assoc(struct sock *sk, sctp_assoc_t *associd,
 }
 
 static int sctp_setsockopt_add_streams(struct sock *sk,
-				       char __user *optval,
+				       struct sctp_add_streams *params,
 				       unsigned int optlen)
 {
 	struct sctp_association *asoc;
-	struct sctp_add_streams params;
-	int retval = -EINVAL;
-
-	if (optlen != sizeof(params))
-		goto out;
 
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	if (optlen != sizeof(*params))
+		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, params.sas_assoc_id);
+	asoc = sctp_id2assoc(sk, params->sas_assoc_id);
 	if (!asoc)
-		goto out;
-
-	retval = sctp_send_add_streams(asoc, &params);
+		return -EINVAL;
 
-out:
-	return retval;
+	return sctp_send_add_streams(asoc, params);
 }
 
 static int sctp_setsockopt_scheduler(struct sock *sk,
@@ -4663,7 +4653,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_reset_assoc(sk, kopt, optlen);
 		break;
 	case SCTP_ADD_STREAMS:
-		retval = sctp_setsockopt_add_streams(sk, optval, optlen);
+		retval = sctp_setsockopt_add_streams(sk, kopt, optlen);
 		break;
 	case SCTP_STREAM_SCHEDULER:
 		retval = sctp_setsockopt_scheduler(sk, optval, optlen);
-- 
2.26.2
