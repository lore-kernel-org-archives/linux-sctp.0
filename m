From: David Miller <davem@davemloft.net>
Date: Thu, 04 Feb 2010 21:56:39 +0000
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed
Message-Id: <20100204.135639.69720709.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20100204.094110.64247447.davem@davemloft.net>
	<201002042015.51092.opurdila@ixiacom.com>
	<201002050645.CEC95380.MLOtOVFFHSFOQJ@I-love.SAKURA.ne.jp>
In-Reply-To: <201002050645.CEC95380.MLOtOVFFHSFOQJ-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org
Cc: opurdila-+zzKsuq53OdBDgjK7y7TUQ@public.gmane.org, amwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Fri, 5 Feb 2010 06:45:28 +0900

> Octavian Purdila wrote:
>> 
>> int inet_is_reserved_local_port(int port)
>> {
>> 	if (test_bit(port, reserved_ports))
>> 		return 1;
>> 	return 0;
>> }
>> 
> Above check is exactly what I'm doing in the LSM hook.

But his version can be done inline in 2 or 3 instructions.

An LSM hook will result in an indirect function call,
all live registers spilled to the stack, then all of
those reloaded when the function returns.

It will be much more expensive.
