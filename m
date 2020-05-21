From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:47:13 +0000
Subject: [PATCH 38/49] sctp: pass a kernel pointer to sctp_setsockopt_reset_streams
Message-Id: <20200521174724.2635475-39-hch@lst.de>
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
 net/sctp/socket.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c5a4e9375bb55..70451a9177407 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4057,12 +4057,10 @@ static int sctp_setsockopt_enable_strreset(struct sock *sk,
 }
 
 static int sctp_setsockopt_reset_streams(struct sock *sk,
-					 char __user *optval,
+					 struct sctp_reset_streams *params,
 					 unsigned int optlen)
 {
-	struct sctp_reset_streams *params;
 	struct sctp_association *asoc;
-	int retval = -EINVAL;
 
 	if (optlen < sizeof(*params))
 		return -EINVAL;
@@ -4070,23 +4068,15 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
 	optlen = min_t(unsigned int, optlen, USHRT_MAX +
 					     sizeof(__u16) * sizeof(*params));
 
-	params = memdup_user(optval, optlen);
-	if (IS_ERR(params))
-		return PTR_ERR(params);
-
 	if (params->srs_number_streams * sizeof(__u16) >
 	    optlen - sizeof(*params))
-		goto out;
+		return -EINVAL;
 
 	asoc = sctp_id2assoc(sk, params->srs_assoc_id);
 	if (!asoc)
-		goto out;
-
-	retval = sctp_send_reset_streams(asoc, params);
+		return -EINVAL;
 
-out:
-	kfree(params);
-	return retval;
+	return sctp_send_reset_streams(asoc, params);
 }
 
 static int sctp_setsockopt_reset_assoc(struct sock *sk,
@@ -4678,7 +4668,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_enable_strreset(sk, kopt, optlen);
 		break;
 	case SCTP_RESET_STREAMS:
-		retval = sctp_setsockopt_reset_streams(sk, optval, optlen);
+		retval = sctp_setsockopt_reset_streams(sk, kopt, optlen);
 		break;
 	case SCTP_RESET_ASSOC:
 		retval = sctp_setsockopt_reset_assoc(sk, optval, optlen);
-- 
2.26.2
