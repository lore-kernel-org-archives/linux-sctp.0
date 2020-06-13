From: Neil Horman <nhorman@tuxdriver.com>
Date: Sat, 13 Jun 2020 15:57:51 +0000
Subject: Re: [PATCH] sctp: Fix sk_buff leak when receiving a datagram
Message-Id: <20200613155751.GA161691@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1592051965-94731-1-git-send-email-xiyuyang19@fudan.edu.cn>
In-Reply-To: <1592051965-94731-1-git-send-email-xiyuyang19@fudan.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, yuanxzhang@fudan.edu.cn, kjlu@umn.edu, Xin Tan <tanxin.ctf@gmail.com>

On Sat, Jun 13, 2020 at 08:39:25PM +0800, Xiyu Yang wrote:
> In sctp_skb_recv_datagram(), the function fetch a sk_buff object from
> the receiving queue to "skb" by calling skb_peek() or __skb_dequeue()
> and return its reference to the caller.
> 
> However, when calling __skb_dequeue() successfully, the function forgets
> to hold a reference count of the "skb" object and directly return it,
> causing a potential memory leak in the caller function.
> 
> Fix this issue by calling refcount_inc after __skb_dequeue()
> successfully executed.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> ---
>  net/sctp/socket.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index d57e1a002ffc..4c8f0b83efd0 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -8990,6 +8990,8 @@ struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags,
>  				refcount_inc(&skb->users);
>  		} else {
>  			skb = __skb_dequeue(&sk->sk_receive_queue);
> +			if (skb)
> +				refcount_inc(&skb->users);
For completeness, you should probably use skb_get here, rather than refcount_inc
directly.

Also, I'm not entirely sure I see how a memory leak can happen here.  we take an
extra reference in the skb_peek clause of this code area because if we return an
skb that continues to exist on the sk_receive_queue list, we legitimately have
two users for the skb (the user who called sctp_skb_recv_datagram(...,MSG_PEEK),
and the potential next caller who will actually dequeue the skb.

In the else clause however, that condition doesn't exist.  the user count for
the skb should alreday be 1, if the caller is the only user of the skb), or more
than 1, if 1 or more callers have gotten a reference to the message using
MSG_PEEK.

I don't think this code is needed, and in fact will actually cause memory leaks,
because theres no subsequent skb_unref call to drop refcount that you are adding
here.

Neil

>  		}
>  
>  		if (skb)
> -- 
> 2.7.4
> 
> 
