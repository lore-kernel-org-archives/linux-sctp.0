From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 22 Jan 2014 00:08:20 +0000
Subject: Re: [PATCH] net: sctp: Fix a_rwnd/rwnd management to reflect real state of the receiver's buffer
Message-Id: <52DF0BF4.8080905@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52D8D544.5050501@nsn.com> <20140121.143620.1777441472756091252.davem@davemloft.net>
In-Reply-To: <20140121.143620.1777441472756091252.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>, matija.glavinic-pecotic.ext@nsn.com
Cc: linux-sctp@vger.kernel.org, alexander.sverdlin@nsn.com, netdev@vger.kernel.org

On 01/21/2014 05:36 PM, David Miller wrote:
> From: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>
> Date: Fri, 17 Jan 2014 08:01:24 +0100
> 
>> Implementation of (a)rwnd calculation might lead to severe performance issues
>> and associations completely stalling. These problems are described and solution
>> is proposed which improves lksctp's robustness in congestion state.
> 
> It would be fantastic if an SCTP expert would review this patch, it's
> been rotting in patchwork for 4 days.
> 

Apologies.  It's been on my to do list.

-vlad

