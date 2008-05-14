From: David Miller <davem@davemloft.net>
Date: Wed, 14 May 2008 01:14:15 +0000
Subject: Re: [PATCH] [SCTP]: Add address type check while process
Message-Id: <20080513.181415.228379595.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <48298E27.40100@hp.com>
	<20080513.153238.211668684.davem@davemloft.net>
	<482A38B5.5030908@cn.fujitsu.com>
In-Reply-To: <482A38B5.5030908@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yjwei@cn.fujitsu.com
Cc: vladislav.yasevich@hp.com, kaber@trash.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net

From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 14 May 2008 08:56:21 +0800

> Hi David:
> 
>  Sorry for my mistake. This patch is create and tested by me.
> 
>  I tested it used a test tool which is created by me. And this patchset 
> resolved the kernel panic problem. It seems that I need to do more 
> review my patch and
> add more test case to my tool. I will pay more attention to do the 
> correct patchs.

It dereferences an uninitialized pointer, unconditionally.  Therefore,
the patch was definitely completely untested.  This function never ran
during your tests.

Please, no more excuses.

You didn't test the patch.
The end.
