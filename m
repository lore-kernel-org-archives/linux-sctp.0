From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:05 +0000
Subject: [PATCH 28/51] sctp: pass a kernel pointer to sctp_setsockopt_active_key
Message-Id: <20200719072228.112645-29-hch@lst.de>
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
 net/sctp/socket.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b4dcccba5787e3..02153f243683ea 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3655,42 +3655,39 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
  * the association shared key.
  */
 static int sctp_setsockopt_active_key(struct sock *sk,
-				      char __user *optval,
+				      struct sctp_authkeyid *val,
 				      unsigned int optlen)
 {
 	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_association *asoc;
-	struct sctp_authkeyid val;
 	int ret = 0;
 
 	if (optlen != sizeof(struct sctp_authkeyid))
 		return -EINVAL;
-	if (copy_from_user(&val, optval, optlen))
-		return -EFAULT;
 
-	asoc = sctp_id2assoc(sk, val.scact_assoc_id);
-	if (!asoc && val.scact_assoc_id > SCTP_ALL_ASSOC &&
+	asoc = sctp_id2assoc(sk, val->scact_assoc_id);
+	if (!asoc && val->scact_assoc_id > SCTP_ALL_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	if (asoc)
-		return sctp_auth_set_active_key(ep, asoc, val.scact_keynumber);
+		return sctp_auth_set_active_key(ep, asoc, val->scact_keynumber);
 
 	if (sctp_style(sk, TCP))
-		val.scact_assoc_id = SCTP_FUTURE_ASSOC;
+		val->scact_assoc_id = SCTP_FUTURE_ASSOC;
 
-	if (val.scact_assoc_id = SCTP_FUTURE_ASSOC ||
-	    val.scact_assoc_id = SCTP_ALL_ASSOC) {
-		ret = sctp_auth_set_active_key(ep, asoc, val.scact_keynumber);
+	if (val->scact_assoc_id = SCTP_FUTURE_ASSOC ||
+	    val->scact_assoc_id = SCTP_ALL_ASSOC) {
+		ret = sctp_auth_set_active_key(ep, asoc, val->scact_keynumber);
 		if (ret)
 			return ret;
 	}
 
-	if (val.scact_assoc_id = SCTP_CURRENT_ASSOC ||
-	    val.scact_assoc_id = SCTP_ALL_ASSOC) {
+	if (val->scact_assoc_id = SCTP_CURRENT_ASSOC ||
+	    val->scact_assoc_id = SCTP_ALL_ASSOC) {
 		list_for_each_entry(asoc, &ep->asocs, asocs) {
 			int res = sctp_auth_set_active_key(ep, asoc,
-							   val.scact_keynumber);
+							   val->scact_keynumber);
 
 			if (res && !ret)
 				ret = res;
@@ -4689,7 +4686,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_auth_key(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_ACTIVE_KEY:
-		retval = sctp_setsockopt_active_key(sk, optval, optlen);
+		retval = sctp_setsockopt_active_key(sk, kopt, optlen);
 		break;
 	case SCTP_AUTH_DELETE_KEY:
 		retval = sctp_setsockopt_del_key(sk, optval, optlen);
-- 
2.27.0
