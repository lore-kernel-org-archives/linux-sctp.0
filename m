From: Cong Wang <amwang@redhat.com>
Date: Mon, 08 Feb 2010 03:21:50 +0000
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port
Message-Id: <4B6F834E.4010801@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <201002031312.48531.opurdila@ixiacom.com> <201002042015.51092.opurdila@ixiacom.com> <4B6BA272.4090405@redhat.com> <201002051405.54029.opurdila@ixiacom.com>
In-Reply-To: <201002051405.54029.opurdila-+zzKsuq53OdBDgjK7y7TUQ@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Octavian Purdila <opurdila-+zzKsuq53OdBDgjK7y7TUQ@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Octavian Purdila wrote:
> On Friday 05 February 2010 06:45:38 you wrote:
> 
>> Again, using bitmap algorithm is not a problem and it's better, the
>> problem is sysctl interface, how would you plan to interact with users
>> via sysctl/proc if you use bitmap to handle this? I would like to hear
>> more details about this.
>>
> 
> We could use something like positive values for setting and negative for reset 
> (e.g. 3 would set the port in the bitmap and -3 would reset it).


Hmm, then how do you output the info of those ports? Arrays of bitmaps?

> 
> But we would need new sysctl and proc handlers to handle the bitmap case (e.g. 
> sysctl_bitmap, proc_dobitmap_minmax).

Maybe.

Thanks.
