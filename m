From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 05 Oct 2017 13:16:31 +0000
Subject: Re: [PATCH V2] Fix a sleep-in-atomic bug in shash_setkey_unaligned
Message-Id: <20171005131631.GA1553@gondor.apana.org.au>
List-Id: <linux-sctp.vger.kernel.org>
References: <20171003052643.GB22750@gondor.apana.org.au>
 <20171003224505.GE19750@localhost.localdomain>
 <20171005034054.GB31996@gondor.apana.org.au>
 <20171004.213758.2210486785503998906.davem@davemloft.net>
 <20171005101620.GA1246@gondor.apana.org.au>
In-Reply-To: <20171005101620.GA1246-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: marcelo.leitner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, baijiaju1990-9Onoh4P/yGk@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Oct 05, 2017 at 06:16:20PM +0800, Herbert Xu wrote:
>
> That was my point.  Functions like sctp_pack_cookie shouldn't be
> setting the key in the first place.  The setkey should happen at
> the point when the key is generated.  That's sctp_endpoint_init
> which AFAICS only gets called in GFP_KERNEL context.
> 
> Or is there a code-path where sctp_endpoint_init is called in
> softirq context?

OK, there are indeed code paths where the key is derived in softirq
context.  Notably sctp_auth_calculate_hmac.

So I think this patch is the correct fix and I will push it upstream
as well as back to stable.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
