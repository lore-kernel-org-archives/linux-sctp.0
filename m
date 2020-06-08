From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 08 Jun 2020 16:18:39 +0000
Subject: RE: packed structures used in socket options
Message-Id: <cd3793726252407f8e80aa8d0025d44f@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
 <B69695A1-F45B-4375-B9BB-1E50D1550C6D@lurchi.franken.de>
 <23a14b44bd5749a6b1b51150c7f3c8ba@AcuMS.aculab.com>
 <2213135.ChUyxVVRYb@isjsys>
In-Reply-To: <2213135.ChUyxVVRYb@isjsys>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: =?iso-8859-1?Q?=27Ivan_Skytte_J=F8rgensen=27?= <isj-sctp@i1.dk>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>

From: Ivan Skytte J=C3=B8rgensen
> Sent: 07 June 2020 22:35
...
> > > >>>> contains:
> > > >>>>
> > > >>>> struct sctp_paddrparams {
> > > >>>> 	sctp_assoc_t		spp_assoc_id;
> > > >>>> 	struct sockaddr_storage	spp_address;
> > > >>>> 	__u32			spp_hbinterval;
> > > >>>> 	__u16			spp_pathmaxrxt;
> > > >>>> 	__u32			spp_pathmtu;
> > > >>>> 	__u32			spp_sackdelay;
> > > >>>> 	__u32			spp_flags;
> > > >>>> 	__u32			spp_ipv6_flowlabel;
> > > >>>> 	__u8			spp_dscp;
> > > >>>> } __attribute__((packed, aligned(4)));
> > > >>>>
> > > >>>> This structure is only used in the IPPROTO_SCTP level socket opt=
ion SCTP_PEER_ADDR_PARAMS.
> > > >>>> Why is it packed?
...
> I was involved. At that time (September 2005) the SCTP API was still evol=
ving (first finalized in
> 2011), and one of the major users of the API was 32-bit programs running =
on 64-bit kernel (on powerpc
> as I recall). When we realized that the structures were different between=
 32bit and 64bit we had to
> break the least number of programs, and the result were those ((packed)) =
structs so 32-bit programs
> wouldn't be broken and we didn't need a xxx_compat translation layer in t=
he kernel.

I was also looking at all the __u16 in that header - borked.

Ok, so the intention was to avoid padding caused by the alignment
of sockaddr_storage rather than around the '__u16 spp_flags'.

I'd have to look up what (packed, aligned(4)) actually means.
It could force the structure to be fully packed (no holes)
but always have an overall alignment of 4.

It might have been clearer to put an 'aligned(4)' attribute
on the spp_address field itself.
Or even wonder whether sockaddr_storage should actually
have 8 byte alignment.

If it has 16 byte alignment then you cannot cast an IPv4
socket buffer address (which will be at most 4 byte aligned)
to sockaddr_storage and expect the compiler not to generate
code that will crash and burn on sparc64.

ISTR that the NetBSD view was that 'sockaddr_storage' should
never actually be instantiated - it only existed as a typed
pointer.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)
