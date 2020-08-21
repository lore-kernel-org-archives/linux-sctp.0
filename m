From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 21 Aug 2020 21:03:46 +0000
Subject: RE: 64k streams not supported
Message-Id: <8737d07930a34da3b0c91f8268793ce1@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <bedd13a72afd427ca4dbbdfa61985533@AcuMS.aculab.com>
In-Reply-To: <bedd13a72afd427ca4dbbdfa61985533@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Michael Tuexen
> Sent: 21 August 2020 21:10
> > On 21. Aug 2020, at 17:59, David Laight <David.Laight@ACULAB.COM> wrote:
> >
> > Isn't SCTP supposed to support 65536 data streams?
>
> Since the number of streams is exchanged in the INIT and INIT-ACK chunks
> and encoded in a uint16_t, the number is 65535, not 65536.
> So an implementation should be able to use up to 65535 incoming and
> outgoing streams.

Ah, I'd assumed that because the stream number was encoded
in 16 bits you could use stream numbers 0 through 65535.

At least no one needs to write the patch :-)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
