From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 26 Nov 2018 12:26:54 +0000
Subject: Re: [PATCH net] sctp: increase sk_wmem_alloc when head->truesize is increased
Message-Id: <20181126122654.GA18847@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <4989c666f6077526983b02615cad001748d2e658.1543215164.git.lucien.xin@gmail.com>
In-Reply-To: <4989c666f6077526983b02615cad001748d2e658.1543215164.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

On Mon, Nov 26, 2018 at 02:52:44PM +0800, Xin Long wrote:
> I changed to count sk_wmem_alloc by skb truesize instead of 1 to
> fix the sk_wmem_alloc leak caused by later truesize's change in
> xfrm in Commit 02968ccf0125 ("sctp: count sk_wmem_alloc by skb
> truesize in sctp_packet_transmit").
> 
> But I should have also increased sk_wmem_alloc when head->truesize
> is increased in sctp_packet_gso_append() as xfrm does. Otherwise,
> sctp gso packet will cause sk_wmem_alloc underflow.
> 
> Fixes: 02968ccf0125 ("sctp: count sk_wmem_alloc by skb truesize in sctp_packet_transmit")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/output.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index b0e74a3..025f48e 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -410,6 +410,7 @@ static void sctp_packet_gso_append(struct sk_buff *head, struct sk_buff *skb)
>  	head->truesize += skb->truesize;
>  	head->data_len += skb->len;
>  	head->len += skb->len;
> +	refcount_add(skb->truesize, &head->sk->sk_wmem_alloc);
>  
>  	__skb_header_release(skb);
>  }
This looks to me like you are now double counting every packet that passes
through sctp_packet_transmit, once in skb_set_owner_w and again in
sctp_packet_pack=>sctp_packet_gso_append

Neil

> -- 
> 2.1.0
> 
> 
