From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 26 Aug 2020 09:56:56 +0000
Subject: RE: [PATCH 00/13] lib/generic-radix-tree: genradix bug fix and optimisations.
Message-Id: <7894f0bc41764c0a8cb87f1482df7679@AcuMS.aculab.com>
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

I've just done quick test that shows ~1% improvement on an MTP3+M2PA
'double reflect' test using the 'test' userpart and a test program.
So there is quite a lot of extra protocol stack in the way.

The test is running ~200k very small data chunks/sec (tx and rx)
on a poor little 2.4GHz 8 core atom C2758.

However the 'baseline' kernel just locked up.
(Reports 5.8.0+ so must be late in the merge for rc1).

Annoyingly the Ubuntu 20.04 userspace won't show the kernel messages
(only a graphical login) - so I can see any kernel ooops messages.
I'm going to have to setup a serial console.
That'll need a trip into the office.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
