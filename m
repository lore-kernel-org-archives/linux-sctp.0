From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 21 Aug 2020 21:18:42 +0000
Subject: RE: Use of genradix in sctp
Message-Id: <9f5b892bcf4f41f9b32990fb6049fce2@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <2ffb7752d3e8403ebb220e0a5e2cf3cd@AcuMS.aculab.com>
 <20200818213800.GJ906397@localhost.localdomain>
 <357ded60999a4957addb766a29431ad7@AcuMS.aculab.com>
 <20200821204636.GO3399@localhost.localdomain>
In-Reply-To: <20200821204636.GO3399@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Cc: "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>, "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>

From: 'Marcelo Ricardo Leitner'
> Sent: 21 August 2020 21:47
...
> >
> > 2) Optimise the genradix lookup for the case where there
> >    is a single page - it can be completely inlined.
> 
> And/or our struct sizes.
> 
> __idx_to_offset() will basically do:
>         if (!is_power_of_2(obj_size)) {
>                 return (idx / objs_per_page) * PAGE_SIZE +
>                         (idx % objs_per_page) * obj_size;
>         } else {
>                 return idx * obj_size;
> 
> if we can get it to his the else block, it saves some CPU cycles already (at
> the expense of memory).

I'm penning some changes to the genradix code:
That expression can be written:
	idx * obj_size + (idx / objs_per_page) * (PAGE_SIZE % obj_size)
which is simpler and doesn't need the is_power_of_2() test.

You can then do the early test:
	if (idx * obj_size <= PAGE_SIZE - obj_size) && root && !llevel)
		return root + idx * obj_size;
in the inline function.
A slight increase in code size, but a reduction in code path.
(Better still if you increment 'level'.)
Which catches most SCTP uses and the only other place I've found it used.

There is actually a nasty bug in the genradix code.
If the cmpxchg 'fails' when adding extra root levels then the page
can get reused later - but child[0] has been set.
This could add a loop to the tree!

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
