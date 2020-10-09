From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 09 Oct 2020 11:13:31 +0000
Subject: RE: sctp discarding received data chunks
Message-Id: <73434b87932e46a89dd1b5b5132b3196@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <e377e7e2a87e4f078e7a6d82992cfda0@AcuMS.aculab.com>
In-Reply-To: <e377e7e2a87e4f078e7a6d82992cfda0@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Andreas Fink
> Sent: 09 October 2020 08:25
> 
> Can you see this issue with the 5.4 kernel too?
> 
> I did yesterday some testing by upgrading kernel from 5.4 to 5.7 and I run into all sorts of links
> going off after a while so I had to revert back.
> 5.4 is stable for me. 5.7 is not. And I have lots of M2PA and M3UA connections like you

I've just spent hours digging through my traces.
It is only some messages through the connection that get lost!

Now SCTP_MIN_IN_DATA_CHUNK_DISCARDS is only incremented in two
adjacent places in sm_statefuncs.c.

Either for bad TSN (unlikely when everything is using "lo")
and bad STREAM.
I suspect it is the 'bad stream' case.
I've not double-checked but I bet the discarded packets
all have a large stream number.

So it is likely that the addition of 'sctp streams' broke
the negotiation of the maximum stream number, and the reporting
of that value back to the application in getsockopt().

I've probably recently changed my test to request 17 streams
(not 5). Since the default number of streams is 10 that may
be why it worked on this kernel before.

There was a similar bug that got fixed very recently.
Ah yes, I wrote this on 14th August:

    At some point the negotiation of the number of SCTP streams
    seems to have got broken.
    I've definitely tested it in the past (probably 10 years ago!)
    but on a 5.8.0 kernel getsockopt(SCTP_INFO) seems to be
    returning the 'num_ostreams' set by setsockopt(SCTP_INIT)
    rather than the smaller of that value and that configured
    at the other end of the connection.

Although I though that stopped packets being set, not received.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
