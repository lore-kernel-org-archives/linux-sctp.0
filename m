From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 22 Jan 2009 21:18:43 +0000
Subject: Re: [PATCH] sctp/ipv6.c: use ipv6_addr_copy
Message-Id: <4978E2B3.3010109@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1232658506.15489.63.camel@localhost>
In-Reply-To: <1232658506.15489.63.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>, Networking Team <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org

Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index ceaa4aa..7862275 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -97,8 +97,7 @@ static int sctp_inet6addr_event(struct notifier_block *this, unsigned long ev,
>  		if (addr) {
>  			addr->a.v6.sin6_family = AF_INET6;
>  			addr->a.v6.sin6_port = 0;
> -			memcpy(&addr->a.v6.sin6_addr, &ifa->addr,
> -				 sizeof(struct in6_addr));
> +			ipv6_addr_copy(&addr->a.v6.sin6_addr, &ifa->addr);
>  			addr->a.v6.sin6_scope_id = ifa->idev->dev->ifindex;
>  			addr->valid = 1;
>  			spin_lock_bh(&sctp_local_addr_lock);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

ACK.  Simple enough of a cleanup.

-vlad
