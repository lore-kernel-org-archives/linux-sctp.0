From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 22 May 2020 08:02:09 +0000
Subject: RE: do a single memdup_user in sctp_setsockopt
Message-Id: <348217b7a3e14c1fa4868e47362be9c5@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200521174724.2635475-1-hch@lst.de>
In-Reply-To: <20200521174724.2635475-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Christoph Hellwig' <hch@lst.de>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

From: Christoph Hellwig
> Sent: 21 May 2020 18:47
> based on the review of Davids patch to do something similar I dusted off
> the series I had started a few days ago to move the memdup_user or
> copy_from_user from the inidividual sockopts into sctp_setsockopt,
> which is done with one patch per option, so it might suit Marcelo's
> taste a bit better.  I did not start any work on getsockopt.

I'm not sure that 49 patches is actually any easier to review.
Most of the patches are just repetitions of the same change.
If they were in different files it might be different.

If you try to do getsockopt() the same way it will be much
more complicated - you have to know whether the called function
did the copy_to_user() and then suppress it.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
