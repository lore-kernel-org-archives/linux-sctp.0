From: Christoph Paasch <christoph.paasch@uclouvain.be>
Date: Fri, 21 Jan 2011 13:26:12 +0000
Subject: Re: MultiPath TCP in the Linux Kernel
Message-Id: <201101211426.12278.christoph.paasch@uclouvain.be>
List-Id: <linux-sctp.vger.kernel.org>
References: <201101201509.34536.christoph.paasch@uclouvain.be> <7e28a5ddc16848dcd98c05351113304f@localhost> <1295538176.2825.311.camel@edumazet-laptop>
In-Reply-To: <1295538176.2825.311.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>, netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net, linux-sctp@vger.kernel.org


On Thursday, January 20, 2011 wrote Eric Dumazet:
> > if you want that your work becomes part of the official network stack y=
ou
> > should align your effort on the official Linux way. This means you shou=
ld
> > split your work and publish patches on this maillinglist.
>=20
> Hmm, they probably know that, and prefer to wait MTCP stuff is mature
> before patch submission :)
Exactly... :)

The protocol specification of MPTCP is not stable yet=20
(http://datatracker.ietf.org/doc/draft-ietf-mptcp-multiaddressed/).

Also, all the features are not yet in our implementation (e.g., IPv6-suppor=
t=20
and dual IPv4/IPv6-support), and it is necessary to make our implementation=
=20
less intrusive to the regular TCP/IP-stack.

However, as developper-resources are limited this will still take quite som=
e=20
time... ;)

Cheers,
Christoph


--
Christoph Paasch
PhD Student

IP Networking Lab --- http://inl.info.ucl.ac.be
MultiPath TCP in the Linux Kernel --- http://inl.info.ucl.ac.be/mptcp
Universit=C3=A9 Catholique de Louvain

www.rollerbulls.be
--
