From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Wed, 26 May 2010 09:51:37 +0000
Subject: [PATCH 4/4] sctp: use memdup_user to copy data from userspace
Message-Id: <4BFCEF29.8040108@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Use common function to simply code.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 net/sctp/socket.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ca44917..96cc3f9 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3201,14 +3201,9 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
 	if (optlen < sizeof(struct sctp_hmacalgo))
 		return -EINVAL;
 
-	hmacs = kmalloc(optlen, GFP_KERNEL);
-	if (!hmacs)
-		return -ENOMEM;
-
-	if (copy_from_user(hmacs, optval, optlen)) {
-		err = -EFAULT;
-		goto out;
-	}
+	hmacs= memdup_user(optval, optlen);
+	if (IS_ERR(hmacs))
+		return PTR_ERR(hmacs);
 
 	idents = hmacs->shmac_num_idents;
 	if (idents = 0 || idents > SCTP_AUTH_NUM_HMACS ||
@@ -3243,14 +3238,9 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 	if (optlen <= sizeof(struct sctp_authkey))
 		return -EINVAL;
 
-	authkey = kmalloc(optlen, GFP_KERNEL);
-	if (!authkey)
-		return -ENOMEM;
-
-	if (copy_from_user(authkey, optval, optlen)) {
-		ret = -EFAULT;
-		goto out;
-	}
+	authkey= memdup_user(optval, optlen);
+	if (IS_ERR(authkey))
+		return PTR_ERR(authkey);
 
 	if (authkey->sca_keylength > optlen - sizeof(struct sctp_authkey)) {
 		ret = -EINVAL;
-- 
1.7.0




