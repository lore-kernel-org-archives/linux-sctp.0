From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 16 Oct 2013 13:31:29 +0000
Subject: Re: [PATCH v4 net 1/3] net: dst: provide accessor function to dst->xfrm
Message-Id: <20131016133129.GA10623@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1381888891-31186-1-git-send-email-vyasevich@gmail.com>
 <1381888891-31186-2-git-send-email-vyasevich@gmail.com>
In-Reply-To: <1381888891-31186-2-git-send-email-vyasevich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, fan.du@windriver.com

On Tue, Oct 15, 2013 at 10:01:29PM -0400, Vlad Yasevich wrote:
> dst->xfrm is conditionally defined.  Provide accessor funtion that
> is always available.
> 
> Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
> ---
>  include/net/dst.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/net/dst.h b/include/net/dst.h
> index 3bc4865..3c4c944 100644
> --- a/include/net/dst.h
> +++ b/include/net/dst.h
> @@ -479,10 +479,22 @@ static inline struct dst_entry *xfrm_lookup(struct net *net,
>  {
>  	return dst_orig;
>  } 
> +
> +static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
> +{
> +	return NULL;
> +}
> +
>  #else
>  extern struct dst_entry *xfrm_lookup(struct net *net, struct dst_entry *dst_orig,
>  				     const struct flowi *fl, struct sock *sk,
>  				     int flags);
> +
> +/* skb attached with this dst needs transformation if dst->xfrm is valid */
> +static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
> +{
> +	return dst->xfrm;
> +}
>  #endif
>  
>  #endif /* _NET_DST_H */
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

