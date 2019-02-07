From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 07 Feb 2019 17:33:07 +0000
Subject: RE: [PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length
Message-Id: <1257941619984a2a992af8d801855c04@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190206201430.18830-1-julien@arista.com>
 <20190206203754.GC13621@localhost.localdomain>
 <c13067c0-f127-50a0-9ae0-4be7f0399c0d@arista.com>
 <20190206210723.GD13621@localhost.localdomain>
In-Reply-To: <20190206210723.GD13621@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, Julien Gomes <julien@arista.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>, "vyasevich@gmail.com" <vyasevich@gmail.com>, "lucien.xin@gmail.com" <lucien.xin@gmail.com>

From: Marcelo Ricardo Leitner
> Sent: 06 February 2019 21:07
> 
> On Wed, Feb 06, 2019 at 12:48:38PM -0800, Julien Gomes wrote:
> >
> >
> > On 2/6/19 12:37 PM, Marcelo Ricardo Leitner wrote:
> > > On Wed, Feb 06, 2019 at 12:14:30PM -0800, Julien Gomes wrote:
> > >> Make sctp_setsockopt_events() able to accept sctp_event_subscribe
> > >> structures longer than the current definitions.
> > >>
> > >> This should prevent unjustified setsockopt() failures due to struct
> > >> sctp_event_subscribe extensions (as in 4.11 and 4.12) when using
> > >> binaries that should be compatible, but were built with later kernel
> > >> uapi headers.
> > >
> > > Not sure if we support backwards compatibility like this?
> > >
> > > My issue with this change is that by doing this, application will have
> > > no clue if the new bits were ignored or not and it may think that an
> > > event is enabled while it is not.
> > >
> > > A workaround would be to do a getsockopt and check the size that was
> > > returned. But then, it might as well use the right struct here in the
> > > first place.
> > >
> > > I'm seeing current implementation as an implicitly versioned argument:
> > > it will always accept setsockopt calls with an old struct (v4.11 or
> > > v4.12), but if the user tries to use v3 on a v1-only system, it will
> > > be rejected. Pretty much like using a newer setsockopt on an old
> > > system.
> >
> > With the current implementation, given sources that say are supposed to
> > run on a 4.9 kernel (no use of any newer field added in 4.11 or 4.12),
> > we can't rebuild the exact same sources on a 4.19 kernel and still run
> > them on 4.9 without messing with structures re-definition.
> 
> Maybe what we want(ed) here then is explicit versioning, to have the 3
> definitions available. Then the application is able to use, say struct
> sctp_event_subscribe, and be happy with it, while there is struct
> sctp_event_subscribe_v2 and struct sctp_event_subscribe_v3 there too.
> 
> But it's too late for that now because that would break applications
> already using the new fields in sctp_event_subscribe.

It is probably better to break the recompilation of the few programs
that use the new fields (and have them not work on old kernels)
than to stop recompilations of old programs stop working on old
kernels or have requested new options silently ignored.

There are all sorts of reasons why programs get built on systems that
are newer than the ones they need to run on.
I'm currently planning to get around the glibc 'memcpy()' fubar so I
can retire some very old build systems before their disks die.

Fortunately our sctp code is in the kernel - so has to be compiled
with the correct headers.

> > I understand your point, but this still looks like a sort of uapi
> > breakage to me.
> 
> Not disagreeing. I really just don't know how supported that is.
> Willing to know so I can pay more attention to this on future changes.

Agreed, these structures should never be changed.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
