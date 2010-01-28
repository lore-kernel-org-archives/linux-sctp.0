From: David Miller <davem@davemloft.net>
Date: Thu, 28 Jan 2010 13:51:48 +0000
Subject: Re: [PATCH] sctp: IPsec rules are ineffective with ipv6
Message-Id: <20100128.055148.127214200.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4B6049EB.8030803@dev.6wind.com>
In-Reply-To: <4B6049EB.8030803@dev.6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nicolas.dichtel@dev.6wind.com
Cc: netdev@vger.kernel.org, vladislav.yasevich@hp.com, linux-sctp@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@dev.6wind.com>
Date: Wed, 27 Jan 2010 15:12:59 +0100

> xfrm_lookup() is missing in sctp_v6_xmit(), add it.
> 
> Signed-off-by: Junwei Zhang <junwei.zhang@6wind.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Doing this every transmit packet is overkill.

Whatever calculates the route that ends up in skb_dst(skb)
should be making this xfrm_lookup() call, not here.
