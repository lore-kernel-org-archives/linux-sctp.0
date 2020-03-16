From: Qiujun Huang <hqjagain@gmail.com>
Date: Mon, 16 Mar 2020 03:53:24 +0000
Subject: [PATCH] sctp: fix refcount bug in sctp_wfree
Message-Id: <1584330804-18477-1-git-send-email-hqjagain@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vyasevich@gmail.com, nhorman@tuxdriver.com, marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>

Do accounting for skb's real sk.
In some case skb->sk != asoc->base.sk.

Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 net/sctp/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1b56fc4..5f5c28b 100644
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
1.8.3.1
