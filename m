From: David Miller <davem@davemloft.net>
Date: Sun, 16 May 2010 07:46:52 +0000
Subject: Re: [PATCH v2] sctp: Fix a race between ICMP protocol unreachable
Message-Id: <20100516.004652.24579064.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1273088166-18391-1-git-send-email-vladislav.yasevich@hp.com>
	<4BE775C7.9070702@cn.fujitsu.com>
	<4BE81144.8020806@hp.com>
In-Reply-To: <4BE81144.8020806@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: yjwei@cn.fujitsu.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 10 May 2010 09:59:32 -0400

> 
> 
> Wei Yongjun wrote:
>> [PATCH] sctp: delete active ICMP proto unreachable timer when free transport
>> 
>> transport may be free before ICMP proto unreachable timer expire, so
>> we should delete active ICMP proto unreachable timer when transport
>> is going away.
>> 
>> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
 ...
> ACK.  This fixes a race against close().  Although that will be fairly hard to
> do, it is possible.
> 
> Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied, thanks.
