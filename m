From: David Miller <davem@davemloft.net>
Date: Thu, 04 Feb 2010 17:41:10 +0000
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed
Message-Id: <20100204.094110.64247447.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <201002031312.48531.opurdila@ixiacom.com>
	<4B6A3DBA.1000706@redhat.com>
	<201002041444.01897.opurdila@ixiacom.com>
In-Reply-To: <201002041444.01897.opurdila-+zzKsuq53OdBDgjK7y7TUQ@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: opurdila-+zzKsuq53OdBDgjK7y7TUQ@public.gmane.org
Cc: amwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Octavian Purdila <opurdila@ixiacom.com>
Date: Thu, 4 Feb 2010 14:44:01 +0200

> My concern is that we can have multiple applications that require a
> fixed port and if those ports are significantly apart we will
> decrease the port range available for connect. And that will hurt
> the rate of which new connections can be opened.

I'm already uneasy about adding the simple check every time
we loop around in the bind port allocator.

Adding an LSM hook to this spot?  I absolutely refuse to allow
that, it will completely kill bind performance.
