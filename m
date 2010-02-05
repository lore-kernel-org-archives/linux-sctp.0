From: Octavian Purdila <opurdila@ixiacom.com>
Date: Fri, 05 Feb 2010 12:05:53 +0000
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port numbers
Message-Id: <201002051405.54029.opurdila@ixiacom.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <201002031312.48531.opurdila@ixiacom.com> <201002042015.51092.opurdila@ixiacom.com> <4B6BA272.4090405@redhat.com>
In-Reply-To: <4B6BA272.4090405-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cong Wang <amwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Friday 05 February 2010 06:45:38 you wrote:

> Again, using bitmap algorithm is not a problem and it's better, the
> problem is sysctl interface, how would you plan to interact with users
> via sysctl/proc if you use bitmap to handle this? I would like to hear
> more details about this.
> 

We could use something like positive values for setting and negative for reset 
(e.g. 3 would set the port in the bitmap and -3 would reset it).

But we would need new sysctl and proc handlers to handle the bitmap case (e.g. 
sysctl_bitmap, proc_dobitmap_minmax).
