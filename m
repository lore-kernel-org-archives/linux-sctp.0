From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Sun, 07 Jun 2020 21:55:27 +0000
Subject: Re: packed structures used in socket options
Message-Id: <BC353F4B-8C3A-476E-B00F-B8D8F61174BA@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
In-Reply-To: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

On 7. Jun 2020, at 23:35, Ivan Skytte J=C3=B8rgensen <isj-sctp@i1.dk> wrote:
>=20
> On Sunday, 7 June 2020 22:21:41 CEST you wrote:
>> From: Michael Tuexen
>>> Sent: 07 June 2020 18:24
>>>> On 7. Jun 2020, at 19:14, David Laight <David.Laight@ACULAB.COM> wrote:
>>>>=20
>>>> From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
>>>>> Sent: 07 June 2020 16:15
>>>>>> On 7. Jun 2020, at 15:53, David Laight <David.Laight@ACULAB.COM> wro=
te:
>>>>>>=20
>>>>>> From: Michael Tuexen
>>>>>>>=20
>>>>>>> since gcc uses -Werror=ADdress-of-packed-member, I get warnings for=
 my variant
>>>>>>> of packetdrill, which supports SCTP.
>>>>>>>=20
>>>>>>> Here is why:
>>>>>>>=20
>>>>>>>=20
>>>>>=20
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/include/uapi/linux/sctp.h?h=3Dv5
>>>>>>> .7
>>>>>>> contains:
>>>>>>>=20
>>>>>>> struct sctp_paddrparams {
>>>>>>> 	sctp_assoc_t		spp_assoc_id;
>>>>>>> 	struct sockaddr_storage	spp_address;
>>>>>>> 	__u32			spp_hbinterval;
>>>>>>> 	__u16			spp_pathmaxrxt;
>>>>>>> 	__u32			spp_pathmtu;
>>>>>>> 	__u32			spp_sackdelay;
>>>>>>> 	__u32			spp_flags;
>>>>>>> 	__u32			spp_ipv6_flowlabel;
>>>>>>> 	__u8			spp_dscp;
>>>>>>> } __attribute__((packed, aligned(4)));
>>>>>>>=20
>>>>>>> This structure is only used in the IPPROTO_SCTP level socket option=
 SCTP_PEER_ADDR_PARAMS.
>>>>>>> Why is it packed?
>>>>>>=20
>>>>>> I'm guessing 'to remove holes to avoid leaking kernel data'.
>>>>>>=20
>>>>>> The sctp socket api defines loads of structures that will have
>>>>>> holes in them if not packed.
>>>>>=20
>>>>> Hi David,
>>>>> I agree that they have holes and we should have done better. The
>>>>> kernel definitely should also not leak kernel data. However, the
>>>>> way to handle this shouldn't be packing. I guess it is too late
>>>>> to change this?
>>>>=20
>>>> Probably too late.
>>>> I've no idea how it got through the standards body either.
>>>> In fact, the standard may actually require the holes.
>>>=20
>>> No, it does not. Avoiding holes was not taken into account.
>>=20
>> It depends on whether the rfc that describes the sockops says
>> the structures 'look like this' or 'contain the following members'.
>>=20
>>> It should have been, but this was missed. Authors of all
>>> kernel implementation (FreeBSD, Linux, and Solaris) were involved.
>>=20
>> Sounds like none of the right people even looked at it.
>=20
> I was involved. At that time (September 2005) the SCTP API was still evol=
ving (first finalized in 2011), and one of the major users of the API was 3=
2-bit programs running on 64-bit kernel (on powerpc as I recall). When we r=
ealized that the structures were different between 32bit and 64bit we had t=
o break the least number of programs, and the result were those ((packed)) =
structs so 32-bit programs wouldn't be broken and we didn't need a xxx_comp=
at translation layer in the kernel.
Ahh, I see. Thanks for the explanation.
>=20
> I don't have access to TSVWG mailing list archive that far back but I fou=
nd I wrote this summary here:
>=20
> On Sunday, 25 September 2005 21:36:05 CEST Ivan Skytte J=C3=B8rgensen wro=
te:
>> I followed the discussion in tsvwg mailing list. My interpretation of th=
e few=20
>> answers is that this is a "quality of implementation issue" and that pad=
ding=20
>> fields are allowed but won't get into the RFC because it is an implement=
ation=20
>> issue.
>=20
>=20
> So RFC6458 allows padding but doesn't list them.
Yepp, that is my understanding (being a co-author).
>=20
>=20
> Incidentally, at that time (and perhaps still) sockaddr_storage had diffe=
rent alignement between 32-bit programs and 64-bit programs, and the multic=
ast structures used in setsockopt() (group_req, group_source_req and  group=
_filter) had/has the same problem.
If I remember it correctly, I tested (FreeBSD) stuff on Little Endian, Big =
Endian, 32-bit, 64-bit, but not
run one binary on another platform.

Best regards
Michael
>=20
>=20
> /isj
>=20
>=20
>=20
