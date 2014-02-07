From: David Miller <davem@davemloft.net>
Date: Fri, 07 Feb 2014 04:40:01 +0000
Subject: Re: [PATCH] net: sctp: fix initialization of local source address on accepted ipv6 sockets
Message-Id: <20140206.204001.1307764044699514075.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <52F33A02.2040902@nsn.com>
In-Reply-To: <52F33A02.2040902@nsn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: matija.glavinic-pecotic.ext@nsn.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>
Date: Thu, 06 Feb 2014 08:30:10 +0100

> commit 	efe4208f47f907b86f528788da711e8ab9dea44d:
> 'ipv6: make lookups simpler and faster' broke initialization of local source
> address on accepted ipv6 sockets. Before the mentioned commit receive address
> was copied along with the contents of ipv6_pinfo in sctp_v6_create_accept_sk.
> Now when it is moved, it has to be copied separately.
> 
> This also fixes lksctp's ipv6 regression in a sense that test_getname_v6, TC5 -
> 'getsockname on a connected server socket' now passes.
> 
> Signed-off-by: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>

Applied.
