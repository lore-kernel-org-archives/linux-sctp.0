From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Mon, 19 Apr 2010 06:49:02 +0000
Subject: Re: [PATCH BUG-FIX] ipv6: allow to send packet after receiving	ICMPv6
Message-Id: <4BCBFCDE.7090206@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BCBC6CE.9020302@cn.fujitsu.com> <20100419035535.GA7011@gondor.apana.org.au>
In-Reply-To: <20100419035535.GA7011@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: David Miller <davem@davemloft.net>, "yoshfuji@linux-ipv6.org >> YOSHIFUJI Hideaki" <yoshfuji@linux-ipv6.org>, =?UTF-8?B?6a2P5YuH5Yab?= <yjwei@cn.fujitsu.com>, vladislav.yasevich@hp.com, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org, Patrick McHardy <kaber@trash.net>, eric.dumazet@gmail.com, sri@us.ibm.com, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org

Herbert Xu wrote, at 04/19/2010 11:55 AM:
> 
> The patch looks good to me.

Thanks for reviewing this patch.

> If we wanted to optimise the allfrags case it may be better
> to reserve the space beforehand and generate the fragment header
> at the same time as we're doing the IPv6 header.
> 
> But it can't be all that important as it's been broken for so
> many years.

If somebody needs one patch to fix the broken,
I am pleased to do so. 

-- 
Best Regards
-----
Shan Wei


> 
> Thanks,


