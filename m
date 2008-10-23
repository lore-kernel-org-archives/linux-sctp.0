From: David Miller <davem@davemloft.net>
Date: Thu, 23 Oct 2008 08:01:26 +0000
Subject: Re: [PATCH 4/4] sctp: Fix to handle SHUTDOWN in SHUTDOWN_RECEIVED
Message-Id: <20081023.010126.69738776.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1224641327-11913-1-git-send-email-vladislav.yasevich@hp.com>
	<1224641327-11913-5-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1224641327-11913-5-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, yjwei@cn.fujitsu.com

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 21 Oct 2008 22:08:47 -0400

> Once an endpoint has reached the SHUTDOWN-RECEIVED state,
> it MUST NOT send a SHUTDOWN in response to a ULP request.
> The Cumulative TSN Ack of the received SHUTDOWN chunk
> MUST be processed.
> 
> This patch fix to process Cumulative TSN Ack of the received
> SHUTDOWN chunk in SHUTDOWN_RECEIVED state.
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied.
