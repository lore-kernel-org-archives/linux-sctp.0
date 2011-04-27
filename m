From: David Miller <davem@davemloft.net>
Date: Wed, 27 Apr 2011 01:47:57 +0000
Subject: Re: [PATCH net-next-2.6 0/7] SCTP updates for net-next-2.6
Message-Id: <20110426.184757.226780553.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110426.001238.183056292.davem@davemloft.net>
	<20110426.145120.28826019.davem@davemloft.net>
	<4DB76A64.3020708@cn.fujitsu.com>
In-Reply-To: <4DB76A64.3020708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yjwei@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 27 Apr 2011 08:59:16 +0800

> And I have a stupid question about the rule of backport.  Since those
> patchs have existed so long time, when I backport those patchs, I'd better
> fix the bug in the original patch, or create new patch to fix it? Also how
> about some thing need to improvement like the ->dst_saddr() method?

I think, since these are going in as patches, you should make any
corrections to those patches by fixing the patch.

Adding new patches is just going to keep the bug in there if people
try to bisect through these changes, and that's no good.

Thanks.
