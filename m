From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Sun, 07 Jun 2020 17:23:30 +0000
Subject: Re: packed structures used in socket options
Message-Id: <B69695A1-F45B-4375-B9BB-1E50D1550C6D@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
In-Reply-To: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

> On 7. Jun 2020, at 19:14, David Laight <David.Laight@ACULAB.COM> wrote:
>=20
> From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
>> Sent: 07 June 2020 16:15
>>> On 7. Jun 2020, at 15:53, David Laight <David.Laight@ACULAB.COM> wrote:
>>>=20
>>> From: Michael Tuexen
>>>>=20
>>>> since gcc uses -Werror=ADdress-of-packed-member, I get warnings for my=
 variant
>>>> of packetdrill, which supports SCTP.
>>>>=20
>>>> Here is why:
>>>>=20
>>>>=20
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
include/uapi/linux/sctp.h?h=3Dv5
>>>> .7
>>>> contains:
>>>>=20
>>>> struct sctp_paddrparams {
>>>> 	sctp_assoc_t		spp_assoc_id;
>>>> 	struct sockaddr_storage	spp_address;
>>>> 	__u32			spp_hbinterval;
>>>> 	__u16			spp_pathmaxrxt;
>>>> 	__u32			spp_pathmtu;
>>>> 	__u32			spp_sackdelay;
>>>> 	__u32			spp_flags;
>>>> 	__u32			spp_ipv6_flowlabel;
>>>> 	__u8			spp_dscp;
>>>> } __attribute__((packed, aligned(4)));
>>>>=20
>>>> This structure is only used in the IPPROTO_SCTP level socket option SC=
TP_PEER_ADDR_PARAMS.
>>>> Why is it packed?
>>>=20
>>> I'm guessing 'to remove holes to avoid leaking kernel data'.
>>>=20
>>> The sctp socket api defines loads of structures that will have
>>> holes in them if not packed.
>>=20
>> Hi David,
>> I agree that they have holes and we should have done better. The
>> kernel definitely should also not leak kernel data. However, the
>> way to handle this shouldn't be packing. I guess it is too late
>> to change this?
>=20
> Probably too late.
> I've no idea how it got through the standards body either.
> In fact, the standard may actually require the holes.
No, it does not. Avoiding holes was not taken into account.
It should have been, but this was missed. Authors of all
kernel implementation (FreeBSD, Linux, and Solaris) were involved.
>=20
>> This means the corresponding fields can only be accessed via
>> memcpy() or one needs to tolerate unaligned access. Dealing with
>> warnings is one thing, but do you know if Linux supports
>> unaligned access on all platforms it supports (I'm not familiar
>> with enough with Linux)?
>=20
> The compiler will generate loads shifts and ors to access misaligned
> data on architectures like sparc where the hardware (quite reasonably)
> doesn't allow them.
> The code is horrid and you don't want to do it if it is avoidable.
> But it is better that taking a fault and then emulating it.
OK, so there is no functional problem on Linux. The code will run
slower, but it will work. At some time using FreeBSD on arm, you would
read interesting values and on Sparc with Solaris you would get a core.

This means developers have to use  -Wno-address-of-packed-member when
compiling a program on Linux.

Best regards
Michael
> That really shouldn't have even been allowed to happen.
>=20
> I do remember a classic statement in a header from AT&T.
> 'All the fields are declared 'long' to ensure the same alignment
> on all machines.'
> AT&T had a protocol that passed the structure between machines
> (without allowing for endianness).
> I think it was SGI that did a 64bit interface using 'long'.
> The TOG standard allowed the implementation to pick a type.
>=20
> 	David
>=20
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1=
 1PT, UK
> Registration No: 1397386 (Wales)
>=20
