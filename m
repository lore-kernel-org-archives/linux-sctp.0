From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 26 Aug 2020 08:37:39 +0000
Subject: RE: [PATCH 00/13] lib/generic-radix-tree: genradix bug fix and optimisations.
Message-Id: <3e60559ff056423dbd19bb5e2eecc2e9@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <21289d79b0474811b21ed8478c465159@AcuMS.aculab.com>
 <20200825154127.GB2444@localhost.localdomain>
 <17da427b99b444ce9d310d6542ae197e@AcuMS.aculab.com>
 <20200825163224.GA499490@zaphod.evilpiepirate.org>
 <425b461bdd4c429c905f99d2ab7451f2@AcuMS.aculab.com>
In-Reply-To: <425b461bdd4c429c905f99d2ab7451f2@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Kent Overstreet' <kent.overstreet@gmail.com>
Cc: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, 'Eric Biggers' <ebiggers@kernel.org>, 'Catalin Marinas' <catalin.marinas@arm.com>, 'Andrew Morton' <akpm@linux-foundation.org>, 'Neil Horman' <nhorman@tuxdriver.com>

From: David Laight
> Sent: 26 August 2020 08:36
...
> I'm going to try marking the lookup functions with '__attribute__ ((pure))'.
> That should help the sctp code that does repeated SCTP_SI().
> In reality I want to mark them __attribute__ ((const)) - including the
> inline wrappers, but that isn't allowed if they read memory.

Neither pure nor const makes any difference.
Even to code that like:
	if (SCTP_SO(...)->ext)
		SCTP_SO(...)->ext->foo = 0;

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
