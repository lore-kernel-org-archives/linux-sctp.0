From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 21 Aug 2020 06:59:38 +0000
Subject: [PATCHv2 net] sctp: not disable bh in the whole sctp_get_port_local()
Message-Id: <08a14c2f087153c18c67965cc37ed2ac22da18ed.1597993178.git.lucien.xin@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc: davem@davemloft.net, Eric Dumazet <edumazet@google.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

With disabling bh in the whole sctp_get_port_local(), when
snum = 0 and too many ports have been used, the do-while
loop will take the cpu for a long time and cause cpu stuck:

  [ ] watchdog: BUG: soft lockup - CPU#11 stuck for 22s!
  [ ] RIP: 0010:native_queued_spin_lock_slowpath+0x4de/0x940
  [ ] Call Trace:
  [ ]  _raw_spin_lock+0xc1/0xd0
  [ ]  sctp_get_port_local+0x527/0x650 [sctp]
  [ ]  sctp_do_bind+0x208/0x5e0 [sctp]
  [ ]  sctp_autobind+0x165/0x1e0 [sctp]
  [ ]  sctp_connect_new_asoc+0x355/0x480 [sctp]
  [ ]  __sctp_connect+0x360/0xb10 [sctp]

There's no need to disable bh in the whole function of
sctp_get_port_local. So fix this cpu stuck by removing
local_bh_disable() called at the beginning, and using
spin_lock_bh() instead.

The same thing was actually done for inet_csk_get_port() in
Commit ea8add2b1903 ("tcp/dccp: better use of ephemeral
ports in bind()").

Thanks to Marcelo for pointing the buggy code out.

v1->v2:
  - use cond_resched() to yield cpu to other tasks if needed,
    as Eric noticed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ec1fba1..836615f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8060,8 +8060,6 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 
 	pr_debug("%s: begins, snum:%d\n", __func__, snum);
 
-	local_bh_disable();
-
 	if (snum = 0) {
 		/* Search for an available port. */
 		int low, high, remaining, index;
@@ -8079,20 +8077,21 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 				continue;
 			index = sctp_phashfn(net, rover);
 			head = &sctp_port_hashtable[index];
-			spin_lock(&head->lock);
+			spin_lock_bh(&head->lock);
 			sctp_for_each_hentry(pp, &head->chain)
 				if ((pp->port = rover) &&
 				    net_eq(net, pp->net))
 					goto next;
 			break;
 		next:
-			spin_unlock(&head->lock);
+			spin_unlock_bh(&head->lock);
+			cond_resched();
 		} while (--remaining > 0);
 
 		/* Exhausted local port range during search? */
 		ret = 1;
 		if (remaining <= 0)
-			goto fail;
+			return ret;
 
 		/* OK, here is the one we will use.  HEAD (the port
 		 * hash table list entry) is non-NULL and we hold it's
@@ -8107,7 +8106,7 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 		 * port iterator, pp being NULL.
 		 */
 		head = &sctp_port_hashtable[sctp_phashfn(net, snum)];
-		spin_lock(&head->lock);
+		spin_lock_bh(&head->lock);
 		sctp_for_each_hentry(pp, &head->chain) {
 			if ((pp->port = snum) && net_eq(pp->net, net))
 				goto pp_found;
@@ -8207,10 +8206,7 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 	ret = 0;
 
 fail_unlock:
-	spin_unlock(&head->lock);
-
-fail:
-	local_bh_enable();
+	spin_unlock_bh(&head->lock);
 	return ret;
 }
 
-- 
2.1.0
