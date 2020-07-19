From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:21:39 +0000
Subject: [PATCH 02/51] sctp: pass a kernel pointer to sctp_setsockopt_bindx
Message-Id: <20200719072228.112645-3-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200719072228.112645-1-hch@lst.de>
In-Reply-To: <20200719072228.112645-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Rename sctp_setsockopt_bindx_kernel back to sctp_setsockopt_bindx,
and use the kernel pointer that sctp_setsockopt has available instead of
directly handling the user pointer in the old sctp_setsockopt_bindx.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 33 ++++++++-------------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index af1ebc8313d303..85ba5155b177b1 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -979,9 +979,8 @@ int sctp_asconf_mgmt(struct sctp_sock *sp, struct sctp_sockaddr_entry *addrw)
  *
  * Returns 0 if ok, <0 errno code on error.
  */
-static int sctp_setsockopt_bindx_kernel(struct sock *sk,
-					struct sockaddr *addrs, int addrs_size,
-					int op)
+static int sctp_setsockopt_bindx(struct sock *sk, struct sockaddr *addrs,
+				 int addrs_size, int op)
 {
 	int err;
 	int addrcnt = 0;
@@ -991,7 +990,7 @@ static int sctp_setsockopt_bindx_kernel(struct sock *sk,
 	struct sctp_af *af;
 
 	pr_debug("%s: sk:%p addrs:%p addrs_size:%d opt:%d\n",
-		 __func__, sk, addrs, addrs_size, op);
+		 __func__, sk, addr_buf, addrs_size, op);
 
 	if (unlikely(addrs_size <= 0))
 		return -EINVAL;
@@ -1037,29 +1036,13 @@ static int sctp_setsockopt_bindx_kernel(struct sock *sk,
 	}
 }
 
-static int sctp_setsockopt_bindx(struct sock *sk,
-				 struct sockaddr __user *addrs,
-				 int addrs_size, int op)
-{
-	struct sockaddr *kaddrs;
-	int err;
-
-	kaddrs = memdup_user(addrs, addrs_size);
-	if (IS_ERR(kaddrs))
-		return PTR_ERR(kaddrs);
-	err = sctp_setsockopt_bindx_kernel(sk, kaddrs, addrs_size, op);
-	kfree(kaddrs);
-	return err;
-}
-
 static int sctp_bind_add(struct sock *sk, struct sockaddr *addrs,
 		int addrlen)
 {
 	int err;
 
 	lock_sock(sk);
-	err = sctp_setsockopt_bindx_kernel(sk, addrs, addrlen,
-					   SCTP_BINDX_ADD_ADDR);
+	err = sctp_setsockopt_bindx(sk, addrs, addrlen, SCTP_BINDX_ADD_ADDR);
 	release_sock(sk);
 	return err;
 }
@@ -4705,14 +4688,14 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	switch (optname) {
 	case SCTP_SOCKOPT_BINDX_ADD:
 		/* 'optlen' is the size of the addresses buffer. */
-		retval = sctp_setsockopt_bindx(sk, (struct sockaddr __user *)optval,
-					       optlen, SCTP_BINDX_ADD_ADDR);
+		retval = sctp_setsockopt_bindx(sk, kopt, optlen,
+					       SCTP_BINDX_ADD_ADDR);
 		break;
 
 	case SCTP_SOCKOPT_BINDX_REM:
 		/* 'optlen' is the size of the addresses buffer. */
-		retval = sctp_setsockopt_bindx(sk, (struct sockaddr __user *)optval,
-					       optlen, SCTP_BINDX_REM_ADDR);
+		retval = sctp_setsockopt_bindx(sk, kopt, optlen,
+					       SCTP_BINDX_REM_ADDR);
 		break;
 
 	case SCTP_SOCKOPT_CONNECTX_OLD:
-- 
2.27.0
