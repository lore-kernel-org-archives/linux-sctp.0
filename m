From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:17 +0000
Subject: [PATCH 40/51] sctp: pass a kernel pointer to sctp_setsockopt_reset_assoc
Message-Id: <20200719072228.112645-41-hch@lst.de>
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
 net/sctp/socket.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1365351fd2c86a..f190f59f29595a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4083,30 +4083,19 @@ static int sctp_setsockopt_reset_streams(struct sock *sk,
 	return sctp_send_reset_streams(asoc, params);
 }
 
-static int sctp_setsockopt_reset_assoc(struct sock *sk,
-				       char __user *optval,
+static int sctp_setsockopt_reset_assoc(struct sock *sk, sctp_assoc_t *associd,
 				       unsigned int optlen)
 {
 	struct sctp_association *asoc;
-	sctp_assoc_t associd;
-	int retval = -EINVAL;
-
-	if (optlen != sizeof(associd))
-		goto out;
 
-	if (copy_from_user(&associd, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
+	if (optlen != sizeof(*associd))
+		return -EINVAL;
 
-	asoc = sctp_id2assoc(sk, associd);
+	asoc = sctp_id2assoc(sk, *associd);
 	if (!asoc)
-		goto out;
-
-	retval = sctp_send_reset_assoc(asoc);
+		return -EINVAL;
 
-out:
-	return retval;
+	return sctp_send_reset_assoc(asoc);
 }
 
 static int sctp_setsockopt_add_streams(struct sock *sk,
@@ -4675,7 +4664,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_reset_streams(sk, kopt, optlen);
 		break;
 	case SCTP_RESET_ASSOC:
-		retval = sctp_setsockopt_reset_assoc(sk, optval, optlen);
+		retval = sctp_setsockopt_reset_assoc(sk, kopt, optlen);
 		break;
 	case SCTP_ADD_STREAMS:
 		retval = sctp_setsockopt_add_streams(sk, optval, optlen);
-- 
2.27.0
