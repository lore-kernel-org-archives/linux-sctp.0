From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 14 May 2008 01:49:20 +0000
Subject: Re: [PATCH] [SCTP]: Add address type check while process paramaters
Message-Id: <482A4520.6010103@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48298E27.40100@hp.com>	<20080513.153238.211668684.davem@davemloft.net>	<482A38B5.5030908@cn.fujitsu.com> <20080513.181415.228379595.davem@davemloft.net>
In-Reply-To: <20080513.181415.228379595.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: vladislav.yasevich@hp.com, kaber@trash.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net

David Miller wrote:
> From: Wei Yongjun <yjwei@cn.fujitsu.com>
> Date: Wed, 14 May 2008 08:56:21 +0800
>
>   
>> Hi David:
>>
>>  Sorry for my mistake. This patch is create and tested by me.
>>
>>  I tested it used a test tool which is created by me. And this patchset 
>> resolved the kernel panic problem. It seems that I need to do more 
>> review my patch and
>> add more test case to my tool. I will pay more attention to do the 
>> correct patchs.
>>     
>
> It dereferences an uninitialized pointer, unconditionally.  Therefore,
> the patch was definitely completely untested.  This function never ran
> during your tests.
>
> Please, no more excuses.
>
> You didn't test the patch.
> The end.
>   

Are you sure you are right?

First I am sorry for stupid patch, second I said again, I do test it, 
but do not enough test.

uninitialized pointer is not NULL pointer, so it not kernel panic when 
use "addr_param->v4.param_hdr.type", this patch cause function alaways 
return SCTP_ERROR_INV_PARAM error, so even if I add IPv6 address to peer 
which not supported IPv6 address or add IPv4 address to peer which not 
supported IPv4 address is returned SCTP_ERROR_INV_PARAM, and passed my 
test case.
I not do test add IPv4/IPv6 address to peer which supported IPv4/IPv6 
address, this is my fault .






