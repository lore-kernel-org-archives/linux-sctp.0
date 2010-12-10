From: David Miller <davem@davemloft.net>
Date: Fri, 10 Dec 2010 23:29:58 +0000
Subject: Re: [PATCH] SCTP: Fix SCTP_SET_PEER_PRIMARY_ADDR to accpet
Message-Id: <20101210.152958.42812979.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4CFEF74D.7020704@cn.fujitsu.com>
	<4D02B436.5000605@hp.com>
In-Reply-To: <4D02B436.5000605@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: yjwei@cn.fujitsu.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Vladislav Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 10 Dec 2010 18:13:58 -0500

> On 12/07/2010 10:11 PM, Wei Yongjun wrote:
>> SCTP_SET_PEER_PRIMARY_ADDR does not accpet v4mapped address, using
>> v4mapped address in SCTP_SET_PEER_PRIMARY_ADDR socket option will
>> get -EADDRNOTAVAIL error if v4map is enabled. This patch try to
>> fix it by mapping v4mapped address to v4 address if allowed.
>> 
>> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> 
> Looks good.
> 
> Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied, thanks everyone.
