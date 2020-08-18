From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 18 Aug 2020 08:08:24 +0000
Subject: RE: sctp: num_ostreams and max_instreams negotiation
Message-Id: <e438e08865a04eac92dde5ba8ce1dbf2@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <9a1bfa6085854387bf98b6171c879b37@AcuMS.aculab.com>
 <868bd24b536345e6a5596f856a0ebe90@AcuMS.aculab.com>
 <0c1621e5da2e41e8905762d0208f9d40@AcuMS.aculab.com>
 <20200817142223.GH3399@localhost.localdomain>
 <20200817143554.GI3399@localhost.localdomain>
In-Reply-To: <20200817143554.GI3399@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Cc: "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, 'Neil Horman' <nhorman@tuxdriver.com>, "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>, 'Andrew Morton' <akpm@linux-foundation.org>, "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>

From: Marcelo Ricardo Leitner
> Sent: 17 August 2020 15:36
..
> > The proper fix here is to move back to the original if() condition,
> > and put genradix_prealloc() inside it again, as was fa_zero() before.
> > The if() is not strictly needed, because genradix_prealloc() will
> > handle it nicely, but it's a nice-to-have optimization anyway.
> >
> > Do you want to send a patch?

I can, but my systems aren't really setup for doing it.
Especially while working from home.

Just deleting the conditionals works for normal connections.
I don't know what happens if the number of streams is negotiated
up and down (and up again?) while the connection is active.

> Note the thread 'Subject: RE: v5.3.12 SCTP Stream Negotiation Problem'
> though.

The patch you suggested contained a typo:

-	if (incnt <= stream->incnt)
-		return 0;
+	if (incnt > stream->incnt)
+		goto out;

So the 'in' array was never allocated.

The code will still allocate a 'big' array which I think used
to get shrunk when the value from the peer was processed.
I suspect the array need not get allocated until after
that is done (ISTR in process_init).

I also suspect that the genradix lookup is more expensive
than the sctp code expects.
I wonder if a straight forward kvmalloc() wouldn't be better.
You'd actually need kvrealloc().

All the sctp connections we use have a max of 17 streams.
But if someone allocates 64k and then uses them sparsely
it still allocates about 700 pages for the genradix arrays.

Also, since the 'gfp' flags are being passed in, I suspect
the allocate happens in atomic context somewhere.
I bet allocating 700 pages is very likely to fail!
Lazy allocation would only require single pages be allocated,
but would need extra error paths.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
