From: David Miller <davem@davemloft.net>
Date: Wed, 11 Apr 2018 14:51:37 +0000
Subject: Re: [PATCH net] sctp: do not check port in sctp_inet6_cmp_addr
Message-Id: <20180411.105137.2091306176910843241.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <340aad3be762046ca9d02e54edba5bfefa2f4e71.1523451485.git.lucien.xin@gmail.com>
In-Reply-To: <340aad3be762046ca9d02e54edba5bfefa2f4e71.1523451485.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 11 Apr 2018 20:58:05 +0800

> @@ -863,10 +863,31 @@ static int sctp_inet6_cmp_addr(const union sctp_addr *addr1,
>  	if (sctp_is_any(sk, addr1) || sctp_is_any(sk, addr2))
>  		return 1;
>  
> -	if (addr1->sa.sa_family != addr2->sa.sa_family)
> +	if (addr1->sa.sa_family != addr2->sa.sa_family) {
> +		if (addr1->sa.sa_family = AF_INET &&
> +		    addr2->sa.sa_family = AF_INET6 &&
> +		    ipv6_addr_v4mapped(&addr2->v6.sin6_addr))
> +			if (addr2->v6.sin6_addr.s6_addr32[3] =
> +			    addr1->v4.sin_addr.s_addr)
> +				return 1;
> +		if (addr2->sa.sa_family = AF_INET &&
> +		    addr1->sa.sa_family = AF_INET6 &&
> +		    ipv6_addr_v4mapped(&addr1->v6.sin6_addr))
> +			if (addr1->v6.sin6_addr.s6_addr32[3] =
> +			    addr2->v4.sin_addr.s_addr)
> +				return 1;
> +		return 0;
> +	}
> +
> +	if (!ipv6_addr_equal(&addr1->v6.sin6_addr, &addr2->v6.sin6_addr))
> +		return 0;
> +
> +	if ((ipv6_addr_type(&addr1->v6.sin6_addr) & IPV6_ADDR_LINKLOCAL) &&
> +	    addr1->v6.sin6_scope_id && addr2->v6.sin6_scope_id &&
> +	    addr1->v6.sin6_scope_id != addr2->v6.sin6_scope_id)
>  		return 0;
>  
> -	return af1->cmp_addr(addr1, addr2);
> +	return 1;
>  }

I agree with Neil that we should try to avoid the code duplication here
somehow.

Although we risk gcc emitting two copies of the function if we do
something like:

__sctp_v6_cmp_addr(addr1, addr2, check_ports)
{
}

sctp_v6_cmp_addr(addr, addr2)
{
	return __sctp_v6_cmp_addr(addr1, addr2, true);
}

and invoke __sctp_v6_cmp_addr(addr1, addr2, true) from sctp_inet6_cmp_addr().
