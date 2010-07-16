From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Fri, 16 Jul 2010 09:19:31 +0000
Subject: [PATCH] sctp: kill redundant null check of af variable when doing
Message-Id: <4C402423.7000304@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

The sctp_setsockopt_bindx() copies addrs parameter of sctp_bindx()
from userspace to kernel, and check the sa_family member of address.
After that, we do the work of binding/deleting address.

So, over the next deal, we do not need to do null check of af variable
when calling sctp_get_af_specific().


Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 net/sctp/bind_addr.c |    2 --
 net/sctp/socket.c    |   17 -----------------
 2 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index faf71d1..2eb330f 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -434,8 +434,6 @@ union sctp_addr *sctp_find_unmatch_addr(struct sctp_bind_addr	*bp,
 		for (i = 0; i < addrcnt; i++) {
 			addr = (union sctp_addr *)addr_buf;
 			af = sctp_get_af_specific(addr->v4.sin_family);
-			if (!af)
-				break;
 
 			if (opt->pf->cmp_addr(&laddr->a, addr, opt))
 				break;
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ca44917..c686025 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -476,17 +476,12 @@ static int sctp_bindx_add(struct sock *sk, struct sockaddr *addrs, int addrcnt)
 		 */
 		sa_addr = (struct sockaddr *)addr_buf;
 		af = sctp_get_af_specific(sa_addr->sa_family);
-		if (!af) {
-			retval = -EINVAL;
-			goto err_bindx_add;
-		}
 
 		retval = sctp_do_bind(sk, (union sctp_addr *)sa_addr,
 				      af->sockaddr_len);
 
 		addr_buf += af->sockaddr_len;
 
-err_bindx_add:
 		if (retval < 0) {
 			/* Failed. Cleanup the ones that have been added */
 			if (cnt > 0)
@@ -555,10 +550,6 @@ static int sctp_send_asconf_add_ip(struct sock		*sk,
 		for (i = 0; i < addrcnt; i++) {
 			addr = (union sctp_addr *)addr_buf;
 			af = sctp_get_af_specific(addr->v4.sin_family);
-			if (!af) {
-				retval = -EINVAL;
-				goto out;
-			}
 
 			if (sctp_assoc_lookup_laddr(asoc, addr))
 				break;
@@ -646,10 +637,6 @@ static int sctp_bindx_rem(struct sock *sk, struct sockaddr *addrs, int addrcnt)
 
 		sa_addr = (union sctp_addr *)addr_buf;
 		af = sctp_get_af_specific(sa_addr->sa.sa_family);
-		if (!af) {
-			retval = -EINVAL;
-			goto err_bindx_rem;
-		}
 
 		if (!af->addr_valid(sa_addr, sp, NULL)) {
 			retval = -EADDRNOTAVAIL;
@@ -739,10 +726,6 @@ static int sctp_send_asconf_del_ip(struct sock		*sk,
 		for (i = 0; i < addrcnt; i++) {
 			laddr = (union sctp_addr *)addr_buf;
 			af = sctp_get_af_specific(laddr->v4.sin_family);
-			if (!af) {
-				retval = -EINVAL;
-				goto out;
-			}
 
 			if (!sctp_assoc_lookup_laddr(asoc, laddr))
 				break;
-- 
1.7.0
