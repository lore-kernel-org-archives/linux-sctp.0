From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 25 Aug 2020 16:00:35 +0000
Subject: RE: [PATCH 00/13] lib/generic-radix-tree: genradix bug fix and optimisations.
Message-Id: <17da427b99b444ce9d310d6542ae197e@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <21289d79b0474811b21ed8478c465159@AcuMS.aculab.com>
 <20200825154127.GB2444@localhost.localdomain>
In-Reply-To: <20200825154127.GB2444@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 'Catalin Marinas' <catalin.marinas@arm.com>, "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 'Neil Horman' <nhorman@tuxdriver.com>

From: 'Marcelo Ricardo Leitner'
> Sent: 25 August 2020 16:41
> 
> On Tue, Aug 25, 2020 at 02:52:34PM +0000, David Laight wrote:
> > The genradix code is used by SCTP for accessing per-stream data.
> > This means there are quite a lot of lookups but the code wasn't
> > really optimised at all.
> 
> My test box is down for the moment and will bring it on later today or
> tomorrow, so I can't test it yet. What should we expect as performance
> gains here?

Not sure, probably not much, but it ought to show up :-)
There'll be bigger gains on a cpu that has software ilog2().

I've only checked SCTP still works.
I've requested 32k streams on a listener - to force a level-2 tree.
I've also done at least one check with a massive pad in the sctp
stream structure.

I ought to check one of my M3UA or M2PA 'double-reflect' loopback tests.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
