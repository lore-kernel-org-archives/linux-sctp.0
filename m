From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 18 Nov 2018 07:21:53 +0000
Subject: [PATCHv2 net] sctp: not allow to set asoc prsctp_enable by sockopt
Message-Id: <44569c3eada8633c11f17c63e2d5ea9f3936f59c.1542525713.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

As rfc7496#section4.5 says about SCTP_PR_SUPPORTED:

   This socket option allows the enabling or disabling of the
   negotiation of PR-SCTP support for future associations.  For existing
   associations, it allows one to query whether or not PR-SCTP support
   was negotiated on a particular association.

It means only sctp sock's prsctp_enable can be set.

Note that for the limitation of SCTP_{CURRENT|ALL}_ASSOC, we will
add it when introducing SCTP_{FUTURE|CURRENT|ALL}_ASSOC for linux
sctp in another patchset.

v1->v2:
  - drop the params.assoc_id check as Neil suggested.

Fixes: 28aa4c26fce2 ("sctp: add SCTP_PR_SUPPORTED on sctp sockopt")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 739f3e5..bf618d1 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3940,32 +3940,16 @@ static int sctp_setsockopt_pr_supported(struct sock *sk,
 					unsigned int optlen)
 {
 	struct sctp_assoc_value params;
-	struct sctp_association *asoc;
-	int retval = -EINVAL;
 
 	if (optlen != sizeof(params))
-		goto out;
-
-	if (copy_from_user(&params, optval, optlen)) {
-		retval = -EFAULT;
-		goto out;
-	}
-
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (asoc) {
-		asoc->prsctp_enable = !!params.assoc_value;
-	} else if (!params.assoc_id) {
-		struct sctp_sock *sp = sctp_sk(sk);
+		return -EINVAL;
 
-		sp->ep->prsctp_enable = !!params.assoc_value;
-	} else {
-		goto out;
-	}
+	if (copy_from_user(&params, optval, optlen))
+		return -EFAULT;
 
-	retval = 0;
+	sctp_sk(sk)->ep->prsctp_enable = !!params.assoc_value;
 
-out:
-	return retval;
+	return 0;
 }
 
 static int sctp_setsockopt_default_prinfo(struct sock *sk,
-- 
2.1.0
