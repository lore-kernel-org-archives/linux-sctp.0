From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:21:51 +0000
Subject: [PATCH 14/51] sctp: pass a kernel pointer to sctp_setsockopt_peer_primary_addr
Message-Id: <20200719072228.112645-15-hch@lst.de>
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
 net/sctp/socket.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index abdec7b412bcbc..ff3b720eab0aa2 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3284,12 +3284,12 @@ static int sctp_setsockopt_maxseg(struct sock *sk, char __user *optval, unsigned
  *   locally bound addresses. The following structure is used to make a
  *   set primary request:
  */
-static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_peer_primary_addr(struct sock *sk,
+					     struct sctp_setpeerprim *prim,
 					     unsigned int optlen)
 {
 	struct sctp_sock	*sp;
 	struct sctp_association	*asoc = NULL;
-	struct sctp_setpeerprim	prim;
 	struct sctp_chunk	*chunk;
 	struct sctp_af		*af;
 	int 			err;
@@ -3302,10 +3302,7 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
 	if (optlen != sizeof(struct sctp_setpeerprim))
 		return -EINVAL;
 
-	if (copy_from_user(&prim, optval, optlen))
-		return -EFAULT;
-
-	asoc = sctp_id2assoc(sk, prim.sspp_assoc_id);
+	asoc = sctp_id2assoc(sk, prim->sspp_assoc_id);
 	if (!asoc)
 		return -EINVAL;
 
@@ -3318,26 +3315,26 @@ static int sctp_setsockopt_peer_primary_addr(struct sock *sk, char __user *optva
 	if (!sctp_state(asoc, ESTABLISHED))
 		return -ENOTCONN;
 
-	af = sctp_get_af_specific(prim.sspp_addr.ss_family);
+	af = sctp_get_af_specific(prim->sspp_addr.ss_family);
 	if (!af)
 		return -EINVAL;
 
-	if (!af->addr_valid((union sctp_addr *)&prim.sspp_addr, sp, NULL))
+	if (!af->addr_valid((union sctp_addr *)&prim->sspp_addr, sp, NULL))
 		return -EADDRNOTAVAIL;
 
-	if (!sctp_assoc_lookup_laddr(asoc, (union sctp_addr *)&prim.sspp_addr))
+	if (!sctp_assoc_lookup_laddr(asoc, (union sctp_addr *)&prim->sspp_addr))
 		return -EADDRNOTAVAIL;
 
 	/* Allow security module to validate address. */
 	err = security_sctp_bind_connect(sk, SCTP_SET_PEER_PRIMARY_ADDR,
-					 (struct sockaddr *)&prim.sspp_addr,
+					 (struct sockaddr *)&prim->sspp_addr,
 					 af->sockaddr_len);
 	if (err)
 		return err;
 
 	/* Create an ASCONF chunk with SET_PRIMARY parameter	*/
 	chunk = sctp_make_asconf_set_prim(asoc,
-					  (union sctp_addr *)&prim.sspp_addr);
+					  (union sctp_addr *)&prim->sspp_addr);
 	if (!chunk)
 		return -ENOMEM;
 
@@ -4694,7 +4691,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_primary_addr(sk, kopt, optlen);
 		break;
 	case SCTP_SET_PEER_PRIMARY_ADDR:
-		retval = sctp_setsockopt_peer_primary_addr(sk, optval, optlen);
+		retval = sctp_setsockopt_peer_primary_addr(sk, kopt, optlen);
 		break;
 	case SCTP_NODELAY:
 		retval = sctp_setsockopt_nodelay(sk, optval, optlen);
-- 
2.27.0
