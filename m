From: David Miller <davem@davemloft.net>
Date: Wed, 04 Jun 2008 19:39:17 +0000
Subject: Re: [PATCH 4/6] SCTP: Start T3-RTX timer when fast retransmitting
Message-Id: <20080604.123917.172467649.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1212603951-24932-1-git-send-email-vladislav.yasevich@hp.com>
	<1212603951-24932-5-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1212603951-24932-5-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed,  4 Jun 2008 14:25:49 -0400

> When we are trying to fast retransmit the lowest outstanding TSN, we
> need to restart the T3-RTX timer, so that subsequent timeouts will
> correctly tag all the packets necessary for retransmissions.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
> Tested-by: Wei Yongjun <yjwei@cn.fujitsu.com>

Applied.
