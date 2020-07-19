From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:21:50 +0000
Subject: [PATCH 13/51] sctp: pass a kernel pointer to sctp_setsockopt_primary_addr
Message-Id: <20200719072228.112645-14-hch@lst.de>
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
 net/sctp/socket.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6695fa1cb0ca8f..abdec7b412bcbc 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2982,10 +2982,9 @@ static int sctp_setsockopt_default_sndinfo(struct sock *sk,
  * the association primary.  The enclosed address must be one of the
  * association peer's addresses.
  */
-static int sctp_setsockopt_primary_addr(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_primary_addr(struct sock *sk, struct sctp_prim *prim,
 					unsigned int optlen)
 {
-	struct sctp_prim prim;
 	struct sctp_transport *trans;
 	struct sctp_af *af;
 	int err;
@@ -2993,21 +2992,18 @@ static int sctp_setsockopt_primary_addr(struct sock *sk, char __user *optval,
 	if (optlen != sizeof(struct sctp_prim))
 		return -EINVAL;
 
-	if (copy_from_user(&prim, optval, sizeof(struct sctp_prim)))
-		return -EFAULT;
-
 	/* Allow security module to validate address but need address len. */
-	af = sctp_get_af_specific(prim.ssp_addr.ss_family);
+	af = sctp_get_af_specific(prim->ssp_addr.ss_family);
 	if (!af)
 		return -EINVAL;
 
 	err = security_sctp_bind_connect(sk, SCTP_PRIMARY_ADDR,
-					 (struct sockaddr *)&prim.ssp_addr,
+					 (struct sockaddr *)&prim->ssp_addr,
 					 af->sockaddr_len);
 	if (err)
 		return err;
 
-	trans = sctp_addr_id2transport(sk, &prim.ssp_addr, prim.ssp_assoc_id);
+	trans = sctp_addr_id2transport(sk, &prim->ssp_addr, prim->ssp_assoc_id);
 	if (!trans)
 		return -EINVAL;
 
@@ -4695,7 +4691,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_default_sndinfo(sk, kopt, optlen);
 		break;
 	case SCTP_PRIMARY_ADDR:
-		retval = sctp_setsockopt_primary_addr(sk, optval, optlen);
+		retval = sctp_setsockopt_primary_addr(sk, kopt, optlen);
 		break;
 	case SCTP_SET_PEER_PRIMARY_ADDR:
 		retval = sctp_setsockopt_peer_primary_addr(sk, optval, optlen);
-- 
2.27.0
