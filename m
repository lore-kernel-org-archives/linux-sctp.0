From: David Miller <davem@davemloft.net>
Date: Fri, 10 Dec 2010 23:01:51 +0000
Subject: Re: [PATCH] SCTP: Fix SCTP_SET_PEER_PRIMARY_ADDR to accpet
Message-Id: <20101210.150151.45910848.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4CFEF74D.7020704@cn.fujitsu.com>
In-Reply-To: <4CFEF74D.7020704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yjwei@cn.fujitsu.com
Cc: vladislav.yasevich@hp.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Wed, 08 Dec 2010 11:11:09 +0800

> SCTP_SET_PEER_PRIMARY_ADDR does not accpet v4mapped address, using
> v4mapped address in SCTP_SET_PEER_PRIMARY_ADDR socket option will
> get -EADDRNOTAVAIL error if v4map is enabled. This patch try to
> fix it by mapping v4mapped address to v4 address if allowed.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

Vlad and other SCTP folks, please review this patch.
