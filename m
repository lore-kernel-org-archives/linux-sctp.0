From: Christoph Hellwig <hch@lst.de>
Date: Sun, 19 Jul 2020 07:22:08 +0000
Subject: [PATCH 31/51] sctp: pass a kernel pointer to sctp_setsockopt_auto_asconf
Message-Id: <20200719072228.112645-32-hch@lst.de>
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
 net/sctp/socket.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ab155c15939ee8..64f2a967ddf5d3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3807,26 +3807,23 @@ static int sctp_setsockopt_deactivate_key(struct sock *sk,
  * Note. In this implementation, socket operation overrides default parameter
  * being set by sysctl as well as FreeBSD implementation
  */
-static int sctp_setsockopt_auto_asconf(struct sock *sk, char __user *optval,
+static int sctp_setsockopt_auto_asconf(struct sock *sk, int *val,
 					unsigned int optlen)
 {
-	int val;
 	struct sctp_sock *sp = sctp_sk(sk);
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
-	if (get_user(val, (int __user *)optval))
-		return -EFAULT;
-	if (!sctp_is_ep_boundall(sk) && val)
+	if (!sctp_is_ep_boundall(sk) && *val)
 		return -EINVAL;
-	if ((val && sp->do_auto_asconf) || (!val && !sp->do_auto_asconf))
+	if ((*val && sp->do_auto_asconf) || (!*val && !sp->do_auto_asconf))
 		return 0;
 
 	spin_lock_bh(&sock_net(sk)->sctp.addr_wq_lock);
-	if (val = 0 && sp->do_auto_asconf) {
+	if (*val = 0 && sp->do_auto_asconf) {
 		list_del(&sp->auto_asconf_list);
 		sp->do_auto_asconf = 0;
-	} else if (val && !sp->do_auto_asconf) {
+	} else if (*val && !sp->do_auto_asconf) {
 		list_add_tail(&sp->auto_asconf_list,
 		    &sock_net(sk)->sctp.auto_asconf_splist);
 		sp->do_auto_asconf = 1;
@@ -4690,7 +4687,7 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_deactivate_key(sk, kopt, optlen);
 		break;
 	case SCTP_AUTO_ASCONF:
-		retval = sctp_setsockopt_auto_asconf(sk, optval, optlen);
+		retval = sctp_setsockopt_auto_asconf(sk, kopt, optlen);
 		break;
 	case SCTP_PEER_ADDR_THLDS:
 		retval = sctp_setsockopt_paddr_thresholds(sk, optval, optlen,
-- 
2.27.0
