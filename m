From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 18 Aug 2020 21:28:43 +0000
Subject: RE: [PATCH] net: sctp: Fix negotiation of the number of data streams.
Message-Id: <507feeb112794dcbb206ab630bf6b6be@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <46079a126ad542d380add5f9ba6ffa85@AcuMS.aculab.com>
 <20200818.125808.1491339435094413330.davem@davemloft.net>
In-Reply-To: <20200818.125808.1491339435094413330.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'David Miller' <davem@davemloft.net>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>

From: David Miller
> Sent: 18 August 2020 20:58
> 
> From: David Laight <David.Laight@ACULAB.COM>
> Date: Tue, 18 Aug 2020 14:36:58 +0000
> 
> > Fixes 2075e50caf5ea.
> >
> > Signed-off-by: David Laight <david.laight@aculab.com>
> 
> This is not the correct format for a Fixes tag, also it should not
> be separated by empty lines from other tags such as Signed-off-by
> and Acked-by.
> 
> As someone who reads netdev frequently, these patterns should be
> etched into your brain by now. :-)

Sorry I don't often write patches - I'm only paid to support
our drivers, not fix the Linux kernel :-)
(We don't ship a kernel, our drivers have to work in disto kernels.)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
