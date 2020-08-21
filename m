From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 21 Aug 2020 21:39:23 +0000
Subject: RE: Use of genradix in sctp
Message-Id: <11eafe393bc640a8bbddf33d0e784901@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <2ffb7752d3e8403ebb220e0a5e2cf3cd@AcuMS.aculab.com>
 <20200818213800.GJ906397@localhost.localdomain>
 <357ded60999a4957addb766a29431ad7@AcuMS.aculab.com>
 <20200821204636.GO3399@localhost.localdomain>
In-Reply-To: <20200821204636.GO3399@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Cc: "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>

From: 'Marcelo Ricardo Leitner'
> Sent: 21 August 2020 21:47
...
> > 3) Defer the allocation until the stream is used.
> >    for outbound streams this could remove the extra buffer.
> 
> This can be tricky. What should happen if it gets a packet on a stream
> that it couldn't allocate, and then another on a stream that was
> already allocated? Just a drop, it will retransmit and recover, and
> then again.. While, OTOH, if the application requested such amount of
> streams, it is likely going to use it. If not, that's an application
> bug.

You'd probably need to (effectively) drop the ethernet frame
that contained the chunk.

But the problem I see is that GFP flags are passed in.
So there must me a path where the allocation can't sleep.
Now allocating a couple of pages is fine but if the
maximum is just over 300 for each of 'in' and 'out'.
I can well imagine that is likely to fail.
I suspect this happens because the remote system can
(if my quick scan of the code is right) negotiate a
much larger number on an active connection.

I don't know what applications might be doing such things.
But I can imagine someone will try to negotiate 64k-1
streams just because that is the maximum.
And/or deciding to use stream 65535 for 'special' traffic.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
