From: David Miller <davem@davemloft.net>
Date: Fri, 09 May 2008 22:12:03 +0000
Subject: Re: [PATCH] [SCTP]: Add address type check while process
Message-Id: <20080509.151203.84367922.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1210360195-16524-1-git-send-email-vladislav.yasevich@hp.com>
	<1210360195-16524-2-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1210360195-16524-2-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net, yjwei@cn.fujitsu.com

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri,  9 May 2008 15:09:55 -0400

> If socket is create by AF_INET type, add IPv6 address to asoc will cause
> kernel panic while packet is transmitted on that transport.
> 
> This patch add address type check before process paramaters of ASCONF
> chunk. If peer is not support this address type, return with error
> invald parameter.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied, thanks.
