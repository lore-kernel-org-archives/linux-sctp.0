From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 08 Feb 2019 09:53:03 +0000
Subject: RE: [PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length
Message-Id: <0415888f34e7494e9879a77599c618e0@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190206201430.18830-1-julien@arista.com>
 <20190206203754.GC13621@localhost.localdomain>
 <c13067c0-f127-50a0-9ae0-4be7f0399c0d@arista.com>
 <20190206210723.GD13621@localhost.localdomain>
 <1257941619984a2a992af8d801855c04@AcuMS.aculab.com>
 <20190207174715.GF13621@localhost.localdomain>
In-Reply-To: <20190207174715.GF13621@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Cc: Julien Gomes <julien@arista.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>, "vyasevich@gmail.com" <vyasevich@gmail.com>, "lucien.xin@gmail.com" <lucien.xin@gmail.com>

From: 'Marcelo Ricardo Leitner'
> Sent: 07 February 2019 17:47
...
> > > Maybe what we want(ed) here then is explicit versioning, to have the 3
> > > definitions available. Then the application is able to use, say struct
> > > sctp_event_subscribe, and be happy with it, while there is struct
> > > sctp_event_subscribe_v2 and struct sctp_event_subscribe_v3 there too.
> > >
> > > But it's too late for that now because that would break applications
> > > already using the new fields in sctp_event_subscribe.
> >
> > It is probably better to break the recompilation of the few programs
> > that use the new fields (and have them not work on old kernels)
> > than to stop recompilations of old programs stop working on old
> > kernels or have requested new options silently ignored.
> 
> I got confused here, not sure what you mean. Seems there is one "stop"
> word too many.

More confusing than I intended...

With the current kernel and headers a 'new program' (one that
needs the new options) will fail to run on an old kernel - which is good.
However a recompilation of an 'old program' (that doesn't use
the new options) will also fail to run on an old kernel - which is bad.

Changing the kernel to ignore extra events flags breaks the 'new'
program.

Versioning the structure now (even though it should have been done
earlier) won't change the behaviour of existing binaries.

However a recompilation of an 'old' program would use the 'old'
structure and work on old kernels.
Attempts to recompile a 'new' program will fail - until the structure
name (or some #define to enable the extra fields) is changed.

Breaking compilations is much better than unexpected run-time
behaviour.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
