From: David Miller <davem@davemloft.net>
Date: Mon, 17 Feb 2014 05:17:19 +0000
Subject: Re: [PATCH v3] net: sctp: Fix a_rwnd/rwnd management to reflect real state of the receiver's buffer
Message-Id: <20140217.001719.972154075645167962.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <52FE1F56.2020007@nsn.com>
In-Reply-To: <52FE1F56.2020007@nsn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: matija.glavinic-pecotic.ext@nsn.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, alexander.sverdlin@nsn.com

From: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>
Date: Fri, 14 Feb 2014 14:51:18 +0100

> Implementation of (a)rwnd calculation might lead to severe performance issues
> and associations completely stalling. These problems are described and solution
> is proposed which improves lksctp's robustness in congestion state.
 ...
> Signed-off-by: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>
> Reviewed-by: Alexander Sverdlin <alexander.sverdlin@nsn.com>

Applied, thanks.
