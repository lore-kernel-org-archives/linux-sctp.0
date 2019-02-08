From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 08 Feb 2019 12:36:14 +0000
Subject: Re: [PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length
Message-Id: <20190208123614.GA13299@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190206201430.18830-1-julien@arista.com>
 <20190206203754.GC13621@localhost.localdomain>
 <c13067c0-f127-50a0-9ae0-4be7f0399c0d@arista.com>
 <20190206210723.GD13621@localhost.localdomain>
 <1257941619984a2a992af8d801855c04@AcuMS.aculab.com>
 <20190207174715.GF13621@localhost.localdomain>
 <0415888f34e7494e9879a77599c618e0@AcuMS.aculab.com>
In-Reply-To: <0415888f34e7494e9879a77599c618e0@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>, Julien Gomes <julien@arista.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, "vyasevich@gmail.com" <vyasevich@gmail.com>, "lucien.xin@gmail.com" <lucien.xin@gmail.com>

On Fri, Feb 08, 2019 at 09:53:03AM +0000, David Laight wrote:
> From: 'Marcelo Ricardo Leitner'
> > Sent: 07 February 2019 17:47
> ...
> > > > Maybe what we want(ed) here then is explicit versioning, to have the 3
> > > > definitions available. Then the application is able to use, say struct
> > > > sctp_event_subscribe, and be happy with it, while there is struct
> > > > sctp_event_subscribe_v2 and struct sctp_event_subscribe_v3 there too.
> > > >
> > > > But it's too late for that now because that would break applications
> > > > already using the new fields in sctp_event_subscribe.
> > >
> > > It is probably better to break the recompilation of the few programs
> > > that use the new fields (and have them not work on old kernels)
> > > than to stop recompilations of old programs stop working on old
> > > kernels or have requested new options silently ignored.
> > 
> > I got confused here, not sure what you mean. Seems there is one "stop"
> > word too many.
> 
> More confusing than I intended...
> 
> With the current kernel and headers a 'new program' (one that
> needs the new options) will fail to run on an old kernel - which is good.
> However a recompilation of an 'old program' (that doesn't use
> the new options) will also fail to run on an old kernel - which is bad.
> 
I disagree with this, at least as a unilateral statement.  I would assert that
an old program, within the constraints of the issue being discussed here, will
run perfectly well, when built and run against a new kernel.

At issue is the size of the structure sctp_event_subscribe, and the fact that in
several instances over the last few years, its been extended to be larger and
encompass more events to subscribe to.

Nominally an application will use this structure (roughly) as follows:

...
struct sctp_event_subscribe events;
size_t evsize = sizeof(events);

memset(&events, 0, sizeof(events));

events.sctp_send_failure_event = 1; /*example event subscription*/

if (sctp_setsocktpt(sctp_fd, SOL_SCTP, SCTP_EVENTS, &events, &evsize) < 0) {
	/* do error recovery */
}

....


Assume this code will be built and run against kernel versions A and B, in
which:
A) has a struct sctp_event_subscribe with a size of 9 bytes
B) has a struct sctp_event_subscribe with a size of 10 bytes (due to the added
field sctp_sender_dry_event)

That gives us 4 cases to handle

1) Application build against kernel A and run on kernel A.  This works fine, the
sizes of the struct in question will always match

2) Application is built against kernel A and run on kernel B.  In this case,
everything will work because the application passes a buffer of size 9, and the
kernel accepts it, because it allows for buffers to be shorter than the current
struct sctp_event_subscribe size. The kernel simply operates on the options
available in the buffer.  The application is none the wiser, because it has no
knoweldge of the new option, nor should it because it was built against kernel
A, that never offered that option

3) Application is built against kernel B and run on kernel B.  This works fine
for the same reason as (1).

4) Application is built against kernel B and run on kernel A.  This will break
because the application is passing a buffer that is larger than what the kernel
expects, and rightly so.   The application is passing in a buffer that is
incompatible with what the running kernel expects.

We could look into ways in which to detect the cases in which this might be
'ok', but I don't see why we should bother, because at some point its still an
error to pass in an incompatible buffer.  In my mind this is no different than
trying to run a program that allocates hugepages on a kernel that doesn't
support hugepages (just to make up an example).  Applications built against
newer kernel can't expect all the features/semantics/etc to be identical to
older kernels.

> Changing the kernel to ignore extra events flags breaks the 'new'
> program.
> 
It shouldn't.  Assuming you have a program built against headers from kernel B
(above), if you set a field in the structure that only exists in kernel B, and
try to run it on kernel A, you will get an EINVAL return, which is correct
behavior because you are attempting to deliver information to the kernel that
kernel A (the running kernel) doesn't know about.  Thats correct behavior.

> Versioning the structure now (even though it should have been done
> earlier) won't change the behaviour of existing binaries.
> 
I won't disagree about the niceness of versioning, but that ship has sailed.

> However a recompilation of an 'old' program would use the 'old'
> structure and work on old kernels.
To be clear,  this is situation (1) above, and yeah, running on the kernel you
built your application against should always work from a compatibility
standpoint. 

> Attempts to recompile a 'new' program will fail - until the structure
> name (or some #define to enable the extra fields) is changed.
> 
Yes, but this is alawys the case for structures that change.  If you have an
application built against kernel (B), and uses structure fields that only exist
in that version of the kernel (and not earlier) will fail to compile when built
against kernel (A) headers, and thats expected.  This happens with any kernel
api that exists in a newer kernel but not an older kernel.

> Breaking compilations is much better than unexpected run-time
> behaviour.
> 
Any time you make a system call to the kernel, you have to be prepared to handle
the resulting error condition, thats not unexpected.  To assume that a system
call will always work is bad programming practice.

Neil

> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
> 
