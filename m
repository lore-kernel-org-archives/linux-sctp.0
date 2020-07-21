From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 21 Jul 2020 08:32:45 +0000
Subject: RE: Misaligned IPv6 addresses is SCTP socket options.
Message-Id: <5bf6c1d336284bf7bf0a3a32d5b64910@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <f380b70f54854d98a9c801c7ae6bc370@AcuMS.aculab.com>
 <20200721025517.GA3399@localhost.localdomain>
In-Reply-To: <20200721025517.GA3399@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>

From: Marcelo Ricardo Leitner
> Sent: 21 July 2020 03:55
> 
> On Mon, Jul 20, 2020 at 03:50:16PM +0000, David Laight wrote:
> > Several of the structures in linux/uapi/linux/sctp.h are
> > marked __attribute__((packed, aligned(4))).
> 
> I don't think we can change that by now. It's bad, yes, but it's
> exposed and, well, for a long time (since 2005).
> 
> >
> > I believe this was done so that the UAPI structure was the
> > same on both 32 and 64bit systems.
> > The 'natural' alignment is that of 'u64' - so would differ
> > between 32 and 64 bit x86 cpus.
> >
> > There are two horrible issues here:
> >
> > 1) I believe the natural alignment of u64 is actually 8
> >    bytes on some 32bit architectures.
> 
> Not sure which?

Try arm for starters.

> >    So the change would have broken binary compatibility
> >    for 32bit applications compiled before the alignment
> >    was added.
> 
> If nobody complained in 15 years, that's probably not a problem. ;-)
> 
> >
> > 2) Inside the kernel the address of the structure member
> >    is 'blindly' passed through as if it were an aligned
> >    pointer.
> >    For instance I'm pretty sure is can get passed to
> >    inet_addr_is_any() (in net/core/utils.).
> >    Here it gets passed to memcmp().
> >    gcc will inline the memcmp() and almost certainly use 64bit
> >    accesses.
> >    These will fault on architectures (like sparc64).
> 
> For 2) here we should fix it by copying the data into a different
> buffer, or something like that.

At least on some architectures.
I did wonder if the buffer could be read to 8n+4 aligned memory,
but there are aligned 64bit items elsewhere.

> That is happening on structs sctp_setpeerprim sctp_prim
> sctp_paddrparams sctp_paddrinfo, right?
> As they all use the pattern of having a sockaddr_storage after a s32.

Not no mention sctp_assoc_stats....
Which is broken for 32bit binaries on x86 and sparc 64bit kernels.
I think there is (there should be) a kernel type on 64bit
systems that is 8 bytes with the alignment it would have
on the corresponding 32bit architecture.
If nothing else using alignof() on a structure containing
a member of that type will give the 4 or 8 required to fix
the code.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
