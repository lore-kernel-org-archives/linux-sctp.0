From: David Miller <davem@davemloft.net>
Date: Fri, 16 Apr 2010 06:37:33 +0000
Subject: Re: [net-next-2.6 PATCH 2/3 v2] net: replace ipfragok with
Message-Id: <20100415.233733.35006639.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BC7CEBC.70200@cn.fujitsu.com>
In-Reply-To: <4BC7CEBC.70200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: shanwei@cn.fujitsu.com
Cc: herbert@gondor.apana.org.au, yinghai.lu@oracle.com, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org, dccp@vger.kernel.org, linux-sctp@vger.kernel.org, jchapman@katalix.com, mostrows@speakeasy.net

From: Shan Wei <shanwei@cn.fujitsu.com>
Date: Fri, 16 Apr 2010 10:43:08 +0800

> As Herbert Xu said: we should be able to simply replace ipfragok
> with skb->local_df. commit f88037(sctp: Drop ipfargok in sctp_xmit function)
> has droped ipfragok and set local_df value properly.
> 
> The patch kills the ipfragok parameter of .queue_xmit().
> 
> 
> Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>

Applied.
