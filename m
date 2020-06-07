From: David Laight <David.Laight@ACULAB.COM>
Date: Sun, 07 Jun 2020 13:53:18 +0000
Subject: RE: packed structures used in socket options
Message-Id: <ec8c26c792ea414dbe50bda45725d26f@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
In-Reply-To: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: linux-sctp@vger.kernel.org

From: Michael Tuexen
>=20
> since gcc uses -Werror=ADdress-of-packed-member, I get warnings for my va=
riant
> of packetdrill, which supports SCTP.
>=20
> Here is why:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/i=
nclude/uapi/linux/sctp.h?h=3Dv5
> .7
> contains:
>=20
> struct sctp_paddrparams {
> 	sctp_assoc_t		spp_assoc_id;
> 	struct sockaddr_storage	spp_address;
> 	__u32			spp_hbinterval;
> 	__u16			spp_pathmaxrxt;
> 	__u32			spp_pathmtu;
> 	__u32			spp_sackdelay;
> 	__u32			spp_flags;
> 	__u32			spp_ipv6_flowlabel;
> 	__u8			spp_dscp;
> } __attribute__((packed, aligned(4)));
>=20
> This structure is only used in the IPPROTO_SCTP level socket option SCTP_=
PEER_ADDR_PARAMS.
> Why is it packed?

I'm guessing 'to remove holes to avoid leaking kernel data'.

The sctp socket api defines loads of structures that will have
holes in them if not packed.

OTOH they shouldn't have been packed either.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)
