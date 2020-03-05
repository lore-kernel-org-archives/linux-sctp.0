From: Jere Leppanen <jere.leppanen@nokia.com>
Date: Thu, 05 Mar 2020 17:31:23 +0000
Subject: RE: [PATCH net] sctp: return a one-to-one type socket when doing peeloff
Message-Id: <alpine.LFD.2.21.2003051736080.24727@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <b3091c0764023bbbb17a26a71e124d0f81349f20.1583132235.git.lucien.xin@gmail.com> <HE1PR0702MB3610BB291019DD7F51DBC906ECE40@HE1PR0702MB3610.eurprd07.prod.outlook.com> <CADvbK_ewk7mGNr6T4smWeQ0TcW3q4yabKZwGX3dK=XcH7gv=KQ@mail.gmail.com>
 <alpine.LFD.2.21.2003041349400.19073@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net> <8831b4dc929148f28cca658a4d7a11d9@AcuMS.aculab.com>
In-Reply-To: <8831b4dc929148f28cca658a4d7a11d9@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, "michael.tuexen@lurchi.franken.de" <michael.tuexen@lurchi.franken.de>

On Thu, 5 Mar 2020, David Laight wrote:

> From: Jere Leppanen
> > Sent: 04 March 2020 17:13
> > On Wed, 4 Mar 2020, Xin Long wrote:
> > 
> > > On Wed, Mar 4, 2020 at 2:38 AM Leppanen, Jere (Nokia - FI/Espoo)
> > > <jere.leppanen@nokia.com> wrote:
> > >>
> > >> On Mon, 2 Mar 2020, Xin Long wrote:
> > >>
> > >>> As it says in rfc6458#section-9.2:
> > >>>
> > >>>   The application uses the sctp_peeloff() call to branch off an
> > >>>   association into a separate socket.  (Note that the semantics are
> > >>>   somewhat changed from the traditional one-to-one style accept()
> > >>>   call.)  Note also that the new socket is a one-to-one style socket.
> > >>>   Thus, it will be confined to operations allowed for a one-to-one
> > >>>   style socket.
> > >>>
> > >>> Prior to this patch, sctp_peeloff() returned a one-to-many type socket,
> > >>> on which some operations are not allowed, like shutdown, as Jere
> > >>> reported.
> > >>>
> > >>> This patch is to change it to return a one-to-one type socket instead.
> > >>
> > >> Thanks for looking into this. I like the patch, and it fixes my simple
> > >> test case.
> > >>
> > >> But with this patch, peeled-off sockets are created by copying from a
> > >> one-to-many socket to a one-to-one socket. Are you sure that that's
> > >> not going to cause any problems? Is it possible that there was a
> > >> reason why peeloff wasn't implemented this way in the first place?
> > > I'm not sure, it's been there since very beginning, and I couldn't find
> > > any changelog about it.
> > >
> > > I guess it was trying to differentiate peeled-off socket from TCP style
> > > sockets.
> > 
> > Well, that's probably the reason for UDP_HIGH_BANDWIDTH style. And maybe
> > there is legitimate need for that differentiation in some cases, but I
> > think inventing a special socket style is not the best way to handle it.
> > 
> > But actually I meant why is a peeled-off socket created as SOCK_SEQPACKET
> > instead of SOCK_STREAM. It could be to avoid copying from SOCK_SEQPACKET
> > to SOCK_STREAM, but why would we need to avoid that?
> 
> Because you don't want all the acks and retransmissions??

I don't follow. The socket type and style have virtually no effect on the 
protocol side of things, I think.

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
> 
