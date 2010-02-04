From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Thu, 04 Feb 2010 21:45:28 +0000
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port numbers
Message-Id: <201002050645.CEC95380.MLOtOVFFHSFOQJ@I-love.SAKURA.ne.jp>
List-Id: <linux-sctp.vger.kernel.org>
References: <201002031312.48531.opurdila@ixiacom.com>
	<201002041444.01897.opurdila@ixiacom.com>
	<20100204.094110.64247447.davem@davemloft.net>
	<201002042015.51092.opurdila@ixiacom.com>
In-Reply-To: <201002042015.51092.opurdila-+zzKsuq53OdBDgjK7y7TUQ@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: opurdila-+zzKsuq53OdBDgjK7y7TUQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
Cc: amwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Octavian Purdila wrote:
> 
> int inet_is_reserved_local_port(int port)
> {
> 	if (test_bit(port, reserved_ports))
> 		return 1;
> 	return 0;
> }
> 
Above check is exactly what I'm doing in the LSM hook.
