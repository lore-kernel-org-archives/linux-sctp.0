From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 15 Nov 2018 11:14:28 +0000
Subject: [PATCH net] sctp: not allow to set asoc prsctp_enable by sockopt
Message-Id: <7417f2d10de933afb69b832d9a30a210f42a16bb.1542280468.git.lucien.xin@gmail.com>
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

Fixes: 28aa4c26fce2 ("sctp: add SCTP_PR_SUPPORTED on sctp sockopt")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 739f3e5..e9b8232 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3940,7 +3940,6 @@ static int sctp_setsockopt_pr_supported(struct sock *sk,
 					unsigned int optlen)
 {
 	struct sctp_assoc_value params;
-	struct sctp_association *asoc;
 	int retval = -EINVAL;
 
 	if (optlen != sizeof(params))
@@ -3951,16 +3950,10 @@ static int sctp_setsockopt_pr_supported(struct sock *sk,
 		goto out;
 	}
 
-	asoc = sctp_id2assoc(sk, params.assoc_id);
-	if (asoc) {
-		asoc->prsctp_enable = !!params.assoc_value;
-	} else if (!params.assoc_id) {
-		struct sctp_sock *sp = sctp_sk(sk);
-
-		sp->ep->prsctp_enable = !!params.assoc_value;
-	} else {
+	if (sctp_style(sk, UDP) && sctp_id2assoc(sk, params.assoc_id))
 		goto out;
-	}
+
+	sctp_sk(sk)->ep->prsctp_enable = !!params.assoc_value;
 
 	retval = 0;
 
-- 
2.1.0
