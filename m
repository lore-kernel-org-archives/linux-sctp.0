From: David Miller <davem@davemloft.net>
Date: Tue, 15 May 2012 18:14:23 +0000
Subject: Re: [RFC net-next 0/2] net: Use net_<level>_ratelimit
Message-Id: <20120515.141423.885518974251878746.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1336981915.git.joe@perches.com>
	<20120515.134531.530903973750646107.davem@davemloft.net>
	<1337104765.7050.24.camel@joe2Laptop>
In-Reply-To: <1337104765.7050.24.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net, netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org, coreteam@netfilter.org, linux-wireless@vger.kernel.org, dev@openvswitch.org, linux-sctp@vger.kernel.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 15 May 2012 10:59:25 -0700

> I could produce a net_printk_ratelimited that would keep
> the original behavior if necessary.
> 
> 	net_printk_ratelimited(KERN_DEBUG etc...)

I don't think it's worth the hassle, we'd rather get people
into the habit of using dynamic_debug.
