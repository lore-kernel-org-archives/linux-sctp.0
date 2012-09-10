From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 10 Sep 2012 13:10:39 +0000
Subject: Re: [PATCH 1/2] dst: take into account policy update on check()
Message-Id: <1347282639.1234.1569.camel@edumazet-glaptop>
List-Id: <linux-sctp.vger.kernel.org>
References: <504A08EA.3080506@6wind.com>
	 <1347030598.2484.777.camel@edumazet-glaptop> <504A0F1F.5060504@6wind.com>
	 <20120907.144828.97793990734588625.davem@davemloft.net>
	 <504DE17A.1000908@6wind.com>
In-Reply-To: <504DE17A.1000908@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nicolas.dichtel@6wind.com
Cc: David Miller <davem@davemloft.net>, vyasevich@gmail.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Mon, 2012-09-10 at 14:47 +0200, Nicolas Dichtel wrote:

> So it means that IPv6 dst entries will be invalidated by IPv4 route management. 
> For example, calling rt_cache_flush() will flush IPv6 dst too. Is this acceptable?

If it can save another test in fast path, this is acceptable, yes.



