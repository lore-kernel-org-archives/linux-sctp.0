From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 08 Feb 2013 13:04:34 +0000
Subject: [PATCH net 1/2] net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree
Message-Id: <696cf7a140197488ab830222890fe5b803de6952.1360327229.git.dborkman@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1360327229.git.dborkman@redhat.com>
In-Reply-To: <cover.1360327229.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

In sctp_setsockopt_auth_key, we create a temporary copy of the user
passed shared auth key for the endpoint or association and after
internal setup, we free it right away. Since it's sensitive data, we
should zero out the key before returning the memory back to the
allocator. Thus, use kzfree instead of kfree, just as we do in
sctp_auth_key_put().

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 net/sctp/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9e65758..cedd9bf 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3390,7 +3390,7 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 
 	ret = sctp_auth_set_key(sctp_sk(sk)->ep, asoc, authkey);
 out:
-	kfree(authkey);
+	kzfree(authkey);
 	return ret;
 }
 
-- 
1.7.11.7

