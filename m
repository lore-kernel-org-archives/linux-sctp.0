From: David Laight <David.Laight@ACULAB.COM>
Date: Sun, 07 Jun 2020 17:05:02 +0000
Subject: RE: EAGAIN
Message-Id: <cbdc4f6694a5417e9f40083b7778bbdf@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <0D6B7E65-36EC-4132-B02C-0371099E480A@list.fink.org>
In-Reply-To: <0D6B7E65-36EC-4132-B02C-0371099E480A@list.fink.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Michael Tuexen
> Sent: 07 June 2020 16:18
> > On 7. Jun 2020, at 16:04, David Laight <David.Laight@ACULAB.COM> wrote:
> >
> > From: Michael Tuexen
> >> Sent: 07 June 2020 13:48
> > ...
> >> If you killed the peer, I would assume that there is an SCTP message containing an
> >> ABORT chunk in the wire. Is that true? If that is true, you could subscribe to
> >> SCTP_ASSOC_CHANGE notification, which should tell you.
> >
> > Actually for TCP-style 1-1 connections you must subscribe to
> > SCTP_ASSOC_CHANGE.
>
> I guess you are referring to UDP (1-to-many) style sockets.
> For 1-to-1 style sockets, the normal error handling should
> work, like it does for TCP (returning -1 in a system call
> and errno being ETIMEDOUT or ECONNRESET). At least this is
> the way intended by the specification and I think Linux
> does it that way.

Nope, if you take a program that will run over TCP or SCTP
then receipt of an INIT chunk (with matching ports etc)
goes through the connection handshake sequence and the
application isn't given any indication.

You might expect the incoming INIT to cause a disconnect
indication on the old socket and a new 'listen' event.
But that isn't what happens.

We have to enable the ASSPC_CHANGE indication - and disconnect
in response to it!

No idea what the standard implies should happen.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
