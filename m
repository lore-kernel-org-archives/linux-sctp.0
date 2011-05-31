From: David Miller <davem@davemloft.net>
Date: Tue, 31 May 2011 22:29:36 +0000
Subject: Re: [PATCH] sctp: stop pending timers and purge queues when peer
Message-Id: <20110531.152936.59320562.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4DE36218.2090400@cn.fujitsu.com>
In-Reply-To: <4DE36218.2090400@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yjwei@cn.fujitsu.com
Cc: vladislav.yasevich@hp.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Mon, 30 May 2011 17:23:36 +0800

> If the peer restart the asoc, we should not only fail any unsent/unacked
> data, but also stop the T3-rtx, SACK, T4-rto timers, and teardown ASCONF
> queues.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>

Applied, thanks.
