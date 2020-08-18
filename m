From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 18 Aug 2020 22:10:44 +0000
Subject: RE: [PATCH] net: sctp: Fix negotiation of the number of data streams.
Message-Id: <a71c0fced85a4f0f98b954b37c3a76ae@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <46079a126ad542d380add5f9ba6ffa85@AcuMS.aculab.com>
 <20200818214648.GJ3399@localhost.localdomain>
In-Reply-To: <20200818214648.GJ3399@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Cc: "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>, "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>

From: 'Marcelo Ricardo Leitner'
> Sent: 18 August 2020 22:47
> 
> On Tue, Aug 18, 2020 at 02:36:58PM +0000, David Laight wrote:
> > The number of streams offered by the remote system was being ignored.
> > Any data sent on those streams would get discarded by the remote system.
> 
> That's quite brief and not accurate: it was only ignored if 'Xcnt <> stream->Xcnt'.

The number of streams (esp out ones) received from the remote
system in an INIT or INIT_ACK was ignored.
So it would always send data chunks using the number of streams
requested by the local user.
I managed to tweak our M3UA config to get invalid stream numbers
sent on both inwards and outwards connections.

I only noticed because of testing a (slightly horrid) workaround
for no longer being able to use kernel_getsockopt() to retrieve
the number of ostreams.
The number of ostreams was about the only thing we didn't trace :-(
At least my code can now obtain the correct value even for buggy
kernels.

> Other than this and the Fixes tag, LGTM. Passes the tests here. I'll
> ack the v2 then.

I wasn't sure whether DM actually wanted a V2 with the fixes
tag fixed.
I can send one tomorrow.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
