From: Qiujun Huang <hqjagain@gmail.com>
Date: Tue, 17 Mar 2020 15:55:36 +0000
Subject: [PATCH v2] sctp: fix refcount bug in sctp_wfree
Message-Id: <20200317155536.10227-1-hqjagain@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com, davem@davemloft.net
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, kuba@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, anenbupt@gmail.com, Qiujun Huang <hqjagain@gmail.com>

Do accounting for skb's real sk.
In some case skb->sk != asoc->base.sk:

migrate routing        sctp_check_transmitted routing
------------                    ---------------
lock_sock_nested();
                               mv the transmitted skb to
                               the it's local tlist

sctp_for_each_tx_datachunk(
sctp_clear_owner_w);
sctp_assoc_migrate();
sctp_for_each_tx_datachunk(
sctp_set_owner_w);

                               put the skb back to the
                               assoc lists
----------------------------------------------------

The skbs which held bysctp_check_transmitted were not changed
to newsk. They were not dealt with by sctp_for_each_tx_datachunk
(sctp_clear_owner_w/sctp_set_owner_w).

It looks only trouble here so handling it in sctp_wfree is enough.

Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 net/sctp/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1b56fc440606..5f5c28b30e25 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9080,7 +9080,7 @@ static void sctp_wfree(struct sk_buff *skb)
 {
 	struct sctp_chunk *chunk = skb_shinfo(skb)->destructor_arg;
 	struct sctp_association *asoc = chunk->asoc;
-	struct sock *sk = asoc->base.sk;
+	struct sock *sk = skb->sk;
 
 	sk_mem_uncharge(sk, skb->truesize);
 	sk->sk_wmem_queued -= skb->truesize + sizeof(struct sctp_chunk);
@@ -9109,7 +9109,7 @@ static void sctp_wfree(struct sk_buff *skb)
 	}
 
 	sock_wfree(skb);
-	sctp_wake_up_waiters(sk, asoc);
+	sctp_wake_up_waiters(asoc->base.sk, asoc);
 
 	sctp_association_put(asoc);
 }
-- 
2.17.1
