From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Sun, 07 Jun 2020 15:15:29 +0000
Subject: Re: packed structures used in socket options
Message-Id: <7B4E2F06-8FF9-4C45-8F7D-8C24028C70EF@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
In-Reply-To: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

> On 7. Jun 2020, at 15:53, David Laight <David.Laight@ACULAB.COM> wrote:
>=20
> From: Michael Tuexen
>>=20
>> since gcc uses -Werror=ADdress-of-packed-member, I get warnings for my v=
ariant
>> of packetdrill, which supports SCTP.
>>=20
>> Here is why:
>>=20
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
include/uapi/linux/sctp.h?h=3Dv5
>> .7
>> contains:
>>=20
>> struct sctp_paddrparams {
>> 	sctp_assoc_t		spp_assoc_id;
>> 	struct sockaddr_storage	spp_address;
>> 	__u32			spp_hbinterval;
>> 	__u16			spp_pathmaxrxt;
>> 	__u32			spp_pathmtu;
>> 	__u32			spp_sackdelay;
>> 	__u32			spp_flags;
>> 	__u32			spp_ipv6_flowlabel;
>> 	__u8			spp_dscp;
>> } __attribute__((packed, aligned(4)));
>>=20
>> This structure is only used in the IPPROTO_SCTP level socket option SCTP=
_PEER_ADDR_PARAMS.
>> Why is it packed?
>=20
> I'm guessing 'to remove holes to avoid leaking kernel data'.
>=20
> The sctp socket api defines loads of structures that will have
> holes in them if not packed.
Hi David,
I agree that they have holes and we should have done better. The
kernel definitely should also not leak kernel data. However, the
way to handle this shouldn't be packing. I guess it is too late
to change this?

This means the corresponding fields can only be accessed via
memcpy() or one needs to tolerate unaligned access. Dealing with
warnings is one thing, but do you know if Linux supports
unaligned access on all platforms it supports (I'm not familiar
with enough with Linux)?

Best regards
Michael
>=20
> OTOH they shouldn't have been packed either.
>=20
> 	David
>=20
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1=
 1PT, UK
> Registration No: 1397386 (Wales)
>=20
