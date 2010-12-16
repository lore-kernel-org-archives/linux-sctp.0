From: David Miller <davem@davemloft.net>
Date: Thu, 16 Dec 2010 22:49:36 +0000
Subject: Re: [PATCH] sctp: fix the return value of getting the sctp partial
Message-Id: <20101216.144936.68120774.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4D0823A1.6080307@cn.fujitsu.com>
	<4D08E46A.5010703@hp.com>
In-Reply-To: <4D08E46A.5010703@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: yjwei@cn.fujitsu.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Vladislav Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 15 Dec 2010 10:53:14 -0500

> On 12/14/2010 09:10 PM, Wei Yongjun wrote:
>> Get the sctp partial delivery point using SCTP_PARTIAL_DELIVERY_POINT
>> socket option should return 0 if success, not -ENOTSUPP.
>> 
> 
> Ack.
> 
> -vlad
> 
>> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

Applied, thanks everyone.

Vlad, please use properly formed full "Acked-by: ..." in the
future otherwise automated tools don't pick it up and it's
therefore more likely your ACK gets lost.

Thanks :-)
