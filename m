From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 19 Feb 2016 14:41:09 +0000
Subject: Re: [PATCHv2] sctp: Fix port hash table size computation
Message-Id: <1455892869.648.22.camel@edumazet-ThinkPad-T530>
List-Id: <linux-sctp.vger.kernel.org>
References: <20160218.153921.2010668846576353053.davem@davemloft.net>
	 <1455829857-15797-1-git-send-email-nhorman@tuxdriver.com>
	 <1455877730.648.21.camel@edumazet-ThinkPad-T530>
	 <20160219140703.GA20372@hmsreliant.think-freely.org>
In-Reply-To: <20160219140703.GA20372@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>, Vladislav Yasevich <vyasevich@gmail.com>, "David S. Miller" <davem@davemloft.net>

On ven., 2016-02-19 at 09:07 -0500, Neil Horman wrote:

> I had actually thought about that, but to be frank I felt like the logic to
> compute the hashsize was complex the way it was presented currently, and that my
> rewite made it more clear, breaking it down into a few easy steps:
> 
> 1) compute a goal size order
> 2) compute the target order for the largest table we want to support
> 3) select the minimum of (1) and (2)
> 4) allocated the largest table we can up to the size in (3)
> 5) compute how many buckets the table we allocated in (4) supports
> 
> 
> I'm happy to use your suggestion above if the consensus is that its more clear,
> but it took me a bit to figure out what exactly the existing code was trying to
> do (especially given the dual use of the order variable), so I thought some
> additional clarity was called for.

No strong feelings. I only took a look in other places like
net/dccp/proto.c for similar problem.



