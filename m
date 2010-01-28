From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 28 Jan 2010 15:24:18 +0000
Subject: Re: [PATCH] sctp: IPsec rules are ineffective with ipv6
Message-Id: <4B61AC22.2050907@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4B6049EB.8030803@dev.6wind.com> <20100128.055148.127214200.davem@davemloft.net>
In-Reply-To: <20100128.055148.127214200.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: nicolas.dichtel@dev.6wind.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org



David Miller wrote:
> From: Nicolas Dichtel <nicolas.dichtel@dev.6wind.com>
> Date: Wed, 27 Jan 2010 15:12:59 +0100
> 
>> xfrm_lookup() is missing in sctp_v6_xmit(), add it.
>>
>> Signed-off-by: Junwei Zhang <junwei.zhang@6wind.com>
>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> 
> Doing this every transmit packet is overkill.
> 
> Whatever calculates the route that ends up in skb_dst(skb)
> should be making this xfrm_lookup() call, not here.
> 


Hmm.. Interesting.  Looks like ip_route_output_key() will
do xfrm_lookup for you, but there is no ipv6 route lookup call
that will do the same thing.

I guess we'll need to add an xfrm_lookup call in sctp_v6_get_dst().

-vlad
