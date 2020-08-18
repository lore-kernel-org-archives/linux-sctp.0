From: David Miller <davem@davemloft.net>
Date: Tue, 18 Aug 2020 19:58:08 +0000
Subject: Re: [PATCH] net: sctp: Fix negotiation of the number of data streams.
Message-Id: <20200818.125808.1491339435094413330.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <46079a126ad542d380add5f9ba6ffa85@AcuMS.aculab.com>
In-Reply-To: <46079a126ad542d380add5f9ba6ffa85@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David.Laight@ACULAB.COM
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com

From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 18 Aug 2020 14:36:58 +0000

> Fixes 2075e50caf5ea.
> 
> Signed-off-by: David Laight <david.laight@aculab.com>

This is not the correct format for a Fixes tag, also it should not
be separated by empty lines from other tags such as Signed-off-by
and Acked-by.

As someone who reads netdev frequently, these patterns should be
etched into your brain by now. :-)
