From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 06 Aug 2018 09:34:05 +0000
Subject: RE: [PATCH v2 0/2] net/sctp: Avoid allocating high order memory with kmalloc()
Message-Id: <561fae7f72d34f0b983bfbad5d766bdf@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180724173647.GA8881@localhost.localdomain>
 <20180803162102.19540-1-khorenko@virtuozzo.com>
 <cd32848f0018432fad7246620d32c4e5@AcuMS.aculab.com>
 <20180803203009.GG5482@localhost.localdomain>
 <2D7531CF-9E0A-4B33-83E5-724B7C88F363@lurchi.franken.de>
In-Reply-To: <2D7531CF-9E0A-4B33-83E5-724B7C88F363@lurchi.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Michael Tuexen' <Michael.Tuexen@lurchi.franken.de>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Konstantin Khorenko <khorenko@virtuozzo.com>, "oleg.babin@gmail.com" <oleg.babin@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

From: Michael Tuexen
> Sent: 03 August 2018 21:57
...
> >> Given how useless SCTP streams are, does anything actually use
> >> more than about 4?
> >
> > Maybe Michael can help us with that. I'm also curious now.
> In the context of SIGTRAN I have seen 17 streams...

Ok, I've seen 17 there as well, 5 is probably more common.

> In the context of WebRTC I have seen more streams. In general,
> the streams concept seems to be useful. QUIC has lots of streams.
> 
> So I'm wondering why they are considered useless.
> David, can you elaborate on this?

I don't think a lot of people know what they actually are.

Streams just allow some receive data to forwarded to applications when receive
message(s) on stream(s) are lost and have to be retransmitted.

I suspect some people think that the separate streams have separate flow control,
not just separate data sequences.

M2PA separates control message (stream 0) from user data (stream 1).
I think the spec even suggests this is so control messages get through when
user data is flow controlled off - not true (it would be true for ISO
transport's 'expedited data).

M3UA will use 16 streams (one for each (ITU) SLS), but uses stream 0 for control.
If a data message is lost then data for the other sls can be passed to the
userpart/mtp3 - this might save bursty processing when the SACK-requested
retransmission arrives. But I doubt you'd want to run M3UA on anything lossy
enough for more than 4 data streams to make sense.

Even M3UA separating control onto stream 0 data onto 1-n doesn't seem useful to me.

If QUIC is using 'lots of streams' is it just using the stream-id as a qualifier
for the data? Rather than requiring the 'not head of line blocking' feature
of sctp streams?

Thought....
Could we let the application set large stream-ids, but actually mask them
down to (say) 32 for the protocol code?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

