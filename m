From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 08 Sep 2016 19:27:51 +0000
Subject: Re: [PATCH net] sctp: hold the transport before using it in sctp_hash_cmp
Message-Id: <20160908192751.GE16608@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <f71c2e03ae6e9b956f41c73fff5a282c86d79daf.1473328144.git.lucien.xin@gmail.com>
In-Reply-To: <f71c2e03ae6e9b956f41c73fff5a282c86d79daf.1473328144.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Vlad Yasevich <vyasevich@gmail.com>, daniel@iogearbox.net

On Thu, Sep 08, 2016 at 05:49:04PM +0800, Xin Long wrote:
> Now sctp uses the transport without holding it in sctp_hash_cmp,
> it can cause a use-after-free panic. As after it get transport from
> hashtable, another CPU may free it, then the members it accesses
> may be unavailable memory.
> 
> This patch is to use sctp_transport_hold, in which it checks the
> refcnt first, holds it if it's not 0.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/input.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index 69444d3..1555fb8 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c
> @@ -796,27 +796,34 @@ struct sctp_hash_cmp_arg {
>  static inline int sctp_hash_cmp(struct rhashtable_compare_arg *arg,
>  				const void *ptr)
>  {
> +	struct sctp_transport *t = (struct sctp_transport *)ptr;
>  	const struct sctp_hash_cmp_arg *x = arg->key;
> -	const struct sctp_transport *t = ptr;
> -	struct sctp_association *asoc = t->asoc;
> -	const struct net *net = x->net;
> +	struct sctp_association *asoc;
> +	int err = 1;
>  
>  	if (!sctp_cmp_addr_exact(&t->ipaddr, x->paddr))
> -		return 1;
> -	if (!net_eq(sock_net(asoc->base.sk), net))
> -		return 1;
> +		return err;
> +	if (!sctp_transport_hold(t))
> +		return err;
> +
> +	asoc = t->asoc;
> +	if (!net_eq(sock_net(asoc->base.sk), x->net))
> +		goto out;
>  	if (x->ep) {
>  		if (x->ep != asoc->ep)
> -			return 1;
> +			goto out;
>  	} else {
>  		if (x->laddr->v4.sin_port != htons(asoc->base.bind_addr.port))
> -			return 1;
> +			goto out;
>  		if (!sctp_bind_addr_match(&asoc->base.bind_addr,
>  					  x->laddr, sctp_sk(asoc->base.sk)))
> -			return 1;
> +			goto out;
>  	}
>  
> -	return 0;
> +	err = 0;
> +out:
> +	sctp_transport_put(t);
> +	return err;
>  }
>  
>  static inline u32 sctp_hash_obj(const void *data, u32 len, u32 seed)
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
What path does this occur in?  __sctp_lookup_association takes a hold on the
asoc, and that function is protected by the rcu_read_lock, so I'm not sure how
you get into a situation in which the asoc can be deleted while the lookup is
occuring.

Neil

