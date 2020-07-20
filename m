From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 20 Jul 2020 15:50:16 +0000
Subject: Misaligned IPv6 addresses is SCTP socket options.
Message-Id: <f380b70f54854d98a9c801c7ae6bc370@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>

Several of the structures in linux/uapi/linux/sctp.h are
marked __attribute__((packed, aligned(4))).

I believe this was done so that the UAPI structure was the
same on both 32 and 64bit systems.
The 'natural' alignment is that of 'u64' - so would differ
between 32 and 64 bit x86 cpus.

There are two horrible issues here:

1) I believe the natural alignment of u64 is actually 8
   bytes on some 32bit architectures.
   So the change would have broken binary compatibility
   for 32bit applications compiled before the alignment
   was added.

2) Inside the kernel the address of the structure member
   is 'blindly' passed through as if it were an aligned
   pointer.
   For instance I'm pretty sure is can get passed to
   inet_addr_is_any() (in net/core/utils.).
   Here it gets passed to memcmp().
   gcc will inline the memcmp() and almost certainly use 64bit
   accesses.
   These will fault on architectures (like sparc64).

No amount of casting can make gcc 'forget' the alignment
of a structure.
Passing to an external function as 'void *' will - but
even the LTO could track the alignment through.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
