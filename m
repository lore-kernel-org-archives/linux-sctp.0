From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 18 Jun 2014 13:16:32 +0000
Subject: RE: [PATCH net-next 0/6] A step closer to RFC 6458 compliancy
Message-Id: <063D6719AE5E284EB5DD2968C1650D6D1725E8B7@AcuExch.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1403017296-28469-1-git-send-email-geirola@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D1725DEC9@AcuExch.aculab.com>
 <53A08C10.70103@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D1725E555@AcuExch.aculab.com>
 <84A786A6-D242-4DC6-8FC4-573A91A88311@lurchi.franken.de>
In-Reply-To: <84A786A6-D242-4DC6-8FC4-573A91A88311@lurchi.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Michael Tuexen' <Michael.Tuexen@lurchi.franken.de>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Geir Ola Vaagland <geirola@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>

From: Michael Tuexen [ 
> On 18 Jun 2014, at 10:42, David Laight <David.Laight@ACULAB.COM> wrote:
> 
> > From: Vlad Yasevich
> >> On 06/17/2014 11:36 AM, David Laight wrote:
> >>> From: Of Geir Ola Vaagland
> >>>> These patches are part of my master thesis project. I have been searching for discrepancies
> between
> >>>> the socket API specificiation in RFC 6458 and the current Linux SCTP implementation. The
> following
> >>>> patches are my humble attempts at getting somewhat closer to compliancy.
> >>>
> >>> I've just been reading RFC 6458 - HTF did it get past the editors and
> >>> then published in its current form?
> >>> Lots of the structures have implied padding.
> > ...
> >> I've argued the padding issue, but the editor stance is that it's implementation
> >> dependent.
> >
> > It wouldn't be as bad if the RFC said that the structure contained the
> > fields that followed (as is typical of the posix definitions),
> > but instead it gives a definition of the structure.

> That would have been a possibility, but it was never suggested.
> As far as I know, C does not guarantee the memory layout for structs,
> except for the sequence of the components. So a compiler might add
> some padding at any place. When implementing this, you need to take
> care of this (and your job might be simpler, since you might only
> work with a specific set of compilers).
> In FreeBSD we also added some padding to some structures since they
> "evolved" during the lifetime of of the internet draft and we wanted
> to preserve some compatibility.
> I agree, that one must take care of the implied padding and I will double
> check how this is handled in FreeBSD. Not sure...

You need to add explicit named pad fields in order to zero them.
(since you don't really want a memset())
That is against my reading of the RFC.

What does FreeBSD do about the 'sockaddr_storage'?
I'd have thought it had the same rules as NetBSD - where (IIRC) it should never
be instantiated, but only exists as a pointer type for function parameters.

	David




