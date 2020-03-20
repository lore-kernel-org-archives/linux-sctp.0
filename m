From: Qiujun Huang <hqjagain@gmail.com>
Date: Fri, 20 Mar 2020 11:09:59 +0000
Subject: [PATCH v3] sctp: fix refcount bug in sctp_wfree
Message-Id: <20200320110959.2114-1-hqjagain@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com, davem@davemloft.net
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, kuba@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, anenbupt@gmail.com, Qiujun Huang <hqjagain@gmail.com>

Do accounting for skb's real sk.
In some case skb->sk != asoc->base.sk:

for the trouble SKB, it was in outq->transmitted queue

sctp_outq_sack
	sctp_check_transmitted
		SKB was moved to outq->sack
	then throw away the sack queue
		SKB was deleted from outq->sack
(but the datamsg held SKB at sctp_datamsg_to_asoc
So, sctp_wfree was not called to destroy SKB)

then migrate happened

	sctp_for_each_tx_datachunk(
	sctp_clear_owner_w);
	sctp_assoc_migrate();
	sctp_for_each_tx_datachunk(
	sctp_set_owner_w);
SKB was not in the outq, and was not changed to newsk

finally

__sctp_outq_teardown
	sctp_chunk_put (for another skb)
		sctp_datamsg_put
			__kfree_skb(msg->frag_list)
				sctp_wfree (for SKB)
this case in sctp_wfree SKB->sk was oldsk.

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
