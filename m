From: Joe Perches <joe@perches.com>
Date: Thu, 01 Sep 2011 00:25:11 +0000
Subject: Re: [PATCH 18/24] sctp: Remove unnecessary OOM logging messages
Message-Id: <1314836711.27632.34.camel@Joe-Laptop>
List-Id: <linux-sctp.vger.kernel.org>
References: <21b4d996c8861373ac77d427914ec7882fe0c83e.1314650069.git.joe@perches.com>
	 <1314654209.2563.7.camel@edumazet-laptop>
	 <1314654681.2563.10.camel@edumazet-laptop>
	 <20110829.181520.933815499847625814.davem@davemloft.net>
In-Reply-To: <20110829.181520.933815499847625814.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Mon, 2011-08-29 at 18:15 -0400, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Mon, 29 Aug 2011 23:51:21 +0200
> > Le lundi 29 août 2011 à 23:43 +0200, Eric Dumazet a écrit :
> >> Furthermore, a failed vmalloc() is not guaranteed to emit an OOM
> >> message, is it ?
> > It currently displays a message without context :
> > vmap allocation for size XXXXXX failed: use vmalloc=<size> to increase
> > size.
> > So we dont know which part of the kernel asked this allocation.
> > Please dont remove existing error messages after failed vmalloc() calls.
> Indeed.
> Joe, these vmalloc() and also the __GFP_NOWARN cases will need to be
> attended to and this series resubmitted as such.

No worries.

Andrew Morton picked up a patch I posted that
changes vmalloc to be similar to kmalloc when
the pointer returned is NULL (OOM).  It now
uses dump_stack for those cases.

https://patchwork.kernel.org/patch/1114682/

I'll keep all the current vmalloc failure messages
for now and resubmit in a day or two this series
with acks.  Not batman or netfilter though as they
were picked up by their maintainers.

A month or two after the vmalloc patch hits
mainline and/or wider testing, and it's deemed
acceptable, removing vmalloc site specific OOM
messages should be appropriate.

Anyone object?

I plan on submitting drivers/net OOM removals
next week.

