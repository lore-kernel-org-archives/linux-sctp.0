From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 21 May 2020 15:52:05 +0000
Subject: RE: [PATCH net-next] sctp: Pull the user copies out of the individual sockopt functions.
Message-Id: <4887e5a0858f4bd08734a92d1b8433af@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <fd94b5e41a7c4edc8f743c56a04ed2c9@AcuMS.aculab.com>
 <20200521153729.GB74252@localhost.localdomain>
 <20200521153955.GA19160@lst.de>
In-Reply-To: <20200521153955.GA19160@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Christoph Hellwig' <hch@lst.de>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>

From: Christoph Hellwig
> Sent: 21 May 2020 16:40
> On Thu, May 21, 2020 at 12:37:29PM -0300, 'Marcelo Ricardo Leitner' wrote:
> > On Wed, May 20, 2020 at 03:08:13PM +0000, David Laight wrote:
> >
> > I wish we could split this patch into multiple ones. Like, one for
> > each sockopt, but it doesn't seem possible. It's tough to traverse
> > trough 5k lines long patch. :-(
> 
> I have a series locally that started this, I an try to resurrect and
> finish it.

It is almost better just to look at the new file.
Possibly in a 'side by side' diff.

The only real split is getsockopt v setsockopt.
But they are in separated in the patch anyway.

Most of the patch is just mechanical changes to pass
the compiler and sparse.

Still took over a day to write.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
