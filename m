From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Fri, 21 Aug 2020 20:10:20 +0000
Subject: Re: 64k streams not supported
Message-Id: <B2A8B53A-9704-4C42-84C7-05CD9615FC28@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <bedd13a72afd427ca4dbbdfa61985533@AcuMS.aculab.com>
In-Reply-To: <bedd13a72afd427ca4dbbdfa61985533@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

> On 21. Aug 2020, at 17:59, David Laight <David.Laight@ACULAB.COM> wrote:
> 
> Isn't SCTP supposed to support 65536 data streams?
Since the number of streams is exchanged in the INIT and INIT-ACK chunks
and encoded in a uint16_t, the number is 65535, not 65536.
So an implementation should be able to use up to 65535 incoming and
outgoing streams.

Best regards
Michael
> If I try to enable that many I get 10.
> Not surprising since the number of streams gets stored in a u16.
> 
> The whole code base may need changing to save the highest
> valid stream?
> 
> Since I don't actually need that many I'm not writing the patch.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
