From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Sun, 07 Jun 2020 21:51:06 +0000
Subject: Re: packed structures used in socket options
Message-Id: <F68C9FD5-2F94-4782-9EFF-9EA1153EBE3E@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
In-Reply-To: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

> On 7. Jun 2020, at 22:21, David Laight <David.Laight@ACULAB.COM> wrote:
>=20
> From: Michael Tuexen
>> Sent: 07 June 2020 18:24
>>> On 7. Jun 2020, at 19:14, David Laight <David.Laight@ACULAB.COM> wrote:
>>>=20
>>> From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
>>>> Sent: 07 June 2020 16:15
>>>>> On 7. Jun 2020, at 15:53, David Laight <David.Laight@ACULAB.COM> wrot=
e:
>>>>>=20
>>>>> From: Michael Tuexen
>>>>>>=20
>>>>>> since gcc uses -Werror=ADdress-of-packed-member, I get warnings for =
my variant
>>>>>> of packetdrill, which supports SCTP.
>>>>>>=20
>>>>>> Here is why:
>>>>>>=20
>>>>>>=20
>>>>=20
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
include/uapi/linux/sctp.h?h=3Dv5
>>>>>> .7
>>>>>> contains:
>>>>>>=20
>>>>>> struct sctp_paddrparams {
>>>>>> 	sctp_assoc_t		spp_assoc_id;
>>>>>> 	struct sockaddr_storage	spp_address;
>>>>>> 	__u32			spp_hbinterval;
>>>>>> 	__u16			spp_pathmaxrxt;
>>>>>> 	__u32			spp_pathmtu;
>>>>>> 	__u32			spp_sackdelay;
>>>>>> 	__u32			spp_flags;
>>>>>> 	__u32			spp_ipv6_flowlabel;
>>>>>> 	__u8			spp_dscp;
>>>>>> } __attribute__((packed, aligned(4)));
>>>>>>=20
>>>>>> This structure is only used in the IPPROTO_SCTP level socket option =
SCTP_PEER_ADDR_PARAMS.
>>>>>> Why is it packed?
>>>>>=20
>>>>> I'm guessing 'to remove holes to avoid leaking kernel data'.
>>>>>=20
>>>>> The sctp socket api defines loads of structures that will have
>>>>> holes in them if not packed.
>>>>=20
>>>> Hi David,
>>>> I agree that they have holes and we should have done better. The
>>>> kernel definitely should also not leak kernel data. However, the
>>>> way to handle this shouldn't be packing. I guess it is too late
>>>> to change this?
>>>=20
>>> Probably too late.
>>> I've no idea how it got through the standards body either.
>>> In fact, the standard may actually require the holes.
>>=20
>> No, it does not. Avoiding holes was not taken into account.
>=20
> It depends on whether the rfc that describes the sockops says
> the structures 'look like this' or 'contain the following members'.
It uses "is defined as"... Using "contain the following members"=20
would have been a better way. But is wasn't used. So yes, we could
have minimised the number of holes. But also other structure have
them. So when passing them from kernel land to user land one has
to zero out the padding. Not optimal, but doable.
>=20
>> It should have been, but this was missed. Authors of all
>> kernel implementation (FreeBSD, Linux, and Solaris) were involved.
>=20
> Sounds like none of the right people even looked at it.
Possible. At least the implementers were and it is an open process.
However, the rfc does not tell you to use packed structures.
So if you would follow the rfc, deal with the holes (which is
suboptimal, but doable), everything would be fine.
>=20
>>>> This means the corresponding fields can only be accessed via
>>>> memcpy() or one needs to tolerate unaligned access. Dealing with
>>>> warnings is one thing, but do you know if Linux supports
>>>> unaligned access on all platforms it supports (I'm not familiar
>>>> with enough with Linux)?
>>>=20
>>> The compiler will generate loads shifts and ors to access misaligned
>>> data on architectures like sparc where the hardware (quite reasonably)
>>> doesn't allow them.
>>> The code is horrid and you don't want to do it if it is avoidable.
>>> But it is better that taking a fault and then emulating it.
>>=20
>> OK, so there is no functional problem on Linux. The code will run
>> slower, but it will work. At some time using FreeBSD on arm, you would
>> read interesting values and on Sparc with Solaris you would get a core.
>=20
> Only if you try taking the addresses of the members.
> If you access the structure members the compiler will avoid
> faults on all architectures.
Ahh, OK. Thanks for the clarification.
>=20
> One problem with using 'packed' is that some applications may
> use their own copies of the structures (even though they probably
> shouldn't).
> In that case the kernel will pull out the wrong fields.
Sure, if the kernel and userland don't agree on the structure,
that is a bad thing.
>=20
>> This means developers have to use  -Wno-address-of-packed-member when
>> compiling a program on Linux.
>=20
> I think that will only DTRT if the architecture handles misaligned
> accesses (or the kernel emulates them).
>=20
> Or don't write code that takes the addresses of the structure members.
> The compiler warning is there for a purpose.
Sure. The point is that I wasn't expecting the structures to be packed,
since this is not specified in the rfc, not done in FreeBSD and Solaris.
And I do not see a reason for it (holes should be handled differently).
But I should have read the header file to be sure...

Best regards
Michael
>=20
> 	David
>=20
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1=
 1PT, UK
> Registration No: 1397386 (Wales)
>=20
