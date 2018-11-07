From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 07 Nov 2018 14:37:07 +0000
Subject: RE: Broken sack processing
Message-Id: <9eb8cf179dc24831a2ad58870e82d0d7@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <5dcd9eb4ccf44ce293a73fb9ec4457cf@AcuMS.aculab.com>
In-Reply-To: <5dcd9eb4ccf44ce293a73fb9ec4457cf@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Marcelo Ricardo Leitner
> Sent: 07 November 2018 12:53
> On Wed, Nov 07, 2018 at 10:01:48AM +0000, David Laight wrote:
> > I've a customer trace from a very old system (RHEL 5.7) that shows the
> 
> Ouch. That's really old. (and unsupported)

Indeed, but I doubt 5.11 (on extended support until 2021) or 6.x would much better!
Even RHEL 7 is based on an old kernel.
I wonder if they are paying RH for support?

> > kernel failing to respond to some SACK packets like:
> >
> > SACK chunk (Cumulative TSN: 3327915808, a_rwnd: 224400, gaps: 12, duplicate TSNs: 0)
> > Chunk type: SACK (3)
> > Chunk flags: 0x00
> > Chunk length: 64
> > Cumulative TSN ACK: 3327915808
> > Advertised receiver window credit (a_rwnd): 224400
> > Number of gap acknowledgement blocks: 12
> > Number of duplicated TSNs: 0
> > Gap Acknowledgement for TSN 3327915813 to 3327915814
> > Gap Acknowledgement for TSN 3327915818 to 3327915818
> > Gap Acknowledgement for TSN 3327915822 to 3327915838
> > Gap Acknowledgement for TSN 3327915842 to 3327915852
> > Gap Acknowledgement for TSN 3327915856 to 3327915858
> > Gap Acknowledgement for TSN 3327915860 to 3327915864
> > Gap Acknowledgement for TSN 3327915866 to 3327915866
> > Gap Acknowledgement for TSN 3327915868 to 3327915869
> > Gap Acknowledgement for TSN 3327915873 to 3327915877
> > Gap Acknowledgement for TSN 3327915881 to 3327915892
> > Gap Acknowledgement for TSN 3327915894 to 3327916102
> > Gap Acknowledgement for TSN 3327916104 to 3327916172
> > [Number of TSNs in gap acknowledgement blocks: 337]
> >
> > Does this ring a bell, any idea how long ago it was fixed?
> 
> I don't follow. What is broken in this SACK? And what does it mean
> "kenrel fails to repond some SACK", like, is it not retransmitting?

There are no outbound data chunks at all.
There are a lot on inbound ones all of which are acked.
The above SACK is repeated every few ms (maybe after every inbound data chunk).

Fortunately most of the several million packets queued for transmit
are in userspace!

And yes, it is pretty reproducible in the one system.
Most of the 16 SCTP connections are hosed.

> > Not sure why the connection isn't dropped because of the unacked packets?
> 
> Whenever a new delivery is confirmed, the error count is zeroed. But,
> once it enters RTO, it won't do new deliveries.
> After a SACK like this I would expect some fast rtx, then RTO and then
> a possible abort.
> But if TSN 3327915809 (next after cumack) gets delivered, it will zero
> the error count (again).

I had a look through the changes 'git log net/sctp' unfortunately it
misses everything that happens during the merge window.
Nothing leaps out, but there a lot of comments about the error count
being zeroed - which you never want to do unless progress is made.

There are also all the problems that you can't disconnect connections
with unacked data - they appear in traces for other connections.
I've a workaround for that (disconnect with ABORT) but they don't
have that version of our software either.

> Is this connection triggering zero windows, by any chance? Doesn't
> seem so, as per
>   Advertised receiver window credit (a_rwnd): 224400

I think sends are being limited by a local packet/byte count.
Although the M3UA loadsharing (in our driver) will stop txing on
both connections when one gets blocked like this, so the data chunks
for the M3UA 'inactivate' do get sent.

No idea what triggers the problem.
My guess is something to do with lost packets.

There is the commit a3007446e53af07c53bdb4cabad7b3ea60859da4
    sctp: fix the handling of SACK Gap Ack blocks
which went into 4.8 (dunno if it got back ported).
But that wasn't thought to have a real effect.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
