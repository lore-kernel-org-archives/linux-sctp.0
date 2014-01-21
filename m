From: David Miller <davem@davemloft.net>
Date: Tue, 21 Jan 2014 22:36:20 +0000
Subject: Re: [PATCH] net: sctp: Fix a_rwnd/rwnd management to reflect real state of the receiver's buffer
Message-Id: <20140121.143620.1777441472756091252.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <52D8D544.5050501@nsn.com>
In-Reply-To: <52D8D544.5050501@nsn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: matija.glavinic-pecotic.ext@nsn.com
Cc: linux-sctp@vger.kernel.org, alexander.sverdlin@nsn.com, netdev@vger.kernel.org

From: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>
Date: Fri, 17 Jan 2014 08:01:24 +0100

> Implementation of (a)rwnd calculation might lead to severe performance issues
> and associations completely stalling. These problems are described and solution
> is proposed which improves lksctp's robustness in congestion state.

It would be fantastic if an SCTP expert would review this patch, it's
been rotting in patchwork for 4 days.

Thanks.
