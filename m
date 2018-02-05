From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 05 Feb 2018 12:35:49 +0000
Subject: Re: [PATCH] sctp: fix dst refcnt leak in sctp_v6_get_dst()
Message-Id: <20180205123549.GA23491@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1517832635-18376-1-git-send-email-alexey.kodanev@oracle.com>
In-Reply-To: <1517832635-18376-1-git-send-email-alexey.kodanev@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexey Kodanev <alexey.kodanev@oracle.com>
Cc: netdev@vger.kernel.org, Xin Long <lucien.xin@gmail.com>, Tommi Rantala <tommi.t.rantala@nokia.com>, Vlad Yasevich <vyasevich@gmail.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, David Miller <davem@davemloft.net>, linux-sctp@vger.kernel.org

On Mon, Feb 05, 2018 at 03:10:35PM +0300, Alexey Kodanev wrote:
> When going through the bind address list in sctp_v6_get_dst() and
> the previously found address is better ('matchlen > bmatchlen'),
> the code continues to the next iteration without releasing currently
> held destination.
> 
> Fix it by releasing 'bdst' before continue to the next iteration, and
> instead of introducing one more '!IS_ERR(bdst)' check for dst_release(),
> move the already existed one right after ip6_dst_lookup_flow(), i.e. we
> shouldn't proceed further if we get an error for the route lookup.
> 
> Fixes: dbc2b5e9a09e ("sctp: fix src address selection if using secondary addresses for ipv6")
> Signed-off-by: Alexey Kodanev <alexey.kodanev@oracle.com>
> ---
>  net/sctp/ipv6.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index 5d4c15b..e35d4f7 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -326,8 +326,10 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
>  		final_p = fl6_update_dst(fl6, rcu_dereference(np->opt), &final);
>  		bdst = ip6_dst_lookup_flow(sk, fl6, final_p);
>  
> -		if (!IS_ERR(bdst) &&
> -		    ipv6_chk_addr(dev_net(bdst->dev),
> +		if (IS_ERR(bdst))
> +			continue;
> +
> +		if (ipv6_chk_addr(dev_net(bdst->dev),
>  				  &laddr->a.v6.sin6_addr, bdst->dev, 1)) {
>  			if (!IS_ERR_OR_NULL(dst))
>  				dst_release(dst);
> @@ -336,8 +338,10 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
>  		}
>  
>  		bmatchlen = sctp_v6_addr_match_len(daddr, &laddr->a);
> -		if (matchlen > bmatchlen)
> +		if (matchlen > bmatchlen) {
> +			dst_release(bdst);
>  			continue;
> +		}
>  
>  		if (!IS_ERR_OR_NULL(dst))
>  			dst_release(dst);
> -- 
> 1.7.1
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
