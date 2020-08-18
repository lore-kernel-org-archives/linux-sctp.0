From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 18 Aug 2020 15:38:09 +0000
Subject: Use of genradix in sctp
Message-Id: <2ffb7752d3e8403ebb220e0a5e2cf3cd@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Cc: "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>

A few years ago (for 5.1) the 'arrays' that sctp uses for
info about data streams was changed to use the 'genradix'
functions.

I'm not sure of the reason for the change, but I don't
thing anyone looked at the performance implications.

The code contains lots of SCTP_SI(stream, i) with the
probable expectation that the expansion is basically
stream->foo[i] (a pointer to a big memory array).

However the genradix functions are far more complicated.
Basically it is a list of pointers to pages, each of
which is split into the maximum number of items.
(With the page pointers being in a tree of pages
for large numbers of large items.)

So every SCTP_S[IO]() has inline code to calculate
the byte offset:
	idx / objs_per_page * PAGE_SIZE + idx % objs_per_page * obj_size
(objs_per_page and obj_size are compile time constants)
and then calls a function to do the actual lookup.

This is all rather horrid when the array isn't even sparse.

I also doubt it really helps if anyone is trying to allow
a lot of streams. For 64k streams you might be trying to
allocate ~700 pages in atomic context.

For example look at the object code for sctp_stream_clear()
(__genradix_ptr() is in lib/generic-radix-tree.c).

There is only one other piece of code that uses genradix.
All it needs is a fifo list.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
