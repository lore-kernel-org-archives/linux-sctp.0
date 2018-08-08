From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 08 Aug 2018 14:48:52 +0000
Subject: Re: [PATCH v2 0/2] net/sctp: Avoid allocating high order memory with kmalloc()
Message-Id: <20180808144852.GA5311@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180724173647.GA8881@localhost.localdomain>
 <20180803162102.19540-1-khorenko@virtuozzo.com>
 <cd32848f0018432fad7246620d32c4e5@AcuMS.aculab.com>
 <20180803203009.GG5482@localhost.localdomain>
 <2D7531CF-9E0A-4B33-83E5-724B7C88F363@lurchi.franken.de>
 <561fae7f72d34f0b983bfbad5d766bdf@AcuMS.aculab.com>
In-Reply-To: <561fae7f72d34f0b983bfbad5d766bdf@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: 'Michael Tuexen' <Michael.Tuexen@lurchi.franken.de>, Konstantin Khorenko <khorenko@virtuozzo.com>, "oleg.babin@gmail.com" <oleg.babin@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

On Mon, Aug 06, 2018 at 09:34:05AM +0000, David Laight wrote:
> From: Michael Tuexen
> > Sent: 03 August 2018 21:57
> ...
> > >> Given how useless SCTP streams are, does anything actually use
> > >> more than about 4?
> > >
> > > Maybe Michael can help us with that. I'm also curious now.
> > In the context of SIGTRAN I have seen 17 streams...
> 
> Ok, I've seen 17 there as well, 5 is probably more common.
> 
> > In the context of WebRTC I have seen more streams. In general,
> > the streams concept seems to be useful. QUIC has lots of streams.

That means the migration to flex_array should not have a noticeable
impact, as for a small number of streams it will behave just as the
same as it does now. (yes, considering the app won't use high-order
stream id's just because)

...

> 
> Thought....
> Could we let the application set large stream-ids, but actually mask them
> down to (say) 32 for the protocol code?

This would require both peers to know about the mapping, as stream ids
must be same on both sides. Seems to be it is better to just adjust
the application and make use of low numbers.

  Marcelo
