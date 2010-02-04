From: Octavian Purdila <opurdila@ixiacom.com>
Date: Thu, 04 Feb 2010 12:44:01 +0000
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port numbers
Message-Id: <201002041444.01897.opurdila@ixiacom.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20100203043332.3817.27932.sendpatchset@localhost.localdomain> <201002031312.48531.opurdila@ixiacom.com> <4B6A3DBA.1000706@redhat.com>
In-Reply-To: <4B6A3DBA.1000706-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cong Wang <amwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>

On Thursday 04 February 2010 05:23:38 you wrote:

> > I think it might be useful to allow setting individual ports as reserved,
> > not only ranges, for example by using a bitmap.
> 
> This is a good idea, but I am not sure if this will be overkill? :-/
> Also, using bitmap is not friendly to sysctl interface, I am afraid.
> 

My concern is that we can have multiple applications that require a fixed port 
and if those ports are significantly apart we will decrease the port range 
available for connect. And that will hurt the rate of which new connections 
can be opened.

As for the sysctl interface I agree, I don't think it is even possible to  
cleanly use a bitmap through sysctl.

The options I see are either enhance sysctl to support bitmaps or use a 
dedicated /proc/net entry. 

I want to give this a try, which one do you people think is better?
