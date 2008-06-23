From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 23 Jun 2008 20:00:18 +0000
Subject: Re: [RFC PATCH 2/2] sctp: Correct how sk_rmem_schedule is used.
Message-Id: <486000D2.8030701@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <12139080693483-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <12139080693483-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> We used to only use sk_rmem_schedule when we potentially overflow
> the sk_rcvbuf.  That allowed us to use sk_rmem[1] space on top of
> existing sk_recvbuf space which is way more that needed and thus
> incorrectly detecting memory pressure conditions.
> 
> We need to call sk_rmem_schedule at all times (whenever sk_rcvbuf is
> not locked), letting it correctly catch memory pressure conditions.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
> ---
>  net/sctp/ulpevent.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
> index a1f654a..71a97c7 100644
> --- a/net/sctp/ulpevent.c
> +++ b/net/sctp/ulpevent.c
> @@ -687,6 +687,7 @@ struct sctp_ulpevent *sctp_ulpevent_make_rcvmsg(struct sctp_association *asoc,
>  	struct sk_buff *skb;
>  	size_t padding, len;
>  	int rx_count;
> +	int pressure = 0;
>  
>  	/*
>  	 * check to see if we need to make space for this
> @@ -698,12 +699,13 @@ struct sctp_ulpevent *sctp_ulpevent_make_rcvmsg(struct sctp_association *asoc,
>  	else
>  		rx_count = atomic_read(&asoc->base.sk->sk_rmem_alloc);
>  
> -	if (rx_count >= asoc->base.sk->sk_rcvbuf) {
> +	if (asoc->base.sk->sk_userlocks & SOCK_RCVBUF_LOCK)
> +		pressure = sk_rmem_schedule(asoc->base.sk,
> +					    chunk->skb->truesize);
> +
> +	if (rx_count >= asoc->base.sk->sk_rcvbuf || pressure)
> +		goto fail;
>  
> -		if ((asoc->base.sk->sk_userlocks & SOCK_RCVBUF_LOCK) ||
> -		    (!sk_rmem_schedule(asoc->base.sk, chunk->skb->truesize)))
> -			goto fail;
> -	}
>  
>  	/* Clone the original skb, sharing the data.  */
>  	skb = skb_clone(chunk->skb, gfp);

OK, this one is bogus.  What we currently do is definitely wrong, but this patch
is wrong as well.

We need to always call rmem_schedule, otherwise we allow too much of an overflow.
We need to also adjust our sk_rcvbuf if we get into the condition of buffer exhaustion
prior to rwnd.

-vlad 
