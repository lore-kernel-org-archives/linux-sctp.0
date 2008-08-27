From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 27 Aug 2008 20:03:34 +0000
Subject: [PATCH 1/2] sctp: correct bounds check in sctp_setsockopt_auth_key
Message-Id: <12198674162757-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48B42ECA.7010800@redhat.com>
In-Reply-To: <48B42ECA.7010800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: eteo@redhat.com, netdev@vger.kernel.org, security@kernel.org, linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>

The bonds check to prevent buffer overlflow was not exactly
right.  It still allowed overflow of up to 8 bytes which is
sizeof(struct sctp_authkey).

Since optlen is already checked against the size of that struct,
we are guaranteed not to cause interger overflow either.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/socket.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index afa952e..9b9b2c3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3144,7 +3144,7 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 		goto out;
 	}
 
-	if (authkey->sca_keylength > optlen) {
+	if (authkey->sca_keylength > optlen - sizeof(struct sctp_authkey)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
1.5.2.5

