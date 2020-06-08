From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 08 Jun 2020 08:17:05 +0000
Subject: RE: packed structures used in socket options
Message-Id: <5fcc0a27f6494e8495ad043dfb3f2c56@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
 <ec8c26c792ea414dbe50bda45725d26f@AcuMS.aculab.com>
 <7B4E2F06-8FF9-4C45-8F7D-8C24028C70EF@lurchi.franken.de>
 <e67c3c6e7d634138a4e71e0e768922c6@AcuMS.aculab.com>
 <B69695A1-F45B-4375-B9BB-1E50D1550C6D@lurchi.franken.de>
 <23a14b44bd5749a6b1b51150c7f3c8ba@AcuMS.aculab.com>
 <F68C9FD5-2F94-4782-9EFF-9EA1153EBE3E@lurchi.franken.de>
In-Reply-To: <F68C9FD5-2F94-4782-9EFF-9EA1153EBE3E@lurchi.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: 'Michael Tuexen' <Michael.Tuexen@lurchi.franken.de>
Cc: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

From: Michael Tuexen
> Sent: 07 June 2020 22:51
> > On 7. Jun 2020, at 22:21, David Laight <David.Laight@ACULAB.COM> wrote:
> >
> > From: Michael Tuexen
> >> Sent: 07 June 2020 18:24
> >>> On 7. Jun 2020, at 19:14, David Laight <David.Laight@ACULAB.COM> wrot=
e:
> >>>
> >>> From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
> >>>> Sent: 07 June 2020 16:15
> >>>>> On 7. Jun 2020, at 15:53, David Laight <David.Laight@ACULAB.COM> wr=
ote:
> >>>>>
> >>>>> From: Michael Tuexen
> >>>>>>
> >>>>>> since gcc uses -Werror=ADdress-of-packed-member, I get warnings fo=
r my variant
> >>>>>> of packetdrill, which supports SCTP.
> >>>>>>
> >>>>>> Here is why:
> >>>>>>
> >>>>>>
> >>>>
> >>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/i=
nclude/uapi/linux/sctp.h?h=3Dv5
> >>>>>> .7
> >>>>>> contains:
> >>>>>>
> >>>>>> struct sctp_paddrparams {
> >>>>>> 	sctp_assoc_t		spp_assoc_id;
> >>>>>> 	struct sockaddr_storage	spp_address;
> >>>>>> 	__u32			spp_hbinterval;
> >>>>>> 	__u16			spp_pathmaxrxt;
> >>>>>> 	__u32			spp_pathmtu;
> >>>>>> 	__u32			spp_sackdelay;
> >>>>>> 	__u32			spp_flags;
> >>>>>> 	__u32			spp_ipv6_flowlabel;
> >>>>>> 	__u8			spp_dscp;
> >>>>>> } __attribute__((packed, aligned(4)));
> >>>>>>
> >>>>>> This structure is only used in the IPPROTO_SCTP level socket optio=
n SCTP_PEER_ADDR_PARAMS.
> >>>>>> Why is it packed?
> >>>>>
> >>>>> I'm guessing 'to remove holes to avoid leaking kernel data'.
> >>>>>
> >>>>> The sctp socket api defines loads of structures that will have
> >>>>> holes in them if not packed.
> >>>>
> >>>> Hi David,
> >>>> I agree that they have holes and we should have done better. The
> >>>> kernel definitely should also not leak kernel data. However, the
> >>>> way to handle this shouldn't be packing. I guess it is too late
> >>>> to change this?
> >>>
> >>> Probably too late.
> >>> I've no idea how it got through the standards body either.
> >>> In fact, the standard may actually require the holes.
> >>
> >> No, it does not. Avoiding holes was not taken into account.
> >
> > It depends on whether the rfc that describes the sockops says
> > the structures 'look like this' or 'contain the following members'.
>
> It uses "is defined as"... Using "contain the following members"
> would have been a better way. But is wasn't used. So yes, we could
> have minimised the number of holes. But also other structure have
> them. So when passing them from kernel land to user land one has
> to zero out the padding. Not optimal, but doable.

If it says 'defined as' then the 'packed' is just wrong.

No idea what can be done about it.
But an application is within its rights to define the structure
as it is defined in the rfc.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)
