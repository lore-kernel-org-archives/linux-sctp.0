From: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Date: Tue, 18 Aug 2020 21:38:00 +0000
Subject: Re: Use of genradix in sctp
Message-Id: <20200818213800.GJ906397@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <2ffb7752d3e8403ebb220e0a5e2cf3cd@AcuMS.aculab.com>
In-Reply-To: <2ffb7752d3e8403ebb220e0a5e2cf3cd@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>

On Tue, Aug 18, 2020 at 03:38:09PM +0000, David Laight wrote:
> A few years ago (for 5.1) the 'arrays' that sctp uses for
> info about data streams was changed to use the 'genradix'
> functions.
> 
> I'm not sure of the reason for the change, but I don't
> thing anyone looked at the performance implications.

I don't have something like a CI for it, but I do run some performance
benchmarks every now and then and it didn't trigger anything
noticeable in my tests.

Yet, can it be improved? Certainly. Patches welcomed. :-)

> 
> The code contains lots of SCTP_SI(stream, i) with the
> probable expectation that the expansion is basically
> stream->foo[i] (a pointer to a big memory array).
> 
> However the genradix functions are far more complicated.
> Basically it is a list of pointers to pages, each of
> which is split into the maximum number of items.
> (With the page pointers being in a tree of pages
> for large numbers of large items.)
> 
> So every SCTP_S[IO]() has inline code to calculate
> the byte offset:
> 	idx / objs_per_page * PAGE_SIZE + idx % objs_per_page * obj_size
> (objs_per_page and obj_size are compile time constants)
> and then calls a function to do the actual lookup.
> 
> This is all rather horrid when the array isn't even sparse.
> 
> I also doubt it really helps if anyone is trying to allow
> a lot of streams. For 64k streams you might be trying to
> allocate ~700 pages in atomic context.

Yes, and kvrealloc as you suggested on another email is not a
solution, because it can't fallback to vmalloc in atomic contexts.

Genradix here allows it to use several non-contiguous pages, which is
a win if compared to a simple kmalloc(..., GFP_ATOMIC) it had before
flex_arrays, and anything that we could implement around such scheme
would be just re-implementing genradix/flex_arrays again. After all,
it does need 64k elements allocated.

How soon it needs them? Well, it already deferred some allocation with
the usage of sctp_stream_out_ext (which is only allocated when the
stream is actually used, but added another pointer deref), leaving
just stuff couldn't be (easily) initialized later, there.

> 
> For example look at the object code for sctp_stream_clear()
> (__genradix_ptr() is in lib/generic-radix-tree.c).

sctp_stream_clear() is rarely called.

Caller graph:
sctp_stream_clear
  sctp_assoc_update
    SCTP_CMD_UPDATE_ASSOC
      sctp_sf_do_dupcook_b
      sctp_sf_do_dupcook_a

So, well, I'm not worried about it.

> 
> There is only one other piece of code that uses genradix.
> All it needs is a fifo list.

Specs say 64k streams, so we should support that and preferrably
without major regressions. Traversing 64k elements each time to find
an entry is very not performant.

For a more standard use case, with something like you were saying, 17
streams, genradix here doesn't use too much memory. I'm afraid a
couple of integer calculations to get an offset is minimal overhead if
compared to the rest of the code. For example, the stream scheduler
operations, accessed via struct sctp_sched_ops (due to retpoline), is
probably more interesting fixing than genradix effects here.

  Marcelo
