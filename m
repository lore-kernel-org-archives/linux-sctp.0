From: Octavian Purdila <opurdila@ixiacom.com>
Date: Wed, 03 Feb 2010 11:12:48 +0000
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port numbers
Message-Id: <201002031312.48531.opurdila@ixiacom.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20100203043332.3817.27932.sendpatchset@localhost.localdomain>
In-Reply-To: <20100203043332.3817.27932.sendpatchset-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Amerigo Wang <amwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>

On Wednesday 03 February 2010 06:30:07 you wrote:

> This patch introduces /proc/sys/net/ipv4/ip_local_reserved_ports,
> it can be used like ip_local_port_range, but this is used to
> reserve ports for third-party applications which use fixed
> port numbers within ip_local_port_range.
> 
> This only affects the applications which call socket functions
> like bind(2) with port number 0, to prevent the kernel getting the ports
> within the specified range for them. For applications which use fixed
> port number, it will have no effects.

It also affects the case where applications do connect, without previously 
doing bind, right?

> 
> Any comments are welcome.

I think it might be useful to allow setting individual ports as reserved, not 
only ranges, for example by using a bitmap. 


