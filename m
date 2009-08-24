From: Luo Chunbo <chunbo.luo@windriver.com>
Date: Mon, 24 Aug 2009 09:35:20 +0000
Subject: Re: [PATCH] sctp: fix the check for path failure detection
Message-Id: <1251106520.6513.51.camel@pek-cluo-desktop>
List-Id: <linux-sctp.vger.kernel.org>
References: <1250838275-7444-1-git-send-email-chunbo.luo@windriver.com>
	 <4A8F15F5.3020901@hp.com> <1251080117.6513.11.camel@pek-cluo-desktop>
	 <4A924734.6000702@cn.fujitsu.com>
In-Reply-To: <4A924734.6000702@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Wei Yongjun <yjwei@cn.fujitsu.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>, davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 15:54 +0800, Wei Yongjun wrote:
> Luo Chunbo 写道:
> > On Fri, 2009-08-21 at 17:47 -0400, Vlad Yasevich wrote:
> >   
> >> Chunbo Luo wrote:
> >>     
> >>> The transport is marked DOWN immediately after sending the max+1 HB,
> >>> which is equal to not sending the max+1 HB at all. We should wait
> >>> a next period and make sure the last HB is not acknowledged.
> >>>
> >>>       
> >> I don't think this code does what you want either...
> >>
> >> Let's say path_max_rxt = 2.  What we'll get is:
> >> 	timeout:
> >> 		err++ (1)
> >> 		if (err > 2) false
> >> 		send HB
> >> 		reset timer
> >> 	timeout:
> >> 		err++ (2)
> >> 		if (err > 2) false
> >> 		send HB
> >> 		reset timer
> >> 	timeout:
> >> 		err++ (3)
> >> 		if (err > 2)
> >> 			set transport DOWN
> >> 		send HB
> >> 		reset timer.
> >>
> >> We only had 2 unacknowledged HB when we should have had 3.
> >>     
> >
> > The error count is increment after the HB was sent, and the error count
> > check is before sending HB.
> >
> > Let's say path_max_rxt =2 . What we really get is:
> >
> > timeout:
> > 	if( err > 2) false
> > 	send HB
> > 	err++ (1)
> > 	reset timer
> > timeout:
> > 	if( err > 2) false
> > 	send HB
> > 	err++ (2)
> > 	reset timer
> > timeout:
> > 	if( err > 2) false
> > 	send HB
> > 	err++ (3)
> > 	reset timer
> > timeout:
> > 	if( err > 2)
> > 		set transport DOWN
> > 	send HB
> > 	reset timer
> >
> > Here We had 3 unacknowledged HBs
> 
> 
> But with Vlad's advice, you just need to do little change to the kernel
> codes, may be two lines's patch, and it can do the same thing.


OK, I'll send a new patch later.


> 
> 
> 
