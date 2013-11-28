From: David Miller <davem@davemloft.net>
Date: Thu, 28 Nov 2013 23:30:24 +0000
Subject: Re: [V2 PATCH] sctp: Restore 'resent' bit to avoid retransmitted chunks for RTT measurements
Message-Id: <20131128.183024.1122040393172123504.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1385350017-11324-1-git-send-email-xufeng.zhang@windriver.com>
In-Reply-To: <1385350017-11324-1-git-send-email-xufeng.zhang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: xufeng.zhang@windriver.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

From: Xufeng Zhang <xufeng.zhang@windriver.com>
Date: Mon, 25 Nov 2013 11:26:57 +0800

> Currently retransmitted DATA chunks could also be used for
> RTT measurements since there are no flag to identify whether
> the transmitted DATA chunk is a new one or a retransmitted one.
> This problem is introduced by commit ae19c5486 ("sctp: remove
> 'resent' bit from the chunk") which inappropriately removed the
> 'resent' bit completely, instead of doing this, we should set
> the resent bit only for the retransmitted DATA chunks.
> 
> Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
> ---
> v1->v2:
> Rmoved initialization for resent bit.
> Combined two if clause

Applied, thanks.
