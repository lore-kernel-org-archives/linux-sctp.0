From: David Miller <davem@davemloft.net>
Date: Wed, 04 Jun 2008 19:39:42 +0000
Subject: Re: [PATCH 5/6] SCTP: Flush the queue only once during fast
Message-Id: <20080604.123942.128575696.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1212603951-24932-1-git-send-email-vladislav.yasevich@hp.com>
	<1212603951-24932-6-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1212603951-24932-6-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed,  4 Jun 2008 14:25:50 -0400

> When fast retransmit is triggered by a sack, we should flush
> the queue only once so that only 1 retransmit happens.  Also,
> since we could potentially have non-fast-rtx chunks on
> the retransmit queue, we need make sure any chunks eligable
> for fast retransmit are sent first during fast retransmission.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
> Tested-by: Wei Yongjun <yjwei@cn.fujitsu.com>

Applied.
