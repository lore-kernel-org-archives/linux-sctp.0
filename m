From: Christoph Hellwig <hch@lst.de>
Date: Thu, 21 May 2020 17:46:37 +0000
Subject: [PATCH 02/49] sctp: pass a kernel pointer to sctp_setsockopt_bindx
Message-Id: <20200521174724.2635475-3-hch@lst.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200521174724.2635475-1-hch@lst.de>
In-Reply-To: <20200521174724.2635475-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

Use the kernel pointer that sctp_setsockopt has available instead of
directly handling the user pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ee6a618ee3e8e..eb08e44c0c57a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -972,42 +972,33 @@ int sctp_asconf_mgmt(struct sctp_sock *sp, struct sctp_sockaddr_entry *addrw)
  * it.
  *
  * sk        The sk of the socket
- * addrs     The pointer to the addresses in user land
+ * addrs     The pointer to the addresses
  * addrssize Size of the addrs buffer
  * op        Operation to perform (add or remove, see the flags of
  *           sctp_bindx)
  *
  * Returns 0 if ok, <0 errno code on error.
  */
-static int sctp_setsockopt_bindx(struct sock *sk,
-				 struct sockaddr __user *addrs,
-				 int addrs_size, int op)
+static int sctp_setsockopt_bindx(struct sock *sk, void *addr_buf,
+				  int addrs_size, int op)
 {
-	struct sockaddr *kaddrs;
+	struct sockaddr *kaddrs = addr_buf;
 	int err;
 	int addrcnt = 0;
 	int walk_size = 0;
 	struct sockaddr *sa_addr;
-	void *addr_buf;
 	struct sctp_af *af;
 
 	pr_debug("%s: sk:%p addrs:%p addrs_size:%d opt:%d\n",
-		 __func__, sk, addrs, addrs_size, op);
+		 __func__, sk, addr_buf, addrs_size, op);
 
 	if (unlikely(addrs_size <= 0))
 		return -EINVAL;
 
-	kaddrs = memdup_user(addrs, addrs_size);
-	if (IS_ERR(kaddrs))
-		return PTR_ERR(kaddrs);
-
 	/* Walk through the addrs buffer and count the number of addresses. */
-	addr_buf = kaddrs;
 	while (walk_size < addrs_size) {
-		if (walk_size + sizeof(sa_family_t) > addrs_size) {
-			kfree(kaddrs);
+		if (walk_size + sizeof(sa_family_t) > addrs_size)
 			return -EINVAL;
-		}
 
 		sa_addr = addr_buf;
 		af = sctp_get_af_specific(sa_addr->sa_family);
@@ -1015,10 +1006,8 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 		/* If the address family is not supported or if this address
 		 * causes the address buffer to overflow return EINVAL.
 		 */
-		if (!af || (walk_size + af->sockaddr_len) > addrs_size) {
-			kfree(kaddrs);
+		if (!af || (walk_size + af->sockaddr_len) > addrs_size)
 			return -EINVAL;
-		}
 		addrcnt++;
 		addr_buf += af->sockaddr_len;
 		walk_size += af->sockaddr_len;
@@ -1029,8 +1018,7 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 	case SCTP_BINDX_ADD_ADDR:
 		/* Allow security module to validate bindx addresses. */
 		err = security_sctp_bind_connect(sk, SCTP_SOCKOPT_BINDX_ADD,
-						 (struct sockaddr *)kaddrs,
-						 addrs_size);
+						 kaddrs, addrs_size);
 		if (err)
 			goto out;
 		err = sctp_bindx_add(sk, kaddrs, addrcnt);
@@ -1052,8 +1040,6 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 	}
 
 out:
-	kfree(kaddrs);
-
 	return err;
 }
 
@@ -4698,14 +4684,14 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
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
2.26.2
