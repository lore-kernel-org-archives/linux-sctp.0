From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 27 Aug 2008 20:03:35 +0000
Subject: [PATCH 2/2] sctp: fix random memory dereference with SCTP_HMAC_IDENT option.
Message-Id: <12198674171396-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48B42ECA.7010800@redhat.com>
In-Reply-To: <48B42ECA.7010800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: eteo@redhat.com, netdev@vger.kernel.org, security@kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>

The number of identifiers needs to be checked against the option
length.  Also, the identifier index provided needs to be verified
to make sure that it doesn't exceed the bounds of the array.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/auth.c   |    3 +++
 net/sctp/socket.c |    6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 1fcb4cf..52db5f6 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -786,6 +786,9 @@ int sctp_auth_ep_set_hmacs(struct sctp_endpoint *ep,
 	for (i = 0; i < hmacs->shmac_num_idents; i++) {
 		id = hmacs->shmac_idents[i];
 
+		if (id > SCTP_AUTH_HMAC_ID_MAX)
+			return -EOPNOTSUPP;
+
 		if (SCTP_AUTH_HMAC_ID_SHA1 = id)
 			has_sha1 = 1;
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9b9b2c3..5ffb9de 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3086,6 +3086,7 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
 				    int optlen)
 {
 	struct sctp_hmacalgo *hmacs;
+	u32 idents;
 	int err;
 
 	if (!sctp_auth_enable)
@@ -3103,8 +3104,9 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
 		goto out;
 	}
 
-	if (hmacs->shmac_num_idents = 0 ||
-	    hmacs->shmac_num_idents > SCTP_AUTH_NUM_HMACS) {
+	idents = hmacs->shmac_num_idents;
+	if (idents = 0 || idents > SCTP_AUTH_NUM_HMACS ||
+	    (idents * sizeof(u16)) > (optlen - sizeof(struct sctp_hmacalgo))) {
 		err = -EINVAL;
 		goto out;
 	}
-- 
1.5.2.5

