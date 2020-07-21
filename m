From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 21 Jul 2020 02:55:17 +0000
Subject: Re: Misaligned IPv6 addresses is SCTP socket options.
Message-Id: <20200721025517.GA3399@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <f380b70f54854d98a9c801c7ae6bc370@AcuMS.aculab.com>
In-Reply-To: <f380b70f54854d98a9c801c7ae6bc370@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>

On Mon, Jul 20, 2020 at 03:50:16PM +0000, David Laight wrote:
> Several of the structures in linux/uapi/linux/sctp.h are
> marked __attribute__((packed, aligned(4))).

I don't think we can change that by now. It's bad, yes, but it's
exposed and, well, for a long time (since 2005).

> 
> I believe this was done so that the UAPI structure was the
> same on both 32 and 64bit systems.
> The 'natural' alignment is that of 'u64' - so would differ
> between 32 and 64 bit x86 cpus.
> 
> There are two horrible issues here:
> 
> 1) I believe the natural alignment of u64 is actually 8
>    bytes on some 32bit architectures.

Not sure which?

>    So the change would have broken binary compatibility
>    for 32bit applications compiled before the alignment
>    was added.

If nobody complained in 15 years, that's probably not a problem. ;-)

> 
> 2) Inside the kernel the address of the structure member
>    is 'blindly' passed through as if it were an aligned
>    pointer.
>    For instance I'm pretty sure is can get passed to
>    inet_addr_is_any() (in net/core/utils.).
>    Here it gets passed to memcmp().
>    gcc will inline the memcmp() and almost certainly use 64bit
>    accesses.
>    These will fault on architectures (like sparc64).

For 2) here we should fix it by copying the data into a different
buffer, or something like that.
That is happening on structs sctp_setpeerprim sctp_prim
sctp_paddrparams sctp_paddrinfo, right?
As they all use the pattern of having a sockaddr_storage after a s32.

> 
> No amount of casting can make gcc 'forget' the alignment
> of a structure.
> Passing to an external function as 'void *' will - but
> even the LTO could track the alignment through.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
