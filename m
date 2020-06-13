From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Date: Sat, 13 Jun 2020 12:39:25 +0000
Subject: [PATCH] sctp: Fix sk_buff leak when receiving a datagram
Message-Id: <1592051965-94731-1-git-send-email-xiyuyang19@fudan.edu.cn>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: yuanxzhang@fudan.edu.cn, kjlu@umn.edu, Xiyu Yang <xiyuyang19@fudan.edu.cn>, Xin Tan <tanxin.ctf@gmail.com>

In sctp_skb_recv_datagram(), the function fetch a sk_buff object from
the receiving queue to "skb" by calling skb_peek() or __skb_dequeue()
and return its reference to the caller.

However, when calling __skb_dequeue() successfully, the function forgets
to hold a reference count of the "skb" object and directly return it,
causing a potential memory leak in the caller function.

Fix this issue by calling refcount_inc after __skb_dequeue()
successfully executed.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/sctp/socket.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index d57e1a002ffc..4c8f0b83efd0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8990,6 +8990,8 @@ struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags,
 				refcount_inc(&skb->users);
 		} else {
 			skb = __skb_dequeue(&sk->sk_receive_queue);
+			if (skb)
+				refcount_inc(&skb->users);
 		}
 
 		if (skb)
-- 
2.7.4
