From: David Miller <davem@davemloft.net>
Date: Wed, 25 May 2011 21:57:04 +0000
Subject: Re: [PATCH] sctp: fix memory leak of the ASCONF queue when free
Message-Id: <20110525.175704.394251370550456184.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DDCB432.7000903@cn.fujitsu.com>
In-Reply-To: <4DDCB432.7000903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yjwei@cn.fujitsu.com
Cc: vladislav.yasevich@hp.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 25 May 2011 15:48:02 +0800

> If an ASCONF chunk is outstanding, then the following ASCONF
> chunk will be queued for later transmission. But when we free
> the asoc, we forget to free the ASCONF queue at the same time,
> this will cause memory leak.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

Applied.
