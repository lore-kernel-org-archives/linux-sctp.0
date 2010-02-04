From: David Miller <davem@davemloft.net>
Date: Thu, 04 Feb 2010 18:21:13 +0000
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed
Message-Id: <20100204.102113.267879565.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <201002041444.01897.opurdila@ixiacom.com>
	<20100204.094110.64247447.davem@davemloft.net>
	<201002042015.51092.opurdila@ixiacom.com>
In-Reply-To: <201002042015.51092.opurdila-+zzKsuq53OdBDgjK7y7TUQ@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: opurdila-+zzKsuq53OdBDgjK7y7TUQ@public.gmane.org
Cc: amwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Octavian Purdila <opurdila@ixiacom.com>
Date: Thu, 4 Feb 2010 20:15:51 +0200

> int inet_is_reserved_local_port(int port)
> {
> 	if (test_bit(port, reserved_ports))
> 		return 1;
> 	return 0;
> }
> 
> In theory it might be slower because of the reserved_ports bitmap will have a 
> larger memory footprint than just a min/max, especially with random port 
> allocation. But is this an issue in practice?

No need to speculate, some simple benchmarks would confirm or deny
this.
