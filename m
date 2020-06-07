From: David Laight <David.Laight@ACULAB.COM>
Date: Sun, 07 Jun 2020 17:14:36 +0000
Subject: RE: packed structures used in socket options
Message-Id: <e67c3c6e7d634138a4e71e0e768922c6@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
In-Reply-To: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
> Sent: 07 June 2020 16:15
> > On 7. Jun 2020, at 15:53, David Laight <David.Laight@ACULAB.COM> wrote:
> >
> > From: Michael Tuexen
> >>
> >> since gcc uses -Werror=ADdress-of-packed-member, I get warnings for my=
 variant
> >> of packetdrill, which supports SCTP.
> >>
> >> Here is why:
> >>
> >>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/i=
nclude/uapi/linux/sctp.h?h=3Dv5
> >> .7
> >> contains:
> >>
> >> struct sctp_paddrparams {
> >> 	sctp_assoc_t		spp_assoc_id;
> >> 	struct sockaddr_storage	spp_address;
> >> 	__u32			spp_hbinterval;
> >> 	__u16			spp_pathmaxrxt;
> >> 	__u32			spp_pathmtu;
> >> 	__u32			spp_sackdelay;
> >> 	__u32			spp_flags;
> >> 	__u32			spp_ipv6_flowlabel;
> >> 	__u8			spp_dscp;
> >> } __attribute__((packed, aligned(4)));
> >>
> >> This structure is only used in the IPPROTO_SCTP level socket option SC=
TP_PEER_ADDR_PARAMS.
> >> Why is it packed?
> >
> > I'm guessing 'to remove holes to avoid leaking kernel data'.
> >
> > The sctp socket api defines loads of structures that will have
> > holes in them if not packed.
>
> Hi David,
> I agree that they have holes and we should have done better. The
> kernel definitely should also not leak kernel data. However, the
> way to handle this shouldn't be packing. I guess it is too late
> to change this?

Probably too late.
I've no idea how it got through the standards body either.
In fact, the standard may actually require the holes.

>  This means the corresponding fields can only be accessed via
> memcpy() or one needs to tolerate unaligned access. Dealing with
> warnings is one thing, but do you know if Linux supports
> unaligned access on all platforms it supports (I'm not familiar
> with enough with Linux)?

The compiler will generate loads shifts and ors to access misaligned
data on architectures like sparc where the hardware (quite reasonably)
doesn't allow them.
The code is horrid and you don't want to do it if it is avoidable.
But it is better that taking a fault and then emulating it.
That really shouldn't have even been allowed to happen.

I do remember a classic statement in a header from AT&T.
'All the fields are declared 'long' to ensure the same alignment
on all machines.'
AT&T had a protocol that passed the structure between machines
(without allowing for endianness).
I think it was SGI that did a 64bit interface using 'long'.
The TOG standard allowed the implementation to pick a type.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)
